#-------------------------------------------------------------------------------
# Finance Project - Data Exploration
#-------------------------------------------------------------------------------
# Libraries
library(tidyverse)
library(ggplot2)
library(ggpubr)
library(corrplot)
library(car)
library(lubridate)
library(anytime)
library(ggpubr)
#-------------------------------------------------------------------------------
# Monthly Data
#-------------------------------------------------------------------------------
# Load  data
df_month <- read.csv("../Data/Macro_SP_month.csv", fileEncoding="UTF-8-BOM")

# converting dates to date format
df_month$date <- as.Date(anytime(df_month$date))
head(df_month)

# Removing GDPC1, Shiller_PE
df_month <- subset(df_month, select = -c(GDPC1, shiller_PE))

# correlation matrix
M = cor(df_month[,-1])
corrplot(M, method = 'circle')
M

# Removing UNRATE, ICSA, PERMIT, DXY
df_month <- subset(df_month, select = -c(UNRATE, ICSA, PERMIT, DXY))

# correlation matrix
M = cor(df_month[,-1])
corrplot(M, method = 'number')
M

# Plots
p1  <- ggplot(df_month, aes(x=date, y=SP500)) + geom_line(color='blue')  + labs(x = "Time") + labs(y = "SP500")
p2  <- ggplot(df_month, aes(x=date, y=PPIACO)) + geom_line(color='blue') + labs(x = "Time") + labs(y = "PPIACO")
p3  <- ggplot(df_month, aes(x=date, y=INDPRO)) + geom_line(color='blue') + labs(x = "Time") + labs(y = "INDPRO")
p4  <- ggplot(df_month, aes(x=date, y=PAYEMS)) + geom_line(color='blue') + labs(x = "Time") + labs(y = "PAYEMS")
p5  <- ggplot(df_month, aes(x=date, y=WTISPLC)) + geom_line(color='blue') + labs(x = "Time") + labs(y = "WTISPLC")
p6  <- ggplot(df_month, aes(x=date, y=GDP)) + geom_line(color='blue') + labs(x = "Time") + labs(y = "GDP")
p7  <- ggplot(df_month, aes(x=date, y=CPIAUCSL)) + geom_line(color='blue') + labs(x = "Time") + labs(y = "CPIAUCSL")
p8  <- ggplot(df_month, aes(x=date, y=BOGZ1FA895050005Q)) + geom_line(color='blue') + labs(x = "Time") + labs(y = "BOGZ1FA895050005Q")
p9  <- ggplot(df_month, aes(x=date, y=PRS85006023)) + geom_line(color='blue') + labs(x = "Time") + labs(y = "PRS85006023")
p10 <- ggplot(df_month, aes(x=date, y=DFF)) + geom_line(color='blue') + labs(x = "Time") + labs(y = "DFF")
p11 <- ggplot(df_month, aes(x=date, y=DSPIC96)) + geom_line(color='blue') + labs(x = "Time") + labs(y = "DSPIC96")
p12 <- ggplot(df_month, aes(x=date, y=PCE)) + geom_line(color='blue') + labs(x = "Time") + labs(y = "PCE")
p13 <- ggplot(df_month, aes(x=date, y=W068RCQ027SBEA)) + geom_line(color='blue') + labs(x = "Time") + labs(y = "W068RCQ027SBEA")
p14 <- ggplot(df_month, aes(x=date, y=DGS10)) + geom_line(color='blue') + labs(x = "Time") + labs(y = "DGS10")
p15 <- ggplot(df_month, aes(x=date, y=GFDEBTN)) + geom_line(color='blue') + labs(x = "Time") + labs(y = "GFDEBTN")

# Combine plots together
ggarrange(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, 
          ncol = 3, nrow = 5)

#-------------------------------------------------------------------------------
# Monthly Data
#-------------------------------------------------------------------------------
# Read data
df_MoM <-  read.csv("../Data/Macro_SP_MoM.csv", fileEncoding="UTF-8-BOM")

# Removing GDPC1, Shiller_PE
df_MoM <- subset(df_MoM, select = -c(GDPC1, shiller_PE))

# correlation matrix
M = cor(df_MoM[,-1])
corrplot(M, method = 'number')

#-------------------------------------------------------------------------------
# Regression
#-------------------------------------------------------------------------------
#QoQ----------------------------------------------------------------------------
# Read data
df_QoQ <-  read.csv("../Data/Macro_SP_QoQ.csv", fileEncoding="UTF-8-BOM")
head(df_QoQ)

# Removing GDPC1, Shiller_PE, UNRATE, ICSA, PERMIT, DXY
df_QoQ <- subset(df_QoQ, select = -c(GDPC1, shiller_PE, UNRATE, ICSA, PERMIT, DXY))

m_q <- lm(SP500 ~ ., data=df_QoQ[,-1])
summary(m_q)

vif(m_q)


# Keeping-----------------------------------------------------------------------
# UMCSENT     Consumer Sentiment (Index)
# CPILFESL    Consumer price index for all urban consumers (except food & energy)


# Removing----------------------------------------------------------------------
# PPIACO      Producer Price Index by Commodity
# PAYEMS      All Employees, Total Nonfarm
# GDP         Gross Domestic Product
# CPIAUCSL    Consumer price index for all urban consumers
# GDPC1       Real Gross Domestic Product
# DFF         Federal Funds Effective Rate
# GFDEBTN     Total Public Debt
# ICSA        Initial Unemployment Claims
# INDPRO      Industrial output
# WTISPLC     Oil prices ($/barrel crude oil)
# BOGZ1FA895050005Q  Capital Expenditure
# UNRATE      Unemployment Rate
# PRS85006023 Nonfarm Business Sector: Avg weekly hours worked for all employed
# UMCSENT     Consumer Sentiment (Index)
# DSPIC96     Real disposable personal income
# PCE         Personal consumption expenditures
# PERMIT      New privately-Owned Housing Units authorized in permi_issuing places
# W068RCQ027SBEA  Government spending
# DGS10       10-year treasury constant maturity rate

m_q2 <- lm(SP500 ~ PAYEMS+PRS85006023+PCE+UMCSENT+CPILFESL, data=df_QoQ[,-1])
summary(m_q2)
plot(m_q2)

vif(m_q2)



