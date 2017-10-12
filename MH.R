source("fucn.R")

trueA <- 5
trueB <- 0
trueSd <- 10
sampleSize <- 31

# create independent x-values 
x <- (-(sampleSize-1)/2):((sampleSize-1)/2)
# create dependent values according to ax + b + N(0,sd)
y <-  trueA * x + trueB + rnorm(n=sampleSize,mean=0,sd=trueSd)

plot(x,y, main="Test Data")

# Example: plot the likelihood profile of the slope a
slopevalues <- function(x){return(likelihood(c(x, trueB, trueSd)))}
slopelikelihoods <- lapply(seq(3, 7, by=.05), slopevalues )
plot (seq(3, 7, by=.05), slopelikelihoods , type="l", xlab = "values of slope parameter a", ylab = "Log likelihood")


######## Metropolis algorithm ################

startvalue = c(4,0,10)
chain = run_metropolis_MCMC(startvalue, 10000)

burnIn = 5000
acceptance = 1-mean(duplicated(chain[-(1:burnIn),]))

### Summary: #######################
smry(chain, burnIn, trueA, trueB, trueSd)

# for comparison:
summary(lm(y~x))

# To compare outcomes, we must modify run_metropolis_MCMC function.
# Note that there would be an error if sd becomes negative. To
# solve this problem we add the following line into run_metropolis_MCMC:
#   if(prior(proposal) == -Inf) {
#     chain[i+1,] = chain[i,]
#     next
#   }
# Then when sd becomes negative, we automatically reject it.
# 
# Moreover, since we allow the number of iteratoin differing, we cannot
# fix the number of burn in. Thus, we must take burnIn as input.
compare_outcomes = function(iteration, burnIn) {
  
  for(i in 1:10) {
    cat("Iteration ",i,":\n")
    # random initial value generated from its prior distribution
    initial = c(runif(1,0,10), rnorm(1,0,5), runif(1,0,30))
    chain = run_metropolis_MCMC(initial, iteration)
    
    m = apply(chain[-(1:burnIn),],2,mean)
    s = apply(chain[-(1:burnIn),],2,sd)
    
    cat("mean: a =",m[1],", b =",m[2],", c =",m[3],"\n")
    cat("sd  : a =",s[1],", b =",s[2],", c =",s[3],"\n")
  }
}

compare_outcomes(1000,500)
compare_outcomes(10000,5000)
compare_outcomes(100000,5000)
