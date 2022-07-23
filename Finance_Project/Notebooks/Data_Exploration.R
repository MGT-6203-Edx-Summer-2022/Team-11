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
library(reshape2)
library(forcats)
#-------------------------------------------------------------------------------
# Monthly Data
#-------------------------------------------------------------------------------
# Load  data
df_month <- read.csv("../Data/Macro_SP_month.csv", fileEncoding="UTF-8-BOM")
str(df_month)

# Correlation bar chart
df_plot <- subset(df_month, select = -c(shiller_PE, date))
df_plot <- as.data.frame(cor(df_plot[ , colnames(df_plot) != c("SP500")], df_plot$SP500))

p0<- df_plot %>%
       mutate(variable = as.character(row.names(df_plot))) %>%
       mutate(variable = fct_reorder(variable, V1)) %>%
         ggplot(aes(y=V1, x=variable)) + 
         ylim(-1,1) +
         geom_col() +
         ggtitle('Correlation between SP500 & Macroeconomic Variables: 1967 - 2022') +
         ylab("Correlation") + xlab("Macroeconomic Variables") +
         theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

p0

#-------------------------------------------------------------------------------
### QoQ

# Load  data
df_QoQ <- read.csv("../Data/Macro_SP_QoQ.csv", fileEncoding="UTF-8-BOM")

# # Correlation bar chart
df_plot2 <- subset(df_QoQ, select = -c(shiller_PE, date))
df_plot2 <- as.data.frame(cor(df_plot2[ , colnames(df_plot2) != c("SP500")], df_plot2$SP500))

p2<- df_plot2 %>%
  mutate(variable = as.character(row.names(df_plot2))) %>%
  mutate(variable = fct_reorder(variable, V1)) %>%
  ggplot(aes(y=V1, x=variable)) + 
  geom_col() +
  ggtitle('Correlation between SP500 & Macroeconomic Variables: 1967 - 2022') +
  ylim(-1,1) +
  ylab("Correlation QoQ") + xlab("Macroeconomic Variables") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

p2

#----------------------------------------------------------------------------------------
### MoM

# Load  data
df_MoM <- read.csv("../Data/Macro_SP_MoM.csv", fileEncoding="UTF-8-BOM")

# Correlation bar chart
df_plot3 <- subset(df_MoM, select = -c(shiller_PE, date))
df_plot3 <- as.data.frame(cor(df_plot3[ , colnames(df_plot3) != c("SP500")], df_plot3$SP500))

p3<- df_plot3 %>%
  mutate(variable = as.character(row.names(df_plot3))) %>%
  mutate(variable = fct_reorder(variable, V1)) %>%
  ggplot(aes(y=V1, x=variable)) + 
  geom_col() +
  ggtitle('Correlation between SP500 & Macroeconomic Variables: 1967 - 2022') +
  ylim(-1,1) +
  ylab("Correlation MoM") + xlab("Macroeconomic Variables") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

p3

#ggarrange(p1, p2,  ncol = 1, nrow = 2)

#-------------------------------------------------------------------------------
# Combine plots together and plot

# Combining data frames
df_comb <- cbind(df_plot, df_plot2, df_plot3)
names(df_comb) <- c("Period_1967_2022", "QoQ", 'MoM')
df_comb <- arrange(df_comb, Period_1967_2022)

# Modifying dataframe to be able to plot
df_comb$macro_var <- as.character(row.names(df_comb))
df_comb$macro_var <- as_factor(df_comb$macro_var)
df_comb_ <- melt(df_comb, id.vars=c("macro_var"))


# Plot

head(df_comb_)

p1 <- df_comb_ %>%
        filter(variable %in% c('Period_1967_2022')) %>%
        ggplot(aes(x=macro_var, y=value)) + 
        geom_bar(stat='Identity', position=position_dodge()) +
        ggtitle('Correlation between SP500 & Macroeconomic Variables: 1967 - 2022') +
        ylab("Correlation") + xlab("") +
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

#p1 <- df_comb_ %>%
#        ggplot(aes(x=macro_var, y=value, fill=variable)) + 
#        geom_bar(stat='Identity', position=position_dodge()) +
#        ggtitle('Correlation between SP500 & Macroeconomic Variables: 1967 - 2022') +
#        # ylim(-1,1) +
#        ylab("Correlation") + xlab("") +
#        theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

p1


p2 <- df_comb_ %>%
        filter(variable %in% c('MoM','QoQ')) %>%
        mutate(macro_var = as.character(macro_var)) %>%
        arrange(variable, value) %>%
        mutate(macro_var = as_factor(macro_var)) %>%    
        ggplot(aes(x=macro_var, y=value, fill=variable)) + 
        geom_bar(stat='Identity', position=position_dodge()) +
        ggtitle('Correlation between SP500 & Macroeconomic Variables: QoQ/MoM') +
        ylab("Correlation") + xlab("Macroeconomic Variables") +
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
        scale_y_continuous(breaks=seq(-0.5,0.5,0.1))

p2

# Combine plots together and plot
#ggarrange(p1, p2,  ncol = 1, nrow = 2)

################################################################################
# Trend Curves------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Load  data
df_month <- read.csv("../Data/Macro_SP_month.csv", fileEncoding="UTF-8-BOM")

# converting dates to date format
df_month$date <- as.Date(anytime(df_month$date))

# Plots
p1  <- ggplot(df_month, aes(x=date, y=SP500)) + 
         geom_line(color='blue') + labs(x = "") + labs(y = "SP500") +
         labs(title = 'SP500')+theme(plot.title=element_text(face="bold",size=11))

p2  <- ggplot(df_month, aes(x=date, y=PPIACO)) + 
         geom_line(color='blue') + labs(x = "") + labs(y = "PPIACO") +
         labs(title = 'Producer Price Index')+theme(plot.title=element_text(face="bold",size=11))

