# libsvm library import
library(e1071)

# Reset whole environment
reset <- function() {
  
  rm(list = ls(all = TRUE)) 
  
}

# Target Function.
f <- function(x) {
  
  return(sign(x[2] - x[1] + 0.25 * sin(pi*x[1])))
  
}

# Hard-Margin SVM with RBF Kernel.
rbfKernel <- function(Xtrain, ytrain, Xtest, ytest, g = 1) {
  
  library(e1071)
  
  model = svm(Xtrain, ytrain, scale = FALSE,
              type = "C-classification", cost = 1e16,
              kernel = "radial",
              gamma = g)
    
  eout = mean(predict(model, Xtest) != ytest)
  
  ein = mean(model$fitted != ytrain)
    
  return(list(model = model, ein = ein, eout = eout, discard = ein > 0))
  
}

# Square of the Euclidean Distance between two points.
norms <- function (U, X) { 
  
  return(t(U - X) %*% (U - X) )
  
}

# Observe X.
randomX <- function (void) {
  
  return(runif(2, -1, 1))
  
}

# Workaround for the "special" behavior of colMeans.
average <- function (x) {
  
  return(if (is.null(nrow(x))) x else colMeans(x))
  
}

# Lloyd algorithm for choosing the centers
lloyd <- function(X, k, maxIters = 100) {
  
  n = dim(X)[1]
    
  # Initialize Centers: Random points in X-Space.
  C = t(sapply(1:k, randomX))
  
  # Set of cluster labels of X  
  l <- vector(length = n)
      
  iter <- 1 
  
  while(1) {
    
    # "Fix Centers" : Calculate Set Membership for each x.
    l = apply(X, 1, function (x) { which.min(apply(C, 1, norms, x)) })
    
    # Looks for empty cluster and in case return  
    if (any(!(1:k %in% l))) return(list(empty = TRUE))
        
    Cnew <- t(sapply(1:k, function(j) { average(X[l==j, ]) }))
        
    # Termination Condition.   
    if (all(C == Cnew) || iter > maxIters) break
    
    C <- Cnew
    
    iter <- iter + 1
        
  }
  
   
   # Plots clusters
  
#   colors = c("brown", "darkgoldenrod", "blue4", "cornflowerblue",
#              "aquamarine4", "chartreuse", "chartreuse3",
#              "coral", "burlywood", "blueviolet")
#   
#   plot(X[, 1], X[, 2], xlab = "x1", ylab = "x2",
#        main = "Lloyd algorithm result",
#        col = colors[l], pch = 15)
# 
#   print(sprintf('Lloyd algorithm ended in %d iterations', iter))

  return(list(centers = C, labels = l, empty = FALSE))
  
}

# Error measure for RBF algorithm
rbfError <- function (g, X, y) {
  
  err = mean(apply(X, 1, g) != y)
  
  return(err)
}

# Regular radial basis function
rbfRegular <- function(Xtrain, ytrain, Xtest, ytest, k, gamma = 1) {
 
  n = length(ytrain)
  t = length(ytest)
  
  # Chooses centers using Lloyd's algorithm
  
  lloydResult <- lloyd(Xtrain, k, 100)
   
  if(lloydResult$empty) return(list(discard = TRUE))
     
  C <- lloydResult$centers
  
  # Chooses weights
  
  phi = matrix(nrow = n, ncol = k + 1)
    
  phi[, 1] = 1
  
  for(i in 1 : n) 
    for(j in 1 : k)       
      phi[i,j+1] = exp(-gamma * norms(Xtrain[i,],C[j,]))
  
  w <- solve(t(phi) %*% phi) %*% t(phi) %*% ytrain
  
  b = w[+1]
  w = w[-1]
  
  # Creates Final Hypothesis.
  g <- function (x) {
    
    s = b
    for (k in 1:K) s = s + w[k] * exp(-gamma * norms(C[k, ], x))
    return(sign(s))
    
  }
  
  ein = rbfError(g, Xtrain, ytrain)
  
  eout = rbfError(g, Xtest, ytest)
  
    
  return(list(ein = ein, eout = eout, discard = FALSE))
  
}

