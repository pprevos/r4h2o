## R4H2O: Data Science for Water Professionals
## Chapter 12: Functions

## Channel flow (Kindsvater-Carter formula)
channel_flow <- function(h, b, cd = 0.6){
    q <- (2/3) * cd * sqrt(2 * 9.81) * b * h^(3/2)
    return(q)    
}

channel_flow(0.12, 0.6)
