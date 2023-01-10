rm(list = ls())

library(ggplot2)
library(ggpubr)
library(betareg)
library(viridis)
library(ggsignif)
library(tidyr)
library(RColorBrewer)

setwd("C:/Users/user/Documents/General Threshold Model/Threshold Matrix Distribution/Optimized Polynomial Matrix/Exhaustive Search")

dataUniform = read.csv("UniformProbVarN.csv")
dataElite= read.csv("EliteDistVarN.csv")
dataCaste= read.csv("CastesVarN.csv")
dataNormal= read.csv("NormalDistVarN.csv")

dataNormal$Mass = log(dataNormal$N*(.0697/22))
dataElite$Mass = log(dataElite$N*(.0697/22))
dataCaste$Mass = log(dataCaste$N*(.0697/22))
dataUniform$Mass = log(dataUniform$N*(.0697/22))

### Does DOL Scale with N? ### 

scaleFUN <- function(x) sprintf("%.3f", x)

#normal
dataNormal$SSDCat = as.factor(round(dataNormal$SSDDistriubtion, 0))

p1 = ggplot(dataNormal, aes(x=Mass, y =dolIndIntoTaskMat, color = SSDCat )) + geom_point() + geom_smooth(method='lm', se=F) + theme_bw() + theme(text = element_text(size = 14)) + xlab("Log(Mass)") + ylab("DOL Index") + scale_color_viridis(discrete = TRUE, option = "D") + theme(aspect.ratio=1) + guides(color=guide_legend(title=bquote(sigma^2))) + scale_y_continuous(labels=scaleFUN) + ggtitle("D)")

mdl1 = betareg(dolIndIntoTaskMat ~ MeanDist + SSDDistriubtion + Mass, data = dataNormal)
mdl2 = betareg(dolIndIntoTaskMat ~ MeanDist * SSDDistriubtion * Mass, data = dataNormal)
mdl3 = betareg(dolIndIntoTaskMat ~ MeanDist + SSDDistriubtion * Mass, data = dataNormal)
mdl4 = betareg(dolIndIntoTaskMat ~ MeanDist * SSDDistriubtion + Mass, data = dataNormal)
mdl5 = betareg(dolIndIntoTaskMat ~ MeanDist * Mass + SSDDistriubtion, data = dataNormal)

AIC(mdl1, mdl2, mdl3, mdl4, mdl5)
BIC(mdl1, mdl2, mdl3, mdl4, mdl5)

mdlNormal = mdl1
summary(mdlNormal)

#uniform
dataUniform$CCat = as.factor(round(dataUniform$C, 0))
p2 = ggplot(dataUniform, aes(x=Mass, y =dolIndIntoTaskMat, color = CCat)) + geom_point() + geom_smooth(method='lm', se=F) + theme_bw() + theme(text = element_text(size = 14)) + xlab("Log(Mass)") + ylab("DOL Index") + scale_color_viridis(discrete = TRUE, option = "D") + theme(aspect.ratio=1) + guides(color=guide_legend(title=bquote(I[T]))) + scale_y_continuous(labels=scaleFUN) + ggtitle("A)")

mdl1 = betareg(dolIndIntoTaskMat ~ C + Mass, data = dataUniform)
mdl2 = betareg(dolIndIntoTaskMat ~ C * Mass, data = dataUniform)

#mdl2 fails to converge

mdlUniform = mdl2
summary(mdlUniform)

#Elite
dataElite$ThreshInterceptCat = as.factor(round(dataElite$ThreshIntercept, 0))
p3 = ggplot(dataElite, aes(x=Mass, y =dolIndIntoTaskMat, color = ThreshInterceptCat)) + geom_point() + geom_smooth(method='lm', se=F) + theme_bw() + theme(text = element_text(size = 14)) + xlab("Log(Mass)") + ylab("DOL Index") + scale_color_viridis(discrete = TRUE, option = "D") + theme(aspect.ratio=1) + guides(color=guide_legend(title=bquote(I[E]))) + scale_y_continuous(labels=scaleFUN) + ggtitle("B)")

mdl1 = betareg(dolIndIntoTaskMat ~ ThreshDiff + ThreshIntercept + Mass, data = dataElite)
mdl2 = betareg(dolIndIntoTaskMat ~ ThreshDiff * ThreshIntercept * Mass, data = dataElite)
mdl3 = betareg(dolIndIntoTaskMat ~ ThreshDiff + ThreshIntercept * Mass, data = dataElite)
mdl4 = betareg(dolIndIntoTaskMat ~ ThreshDiff * ThreshIntercept + Mass, data = dataElite)
mdl5 = betareg(dolIndIntoTaskMat ~ ThreshDiff * Mass + ThreshIntercept, data = dataElite)

