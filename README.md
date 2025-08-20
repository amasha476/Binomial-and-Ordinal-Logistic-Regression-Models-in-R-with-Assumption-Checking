## About the project
This project mainly describes how to apply Logistic Regression and an ordinary Logistic Regression model for a classification problem in R. 
The validation of the fitted models via assumption checking is also included in the R notebook.

### Tools used
R programming

### Logistic Regression Model
The response variable - Suffer from CVS (Yes/No)

*CVS refers to the Computer Vision Syndrome, which is an eye-related syndrome associated with screen time.

Independent variables- 'Gender', 'Year',  'Hours_with_Digital_Devices_Daily', 'Wearing_Corrective_Glasses.eyelenses','Eye_Comfort_Facility',
           'Used_Screen_Glasses.Corrective_Glass_with_Blue_Cut','Eye_Disease','Frequency_of_Consuming_healthy_foods','Brightness_Level','Mostly_used_Device','Degree_Combination'

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

* Accuracy of the best binomial logistic regression- 66.67%
* Sensitivity- 88.0%
* Specificity- 7.4%

Hosmer Lemeshow test:

<img width="697" height="68" alt="image" src="https://github.com/user-attachments/assets/8bc56712-bc4b-4e17-8938-0c3d24b46f66" />

The p-value is greater than the significance level (0.05). Therefore, it can be concluded that the model fits the data well.

Linearity between the continuous predictors and the log odds - Box-Tidwell Test:

<img width="522" height="77" alt="image" src="https://github.com/user-attachments/assets/4b28b6ff-2ad0-4f89-84e1-96f97f3b115f" />

The p-value is greater than the significance level (0.05). Therefore, it can be concluded that the linearity assumption between the continuous predictors and the log odds is not violated.

No strongly influential outliers:

<img width="387" height="258" alt="image" src="https://github.com/user-attachments/assets/3076bcd2-4fc1-4071-a771-90af892fbe20" />

By plotting the standardized residuals, it can be seen that no strongly influential points are available. Most of the residuals are in between the range +2 and -2. 



### Ordinal Logistic Regression Model

Respons Variable - CVS Category (No CVS / Slight to Moderate CVS /  Moderate to Severe CVS )

Independent variables are the same as earlier.

The following statistical test is conducted additionally than the above tests.

**Test of Parallel Lines-Proportional Odds Assumption:**

This test is conducted to check the proportional odds assumption in the ordinal logistic regression model which assumes that the coefficients in the model are the same across the response categories.

Hypothesis:

𝐻0 = 𝑇ℎ𝑒 𝑠𝑙𝑜𝑝𝑒𝑠 𝑜𝑓 𝑡ℎ𝑒 𝑙𝑖𝑛𝑒𝑠 𝑎𝑟𝑒 𝑠𝑎𝑚𝑒 𝑎𝑐𝑟𝑜𝑠𝑠 𝑡ℎ𝑒 𝑐𝑎𝑡𝑒𝑔𝑜𝑟𝑖𝑒𝑠 𝑖𝑛 𝑟𝑒𝑠𝑝𝑜𝑛𝑠𝑒

𝐻𝐴 = 𝑇ℎ𝑒 𝑠𝑙𝑜𝑝𝑒𝑠 𝑎𝑟𝑒 𝑑𝑖𝑓𝑓𝑒𝑟𝑒𝑛𝑡 𝑎𝑐𝑟𝑜𝑠𝑠 𝑡ℎ𝑒 𝑐𝑎𝑡𝑒𝑔𝑜𝑟𝑖𝑒𝑠 𝑖𝑛 𝑟𝑒𝑠𝑝𝑜𝑛𝑠e

The results for the best model is described below.

Ordinal logistic regression model was fitted using ‘MASS’ library in R. 

Hosmer Lemeshow test:

<img width="592" height="56" alt="image" src="https://github.com/user-attachments/assets/e80f5b08-ff0e-4f7a-8df3-cad32e2f77a7" />

The p-value is greater than the significance level (0.05). Therefore, it can be concluded that the fitted model fits the data well

Proportional Odds Assumption-Test of parallel lines:

<img width="597" height="57" alt="image" src="https://github.com/user-attachments/assets/d5955a16-5d70-441a-a7fd-9ab3935e090d" />

The p-value is greater than the significance level (0.05). Therefore, it can be concluded that the fitted model holds the proportional odds assumption.

Visualization of Effects:

Graphical interpretation of the ordinal logistic regression model can be obtained by the ‘Effect’ library in R.

* It can be observed that the male undergraduates are more likely to not have CVS. Suffering from slight to moderate CVS and moderate to severe CVS is higher for females than male.
* 1st year undergraduates are less likely to suffer from CVS and the 3rd and 4th year undergraduates are more likely to suffer from slight to moderate and moderate to severe CVS.

  <img width="410" height="398" alt="image" src="https://github.com/user-attachments/assets/921e85c3-75cd-4c18-9c39-4f02bf7f131f" />

  <img width="412" height="393" alt="image" src="https://github.com/user-attachments/assets/0e605550-4703-41c3-80ef-859c0fcac708" />







