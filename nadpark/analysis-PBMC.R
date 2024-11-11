#### Exploration of results about NAD

library('inferno')

## How many parallel cores for the calculations
parallel <- 4

## Name of directory where the "learning" has been saved
learnt <- 'output_learn_MDS_PBMC_NAD-241111T125941-vrt13_dat30_smp3600'

## Consider several variate domains
valuelist <- list(
Age = 40:80, # as an example
TreatmentGroup = c('NR', 'Placebo'),
Sex = c('Female', 'Male'),
AnamnesticLossSmell = c('No', 'Yes'),
History.REM.SleepBehaviourDisorder = c('No', 'Yes'),
MDS.ClinicalDiagnosisCriteria = c('Established', 'Probable'),
Tot.MDS.UPDRS.V1 = 15:80,
Tot.MDS.UPDRS.diff21 = (-20):20,
NAD.ATP.V1 = seq(0.1, 0.7, by = 0.01),
NAD.ATP.ratio21 = seq(0.1, 2.5, by = 0.05),
PBMCs.Me.Nam.V1 = seq(0.01, 2.5, by = 0.01),
PBMCs.Me.Nam.ratio21 = seq(0.1, 8, by = 0.05)
)

combinations <- expand.grid(
    Sex = sexValues,
    MDS.ClinicalDiagnosisCriteria = diagnValues,
    AnamnesticLossSmell = smellValues,
    History.REM.SleepBehaviourDisorder = remValues,
    stringsAsFactors = FALSE)

Y <- data.frame(PBMCs.Me.Nam.ratio21 = 1)

toplot <- c('MDS.ClinicalDiagnosisCriteria',
    'AnamnesticLossSmell',
    'History.REM.SleepBehaviourDisorder',
    'Sex')

qtiles <- c(0.25,0.75)
lower.tail <- FALSE
if(lower.tail){
    addpdf <- 'low'
    addylab <- '<'
}else{
    addpdf <- 'hi'
    addylab <- '>'
}
mypdf(paste0('__testcheck50', addpdf))
for(vrt in toplot){
    for(val in valuelist[[vrt]]){
        X <- setNames(expand.grid('Placebo', valuelist$Age, val,
            stringsAsFactors = FALSE),
            c('TreatmentGroup', 'Age', vrt))
        tprobPl <- tailPr(Y=Y, X=X, learnt=learnt, quantiles=qtiles,
            parallel=parallel, lower.tail=lower.tail)
        ##
        X <- setNames(expand.grid('NR', valuelist$Age, val,
            stringsAsFactors = FALSE),
            c('TreatmentGroup', 'Age', vrt))
        tprobNR <- tailPr(Y=Y, X=X, learnt=learnt, quantiles=qtiles,
            parallel=parallel, lower.tail=lower.tail)
        ##
        plot(tprobPl, legend=FALSE, col=3, lty=2,
            xlab='Age', ylab=paste0('P(PBMCs.Me.Nam.ratio21 ', addylab, ' 1)'), ylim=0:1)
        plot(tprobNR, legend=FALSE, col=2, add = TRUE)
        abline(h=0.5, col=5, lty=2, lwd=2)
        ##
        mylegend('topleft', legend=paste0(vrt,'=',val), lty=NA, pch=NA,
            cex=0.75)
        mylegend('topright', legend=c('Placebo','NR'),
            lty=c(2,1), pch=NA, lwd=3, col=c(3,2),
            cex=0.75)
    }
}
##
##
X <- data.frame(
    Age=valuelist$Age,
    TreatmentGroup='Placebo',
    Sex='Female',
    MDS.ClinicalDiagnosisCriteria='Probable',
    ## Sex='Male',
    ## MDS.ClinicalDiagnosisCriteria='Established',
    AnamnesticLossSmell='Yes',
    History.REM.SleepBehaviourDisorder='Yes')
tprobPl <- tailPr(Y=Y, X=X, learnt=learnt, quantiles=qtiles,
            parallel=parallel, lower.tail=lower.tail)
##
X <- data.frame(
    Age=valuelist$Age,
    TreatmentGroup='NR',
    Sex='Female',
    MDS.ClinicalDiagnosisCriteria='Probable',
    ## Sex='Male',
    ## MDS.ClinicalDiagnosisCriteria='Established',
    AnamnesticLossSmell='Yes',
    History.REM.SleepBehaviourDisorder='Yes')
tprobNR <- tailPr(Y=Y, X=X, learnt=learnt, quantiles=qtiles,
    parallel=parallel, lower.tail=lower.tail)
##
plot(tprobPl, legend=FALSE, col=3, lty=2,
    xlab='Age', ylab=paste0('P(PBMCs.Me.Nam.ratio21 ', addylab, ' 1)'), ylim=0:1)
plot(tprobNR, legend=FALSE, col=2, add = TRUE)
abline(h=0.5, col=5, lty=2, lwd=2)
##
mylegend('topleft', legend=paste0('combined'), lty=NA, pch=NA,
    cex=0.75)
mylegend('topright', legend=c('Placebo','NR'),
    lty=c(2,1), pch=NA, lwd=3, col=c(3,2),
    cex=0.75)
##
dev.off()