AIC(mdl1, mdl2, mdl3, mdl4, mdl5)
BIC(mdl1, mdl2, mdl3, mdl4, mdl5)

mdlElite = mdl1
summary(mdlElite)

#Caste
dataCaste$ThreshInterceptCat = as.factor(round(dataCaste$threshIntercept, 0))
dataCasteGraph = subset(dataCaste, threshDiff>=0)

p4 = ggplot(dataCasteGraph, aes(x=Mass, y =dolIndIntoTaskMat, color = ThreshInterceptCat)) + geom_point() + geom_smooth(method='lm', se=F) + theme_bw() + theme(text = element_text(size = 14)) + xlab("Log(Mass)") + ylab("DOL Index") + scale_color_viridis(discrete = TRUE, option = "D") + theme(aspect.ratio=1) + guides(color=guide_legend(title=bquote(I[C]))) + scale_y_continuous(labels=scaleFUN) + ggtitle("C)")

mdl1 = betareg(dolIndIntoTaskMat ~ threshDiff + threshIntercept + Mass, data = dataCaste)
mdl2 = betareg(dolIndIntoTaskMat ~ threshDiff * threshIntercept * Mass, data = dataCaste)
mdl3 = betareg(dolIndIntoTaskMat ~ threshDiff + threshIntercept * Mass, data = dataCaste)
mdl4 = betareg(dolIndIntoTaskMat ~ threshDiff * threshIntercept + Mass, data = dataCaste)
mdl5 = betareg(dolIndIntoTaskMat ~ threshDiff * Mass + threshIntercept, data = dataCaste)

AIC(mdl1, mdl2, mdl3, mdl4, mdl5)
BIC(mdl1, mdl2, mdl3, mdl4, mdl5)

mdlCaste = mdl3
summary(mdlCaste)

ggarrange(p2, p3, p4, p1, nrow = 2, ncol = 2)

### Right tailed activity ### 

dataGraph = data.frame(Distribution = c(rep("Task Sharing", nrow(dataCaste)), rep("Elite", nrow(dataCaste)), rep("Caste", nrow(dataCaste)),rep("Normal Distribution", nrow(dataCaste))), DOL = c(dataUniform$dolIndIntoTaskMat, dataElite$dolIndIntoTaskMat, dataCaste$dolIndIntoTaskMat, dataNormal$dolIndIntoTaskMat), Kurtosis = c(dataUniform$activityKurtosis, dataElite$activityKurtosis, dataCaste$activityKurtosis, dataNormal$activityKurtosis))

dataSummary <- aggregate(Kurtosis ~ Distribution, median, data=dataGraph)

pairwise.wilcox.test(dataGraph$Kurtosis, dataGraph$Distribution, p.adjust.method = "holm")

ggplot(dataGraph, aes(x = reorder(Distribution, Kurtosis, FUN = median), y = Kurtosis))+ geom_jitter() + theme_bw() + theme(text = element_text(size = 14)) + xlab("Threhold Distribution") + ylab("Activity Kurtosis \nfor Task i") + geom_crossbar(data=dataSummary, aes(ymin = Kurtosis, ymax = Kurtosis), size=.75,col="red", width = .5) + geom_hline(yintercept=9, linetype="dashed", color = "orange", size = 1.5) + annotate("text", x=1.015, y=9.75, label="Exponential/Gamma Distribution", color = 'orange') + geom_hline(yintercept=3, linetype="dashed", color = "orange", size = 1.5) + annotate("text", x=.765, y=3.75, label="Normal Distribution", color = "orange")

ggplot(dataGraph, aes(x= DOL, y = Kurtosis, color = Distribution)) + geom_point() + geom_smooth()

### Division of labor ###

realDOL = c(.15, .42, .2, .65, .1, .31)

dataSummary <- aggregate(DOL ~ Distribution, median, data=dataGraph)

pairwise.wilcox.test(dataGraph$DOL, dataGraph$Distribution, p.adjust.method = "holm")

ggplot(dataGraph, aes(x = reorder(Distribution, DOL, FUN = median), y = DOL))+ geom_jitter() + geom_crossbar(data=dataSummary, aes(ymin = DOL, ymax = DOL), size=.75,col="red", width = .5) + theme_bw() + theme(text = element_text(size = 14)) + xlab("Threhold Distribution") + ylab("DOL Index") + geom_hline(yintercept=min(realDOL), linetype="dashed", color = "orange", size = 1.5) + geom_hline(yintercept=max(realDOL), linetype="dashed", color = "orange", size = 1.5) + annotate("text", x=.75, y=.68, label="Upper DOL Limit", color = 'orange')+ annotate("text", x=.75, y=.13, label="Lower DOL Limit", color = "orange")

