## About the project
This project mainly describes how to apply Logistic Regression and an ordinary Logistic Regression model for a classification problem in R. 
The validation of the fitted models via assumption checking is also included in the R notebook.

### Tools used
R programming

### Logistic Regression Model
The response variable - Suffer from CVS (Yes/No) *CVS refers to the Computer Vision Syndrome, which is an eye-related syndrome associated with screen time.
Independent variables- 'Gender', 'Year',  'Hours_with_Digital_Devices_Daily', 'Wearing_Corrective_Glasses.eyelenses','Eye_Comfort_Facility',
           'Used_Screen_Glasses.Corrective_Glass_with_Blue_Cut','Eye_Disease','Frequency_of_Consuming_healthy_foods','Brightness_Level','Mostly_used_Device','Degree_Combination')

The backward elimination is conducted to obtain the simplest model that fits the data well.
Refer to the code for more explanations.

The following tests are used to check the model assumptions.

**Likelihood Ratio Test (LR Test)**

This test assesses the goodness of fitness of two statistical models.

Hypothesis:  
 *H0 = Reduced Model is adequate*
              
*HA = Full model is adequate*

**Hosmer and Lemeshow Test**

The Hosmer-Lemeshow goodness-of-fit test is used to assess whether the number of expected events from the logistic regression model reflects the number of observed events in the data.

Hypothesis:   
*H0 ∶ Model fits the data well*
              
*H1 : Model does not fit the data well*


**Box-Tidwell Test**

Box Tidwell test can be used to check the linearity between the continuous predictors and the logit in the logistic regression. The Box Tidwell test checks linearity assumption in logistic regression
by adding a nonlinear transform of the original predictor as an interaction term to the test. Here the nonlinear transform of the predictor is calculated by the cross product of each predictor value times
its natural logarithm. That is [x. log(x)] where x is the value of the continuous predictor. 

If that nonlinear transformation is significant, then it is concluded that there is nonlinearity in the logistic regression model. This test can be conducted by the ‘boxTidwell()’ function in R in the
‘car’ package.

The results for the best model are described below.

<img width="697" height="688" alt="image" src="https://github.com/user-attachments/assets/1abf586a-69a8-4bd4-8b73-77a02a499cea" />

Hosmer Lemeshow test:

<img width="697" height="68" alt="image" src="https://github.com/user-attachments/assets/8bc56712-bc4b-4e17-8938-0c3d24b46f66" />

The p-value is greater than the significance level (0.05). Therefore, it can be concluded that the model fits the data well.

Linearity between the continuous predictors and the log odds - Box-Tidwell Test:

<img width="522" height="77" alt="image" src="https://github.com/user-attachments/assets/4b28b6ff-2ad0-4f89-84e1-96f97f3b115f" />

The p-value is greater than the significance level (0.05). Therefore, it can be concluded that the linearity assumption between the continuous predictors and the log odds is not violated.

No strongly influential outliers:

<img width="387" height="258" alt="image" src="https://github.com/user-attachments/assets/3076bcd2-4fc1-4071-a771-90af892fbe20" />

By plotting the standardized residuals, it can be seen that no strongly influential points are available. Most of the residuals are in between the range +2 and -2. 





