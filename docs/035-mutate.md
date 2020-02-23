# Verbs Part 3: mutate


## Key takeaways

* `mutate` just means "compute", or convert one or more variables into something new. 
* mutate is the equivalent of creating a new column in Excel using a formula
* Some of the most important jobs of a `mutate` statement are:
  * Convert unstandardized data into standardized, such as yes-or-no variables or all lower case
  * Use arithmetic on numeric variables
  * Use conditional statements to put different values on variables, instead of filtering one at a time.
  * Change the data *type* from, say, text to date and time.
  * Use functions to combine or pull apart and edit your data. 

### Read in some data

Start with the [Arizona immunization data](https://github.com/cronkitedata/rstudyguide/blob/master/data/az-immunizations-grade6.Rda?raw=true) that some other chapters have worked with, loading it and the tidyverse to follow along. 


Here are the packages and data used for this chapter. You might need to install some of them.


```r
library(tidyverse)
library(knitr)       # used for slightly better looking tables
library(DT)          # even more options with tables
library(lubridate)   # used for working with dates
library(janitor)     # used to clean up dirty data and change column names.

load("data/az-immunizations-grade6.Rda")  # you may need to change the path to wherever you saved the data
```

## Simple arithmetic

Use the usual arithmetic operators to calculate numbers and create a new column: 

      + Addition
      - Subtraction
      * Multiplication
      / Division
      

This example creates a new data frame called `immune_pct` from a few columns of the original:


```r
immune_pct <- 
  grade6_counts %>%
  select ( school_name, city, school_type, enrolled, num_immune_mmr) %>%
  mutate (pct_immune = ( num_immune_mmr/enrolled) * 100) 
```

Here's what it looks like: 


school_name                             city      school_type    enrolled   num_immune_mmr   pct_immune
--------------------------------------  --------  ------------  ---------  ---------------  -----------
ABRAHAM LINCOLN TRADITIONAL SCHOOL      PHOENIX   PUBLIC               59               58         98.3
ACACIA ELEMENTARY SCHOOL                PHOENIX   PUBLIC              134              134        100.0
ACADEMY DEL SOL - HOPE                  TUCSON    CHARTER              53               52         98.1
ACADEMY OF MATH AND SCIENCE             TUCSON    CHARTER              42               40         95.2
ACADEMY OF MATH AND SCIENCE CAMELBACK   PHOENIX   CHARTER             113              113        100.0


## Creating categories with `if_else()`

Sometimes, you want to create categories out of more detailed information. In this case, a threshold of 90 percent immunization is considered the limit under which there is a threat of a measles outbreak, also known as "herd immunity". To categorize each schools as above or under that level, we need to create a new variable that is based on the value of the percentage we just calcluated. That's done using an `if_else` statement, which is in the form: 


      if_else (  condition, 
                 new value if it's true, 
                 new value if it's not true)


For example: 



```r
immune_pct <- 
    immune_pct %>%
    mutate (  threshold_met =  if_else   ( pct_immune >= 90, 
                                        "Meets threshold", 
                                         "Below threshold")
            )
```


Now we can do some grouping by the new categories: 


```r
immune_pct %>%
    group_by (school_type, threshold_met) %>%
    summarise ( school_ct = n(), 
                enrolled = sum(enrolled)) 
```


You can practice rolling up by looking at the percent by type.  


```r
immune_pct %>%
    group_by (school_type, threshold_met) %>%
    summarise ( schools = n(), 
                students = sum(enrolled)) %>%
    mutate (   pct_school_type = schools / sum(schools, na.rm=TRUE) * 100,
               pct_enrolled = students / sum(students, na.rm=TRUE) * 100 
             ) %>%
    filter ( threshold_met == "Below threshold")  
```

<div class="kable-table">

school_type   threshold_met      schools   students   pct_school_type   pct_enrolled
------------  ----------------  --------  ---------  ----------------  -------------
CHARTER       Below threshold         40       2344         20.725389      17.757576
PRIVATE       Below threshold         10        324         14.925373      12.053571
PUBLIC        Below threshold         18       1223          2.777778       1.794544

</div>

You can read this table to say, "More than one-sixth of 6th-grade charter school students could be at risk of contracting measles because their schools have immunization rates below levels experts say are needed to prevent outbreaks."  (The wording is tough here to avoid saying "schools" over and over! )

This strategy can also be used to set unreal values to the special `NA` as in the MAP murder data that uses the value 999 instead of "unknown" for an age. This is common in survey data. 

## Useful functions 

Here are some functions you may find yourself using pretty regularly. I'm not going to go into the details, but think about looking some up if you think you need them. In each case, these are just the `verbs`. You'd put your noun -- an existing variable from your data frame -- within the parentheses.

* `tolower( )` , `toupper ( )`, `toproper ( )`: Convert to all lower, all upper, or proper case.
* `paste ( )`, `paste0 ( )` : Combine (eg, concatenate) two character variables into one, with a delimiter like a space, or smushed together (paste0)
*  `na_if( )`, `replace_na () ` : The first creates NA values if something is true; the other replaces NA values with something else, such as a zero.
* `recode () ` : Lets you set up a system to replace codes with words. 
* Conversion functions: as.character(), as.integer(), as.numeric() and as.double() 

## Bonus: Fun with date and time

Sometimes your data came to you as text, but you need to treat it as numbers. In journalism, we're often trying to work with dates that came to us in some non-standard form. This is called changing the `data type`. ^[This example uses the library `lubridate`, which may not be installed in your computer. If you're following along, you may need to install it in the console.]

This example comes from the opioid emergency call data shown in earlier chapters. 



```r
my_link <- "https://cronkitedata.github.io/cronkite-docs/assets/data/csv/opioidemscalls.csv"
#use it in a read_csv command
opioid_calls_orig <- read_csv(my_link)
opioid_calls <- opioid_calls_orig %>% 
                clean_names() %>%
                select (objectid, incident_date_char = incident_date, narcan= narcan_naloxone_given, is_asu_student, is_homeless=is_homeles)

glimpse( opioid_calls)
```

```
## Observations: 650
## Variables: 5
## $ objectid           <dbl> 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 1…
## $ incident_date_char <chr> "1/3/2017 11:42", "1/9/2017 1:08", "1/9/2017 …
## $ narcan             <chr> "No", "Yes", "No", "No", "No", "Yes", "No", "…
## $ is_asu_student     <chr> "No", "No", "No", "No", "No", "No", "No", "No…
## $ is_homeless        <chr> "No", "No", "Yes", "Yes", "No", "No", "No", "…
```


The date and time in this dataset is a character field, but we want to convert it to a date field and a separate time field. At first, we might just want to get the date value out of the character string. It's in the form month/day/year hour:minute, so we can use the `lubridate::mdy_hm function` [When you see a function preceded by two colons as this one does, the author is showing you which package it comes from. In this case, the `lubridate` package, which you must install before you can use it, has a function `mdy_hm`.]. This function tries to guess how the character string is formatted: 



```r
opioid_calls %>%
  mutate ( incident_date = mdy_hm(incident_date_char)) %>%
  select (incident_date, incident_date_char:is_homeless) %>%
  glimpse()
```

```
## Observations: 650
## Variables: 5
## $ incident_date      <dttm> 2017-01-03 11:42:00, 2017-01-09 01:08:00, 20…
## $ incident_date_char <chr> "1/3/2017 11:42", "1/9/2017 1:08", "1/9/2017 …
## $ narcan             <chr> "No", "Yes", "No", "No", "No", "Yes", "No", "…
## $ is_asu_student     <chr> "No", "No", "No", "No", "No", "No", "No", "No…
## $ is_homeless        <chr> "No", "No", "Yes", "Yes", "No", "No", "No", "…
```

Notice that the new variable is of the type <dttm>, which refers to a date-time combined variable. 

Let's say I want to distinguish weekends from weekdays in this dataset. First, we have to define weekend. Here's one definition, but you might want to use another: A weekend begins at 3pm on Friday and ends at 6pm on Sunday. (The `hour` variable is in military time.). Instead of using `if_else`, this example uses `case_when`, which lets you choose among a variety of options, not just two.


```r
opioid_calls %>%
  mutate (incident_date = mdy_hm(incident_date_char), 
          day_of_week = wday(incident_date) ,
          weekday = weekdays(incident_date),
          hour = hour(incident_date), 
          weekend = 
              case_when ( day_of_week == 7                 ~ "Yes", 
                          day_of_week == 6 & hour >= 15     ~ "Yes", 
                          day_of_week == 1 & hour <= 18   ~ "Yes", 
                          TRUE                             ~ "No"
                          )
          ) %>%
  #use count() instead of group_by / summarise. Same thing in this context.
  count (day_of_week, weekend, weekday) %>%
  pivot_wider (values_from = n, names_from = weekend, values_fill= list(n=0))
```

<div class="kable-table">

 day_of_week  weekday       No   Yes
------------  ----------  ----  ----
           1  Sunday        19    80
           2  Monday        78     0
           3  Tuesday       87     0
           4  Wednesday     87     0
           5  Thursday     102     0
           6  Friday        53    41
           7  Saturday       0   103

</div>

## More resources

As always, other professors have done similar exercises: 

* Matt Waite's [chapter on "mutate"](https://mattwaite.github.io/datajournalism/mutating-data.html), which includes a recipe for combining character variables into phrases


### TK: Exercises {-}

