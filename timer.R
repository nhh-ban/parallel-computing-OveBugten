library(tictoc)
library(foreach)
library(iterators)
library(parallel)
library(doParallel)
library(tweedie) 
library(ggplot2)
library(tidyverse)

## --------- Timer for original solution

tic.clearlog()
tic("Original Solution")
source("scripts/hw4_solution1.r")
toc()

## --------- Rewritten lines 29-35

tic("Parallel loop 29-35")
source("scripts/hw4_solution2.r")
toc()

## --------- Rewritten MTweedieTests to split the M simulations in more
#             than one core

tic("Rewritten MTweedietests")
source("scripts/hw4_solution3.r")
toc()

## --------- Printing the TicToc Log with times

printTicTocLog() %>%
  knitr::kable()

# The computing with parallel loop 29-35 is the , probably because it takes 
# advantage of multiple CPU cores for parallel processing and might be fastest
# due to problem size. 