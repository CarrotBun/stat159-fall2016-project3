# College Admissions Applet

Our applet has three general functions:

1. School info and stats lookup. 
2. Observe trends between demographic and school statistics for a certain set of schools
3. Suggestions for lowering admission rate for a specific target school.

To look up schools’ information and statistics, one can select state, enrollment size range, and admissions rate range.  With those three criteria selected, 
- the **table** tab will display all the schools that fits the description.
- the **summary** tab gives summary statistics on all the variables that are included in the data
- the **plot** tab will show a scatterplot for any of the two variables selected in the data set

To view more variables listed in the table, one can select multiple variables in **_Table Output - variable selection_**. the table will be updated in real time. 
To change the x and y variables in the plot, one can choose variables from the **Plot Components** section of the applet.

The other main function of the applet is to *predict a school’s admission rate* based on similar schools that has lower admissions rate. This serves to help school administrators to decide which demographic variable they should focus on when recruiting students.

To pick a target school,  use the drop down menu in the lower portion of the applet titled **Pick Target School**. One can look up a school’s OPEID number using the school lookup function in the part above. Once an ID has been inputed, the system will randomly select 20 schools  (with replacement, in case the population is very small) that has average admissions rate that is lower than the target school’s admission. 
In the *Comparisons Table* tab, one can view the schools selected for comparison purpose. 
To create a regression model from the comparison schools and predict a new admissions rate for the target school, one must choose at least two variables under **Prediction Criteria** section. The statistics for each variable for each school will be added to the **Comparisons Table** tab. 
The predicted admissions rate using the comparisons schools’ model will be presented in the **Suggestions** tab. One can add or remove any variables in real time to adjust the model and see what variables will yield a lower admissions rate. 

Lastly, the **Comparison Plots** will graphically present how each of the statistics used in the prediction model from comparison schools compare with that of the target school, this table will also update in real time with the addition or removal of variables in the model.
