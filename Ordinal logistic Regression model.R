#import the training set

library(tidyverse)
library(caret)
#library(moments)
library(glmnet)
library(tidyverse)
library(dplyr)
library(vip)

library(ROSE)
library(rpart)
library(foreign)
library(ggplot2)
library(MASS)
#library(Hmisc)
library(reshape2)
library(GoodmanKruskal)
library(corrplot)

#### load the dataset
data1=read.csv("CVS_train.csv")
data2=read.csv("CVS_test.csv")
dim(data1)
dim(data2)
summary(data1)

### Factorizing
cols = c('Gender', 'Year', 'Degree_Combination', 'Eye_Disease',
         'Family_members_with_eye_Disease', 'Taking_Medications',
         'Wearing_Corrective_Glasses.eyelenses', 'Eye_Surgery', 'Smoking',
         'Mostly_used_Device', 'Brightness_Level', 'Eye_Comfort_Facility','Dark_Mode.Dark_Theme',
         'Installed_Blue_Light_filter_apps', 'Bed_Time',
         'Length_to_Device_from_Eyes', 'Level_of_Keeping_the_Device',
         'Used_Screen_Glasses.Corrective_Glass_with_Blue_Cut',
         'Frequency_of_Breaks', 'Voluntary_Blinking',
         'Frequency_of_Consuming_healthy_foods')

data1[cols] <- lapply(data1[cols], factor)
data2[cols] <- lapply(data2[cols], factor)
summary(data1)
summary(data2)

## removing unwanted columns
keeps <- c('Gender', 'Year', 'Degree_Combination', 'Eye_Disease',
           'Family_members_with_eye_Disease', 'Taking_Medications',
           'Wearing_Corrective_Glasses.eyelenses', 'Eye_Surgery', 'Smoking',
           'Mostly_used_Device', 'Brightness_Level', 'Eye_Comfort_Facility',
           'Hours_with_Digital_Devices_Daily', 'Dark_Mode.Dark_Theme',
           'Installed_Blue_Light_filter_apps', 'Sleeping_Hours_Daily', 'Bed_Time',
           'Length_to_Device_from_Eyes', 'Level_of_Keeping_the_Device',
           'Used_Screen_Glasses.Corrective_Glass_with_Blue_Cut',
           'Frequency_of_Breaks', 'Voluntary_Blinking',
           'Frequency_of_Consuming_healthy_foods','CVS_Category')
train = data1[keeps]
test= data2[keeps]

train
test

train$CVS_Category<-factor(train$CVS_Category,
                           levels = c('No CVS','Slightly to Moderate','Moderate to Severe'),
                           labels = c('No CVS','Slight to Moderate','Moderate to Severe'))
test$CVS_Category<-factor(test$CVS_Category,
                          levels = c('No CVS','Slightly to Moderate','Moderate to Severe'),
                          labels = c('No CVS','Slight to Moderate','Moderate to Severe'))
summary(train)
summary(test)
dim(train)
dim(test)



######################  ordinal Logistic Model
###Selected 
keeps <- c('Gender', 'Year',  
           'Hours_with_Digital_Devices_Daily', 'Wearing_Corrective_Glasses.eyelenses','Eye_Comfort_Facility',
           'Used_Screen_Glasses.Corrective_Glass_with_Blue_Cut','Eye_Disease',
           'Frequency_of_Consuming_healthy_foods','Brightness_Level','Mostly_used_Device',
           'Eye_Surgery','Taking_Medications','CVS_Category')
train_new = train[keeps]
test_new= test[keeps]

train_new$CVS_Category = as.ordered(train_new$CVS_Category)
test_new$CVS_Category = as.ordered(test_new$CVS_Category)

## INITIAL MODEL

m <- polr(CVS_Category ~ Gender+ Year+ Wearing_Corrective_Glasses.eyelenses+Eye_Comfort_Facility+Eye_Disease+
            Used_Screen_Glasses.Corrective_Glass_with_Blue_Cut+Frequency_of_Consuming_healthy_foods+
            Hours_with_Digital_Devices_Daily+Brightness_Level+Mostly_used_Device+
            Eye_Surgery+Taking_Medications,data=train_new, Hess=TRUE)
summary(m)
ctable <- coef(summary(m))
p <- pnorm(abs(ctable[, "t value"]), lower.tail = FALSE) * 2
ctable <- cbind(ctable, "p value" = p)
ctable


## PROPOTIONAL ODDS ASSUMPTION-Test of parerral lines - Probability-Omnibus >0.05 -Do not reject Ho
### Ho- Assumption satisfied
## H1-Not satisfied
library(brant)
brant(m)

## ADEQUECY OF MODEL robability- >0.05 -Do not reject Ho
## H0 -Model is adequate
## H1 -model is not adequate
library(generalhoslem)
#lipsitz.test(m)
logitgof(train_new$CVS_Category, fitted(m), g = 5, ord = TRUE)

## DROPPINGB THE LEAST SIGNIFICANT VARIABLKE

m1 <- polr(CVS_Category ~ Gender+ Year+ Wearing_Corrective_Glasses.eyelenses+Eye_Comfort_Facility+Eye_Disease+
             Used_Screen_Glasses.Corrective_Glass_with_Blue_Cut+Frequency_of_Consuming_healthy_foods+
             Hours_with_Digital_Devices_Daily+Brightness_Level+Mostly_used_Device+
             Eye_Surgery,data=train_new, Hess=TRUE)
summary(m1)
ctable <- coef(summary(m1))
p <- pnorm(abs(ctable[, "t value"]), lower.tail = FALSE) * 2
ctable <- cbind(ctable, "p value" = p)
ctable

## CHECKING THE ADEQUATE MODEL_REDUCED OR FULL P value>0.05 -Do not reject Ho
## LIKELIHOOD RATIO TEST
## H0- Reduced model is adequate
## H1-Full model is adequate
library(lmtest)
lrtest(m, m1)
anova(m,m1, test ="Chisq")

##### IF VTHE REDUCED MODEL IS ADEQUATE AGAIN DROP A LEAST SIGNIFICANT VARIABLE
m2 <- polr(CVS_Category ~ Gender+ Year+Eye_Comfort_Facility+Eye_Disease+
             Used_Screen_Glasses.Corrective_Glass_with_Blue_Cut+Frequency_of_Consuming_healthy_foods+
             Hours_with_Digital_Devices_Daily+Brightness_Level+Mostly_used_Device+
             Eye_Surgery,data=train_new, Hess=TRUE)
summary(m2)
ctable <- coef(summary(m2))
p <- pnorm(abs(ctable[, "t value"]), lower.tail = FALSE) * 2
ctable <- cbind(ctable, "p value" = p)
ctable

lrtest(m1, m2)
anova(m1,m2, test ="Chisq")


##### CONTINUE THIS PROCESS

## AFTER TAKING THE SIMPKEST ADEQUATE MODEL,

#Compute confusion table and misclassification error
predictions = predict(m2,test_new)
(tab = table(test_new$CVS_Category , predictions))
1 - sum(diag(tab)/sum(tab))
confusionMatrix(table(prob=predictions,true=test_new$CVS_Category ))


## PRopotional Assumptional Assumption

library(brant)
brant(m2)

## Adequacy
logitgof(train_new$CVS_Category, fitted(m), g = 5, ord = TRUE)

## LOG ODDS
ci = confint(m2)
exp(cbind(OR = coef(m2), ci))
