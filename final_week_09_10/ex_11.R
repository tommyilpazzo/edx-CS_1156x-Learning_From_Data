transform  <- function(X) {
  
  Z <- cbind(
    
    X[,2]^2 - 2*X[,1] - 1,
    X[,1]^2 - 2*X[,2] + 1
    
  )
  
  return(Z)
  
}

# exercise11 <- function() {
#       
#   X = matrix(c(1, 0, 0, 1, 0, -1, -1, 0, 0, 2, 0, -2, -2, 0), ncol = 2, byrow = TRUE)
#   
#   y = c(-1, -1, -1, 1, 1, 1, 1)
#   
#   # Sample Size.
#   N = length(Y)
#   
#   Z <- transform(X)
#   
#   # Method 1: Maximixes margin using geometry
#   
#   name = "margin.png"
#   
#   png(name)
#     
#   plot(Z[, 1], Z[, 2], xlab = "z1", ylab = "z2",
#        main = "METHOD 1: Maximize Margin using Geometry",
#        col = 3 + y, pch = 15)
#   
#   dev.off()
#   
#   browseURL(name)
#   
#   # Method 2: QP Package.
#           
#   library(LowRankQP)
#   
#   N = length(y)
#   
#   # Create the Quadratic Programing Parameters for LowRankQP().
#   Vmat = (y * Z) %*% t(y * Z)
#   dvec = rep(-1, N)
#   Amat = t(y)
#   bvec = 0
#   uvec = rep(10000, N)
#   
#   # Minimize the Quadratic Function!
#   solution = LowRankQP(Vmat, dvec, Amat, bvec, uvec, method = "LU")
#   
#   # Obtain Alphas.
#   a = c(zapsmall(solution$alpha))
#   
#   # Weights.
#   w = colSums(a * y * Z)
#   
#   # Workaround for "special" behavior of sample().
#   resample = function (x, ...) x[sample.int(length(x), ...)]
#   
#   # Bias/Threshold Term. Take any one, all are equal.
#   b = resample(((1 / y) - (Z %*% w))[a > 0], 1)
#   
#   print("Method 2: Quadratic Programming")
#   print(paste("#SV's =", sum(a > 0)))
#   print("Weights (w1, w2, b):")
#   print(c(w, b))
#   
# }

exercise11 <- function() {
    
  # Training set
  X = matrix(c(1, 0, 0, 1, 0, -1, -1, 0, 0, 2, 0, -2, -2, 0), ncol = 2, byrow = TRUE)
  y = c(-1, -1, -1, 1, 1, 1, 1)
  
  Z <- transform(X)
    
  # Number of answers
  a  = 4
  
  # Possible w and b
  W <- matrix(c(-1, 1, 1, -1, 1, 0, 0, 1), ncol = 2, byrow = TRUE)  
  b = c(-0.5, -0.5, -0.5, -0.5)
  
  # Number of samples
  N = dim(Z)[1]
  
  for(i in 1:a) {
      
    w = W[i,]
    
    for(j in 1:N) {
      
      # y[j] * (w %*% Z[j,] + b[i]) sempre maggiore di 0 se h=(b, w) separa i dati
      
      if((y[j] * (w %*% Z[j,] + b[i])) < 0)
        break;
      
      if(j == N)
        print(sprintf("w = (%f, %f), b = %f", w[1], w[2], b[i]))
            
    }
    
  }
  
}

exercise11()