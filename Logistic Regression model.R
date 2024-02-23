#import the training set

library(tidyverse)
library(caret)
library(glmnet)
library(tidyverse)
library(dplyr)
library(vip)
library(ROSE)
library(rpart)
library(foreign)
library(ggplot2)
library(MASS)
library(reshape2)
library(GoodmanKruskal)
library(corrplot)

#### load the dataset - Full 
data1=read.csv("CVS_train.csv")
data2=read.csv("CVS_test.csv")
dim(data1)
dim(data2)
summary(data1)
str(data1)

## removing unwanted columns -Keeps - Columns to keep
keeps <- c('Gender', 'Year', 'Degree_Combination', 'Eye_Disease',
           'Family_members_with_eye_Disease', 'Taking_Medications',
           'Wearing_Corrective_Glasses.eyelenses', 'Eye_Surgery', 'Smoking',
           'Mostly_used_Device', 'Brightness_Level', 'Eye_Comfort_Facility',
           'Hours_with_Digital_Devices_Daily', 'Dark_Mode.Dark_Theme',
           'Installed_Blue_Light_filter_apps', 'Sleeping_Hours_Daily', 'Bed_Time',
           'Length_to_Device_from_Eyes', 'Level_of_Keeping_the_Device',
           'Used_Screen_Glasses.Corrective_Glass_with_Blue_Cut',
           'Frequency_of_Breaks', 'Voluntary_Blinking',
           'Frequency_of_Consuming_healthy_foods','Suffer_from_CVS')
train = data1[keeps]
test= data2[keeps]


### recoding response
train$Suffer_from_CVS<-factor(train$Suffer_from_CVS,levels = c('Yes','No'))
#labels = c(1,0)
test$Suffer_from_CVS<-factor(test$Suffer_from_CVS, levels = c('Yes','No'))
summary(train)
summary(test)
dim(train)
dim(test)


######################  Logistic Model #####################
## Keeps- Columns identified from chisquare test
keeps <- c('Gender', 'Year',  
           'Hours_with_Digital_Devices_Daily', 'Wearing_Corrective_Glasses.eyelenses','Eye_Comfort_Facility',
           'Used_Screen_Glasses.Corrective_Glass_with_Blue_Cut','Eye_Disease',
           'Frequency_of_Consuming_healthy_foods','Brightness_Level','Mostly_used_Device',
           'Degree_Combination', 'Suffer_from_CVS')
train_new = train[keeps]
test_new= test[keeps]

library(dplyr)
response=recode(train_new$Suffer_from_CVS, Yes=1, No=0)

train_new = cbind(train_new, response)

### Initial model
m <- glm(response~ Gender+ Year+ Eye_Disease+Wearing_Corrective_Glasses.eyelenses+
           Eye_Comfort_Facility+
           Used_Screen_Glasses.Corrective_Glass_with_Blue_Cut+
           Frequency_of_Consuming_healthy_foods+ Hours_with_Digital_Devices_Daily+Brightness_Level+Mostly_used_Device
         +Degree_Combination,data=train_new,family = binomial("logit"))
summary(m)


# Make predictions
probabilities <- m %>% predict(test_new, type = "response")
predicted.classes <- ifelse(probabilities < 0.5, "No","Yes")
predicted.classes

# Model accuracy
mean(predicted.classes == test_new$Suffer_from_CVS)


### Hosmer lemeshow test 
## H0 -Model is adequate
## H1 -Model is not adequate p value >0.05 -Do not reject H0
library(ResourceSelection)
h1=hoslem.test(m$y,fitted(m))
h1

###step 2
### Backward elimination - Remove least significant model 
#####################################################

m2 <- glm(response~ Gender+ Year+ 
            +Wearing_Corrective_Glasses.eyelenses+
            Eye_Comfort_Facility+
            Used_Screen_Glasses.Corrective_Glass_with_Blue_Cut+
            Frequency_of_Consuming_healthy_foods+ Hours_with_Digital_Devices_Daily+Brightness_Level+Mostly_used_Device
          +Degree_Combination,data=train_new,family = binomial("logit"))
summary(m2)

##### Likelihood ratio 
## H0 -Reduced model  is adequate
## H1 -Full model is adequate p value >0.05 -Do not reject H0
library(lmtest)
lrtest(m, m2)


### Step 3
m3 <- glm(response~ Gender+ Year+ 
            +Wearing_Corrective_Glasses.eyelenses+
            Eye_Comfort_Facility+
            Used_Screen_Glasses.Corrective_Glass_with_Blue_Cut+
            Frequency_of_Consuming_healthy_foods+ Hours_with_Digital_Devices_Daily+
            +Degree_Combination,data=train_new,family = binomial("logit"))
summary(m3)
library(lmtest)
lrtest(m3, m2)

### If best model is m3,

# Make predictions
probabilities <- m3 %>% predict(test_new, type = "response")
predicted.classes <- ifelse(probabilities < 0.5, "No","Yes")
predicted.classes

# Model accuracy
mean(predicted.classes == test_new$Suffer_from_CVS)


### Hosmer lemeshow test 
## H0 -Model is adequate
## H1 -Model is not adequate p value >0.05 -Do not reject H0
library(ResourceSelection)
h1=hoslem.test(m3$y,fitted(m3))
h1





