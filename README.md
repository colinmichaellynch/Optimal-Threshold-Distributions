# Optimal-Threshold-Distributions
I compare the relative capacities of response threshold distributions across agents to divide labor and complete work 

## Table of Contents

* Supplementary Material
  - [Justification for Softmax Function](https://github.com/colinmichaellynch/Optimal-Threshold-Distributions/blob/main/Modeling%20response%20thresholds%20for%20multiple%20simultaneous%20stimuli%20using%20a%20Boltzmann-sampling%20approach.docx)
  - [Manuscript Draft](https://github.com/colinmichaellynch/Optimal-Threshold-Distributions/blob/main/Independent%20and%20normally-distributed%20response%20thresholds%20are%20biologically%20feasible%20for%20social%20insects.docx)
* Simulation Code
* Data Analytics

## Background 

Division of labor models for social insects often use response thresholds as a mechanism for how individual workers choose to do different tasks, and variation in these thresholds is what produces division of labor. Most models use normal distributions to describe the distribution of thresholds, however there is little justification for this assumption beyond the observation that many traits are normal. Here, we test the validity of this assumption by measuring how well normal distributions reproduce real ant colony behavior compared to other biologically-relevant distributions and one produced by a genetic algorithm. 

## Methods

* We first create 4 distribution types which are each controlled by their own set of parameters:
  - Task-Sharing: all ants have the same response threshold
  - Elite: a subset of ants have low thresholds for all tasks. Everyone else has a high threshold.
  - Caste: each task has a group of ants that have a low threshold for that task. Everyone else has a high threshold for the task.
  - Normal Distribution: all response thresholds across tasks and ants are independently drawn from a normal distribution. 

* We then run MCMC model where a colony of N ants need to perform T tasks.
  - The need for each task is captured by a signal. The higher the signal, the more the task needs to be done. 
  - Ants can choose to do any one of the tasks or rest. 
  - This choice depends on the ant's reponse threshold. The lower it is, the more likely they are to do the task. 
  - We use softmax function to determine this probability. 
  - We run simulations with different combinations of free parameters, including N
  
* At the end of the simulation, we record:
  - How much each ant performed each task, which allows us to calculate division of labor. 
  - How activity is distributed across each task. We measure how right-tailed it is with kurtosis
  - Whether or not 

normal distributions performed the best. it had the highest kurtosis levels, it successfully predicted the relationship between N and DOL, and it had a realistic DOL range. It also performed well compared to GA 

ultimately ga algorithm does not produce performance better than other algorithms
biologically, this means that typical distributions may be sufficient for accomplishing colony goals
for multi agent systems, this means that finkiky and computationally expensive optimization methods may not be necessary to organize swarms. This model took a lot of manual tuning, and on average took 6 times longer to find an optimal solution than it did for the biological distributions. 
