# Set working directory
setwd("~/uio/pc/Dokumenter/PhD/Stat_Help/Ronny/OSF_PIAAC_2022/Examples/7-MplusAutomation/")

# # Install MplusAutomation
#install.packages(c("MplusAutomation", "texreg"), dependencies = T)

# Load MplusAutomation
library(MplusAutomation)


# Re-use Ronny's CFA1a model
# MplusAutomation manual (pp. 74--75)
runModels("../2-CFA/CFA1a.inp", showOutput = T)

# Read Mplus output file into R
# MplusAutomation manual (pp. 71--73)
CFA1a <- readModels("../2-CFA/CFA1a.out")



# Request some Mplus output
# MplusAutomation manual (pp. 72--73)

# Summary statistics
CFA1a$summaries

# Model parameters
CFA1a$parameters

# Fully standardised result
CFA1a$parameters$stdyx.standardized
CFA1a$parameters$ci.stdyx.standardized

# If OUTPUT: SAMPSTAT is ordered
CFA1a$sampstat

# If OUTPUT: MOD(ALL) is ordered
CFA1a$mod_indices


# Tabulate (unstandardized) parameters, CIs (low/up 2.5), and fit indices
library(texreg)
screenreg(CFA1a,
    cis = T, # Request confidence intervals
    single.row = T, # Print CIs next to, not below, parameter estimates
    summaries = c("BIC", "CFI", "SRMR") # Order some model fit indices
)


# Plot means and SEs of parameter estimates
library(ggplot2)
model_par <- CFA1a$parameters$stdyx.standardized
model_par <- subset(
    model_par,
    paramHeader == "CURIOUS.BY",
    select = c("param", "est", "se")
)
limits <- aes(ymax = est + se, ymin = est - se)
pdf(file="wrapper.pdf")
    ggplot(model_par, aes(x = param, y = est)) +
        geom_pointrange(limits) +
        xlab("Items") + ylab("Factor Loadings")
dev.off()
