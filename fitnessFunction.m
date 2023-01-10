function [sFitness] = fitnessFunction(initalGeneration, sims, b,...
    delta, kSoftmax, sInitial, pStop, alpha, T, N, timesteps, targetStim)

%generate new solution
thresholdMat = initalGeneration(:, :, b); 
thresholdMat = [thresholdMat; zeros(1, N)];

%fitness function 
for c = 1:sims
    %[softmaxSMean(c), ~, softmaxTaskSwtichAverage(c), softmaxSSD(c), dolTaskIntoIndSoftmax(c), dolIndIntoTaskSoftmax(c), timeStepsToEQ(c), workerNumber(c), workerVariation(c)] = ...
    %    runSimulation(delta, kSoftmax, sInitial, pStop, alpha, T, N, timesteps, thresholdMat);
    [softmaxSMean(c)] = ...
        runSimulation(delta, kSoftmax, sInitial, pStop, alpha, T, N, timesteps, thresholdMat);
end

sFitness = (mean(softmaxSMean) - targetStim)^2; 

%{
    SMeanMat(b) = mean(softmaxSMean); 
    taskSwitchMat(b) = mean(softmaxTaskSwtichAverage); 
    SSDMat(b) = mean(softmaxSSD);
    dolTaskIntoIndMat(b) = mean(dolTaskIntoIndSoftmax);
    dolIndIntoTaskMat(b) = mean(dolIndIntoTaskSoftmax);
    timeEQMat(b) = mean(timeStepsToEQ); 
    meanMat(b) = threshMean;
    SDMat(b) = threshSD;
    workerNumberMat(b) = mean(workerNumber); 
    workerVariationMat(b) = mean(workerVariation);
    %}
