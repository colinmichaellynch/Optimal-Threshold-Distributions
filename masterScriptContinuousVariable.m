clear

%http://www.cs.us.es/~fsancho/ficheros/IA2019/TheContinuousGeneticAlgorithm.pdf
%terminate when solution plateaus 

%% Set Constants for sims
T = 4; %8
N = 25; %100
alpha = 3;
timesteps = 1000;
sims = 3; 
pStop = 1/5;
sInitial = 0;  
delta = .6;
kSoftmax = 5;

%% Set constants for GA
populationSize = 1000; %must be even
generations = 2500; 
minThreshold = -5;
maxThreshold = 5; 
Nkeep = 4;
crossoverNumber = 3; 

%% Genetic representation of solution
initalGeneration = minThreshold + rand(T, N, populationSize)*(maxThreshold-minThreshold); 

%% Fitness function, proximity target stimulus value
targetStim = 2; 

%% Mutation rate for mutation function
mutationRate = .2; 

%% Run GA
thresholdTens = zeros(T, N, Nkeep); 

for a = 1:generations
    
    parfor b = 1:populationSize    
        sFitness(b) = fitnessFunction(initalGeneration, sims, b, ...
            delta, kSoftmax, sInitial, pStop, alpha, T, N, timesteps,targetStim);
    end

    [minValues, minIndeces] = mink(sFitness, Nkeep);
    
    for b = 1:Nkeep
        thresholdTens(:, :, b) = initalGeneration(:, :, minIndeces(b));
    end
    
    for b = 1:Nkeep
        initalGeneration(:, :, b) = thresholdTens(:, :, b);
    end
    
    [smallestValue, smallestIndx] = min(sFitness); 
    thresholdMat1 = initalGeneration(:, :, smallestIndx);

    %save best solution
    if a == 1
        bestMat1 = thresholdMat1; 
        sFitness1 = smallestValue; 
    else
        if smallestValue < sFitness1
            sFitness1 = smallestValue; 
            bestMat1 = thresholdMat1; 
        end
    end

    %crossover function on a vector level, 2 randomly paired parents 
    counter = Nkeep;
    while counter < populationSize
        
        indx = datasample(1:4, 2,'Replace',false);
        thresholdVec1 = thresholdTens(:, :, indx(1)); 
        thresholdVec1 = thresholdVec1(:); 
        thresholdVec2 = thresholdTens(:, :, indx(2)); 
        thresholdVec2 = thresholdVec2(:); 
        
        crossOverPoints = [1 sort(datasample(2:(length(thresholdVec1)-1), crossoverNumber,'Replace',false), 'ascend') length(thresholdVec1)+1]; 
        offspring1 = []; 
        offspring2 = [];
        %crossover
        for c = 1:(crossoverNumber+1)
           
            beta = rand; 
            c1 = crossOverPoints(c);
            c2 = crossOverPoints(c+1);
            %blending
            offspring1 = [offspring1; beta.*(thresholdVec1(c1:(c2-1)))+(1-beta).*(thresholdVec2(c1:(c2-1)))]; 
            offspring2 = [offspring2; beta.*(thresholdVec2(c1:(c2-1)))+(1-beta).*(thresholdVec1(c1:(c2-1)))]; 
            %extrapolation with linear crossover
            %{
            for d = c1:(c2-1)

                beta = .5 + rand*(1.5-.5); 
                value(1) = .5*thresholdVec1(d)+.5*thresholdVec2(d);
                value(2) = beta*thresholdVec1(d)-beta*thresholdVec2(d);
                value(3) = -beta*thresholdVec1(d)+beta*thresholdVec2(d);
                value = value(value > minThreshold & value < maxThreshold);
                value1 = datasample(value,1); 
                offspring1 = [offspring1; value1]; 
                value2 = datasample(value,1); 
                offspring2 = [offspring2; value2]; 
                
            end
            %offspring1 = [offspring1; beta.*(thresholdVec1(c1:(c2-1))-thresholdVec2(c1:(c2-1)))+thresholdVec1(c1:(c2-1))]; 
            %offspring2 = [offspring2; beta.*(thresholdVec2(c1:(c2-1))-thresholdVec1(c1:(c2-1)))+thresholdVec2(c1:(c2-1))];     
            %}
        end
        beta = rand; 
        counter = counter+1;
        initalGeneration(:, :, counter) = reshape(offspring1, T, N);
        counter = counter+1;
        initalGeneration(:, :, counter) = reshape(offspring1, T, N);
        
    end
    
    %mutation function
    for c = 2:populationSize
        
        thresholdVec = initalGeneration(:, :, c); 
        thresholdVec = thresholdVec(:); 
        for d = 1:(T*N)
            if rand < mutationRate
                thresholdVec(d) = minThreshold + rand*(maxThreshold-minThreshold); 
            end
        end

        initalGeneration(:, :, c) = reshape(thresholdVec, T, N);
    end
    
    bestSolution(a) = sFitness1;
    meanDistribution(a) = mean(thresholdVec1); 
    varDistribution(a) = std(thresholdVec1); 
    
    a/generations
    
    %check if reached convergence
    %if a > 100
    %    if abs(mean(diff(bestSolution(length(bestSolution)-100:end)))) < .00001
    %        generations = a;
    %        break
    %    end
    %end
    
end

%% Evaluate model
figure(1) 
plot(1:generations, bestSolution)
hold on
plot(1:generations, meanDistribution)
plot(1:generations, varDistribution)

figure(2)
heatmap(initalGeneration(:, :, 1))

thresholdMat = initalGeneration(:, :, 1);
thresholdMat = [thresholdMat; zeros(1, N)];
[~, SMat] = runSimulation(delta, kSoftmax, sInitial, pStop, alpha, T, N, timesteps, thresholdMat);

figure(3)
plot(mean(SMat(1:T, :)))
hold on
yline(targetStim)

((mean(mean(SMat(1:T, :)))-targetStim)^2)

figure(4)
heatmap(bestMat1)

figure(1)
hist(bestMat1(:))

thresholdMat = bestMat1;
thresholdMat = [thresholdMat; zeros(1, N)];
[~, SMat] = runSimulation(delta, kSoftmax, sInitial, pStop, alpha, T, N, timesteps, thresholdMat);

figure(5)
plot(mean(SMat(1:T, :)))
hold on
yline(targetStim)

((mean(mean(SMat(1:T, :)))-targetStim)^2)


%{
A = [meanMat(:), SDMat(:), sLoss(:),SMeanMat(:), taskSwitchMat(:), SSDMat(:), dolTaskIntoIndMat(:), dolIndIntoTaskMat(:), timeEQMat(:), workerNumberMat(:), workerVariationMat(:)]; 
table = array2table(A);
table.Properties.VariableNames(1:11) = {'MeanDist', 'SSDDistriubtion', 'Loss', 'meanS', 'taskSwitch', 'SSD', 'dolTaskIntoIndMat', 'dolIndIntoTaskMat', 'timeToEQ', 'workerNumber', 'workerNumberVar'};
writetable(table,'NormalDist.csv')
%}