exercise13 <- function() {
  
  # Numbers of runs
  runs = 1000
  
  # Number of samples
  n = 100
  
  # Size of test data set
  t = 1000
  
  gamma = 1.5
    
  notSep <- 0
  
  for(r in 1:runs) {
        
    # Generates training data
    Xtrain = t(sapply(1:n, randomX))
    ytrain = apply(Xtrain, 1, f)
    
    #Generates test data
    Xtest= t(sapply(1:t, randomX))
    ytest = apply(Xtest, 1, f)
    
    solution = rbfKernel(Xtrain, ytrain, Xtest, ytest, gamma)
    
    if(solution$ein > 0) {
      notSep = notSep + 1
    }        
    
  }
  
  percNotSep = (notSep / runs) * 100
      
  print(sprintf('%f%% of the time the data set is not separable by RBF kernel', percNotSep))

}

exercise14 <- function() {
  
  # Reset environment
  reset()
  
  # Numbers of runs
  runs = 1000
  
  # Number of samples
  n = 100
  
  # Size of test data set
  t = 1000
  
  # Number of kernels
  k = 9
  
  # Gamma value to be used in both RBF and SVM
  gamma = 1.5
  
  # Fraction of OUT-OF-SAMPLE Mismatches per Experiment: SVM.
  EoutSVM = vector(length = R)
  
  # Fraction of OUT-OF-SAMPLE Mismatches per Experiment: RBF.
  EoutRBF = vector(length = R)
  
  #
  # Per Experiment: SVM
  # Fraction of IN-SAMPLE Mismatches gSVM(x) != y.
  #
  EinSVM = vector(length = R)
  
  #
  # Per Experiment: RBF
  # Fraction of IN-SAMPLE Mismatches gRBF(x) != y.
  #
  EinRBF = vector(length = R)
  
  # Discard Counts.
  discardSVM = 0; discardRBF = 0;
  
  #Number of times the kernels version beats the regular one  
  kernelWins = 0
    
  # Number of Effective Runs.
  r = 0
  
  while(1) {
    
    # Generates training data
    Xtrain = t(sapply(1:n, randomX))
    ytrain = apply(Xtrain, 1, f)
    
    #Generates test data
    Xtest= t(sapply(1:t, randomX))
    ytest = apply(Xtest, 1, f)
    
    kernelSolution = rbfKernel(Xtrain, ytrain, Xtest, ytest, gamma)
    if (kernelSolution$discard) { discardSVM = discardSVM + 1; next }
      
    regularSolution = rbfRegular(Xtrain, ytrain, Xtest, ytest, k, gamma)
    if (regularSolution$discard) { discardRBF = discardRBF + 1; next }
    
    kernelWins = kernelWins + ifelse(kernelSolution$eout < regularSolution$eout, 1, 0)
        
    r = r + 1
    
    # All Runs done.
    if (r == runs) break
      
  }
  
  
  print(paste("Sample Size               =", N))
  print(paste("Effective      #Runs      =", r))
  print(paste("SVM: Discarded #Runs      =", discardSVM))
  print(paste("RBF: Discarded #Runs      =", discardRBF))
  print(paste("RBF: Number of Clusters K =", k))
  print(paste("SVM beats RBF wrt Eout    =", (kernelWins/r)*100, "%", " of the times"))
  
}

