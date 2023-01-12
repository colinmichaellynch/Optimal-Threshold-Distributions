# Optimal-Threshold-Distributions
I compare the relative capacities of response threshold distributions across agents to divide labor and complete work 

## Table of Contents

* Supplementary Material
  - [Justification for Softmax Function](https://github.com/colinmichaellynch/Optimal-Threshold-Distributions/blob/main/Modeling%20response%20thresholds%20for%20multiple%20simultaneous%20stimuli%20using%20a%20Boltzmann-sampling%20approach.docx)
  - [Manuscript Draft](https://github.com/colinmichaellynch/Optimal-Threshold-Distributions/blob/main/Independent%20and%20normally-distributed%20response%20thresholds%20are%20biologically%20feasible%20for%20social%20insects.docx)
* [Simulation Code](https://github.com/colinmichaellynch/Optimal-Threshold-Distributions/blob/main/masterScriptContinuousVariable.m)
* [Data Analytics](https://github.com/colinmichaellynch/Optimal-Threshold-Distributions/blob/main/matrixAnalysisFinal.R)

## Background 

Division of labor models for social insects often use response thresholds as a mechanism for how individual workers choose to do different tasks, and variation in these thresholds is what produces division of labor. Most models use normal distributions to describe the distribution of thresholds, however there is little justification for this assumption beyond the observation that many traits are normal. Here, we test the validity of this assumption by measuring how well normal distributions reproduce real ant colony behavior compared to other biologically-relevant distributions and one produced by a genetic algorithm. 

## Methods

* We first create 4 distribution types which are each controlled by their own set of parameters:
  - In the following figure, the x-axis shows individuals, the y-axis is task, and the color is the response threshold level. 
  - A) Task-Sharing: all ants have the same response threshold
  - B) Elite: a subset of ants have low thresholds for all tasks. Everyone else has a high threshold.
  - C) Caste: each task has a group of ants that have a low threshold for that task. Everyone else has a high threshold for the task.
  - D) Normal Distribution: all response thresholds across tasks and ants are independently drawn from a normal distribution. 

<p align="center">
  <img width="475" height="450" src=/Images/distributionTypes.png>
</p>

* We then run MCMC model where a colony of N ants need to perform T tasks.
  - The need for each task is captured by a signal. The higher the signal, the more the task needs to be done. 
  - Ants can choose to do any one of the tasks or rest. 
  - This choice depends on the ant's reponse threshold. The lower it is, the more likely they are to do the task. 
  - We use softmax function to determine this probability. 
  - We run simulations with different combinations of free parameters, including N
  
* At the end of the simulation, we record:
  - How much each ant performed each task, which allows us to calculate division of labor. 
  - How activity is distributed across each task. We measure how right-tailed it is with kurtosis
  - Whether or not division of labor has a positive correlation with N.
  
* We also want to know how well these natural distributions will perform relative to an artificial distribution created by a genetic algorithm. 

<p align="center">
  <img width="260" height="250" src=/Images/gaDist.png>
</p>

## Results

* Normal and caste distributions produce the most realistic levels of divison of labor. In the following figure, x shows the distribution types, y is the division of labor index of a simulation for a unique parameter combination, and the orange lines show the range of division of labor indeces in real social insects.

<p align="center">
  <img width="500" height="400" src=/Images/dol.png>
</p>

* Only a normal distribution of thresholds produces right-tailed distributions like those of real social insects (which follow exponential and gamma distributions, the kurtosis level of these distributions is represented by the top orange line in the following figure). Other distribution types produce more normal-looking distributions (the bottom orange line). 

<p align="center">
  <img width="500" height="350" src=/Images/activity.png>
</p>

* Normal and elite distributions predict a significant and positive relationship between colony size and division of labor. 

* All distribution types perform as well as the genetic algorithm-designed distribution in terms of most performance metrics. The one exception is that the GA distribution allowed the simulation to reach equilibrium sooner than the natural distributions. In the following figure, we show the rank of each algorithm in terms of accomplishing some colony-level goal, represented on the x-axis. 

<p align="center">
  <img width="500" height="350" src=/Images/ranks.png>
</p>

* Normal distributions pass all tests, indiciating that this is a valid assumption to make for future models. 

* Engineers can use normal distributions to solve task allocation problems for task allocation problems.
  - The normal distribution is much easier to optimize than a genetic algorithm, taking 6 times less computational time. 
  - Normal distributions also perform nearly as well as the GA distribution.  

## Acknowledgements

I would like to thank my collaborator Dr. Ted Pavlic for his advice and mathematical insights. 
