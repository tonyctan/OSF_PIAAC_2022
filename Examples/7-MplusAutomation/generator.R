# Set working directory
setwd("~/uio/pc/Dokumenter/PhD/Stat_Help/Ronny/OSF_PIAAC_2022/Examples/7-MplusAutomation/")

# Load MplusAutomation
library(MplusAutomation)

# Turn the template file into Mplus input files
createModels("template.txt")
# There must be NO COMMENTS (!) between [[init]] and [[/init]]
# Remember to inspect the *.inp files

# Run all the input models
runModels("./batch/", recursive = T)

# Pool the models together
cfa <- readModels("./batch/", recursive = T)

# Summarise the models
SummaryTable(cfa)

# Pair-wise comparison
# MplusAutomation manual (p. 8)
compareModels(
    cfa[["..batch..NOR.NOR.out"]], # Model 1
    cfa[["..batch..SWE.SWE.out"]], # Model 2
    show = "all",
    equalityMargin = c(param = .1, pvalue = .025),
    compare = "stdyx.standardized", # Use fully standardised versions
    sort = "none",
    showNS = T, # Show non-significant parameter estimates?
    diffTest = F # Only meaningful for nested models
)
