##
args <- commandArgs(trailingOnly = T)

##docNum <- as.numeric(args[1]);
docNum <- 52;
docWord <- read.table("docWords.txt", sep="\t");
docMat <- docWord[,1:docNum];

docWc <- NULL;
for (i in 1:docNum) {
    docWc <- cbind(docWc, sum(docMat[,i]));
}

tf <- NULL;
for (i in 1:docNum) {
    tf <- cbind(tf, docMat[,i]/docWc[1,i]);
}

tp <- docMat > 0;
idf <- cbind(log(docNum/rowSums(tp) +1));
##idf <- cbind(log(docNum/rowSums(tp) ));

idfs <- NULL
for (i in 1:docNum) {
    idfs <- cbind(idfs, idf);
}
tfidf <- tf * idfs;
tfidf <- cbind(tfidf, docWord[, (docNum+1):(docNum+6)]);

criteria <- rep(FALSE, length=dim(docMat)[1]);
for (i in 1:docNum) {
    criteria <- criteria |
        tfidf[,i] >= quantile(tfidf[,i], 0.90);
        ##tfidf[,i] >= quantile(tfidf[,i], 0.80);
}

tfidf0 <- tfidf[criteria,];

wordSet <- setdiff(
    union(
        grep("^名詞", tfidf0[,docNum+4]),
        grep("^動詞", tfidf0[,docNum+4])
    ),
    grep("非自立", tfidf0[,docNum+4])
);
tfidf1 <- tfidf0[1:dim(tfidf0)[1] %in% wordSet,];

write.table(tfidf1, "tfidf1.txt", sep="\t", col.names=F, row.names=F);

## LSA
lsa <- svd(tfidf1[,1:docNum]);

## Primary Component Analysis
pri <- prcomp(tfidf1[,1:docNum], scale=TRUE);
index = 0;
for (i in 1:docNum) {
    if (summary(pri)$importance[3,i] > 0.8) {
        index = i;
        break;
    }
}

if (index == 1) {
    index <- 2;
}

## make document matrix using LSA
docMatLSA <- lsa$u[,1:index] %*% diag(lsa$d[1:index]) %*% t(lsa$v[,1:index]);

### vector space method
simResult <- diag(docNum);
for (i in 1:docNum) {
    for (j in i:docNum) {
        similarity = (docMatLSA[,i] %*% docMatLSA[,j]) /
            (sqrt(sum(docMatLSA[,i] * docMatLSA[,i])) *
             sqrt(sum(docMatLSA[,j] * docMatLSA[,j])) );
        simResult[i, j] = similarity;
        simResult[j, i] = similarity;
    }
}

write.table(simResult, "simResult.txt", sep="\t");

## make document matrix not using LSA
docMatNonLSA <- tfidf1[,1:docNum]

### non LSA vector space method
simResultNonLSA <- diag(docNum);
for (i in 1:docNum) {
    for (j in i:docNum) {
        similarity = (docMatNonLSA[,i] %*% docMatNonLSA[,j]) /
            (sqrt(sum(docMatNonLSA[,i] * docMatNonLSA[,i])) *
             sqrt(sum(docMatNonLSA[,j] * docMatNonLSA[,j])) );
        simResultNonLSA[i, j] = similarity;
        simResultNonLSA[j, i] = similarity;
    }
}