#+ annotate("rect", xmin = .6, xmax = 4.4, ymin = min(realDOL), ymax = max(realDOL),alpha = .2, fill = "orange") 

### Compare to GA ### 

### ranks

dataGA = read.csv('~/General Threshold Model/Threshold Matrix Distribution/Genetic Algorithm/optimalMatrices.csv')
dataGA$Model[dataGA$Model == "GA"] = "Genetic Algorithm"
dataGA$Model[dataGA$Model == "U"] = "Task Sharing"
dataGA$Model[dataGA$Model == "E"] = "Elite"
dataGA$Model[dataGA$Model == "C"] = "Castes"
dataGA$Model[dataGA$Model == "N"] = "Normal"
names(dataGA)
pairwise.wilcox.test(dataGA$Mean, dataGA$Model, p.adjust.method = "holm")
ggplot(dataGA, aes(x = Model, y = Mean)) + geom_boxplot() + geom_signif(comparisons=list(c("Genetic Algorithm", "Task Sharing")), map_signif_level = TRUE)
pairwise.wilcox.test(dataGA$SSD, dataGA$Model, p.adjust.method = "holm")
ggplot(dataGA, aes(x = Model, y = SSD)) + geom_boxplot()
pairwise.wilcox.test(dataGA$taskSwitch, dataGA$Model, p.adjust.method = "holm")
ggplot(dataGA, aes(x = Model, y = taskSwitch)) + geom_boxplot()
pairwise.wilcox.test(dataGA$timeStepsToEQ, dataGA$Model, p.adjust.method = "holm")
ggplot(dataGA, aes(x = Model, y = timeStepsToEQ)) + geom_boxplot()
pairwise.wilcox.test(dataGA$workerNumber, dataGA$Model, p.adjust.method = "holm")
ggplot(dataGA, aes(x = Model, y = workerNumber)) + geom_boxplot()

dataRanks = data.frame(Model = c("Genetic Algorithm", "Task Sharing",  "Elite", "Castes", "Normal"), RankSMean = c(3, 3, 3, 3, 3), RankSSD = c(2, 4, 5, 1, 3), RankTSwitch = c(3, 3, 3, 3, 3), RankTimeSteptoEQ = c(1, 3.5, 3.5, 3.5, 3.5), RankWorkerNumber = c(3, 3, 3, 3, 3))

dataRanks <- dataRanks %>% pivot_longer(-Model, names_to="variable", values_to="Rank")
dataRanks$Rank = 6 - dataRanks$Rank

ggplot(dataRanks, aes(x = variable, y = Rank, fill = Model)) + geom_bar(stat = "identity", position = 'dodge') + theme_bw() + theme(text = element_text(size = 14)) + xlab("Performance Metric") + scale_color_viridis(discrete = TRUE, option = "D") + guides(fill=guide_legend(title="Distribution")) + scale_x_discrete(labels=c("RankSMean" = "x Proximity \nto Target", "RankSSD" = "Minimize x \nStandard Deviation", "RankTimeSteptoEQ" = "Fastest \nEquilibrium", "RankTSwitch" = "Minimize \nTask Switches", "RankWorkerNumber" = "Minimize \nWorker Activity")) + scale_y_continuous(breaks = c(1:5), limits = c(0,5),  oob = scales::squish, labels = function(x) 6- x) + scale_fill_brewer(palette = "Dark2") 

matrixGA =  data.matrix(read.csv('~/General Threshold Model/Threshold Matrix Distribution/Genetic Algorithm/GAMatrix.csv'))

T=4
N=25
limitRange = c(-5, 5)
breakRange = seq(-5, 5, by =5)

geneticAlgorithmMatrix = matrix(, T, N)
for(i in 1:T){
  for(j in 1:N){
    geneticAlgorithmMatrix[i, j] = matrixGA[i,j]
  }
}

geneticAlgorithmMatrix = melt(geneticAlgorithmMatrix)
geneticAlgorithmMatrix<-geneticAlgorithmMatrix[geneticAlgorithmMatrix$value!=0,]

ggplot(geneticAlgorithmMatrix, aes(x = Var2, y = Var1)) + geom_raster(aes(fill=value)) + scale_fill_gradient(low="grey90", high="red") + labs(x="Ant ID", y="Task", fill = "Threshold") + theme_bw() + theme(text = element_text(size = 14)) + scale_fill_gradientn(colours = hcl.colors(10, "YlGnBu"),breaks = breakRange, limits = limitRange) + theme(aspect.ratio=1)