exercise15 <- function() {
  
  # Reset environment
  reset()
  
  # Numbers of runs
  runs = 1000
  
  # Number of samples
  n = 100
  
  # Size of test data set
  t = 1000
  
  # Number of kernels
  k = 12
  
  # Gamma value to be used in both RBF and SVM
  gamma = 1.5
  
  # Fraction of OUT-OF-SAMPLE Mismatches per Experiment: SVM.
  EoutSVM = vector(length = R)
  
  # Fraction of OUT-OF-SAMPLE Mismatches per Experiment: RBF.
  EoutRBF = vector(length = R)
  
  #
  # Per Experiment: SVM
  # Fraction of IN-SAMPLE Mismatches gSVM(x) != y.
  #
  EinSVM = vector(length = R)
  
  #
  # Per Experiment: RBF
  # Fraction of IN-SAMPLE Mismatches gRBF(x) != y.
  #
  EinRBF = vector(length = R)
  
  # Discard Counts.
  discardSVM = 0; discardRBF = 0;
  
  #Number of times the kernels version beats the regular one  
  kernelWins = 0
  
  # Number of Effective Runs.
  r = 0
  
  while(1) {
    
    # Generates training data
    Xtrain = t(sapply(1:n, randomX))
    ytrain = apply(Xtrain, 1, f)
    
    #Generates test data
    Xtest= t(sapply(1:t, randomX))
    ytest = apply(Xtest, 1, f)
    
    kernelSolution = rbfKernel(Xtrain, ytrain, Xtest, ytest, gamma)
    if (kernelSolution$discard) { discardSVM = discardSVM + 1; next }
    
    regularSolution = rbfRegular(Xtrain, ytrain, Xtest, ytest, k, gamma)
    if (regularSolution$discard) { discardRBF = discardRBF + 1; next }
    
    kernelWins = kernelWins + ifelse(kernelSolution$eout < regularSolution$eout, 1, 0)
    
    r = r + 1
    
    # All Runs done.
    if (r == runs) break
    
  }
  
  
  print(paste("Sample Size               =", N))
  print(paste("Effective      #Runs      =", r))
  print(paste("SVM: Discarded #Runs      =", discardSVM))
  print(paste("RBF: Discarded #Runs      =", discardRBF))
  print(paste("RBF: Number of Clusters K =", k))
  print(paste("SVM beats RBF wrt Eout    =", (kernelWins/r)*100, "%", " of the times"))
  
}

exercise16 <- function() {
  
  # Reset environment
  reset()
  
  # Numbers of runs
  runs = 1000
  
  # Number of samples
  n = 100
  
  # Size of test data set
  t = 1000
  
  # Number of kernels
  k1 = 9
  k2 = 12
  
  # Gamma value to be used in both RBF and SVM
  gamma = 1.5
  
  # Fraction of OUT-OF-SAMPLE mismatches per RBF K = 9
  EoutRBF1 = vector(length = runs)
  
  # Fraction of OUT-OF-SAMPLE mismatches per RBF K = 12
  EoutRBF2 = vector(length = runs)
  
  # Fraction of IN-OF-SAMPLE mismatches per RBF K = 9
  EinRBF1 = vector(length = runs)
  
  # Fraction of IN-OF-SAMPLE mismatches per RBF K = 12
  EinRBF2 = vector(length = runs)
  
  # Discard Counts.
  discard = 0;
  
  # Number of Effective Runs.
  r = 0
  
  while(1) {
    
    # Generates training data
    Xtrain = t(sapply(1:n, randomX))
    ytrain = apply(Xtrain, 1, f)
    
    #Generates test data
    Xtest= t(sapply(1:t, randomX))
    ytest = apply(Xtest, 1, f)
    
    regularSolution1 = rbfRegular(Xtrain, ytrain, Xtest, ytest, k1, gamma)
    if (regularSolution1$discard) { discard = discard + 1; next }
    
    regularSolution2 = rbfRegular(Xtrain, ytrain, Xtest, ytest, k2, gamma)
    if (regularSolution2$discard) { discard = discard + 1; next }
    
    r = r + 1
    
    EinRBF1[r] = regularSolution1$ein
    EinRBF2[r] = regularSolution2$ein
    
    EoutRBF1[r] = regularSolution1$eout
    EoutRBF2[r] = regularSolution2$eout
    
    # All Runs done.
    if (r == runs) break
    
  }
  
  print(paste("Sample Size               =", N))
  print(paste("Effective      #Runs      =", r))
  print(paste("Discarded      #Runs      =", discard))
  print('')
  print(paste("RBF: Number of Clusters K =", k1))
  print(paste("RBF: Average Ein          =", mean(EinRBF1)))
  print(paste("RBF: Average Eout         =", mean(EoutRBF1)))
  print('')
  print(paste("RBF: Number of Clusters K =", k2))
  print(paste("RBF: Average Ein          =", mean(EinRBF2)))
  print(paste("RBF: Average Eout         =", mean(EoutRBF2)))
  
}

