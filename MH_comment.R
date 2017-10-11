# This file illustrates how to use Metropolis-Hastings MCMC algorithm to 
# draw random samples and estimate parameters. We will use the following 
# model to give a concrete example:
#   y = Ax + B + epsilon
# where epsilon ~ N(0,SD^2), and the prior distributions of A, B, SD are
#   A ~ Uinf(0,10)
#   B ~ N(0,25)
#   SD ~ Unif(0,30)

# First of all, we need to generate data. The true values of
# A, B and SD are setting to be 5, 0 and 10, respectively.
# Moreover, we generate total 31 samples.
trueA <- 5
trueB <- 0
trueSd <- 10
sampleSize <- 31

# Then we create independent variables x, and generate dependent data y
# as mentioned above.
x <- (-(sampleSize-1)/2):((sampleSize-1)/2)
y <-  trueA * x + trueB + rnorm(n=sampleSize,mean=0,sd=trueSd)

# Plot (x,y). We can see that there is a linear relationship.
plot(x,y, main="Test Data")

# Compute its log-likelihood. Since y = Ax+B+N(0,SD^2), we have
# y ~ N(Ax+b,SD^2). Thus, we can use 
#   sum( dnorm(y, mean=a*x+b, sd=sd, log=T) )
# to compute its log-likelihood.
likelihood <- function(param){
  a = param[1]
  b = param[2]
  sd = param[3]
  
  pred = a*x + b
  singlelikelihoods = dnorm(y, mean = pred, sd = sd, log = T)
  sumll = sum(singlelikelihoods)
  return(sumll)   
}

# Here we compute the log-likelihood for different a given B and SD. 
# The second line is used to compute log-likelihood for a=seq(3,7,by=.05)
slopevalues <- function(x) {return(likelihood(c(x, trueB, trueSd)))}
slopelikelihoods <- lapply(seq(3, 7, by=.05), slopevalues )
plot (seq(3, 7, by=.05), slopelikelihoods , type="l", xlab = "values of slope parameter a", ylab = "Log likelihood")

# Here we compute the log-pdf of prior distribution. Note that we assume
# A, B and SD are independent so that we can sum up these three log-pdfs.
prior <- function(param){
  a = param[1]
  b = param[2]
  sd = param[3]
  aprior = dunif(a, min=0, max=10, log = T)
  bprior = dnorm(b, sd = 5, log = T)
  sdprior = dunif(sd, min=0, max=30, log = T)
  return(aprior+bprior+sdprior)
}

# Then we compute its log-pdf of posterior distribution. Note that
# f(theta|x) \propto f(x|theta) f(theta)
# Thus, we can sum the log-likelihood and log-pdf of prior distribution.
posterior <- function(param){
  return (likelihood(param) + prior(param))
}

# To draw random samples, we first need to decide proposal distribution.
# Here, we choose it as theta* ~ N(theta, Sigma)
# where Sigma ~ diag(0.1,0.5,0.3)
proposalfunction <- function(param){
  return(rnorm(3,mean = param, sd= c(0.1,0.5,0.3)))
}

# Then we can start the MCMC algorithm, our goal is to draw random samples
# from the posterior distribution.
run_metropolis_MCMC <- function(startvalue, iterations){
  
  # We first construct an matrix to store the following chains.
  # The size of this matrix is (N+1)*3, where N is the number of 
  # iterations and 3 is the parameters we interested. Note that the 
  # first row of this matrix is the initial value.
  chain = array(dim = c(iterations+1,3))
  chain[1,] = startvalue
  
  for (i in 1:iterations){
    
    # Then, we will draw a sample. We will accept this sample if U < A
    # where U ~ Unif(0,1) and A = f(theta_new|x)/f(theta_current|x)
    # That is, if the new sample is more likely than the current one, then 
    # we will accept is. Otherwise, we will accept it at appropriate chance.
    proposal = proposalfunction(chain[i,]) 
    probab = exp(posterior(proposal) - posterior(chain[i,]))
    if (runif(1) < probab){
      chain[i+1,] = proposal
    }else{
      chain[i+1,] = chain[i,]
    }
  }
  return(chain)
}

# Give the initial value 4, 0, 10 and run the above codes.
startvalue = c(4,0,10)
chain = run_metropolis_MCMC(startvalue, 10000)

# Since the initial value is usually chosen by random. We will delete first
# few samples to avoid the effect of initial value. Here we will delete the
# first 5000 samples.
burnIn = 5000

# duplicated function return the TRUE value for the duplicated values, and
# FALSE otherwise. Then, we can use the following sample to compute the
# acceptance rate, which is affected by the sd of proposal distribution.
acceptance = 1-mean(duplicated(chain[-(1:burnIn),]))


# Summary plots
par(mfrow = c(2,3))
hist(chain[-(1:burnIn),1],nclass=30, , main="Posterior of a", xlab="True value = red line" )
abline(v = mean(chain[-(1:burnIn),1]))
abline(v = trueA, col="red" )
hist(chain[-(1:burnIn),2],nclass=30, main="Posterior of b", xlab="True value = red line")
abline(v = mean(chain[-(1:burnIn),2]))
abline(v = trueB, col="red" )
hist(chain[-(1:burnIn),3],nclass=30, main="Posterior of sd", xlab="True value = red line")
abline(v = mean(chain[-(1:burnIn),3]) )
abline(v = trueSd, col="red" )
plot(chain[-(1:burnIn),1], type = "l", xlab="True value = red line" , main = "Chain values of a", )
abline(h = trueA, col="red" )
plot(chain[-(1:burnIn),2], type = "l", xlab="True value = red line" , main = "Chain values of b", )
abline(h = trueB, col="red" )
plot(chain[-(1:burnIn),3], type = "l", xlab="True value = red line" , main = "Chain values of sd", )
abline(h = trueSd, col="red" )

# For comparison, we compute the least squares result.
summary(lm(y~x))