p3  <- ggplot(df_month, aes(x=date, y=INDPRO)) + 
         geom_line(color='blue') + labs(x = "") + labs(y = "INDPRO") +
         labs(title = 'Industrial Output')+theme(plot.title=element_text(face="bold",size=11))

p4  <- ggplot(df_month, aes(x=date, y=PAYEMS)) + 
         geom_line(color='blue') + labs(x = "") + labs(y = "PAYEMS") +
         labs(title = 'All Employees, Nonfarm')+theme(plot.title=element_text(face="bold",size=11))

p5  <- ggplot(df_month, aes(x=date, y=WTISPLC)) + 
         geom_line(color='blue') + labs(x = "") + labs(y = "WTISPLC") +
         labs(title = 'Oil Prices')+theme(plot.title=element_text(face="bold",size=11))

p6  <- ggplot(df_month, aes(x=date, y=GDP)) + 
         geom_line(color='blue') + labs(x = "") + labs(y = "GDP") +
         labs(title = 'Real GDP')+theme(plot.title=element_text(face="bold",size=11))

p7  <- ggplot(df_month, aes(x=date, y=GDPC1)) + 
         geom_line(color='blue') + labs(x = "") + labs(y = "GDPC1") +
         labs(title = 'GDP')+theme(plot.title=element_text(face="bold",size=11))

p8  <- ggplot(df_month, aes(x=date, y=CPIAUCSL)) + 
         geom_line(color='blue') + labs(x = "") + labs(y = "CPIAUCSL") +
         labs(title = 'Consumer Price Index')+theme(plot.title=element_text(face="bold",size=11))

p9  <- ggplot(df_month, aes(x=date, y=BOGZ1FA895050005Q)) + 
         geom_line(color='blue') + labs(x = "") + labs(y = "BOGZ1FA895050005Q") +
         labs(title = 'Capital Expenditure')+theme(plot.title=element_text(face="bold",size=11))

p10  <- ggplot(df_month, aes(x=date, y=PRS85006023)) + 
         geom_line(color='blue') + labs(x = "") + labs(y = "PRS85006023") +
         labs(title = 'Avg. Hours Worked')+theme(plot.title=element_text(face="bold",size=11))

p11 <- ggplot(df_month, aes(x=date, y=DFF)) + 
         geom_line(color='blue') + labs(x = "") + labs(y = "DFF") +
         labs(title = 'Federal Funds Eff. Rate')+theme(plot.title=element_text(face="bold",size=11))

p12 <- ggplot(df_month, aes(x=date, y=DSPIC96)) + 
         geom_line(color='blue') + labs(x = "") + labs(y = "DSPIC96") +
         labs(title = 'Real Disp.Personal Income')+theme(plot.title=element_text(face="bold",size=11))

p13 <- ggplot(df_month, aes(x=date, y=PCE)) + 
         geom_line(color='blue') + labs(x = "") + labs(y = "PCE") +
         labs(title = 'Personal Consumption Exp.')+theme(plot.title=element_text(face="bold",size=11))

p14 <- ggplot(df_month, aes(x=date, y=W068RCQ027SBEA)) + 
         geom_line(color='blue') + labs(x = "") + labs(y = "W068RCQ027SBEA") +
         labs(title = 'Government Spending')+theme(plot.title=element_text(face="bold",size=11))

p15 <- ggplot(df_month, aes(x=date, y=DGS10)) + 
         geom_line(color='blue') + labs(x = "") + labs(y = "DGS10") +
         labs(title = '10-Year Treasury Maturity Rate')+theme(plot.title=element_text(face="bold",size=11))

p16 <- ggplot(df_month, aes(x=date, y=GFDEBTN)) + 
         geom_line(color='blue') + labs(x = "") + labs(y = "GFDEBTN") +
         labs(title = 'Total Public Debt')+theme(plot.title=element_text(face="bold",size=11))

p17 <- ggplot(df_month, aes(x=date, y=UNRATE)) + 
         geom_line(color='blue') + labs(x = "") + labs(y = "UNRATE") +
         labs(title = 'Unemployment Rate')+theme(plot.title=element_text(face="bold",size=11))

p18 <- ggplot(df_month, aes(x=date, y=ICSA)) + 
         geom_line(color='blue') + labs(x = "") + labs(y = "ICSA") +
         labs(title = 'Initial Unemployment Claims')+theme(plot.title=element_text(face="bold",size=11))

p19 <- ggplot(df_month, aes(x=date, y=PERMIT)) + 
         geom_line(color='blue') + labs(x = "") + labs(y = "PERMIT") +
         labs(title = 'New Housing Permits')+theme(plot.title=element_text(face="bold",size=11))

p20 <- ggplot(df_month, aes(x=date, y=DXY)) + 
         geom_line(color='blue') + labs(x = "") + labs(y = "DXY") +
         labs(title = 'US Dollar Index')+theme(plot.title=element_text(face="bold",size=11))

p21 <- ggplot(df_month, aes(x=date, y=shiller_PE)) + 
         geom_line(color='blue') + labs(x = "") + labs(y = "Shiller_PE") +
         labs(title = 'Shiller PE')+theme(plot.title=element_text(face="bold",size=11))

p22 <- ggplot(df_month, aes(x=date, y=UMCSENT)) + 
         geom_line(color='blue') + labs(x = "") + labs(y = "UMCSENT") +
         labs(title = 'Consumer Sentiment')+theme(plot.title=element_text(face="bold",size=11))



# Combine plots together
ggarrange(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, 
          p16, p17, p18, p19, p20, p21, p22,
          ncol = 4, nrow = 6)

################################################################################

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



