train_data = read.csv("train.csv", sep=",", header=TRUE)
head(train_data)
dim(train_data)

test_data = read.csv("test.csv", sep=",", header=TRUE)
head(test_data)
dim(test_data)

install.packages("gbm")
require(gbm)
require(MASS)

?gbm
boosting = gbm(SalePrice ~ . ,data = train_data, distribution = "gaussian", n.trees = 10000, shrinkage = 0.01, interaction.depth = 4)
boosting
summary(boosting)

n.trees = seq(from=100 ,to=10000, by=100)
predmatrix<-predict(boosting,train_data,n.trees = n.trees)
predmatrix

?rowSums
predmatrix_means = rowMeans(predmatrix)
predmatrix_means

train_data = cbind(train_data, means=predmatrix_means)
head(train_data)

predmatrix2 = predict(boosting, test_data, n.trees = n.trees)
predmatrix2

predmatrix2_means = rowMeans(predmatrix2)
predmatrix2_means

test_data = cbind(test_data, predction=predmatrix2_means)
head(test_data)

final_test_data = data.frame(test_data$Id, test_data$predction)
names(final_test_data) = c("Id", "SalePrice")
head(final_test_data)


write.csv(final_test_data, "submission.csv", row.names = FALSE)
