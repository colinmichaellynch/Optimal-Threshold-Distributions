function timeStepsToEQ = equilibriumFinder(SMat)

    SVec = mean(SMat);
    SVecDiff = smooth(smooth(smooth(smooth(diff(SVec))))); 
    SVecDiffBol = SVecDiff > -.00025 & SVecDiff < .00025;
    timeStepsToEQ = min(find(SVecDiffBol==1)); 

end