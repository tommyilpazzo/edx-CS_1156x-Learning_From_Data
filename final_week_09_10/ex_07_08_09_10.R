oneversusall <- function(digits, transformation = noTransformation, lambda = 1) {

  #Loads training data set
  training <- read.table("http://www.amlbook.com/data/zip/features.train", 
    col.names = c("digit","intensity","simmetry"))
  
  #Loads test data set
  test <- read.table("http://www.amlbook.com/data/zip/features.test", 
    col.names = c("digit","intensity","simmetry"))
    
  #Loops over all the possible answers
  for (n in digits) {
    
    X <- training[,c("intensity","simmetry")]
  
    X <- cbind(ones = 1, X) 
  
    y <- training[,"digit"] 
    
    y[y != n] = -1
    y[y == n] = 1
  
    X <- data.matrix(X)
    y <- data.matrix(y)
    
    X <- transformation(X)
    
    #Computes weights
    w = solve(t(X) %*% X + diag(dim(X)[2]) * lambda) %*% t(X) %*% y
  
    g = sign(X %*% w)
    
    #Computes Ein
    ein = sum(g != y) / dim(X)[1]
    
    #Starts Eout computation
    
    X <- test[,c("intensity","simmetry")]
    
    X <- cbind(ones = 1, X) 
    
    y <- test[,"digit"] 
    
    y[y != n] = -1
    y[y == n] = 1
    
    X <- data.matrix(X)
    y <- data.matrix(y)
        
    X <- transformation(X)
        
    g = sign(X %*% w)
    
    #Computes Eout
    eout = sum(g != y) / dim(test)[1]
    
    #Prints results
    cat(sprintf("%d vs all (lambda = %.3f) >> Ein: %.3f, Eout: %.3f\n", n, lambda, ein, eout))
        
  }
  
}

oneversusone <- function(digit1, digit2, transformation = noTransformation, lambda = 1) {
  
  #Loads training data set
  training <- read.table("http://www.amlbook.com/data/zip/features.train", 
                         col.names = c("digit","intensity","simmetry"))
  
  #Loads test data set
  test <- read.table("http://www.amlbook.com/data/zip/features.test", 
                     col.names = c("digit","intensity","simmetry"))
  
  X <- training[,c("intensity","simmetry")]
  
  X <- cbind(ones = 1, X) 
  
  y <- training[,"digit"]
  
  X <- X[training$digit == digit1 | training$digit == digit2,]
  y <- y[training$digit == digit1 | training$digit == digit2]
  
  y[y == digit1] = 1
  y[y == digit2] = -1
  
  X <- data.matrix(X)
  y <- data.matrix(y)
  
  X <- transformation(X)
  
  #Computes weights
  w = solve(t(X) %*% X + diag(dim(X)[2]) * lambda) %*% t(X) %*% y
  
  g = sign(X %*% w)
  
  #Computes Ein
  ein = sum(g != y) / dim(X)[1]
  
  #Starts Eout computation
  
  X <- test[,c("intensity","simmetry")]
  
  X <- cbind(ones = 1, X) 
  
  y <- test[,"digit"] 
  
  X <- X[test$digit == digit1 | test$digit == digit2,]
  y <- y[test$digit == digit1 | test$digit == digit2]
  
  y[y == digit1] = 1
  y[y == digit2] = -1
  
  X <- data.matrix(X)
  y <- data.matrix(y)
  
  X <- transformation(X)
  
  g = sign(X %*% w)
  
  #Computes Eout
  eout = sum(g != y) / dim(test)[1]
  
  #Prints results
  cat(sprintf("%d vs %d (lambda = %.3f) >> Ein: %.3f, Eout: %.3f\n", digit1, digit2, lambda, ein, eout))

}

noTransformation <- function(X) {
  
  return(X)
  
}

polynomialTransformation  <- function(X) {
  
  X <- cbind(
    X,
    X[,2] * X[,3],
    X[,2] ^ 2,
    X[,3] ^ 2
  )
  
  return(X)
  
}

#Exercise 7
oneversusall(5:9)

#Exercise 8
oneversusall(0:4, polynomialTransformation)

#Exercise 9
oneversusall(0:9)
oneversusall(0:9, polynomialTransformation)

#Exercise 10
oneversusone(1, 5, polynomialTransformation)
oneversusone(1, 5, polynomialTransformation, 0.01)

