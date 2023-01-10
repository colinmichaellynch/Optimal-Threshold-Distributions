function percentAgreement = coincidenceCount(stateMat, thresholdMat, N, T)

coincidenceCounter = 0; 
for n = 1:N
   states = nonzeros(stateMat(n,:)); 
   [GC,GR] = groupcounts(states); 
   
  [~,p] = sort(GC,'descend');
   r = 1:length(GC);
   r(p) = r;
   
   thresholdsAnt = (thresholdMat(n,:)); 
   thresholdsAnt = thresholdsAnt(1:T);
   thresholdsAnt = thresholdsAnt(GR); 
   
   [~,p] = sort(thresholdsAnt,'ascend');
   r2 = 1:length(thresholdsAnt);
   r2(p) = r2;
   
   %[~, maxStateIndex] = max(GC); 
   %maxState = GR(maxStateIndex); 

   %thresholdsAnt = nonzeros(thresholds(n,:)); 
   %[~, minThreshold] = min(thresholdsAnt); 
   if all(r == r2)
       coincidenceCounter = coincidenceCounter+1; 
   end

end

percentAgreement = coincidenceCounter/N;