exercise17 <- function() {
  
  # Reset environment
  reset()
  
  # Numbers of runs
  runs = 1000
  
  # Number of samples
  n = 100
  
  # Size of test data set
  t = 1000
  
  # Number of kernels
  k = 9
  
  # Gamma value to be used in both RBF and SVM
  gamma1 = 1.5
  gamma2 = 2
  
  # Fraction of OUT-OF-SAMPLE mismatches per RBF K = 9
  EoutRBF1 = vector(length = runs)
  
  # Fraction of OUT-OF-SAMPLE mismatches per RBF K = 12
  EoutRBF2 = vector(length = runs)
  
  # Fraction of IN-OF-SAMPLE mismatches per RBF K = 9
  EinRBF1 = vector(length = runs)
  
  # Fraction of IN-OF-SAMPLE mismatches per RBF K = 12
  EinRBF2 = vector(length = runs)
  
  # Discard Counts.
  discard = 0;
  
  # Number of Effective Runs.
  r = 0
  
  while(1) {
    
    # Generates training data
    Xtrain = t(sapply(1:n, randomX))
    ytrain = apply(Xtrain, 1, f)
    
    #Generates test data
    Xtest= t(sapply(1:t, randomX))
    ytest = apply(Xtest, 1, f)
    
    regularSolution1 = rbfRegular(Xtrain, ytrain, Xtest, ytest, k, gamma1)
    if (regularSolution1$discard) { discard = discard + 1; next }
    
    regularSolution2 = rbfRegular(Xtrain, ytrain, Xtest, ytest, k, gamma2)
    if (regularSolution2$discard) { discard = discard + 1; next }
    
    r = r + 1
    
    EinRBF1[r] = regularSolution1$ein
    EinRBF2[r] = regularSolution2$ein
    
    EoutRBF1[r] = regularSolution1$eout
    EoutRBF2[r] = regularSolution2$eout
    
    # All Runs done.
    if (r == runs) break
    
  }
  
  print(paste("Sample Size               =", N))
  print(paste("Effective      #Runs      =", r))
  print(paste("Discarded      #Runs      =", discard))
  print('')
  print(paste("RBF: Gamma value          =", gamma1))
  print(paste("RBF: Number of Clusters K =", k))
  print(paste("RBF: Average Ein          =", mean(EinRBF1)))
  print(paste("RBF: Average Eout         =", mean(EoutRBF1)))
  print('')
  print(paste("RBF: Gamma value          =", gamma2))
  print(paste("RBF: Number of Clusters K =", k))
  print(paste("RBF: Average Ein          =", mean(EinRBF2)))
  print(paste("RBF: Average Eout         =", mean(EoutRBF2)))
  
}

exercise18 <- function() {
    
  # Reset environment
  reset()
  
  # Numbers of runs
  runs = 1000
  
  # Number of samples
  n = 100
  
  # Size of test data set
  t = 1000
  
  # Number of kernels
  k = 9
  
  # Gamma value to be used in both RBF and SVM
  gamma = 1.5
  
  # Fraction of OUT-OF-SAMPLE mismatches per RBF K = 9
  EoutRBF = vector(length = runs)
    
  # Fraction of IN-OF-SAMPLE mismatches per RBF K = 9
  EinRBF = vector(length = runs)
    
  # Discard Counts.
  discard = 0;
  
  # Number of Effective Runs.
  r = 0
  
  while(1) {
    
    # Generates training data
    Xtrain = t(sapply(1:n, randomX))
    ytrain = apply(Xtrain, 1, f)
    
    #Generates test data
    Xtest= t(sapply(1:t, randomX))
    ytest = apply(Xtest, 1, f)
    
    regularSolution = rbfRegular(Xtrain, ytrain, Xtest, ytest, k, gamma)
    if (regularSolution$discard) { discard = discard + 1; next }
    
    r = r + 1
        
    EinRBF[r] = regularSolution$ein
    EoutRBF[r] = regularSolution$eout
    
    # All Runs done.
    if (r == runs) break
    
  }
  
  print(paste("Sample Size               =", N))
  print(paste("Effective      #Runs      =", r))
  print(paste("Discarded      #Runs      =", discard))
  print(paste("RBF: Gamma value          =", gamma))
  print(paste("RBF: Number of Clusters K =", k))
  print(paste("RBF: Average Ein          =", mean(EinRBF)))
  print(paste("RBF: Average Eout         =", mean(EoutRBF)))
  print(paste("RBF: Zero Ein             =", 100 * mean(EinRBF == 0), "%", " of the times"))
    
}

# exercise13()

# exercise14()

# exercise15()

# exercise16()

# exercise17()

# exercise18()