function [dolTaskIntoInd, dolIndIntoTask, symmetricDol] = DOLCalculation(T, N, stateMat)

for r = 1:T+1
    for n = 1:N
        taskMatrix(r, n) = sum(stateMat(n,:)==r-1); 
    end
end

%taskMatrix = taskMatrix(2:end,:);

taskMatrixProb = taskMatrix/sum(sum(taskMatrix)); 
[rows, columns] = size(taskMatrix); 

pInd = repelem(1/columns, columns);
for r = 1:rows
   pTask(r) = sum(taskMatrix(r,:))/sum(sum(taskMatrix));
end
hInd = (-1).*sum(pInd.*log(pInd));
internal = pTask.*log(pTask);
internal(isnan(internal)) = 0;
hTask = (-1)*sum(internal);

IMat = taskMatrixProb;

for r = 1:rows
    for n = 1:columns
        IMat(r,n) = taskMatrixProb(r, n) * log(taskMatrixProb(r, n)/(pInd(n)*pTask(r))); 
    end
end

IMat(isnan(IMat)) = 0;
I = sum(sum(IMat)); 

dolTaskIntoInd = I/hInd;
if dolTaskIntoInd>1
    dolTaskIntoInd = 1-(rand/100);
end
dolIndIntoTask = I/hTask;
if dolIndIntoTask>1
    dolIndIntoTask = 1-(rand/100);
end
symmetricDol = I/sqrt(hInd*hTask);
if symmetricDol>1
    symmetricDol = 1-(rand/100);
end