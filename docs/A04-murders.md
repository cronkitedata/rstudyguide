# Murder Accountability Project exercises


<style>
   table {
      font-size:.8em;
   }
</style>


The Murder Accountability Project was profiled in the [New Yorker in November, 2017](https://www.newyorker.com/magazine/2017/11/27/the-serial-killer-detector). Andrew B Tran brilliantly decided to use its data as a vehicle for learning R in his [R for Journalists' online class](https://learn.r-journalism.com/en/).  This set of tutorials adapts his exercises for people using this textbook. You should consider taking his entire free full course if you want to get more detail. 


[Download the data](https://github.com/cronkitedata/rstudyguide/blob/master/data/murder_data.Rda) into a new or existing R project, then load it using the `load(file="murder_data.Rda")` command in a code chunk. 





## The data

This R dataset was created by subsetting only mountain states and Oregon and Washington from the national dataset, and converting the codes used in the original SPSS data into codes and their labels in separate variables. The data runs from 1976 through 2018. Here are the fields included: 



```
## Observations: 56,075
## Variables: 37
## $ rowid             <int> 27475, 27476, 27477, 27478, 27479, 27480, 2748…
## $ mapid             <chr> "197612001AZ00100", "197708001AZ00100", "19780…
## $ year              <dbl> 1976, 1977, 1978, 1982, 1985, 1988, 1989, 1990…
## $ month             <dbl> 12, 8, 1, 7, 6, 11, 10, 9, 12, 2, 12, 3, 9, 4,…
## $ fip               <chr> "04001", "04001", "04001", "04001", "04001", "…
## $ state_fip         <chr> "04", "04", "04", "04", "04", "04", "04", "04"…
## $ cnty_name         <chr> "Apache, AZ", "Apache, AZ", "Apache, AZ", "Apa…
## $ msa_code          <chr> "99904", "99904", "99904", "99904", "99904", "…
## $ msa_name          <chr> "Rural Arizona", "Rural Arizona", "Rural Arizo…
## $ state_abbr        <chr> "AZ", "AZ", "AZ", "AZ", "AZ", "AZ", "AZ", "AZ"…
## $ ori               <chr> "AZ00100", "AZ00100", "AZ00100", "AZ00100", "A…
## $ agency            <chr> "Apache County", "Apache County", "Apache Coun…
## $ agency_type       <chr> "Sheriff", "Sheriff", "Sheriff", "Sheriff", "S…
## $ solved            <chr> "Yes", "Yes", "Yes", "No", "No", "Yes", "Yes",…
## $ homicide_type     <chr> "Murder and non-negligent manslaughter", "Murd…
## $ incident_num      <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
## $ vic_age           <dbl> 42, 28, 0, 23, 18, 23, 43, 33, 33, 0, 38, 0, 3…
## $ vic_sex           <chr> "Male", "Male", "Female", "Female", "Male", "M…
## $ vic_race_code     <chr> "W", "W", "W", "W", "W", "W", "W", "W", "W", "…
## $ vic_race          <chr> "White", "White", "White", "White", "White", "…
## $ vic_ethnic_code   <chr> "U", "U", "U", "N", "U", "U", "N", "N", "N", "…
## $ vic_ethnic        <chr> "Unknown or not reported", "Unknown or not rep…
## $ off_age           <dbl> 22, 44, 50, 999, 999, 41, 39, 48, 999, 29, 18,…
## $ off_sex           <chr> "Male", "Male", "Male", "Unknown", "Unknown", …
## $ off_race_code     <chr> "I", "W", "W", "U", "U", "W", "W", "W", "U", "…
## $ off_race          <chr> "American Indian or Alaskan Native", "White", …
## $ off_ethnic_code   <chr> "U", "U", "U", "U", "U", "U", "N", "N", "U", "…
## $ off_ethnic        <chr> "Unknown or not reported", "Unknown or not rep…
## $ situation_code    <chr> "C", "A", "C", "B", "B", "A", "A", "A", "B", "…
## $ situation         <chr> "Single victim/multiple offenders", "Single vi…
## $ weapon_code       <chr> "20", "13", "90", "11", "12", "12", "12", "12"…
## $ weapon            <chr> "Knife or cutting instrument", "Rifle", "Other…
## $ relationship_code <chr> "AQ", "AQ", "DA", "UN", "UN", "AQ", "AQ", "AQ"…
## $ relationship      <chr> "Acquaintance", "Acquaintance", "Daughter", "R…
## $ circumstance_code <chr> "42", "44", "59", "99", "99", "45", "5", "60",…
## $ circumstance      <chr> "Brawl due to influence of alcohol", "Argument…
## $ use_date          <date> 1980-03-01, 1980-03-01, 1980-03-01, 1982-10-0…
```

Any variable that begins with `off` refers to the offender; any variable that begins with `vic` refers to the victim. Most variables are pretty self-explanatory, but here are a few details: 

* `fip` and `state_fip` are standard codes used across many databases to identify geographic areas -- in this case, counties and states.
* `msa_code` and `msa_name` refer to Metropolitan Statistical Areas, which combine nearby counties regardless of state into areas that are often considered on large metropolitan area, such as Washington DC and the Virginia and Maryland suburbs.
* `ori`, `agency` and `agency_type` refer to the law enforcement agency -- police or sheriff's office -- that investigated the murder. An ORI is a standard code for each agency from the FBI. 
* `relationship_code` and `relationship` can be confusing. They refer to the relationship of the victim to the offender, not the other way around. For example, "Wife" means that the victim was the killer's wife, not that the killer was the victim's wife. This is unclear in the FBI documentation. 

More details are available in [this detailed record layout and data dictionary](https://www.dropbox.com/s/lo6tgo8nnbpqeru/MAPdefinitionsSHR.pdf?dl=1). 



## Exercises by chapter

### Select and filter exercises

Here are some suggested exercises to practice what you learned in Chapter 5, Select and Filter: 


#### Older wives as victims in Arizona {-}

1. Create a new data frame called `arizona_murders` based on just the murders that were reported in that state.  

Try doing these one step at a time by adding to a query : 

2. Pick out just following variables to work with:  
    * year
    * name of the county and the police department, 
    * whether it was solved, 
    * demographics (eg, age, race, sex, ethnicity) of the victim and the offender, 
    * information on the weapon and the relationship
    
3. List all of the murders in which the killer was the husband of the victim. This can be done using either the relationship or the relationship_code.

4. Add a condition that the wives were at least 60 years old. 

5. Sort the answer by oldest to youngest


#### Gun-related killings {-}

Finding out what codes are in the data could be done with a `group_by`/`summarise` query, but there is another verb that can show you every **unique** value in a dataset. Use this code to show you every type of weapon used in the dataset: 

        murder_data %>%
           distinct (weapon_code, weapon) %>%
           arrange (weapon_code)


The verb `distinct` is used instead of `select` to just show a list of values that are never repeated. When you run that code, you can see why it's sometimes useful to keep codes as well as words in a dataset -- codes "11" through "15" refer to some kind of gun. 

**Q: Find all gun-related murders of young black or Hispanic men since 2015.
You can define "young" however you want, but in my example I'll use victims between 15 and 29. 

In this example, you'll have to combine OR conditions, with others. Remember you can use BETWEEN for ranges of values or %in% for a list of values. 


#### Advanced exercises using other conditions {-}

If you're feeling adventurous, try figuring out how you might find: 

* Any domestic-violence related incidents. Hint: This would be an `%in%` condition once you look at your options using either "distinct" or a group-by query. 

* Try using `str_detect` when you want to use wild cards instead of exact matches. These take regular expressions as arguments. So to find any gun in this dataset, you'd use 

      str_detect(weapon_code, "^1")

(For more details on regular expressions, try the [Regex101 tutorial](https://cronkitedata.github.io/cronkite-docs/special/regex-beginning.html) on our class website. Using regular expressions is often a way to make queries shorter and less fussy, but they are not as clear to a reader -- they often take some puzzling through.)


### Group by and summarise

The group by exercises are just like a pivot table. In fact, to turn it on its head, you use the command "pivot_wider"


#### "The most" {-}

* Which county in this small dataset has the most murders? Which one has the most police killings? (Look in the circumstance column for this.)

* Create a table showing the number of murders by year and state (with states across the top, and years down the side). This is a group_by / summarise / arrange / pivot_wider exercise

* Try calculating the percent of murders by relationship. For this to work, you can only keep one group_by column (relationship)

#### Putting it all together {-}

What percent of each state's domestic violence victims are of Hispanic origin? 


####  Bonus: Mutate with group_by {-}

Chapter 7, Mutate, has an example of creating a new category out of an old one. Try to puzzle through how to find the county that has the highest rate of gun murders vs. other weapons. This involves three steps: creating a new category of Yes/No out of the weapon; grouping and counting; then rolling up to the next level. 

## Answers to exercises

### Select and filter

#### Arizona wives {-}

1. Create a new dataset with just arizona: 


```r
arizona_murders <- 
  murder_data %>%
  filter ( state_abbr == "AZ")
```


You should have 15,443 rows in this dataset.

2. The final set of queries might look like this. (You might have noticed you that you had one victim age 999 when you sorted. That means "unknown" in this dataset, so you'll want to filter that out as well.)


```r
arizona_murders  %>%
  select ( year, cnty_name, agency, solved, 
           starts_with("vic"), starts_with("off"), 
           contains ("relationship")) %>%
  filter (relationship == "Wife"  & 
          vic_age >= 60 & 
          vic_age < 999 )  %>%
  arrange ( desc(vic_age)) 
```

<div class="kable-table">

 year  cnty_name        agency             solved    vic_age  vic_sex   vic_race_code   vic_race   vic_ethnic_code   vic_ethnic                 off_age  off_sex   off_race_code   off_race   off_ethnic_code   off_ethnic                relationship_code   relationship 
-----  ---------------  -----------------  -------  --------  --------  --------------  ---------  ----------------  ------------------------  --------  --------  --------------  ---------  ----------------  ------------------------  ------------------  -------------
 2006  Maricopa, AZ     Scottsdale         Yes            95  Female    W               White      N                 Not of Hispanic origin          88  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2018  Coconino, AZ     Coconino County    Yes            94  Male      W               White      H                 Hispanic origin                 70  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1996  Maricopa, AZ     Mesa               Yes            90  Female    W               White      N                 Not of Hispanic origin          92  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2008  Maricopa, AZ     Mesa               Yes            89  Female    W               White      N                 Not of Hispanic origin          86  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2017  Pima, AZ         Pima County        Yes            88  Female    W               White      U                 Unknown or not reported         89  Male      W               White      U                 Unknown or not reported   WI                  Wife         
 1987  Maricopa, AZ     Maricopa County    Yes            87  Female    W               White      U                 Unknown or not reported         88  Male      W               White      U                 Unknown or not reported   WI                  Wife         
 2013  Maricopa, AZ     Phoenix            Yes            87  Female    W               White      U                 Unknown or not reported         87  Male      W               White      U                 Unknown or not reported   WI                  Wife         
 2013  Maricopa, AZ     Glendale           Yes            86  Female    W               White      N                 Not of Hispanic origin          86  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2016  Maricopa, AZ     Mesa               Yes            85  Female    W               White      N                 Not of Hispanic origin          85  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2008  Maricopa, AZ     Phoenix            Yes            85  Female    W               White      N                 Not of Hispanic origin          89  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1986  Pima, AZ         Tucson             Yes            85  Female    W               White      N                 Not of Hispanic origin          90  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2012  Yavapai, AZ      Prescott           Yes            85  Female    W               White      N                 Not of Hispanic origin          88  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1980  Maricopa, AZ     Maricopa County    Yes            84  Female    W               White      N                 Not of Hispanic origin          77  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2016  Maricopa, AZ     Maricopa County    Yes            84  Female    W               White      N                 Not of Hispanic origin          87  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2005  Maricopa, AZ     Phoenix            Yes            84  Female    W               White      N                 Not of Hispanic origin          85  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1992  Maricopa, AZ     Phoenix            Yes            83  Female    W               White      N                 Not of Hispanic origin          83  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1998  Maricopa, AZ     Phoenix            Yes            83  Female    W               White      N                 Not of Hispanic origin          81  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1994  Mohave, AZ       Lake Havasu City   Yes            83  Female    W               White      N                 Not of Hispanic origin          83  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2012  Pinal, AZ        Pinal County       Yes            83  Female    W               White      N                 Not of Hispanic origin          81  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1999  Maricopa, AZ     Glendale           Yes            82  Female    W               White      N                 Not of Hispanic origin          83  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2009  Maricopa, AZ     Glendale           Yes            82  Female    A               Asian      N                 Not of Hispanic origin          82  Male      A               Asian      N                 Not of Hispanic origin    WI                  Wife         
 1983  Maricopa, AZ     Phoenix            Yes            82  Female    W               White      N                 Not of Hispanic origin          79  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1988  Maricopa, AZ     Phoenix            Yes            82  Female    W               White      U                 Unknown or not reported         84  Male      W               White      U                 Unknown or not reported   WI                  Wife         
 2007  Maricopa, AZ     Phoenix            Yes            82  Female    W               White      N                 Not of Hispanic origin          87  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1995  Pima, AZ         Tucson             Yes            82  Female    W               White      N                 Not of Hispanic origin          68  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1994  Yavapai, AZ      Yavapai County     Yes            82  Female    W               White      N                 Not of Hispanic origin          85  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1982  Yavapai, AZ      Prescott           Yes            82  Female    W               White      N                 Not of Hispanic origin          81  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2013  Maricopa, AZ     Maricopa County    Yes            81  Female    W               White      N                 Not of Hispanic origin          85  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1982  Pima, AZ         Tucson             Yes            81  Female    W               White      N                 Not of Hispanic origin          83  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2004  Pinal, AZ        Pinal County       Yes            81  Female    W               White      N                 Not of Hispanic origin          77  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2011  Maricopa, AZ     Maricopa County    Yes            80  Female    W               White      N                 Not of Hispanic origin          78  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1995  Maricopa, AZ     Mesa               Yes            80  Female    W               White      N                 Not of Hispanic origin          81  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2006  Maricopa, AZ     Youngtown          Yes            80  Female    W               White      N                 Not of Hispanic origin          83  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2008  Pinal, AZ        Pinal County       Yes            80  Female    W               White      N                 Not of Hispanic origin          80  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1977  Yuma, AZ         Yuma               Yes            80  Female    W               White      U                 Unknown or not reported         86  Male      W               White      U                 Unknown or not reported   WI                  Wife         
 1977  Maricopa, AZ     Phoenix            Yes            79  Female    B               Black      U                 Unknown or not reported         70  Male      B               Black      U                 Unknown or not reported   WI                  Wife         
 1991  Maricopa, AZ     Phoenix            Yes            79  Female    W               White      N                 Not of Hispanic origin          80  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2016  Maricopa, AZ     Phoenix            Yes            79  Female    W               White      N                 Not of Hispanic origin          82  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1980  Gila, AZ         Payson             Yes            78  Female    W               White      N                 Not of Hispanic origin          93  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1989  Maricopa, AZ     Scottsdale         Yes            78  Female    W               White      N                 Not of Hispanic origin          70  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2003  Maricopa, AZ     Scottsdale         Yes            78  Female    W               White      N                 Not of Hispanic origin          79  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2012  Yavapai, AZ      Yavapai County     Yes            78  Female    W               White      N                 Not of Hispanic origin          80  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1991  Coconino, AZ     Flagstaff          Yes            77  Female    B               Black      N                 Not of Hispanic origin          82  Male      B               Black      N                 Not of Hispanic origin    WI                  Wife         
 1985  Maricopa, AZ     Maricopa County    Yes            77  Female    W               White      N                 Not of Hispanic origin          74  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2002  Maricopa, AZ     Maricopa County    Yes            77  Female    W               White      N                 Not of Hispanic origin          77  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2007  Maricopa, AZ     Chandler           Yes            77  Female    W               White      H                 Hispanic origin                 80  Male      W               White      H                 Hispanic origin           WI                  Wife         
 1997  Maricopa, AZ     Peoria             Yes            77  Female    W               White      N                 Not of Hispanic origin          80  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2018  Maricopa, AZ     Phoenix            Yes            77  Female    W               White      U                 Unknown or not reported         77  Male      W               White      U                 Unknown or not reported   WI                  Wife         
 2004  Maricopa, AZ     Tempe              Yes            77  Female    W               White      N                 Not of Hispanic origin          78  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1999  Yavapai, AZ      Yavapai County     Yes            77  Female    W               White      N                 Not of Hispanic origin          79  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1979  Maricopa, AZ     Maricopa County    Yes            76  Female    W               White      U                 Unknown or not reported         78  Male      W               White      U                 Unknown or not reported   WI                  Wife         
 1998  Maricopa, AZ     Phoenix            Yes            76  Female    W               White      N                 Not of Hispanic origin          77  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2014  Pima, AZ         Pima County        Yes            76  Female    W               White      U                 Unknown or not reported         77  Male      W               White      U                 Unknown or not reported   WI                  Wife         
 1993  Pima, AZ         Tucson             Yes            76  Female    W               White      N                 Not of Hispanic origin          78  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2000  Maricopa, AZ     Maricopa County    Yes            75  Female    W               White      N                 Not of Hispanic origin          75  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1978  Maricopa, AZ     Phoenix            Yes            75  Female    W               White      U                 Unknown or not reported         76  Male      W               White      U                 Unknown or not reported   WI                  Wife         
 1981  Maricopa, AZ     Phoenix            Yes            75  Female    W               White      N                 Not of Hispanic origin          78  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2005  Maricopa, AZ     Scottsdale         Yes            75  Female    W               White      N                 Not of Hispanic origin          78  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2011  Maricopa, AZ     Tempe              Yes            75  Female    W               White      N                 Not of Hispanic origin          77  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1999  Pima, AZ         Pima County        Yes            75  Female    W               White      N                 Not of Hispanic origin          66  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1981  Maricopa, AZ     Maricopa County    Yes            74  Female    W               White      N                 Not of Hispanic origin          77  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1990  Maricopa, AZ     Maricopa County    Yes            74  Female    W               White      N                 Not of Hispanic origin          82  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2000  Maricopa, AZ     Mesa               Yes            74  Female    W               White      N                 Not of Hispanic origin          76  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2000  Maricopa, AZ     Phoenix            Yes            74  Female    W               White      N                 Not of Hispanic origin          76  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1992  Mohave, AZ       Kingman            Yes            74  Female    W               White      N                 Not of Hispanic origin          77  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1987  La Paz, AZ       La Paz County      Yes            74  Female    W               White      U                 Unknown or not reported         72  Male      W               White      U                 Unknown or not reported   WI                  Wife         
 2013  Maricopa, AZ     Maricopa County    Yes            73  Female    W               White      U                 Unknown or not reported         78  Male      W               White      U                 Unknown or not reported   WI                  Wife         
 1993  Maricopa, AZ     Phoenix            Yes            73  Female    W               White      N                 Not of Hispanic origin          73  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2015  Maricopa, AZ     Phoenix            Yes            73  Female    W               White      N                 Not of Hispanic origin          78  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1991  Maricopa, AZ     Scottsdale         Yes            73  Female    W               White      N                 Not of Hispanic origin          64  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2015  Maricopa, AZ     Scottsdale         Yes            73  Female    W               White      N                 Not of Hispanic origin          74  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2002  Pima, AZ         Tucson             Yes            73  Female    A               Asian      N                 Not of Hispanic origin          73  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1994  Yavapai, AZ      Prescott           Yes            73  Female    W               White      N                 Not of Hispanic origin          84  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1979  Maricopa, AZ     Maricopa County    Yes            72  Female    W               White      U                 Unknown or not reported         69  Male      W               White      U                 Unknown or not reported   WI                  Wife         
 2017  Maricopa, AZ     Scottsdale         Yes            72  Female    W               White      N                 Not of Hispanic origin          67  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1984  Pima, AZ         Pima County        Yes            72  Female    W               White      N                 Not of Hispanic origin          75  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1996  Pima, AZ         Pima County        Yes            72  Female    W               White      N                 Not of Hispanic origin          73  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1998  Pima, AZ         Pima County        Yes            72  Female    W               White      N                 Not of Hispanic origin          71  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1988  Pima, AZ         Tucson             Yes            72  Female    W               White      U                 Unknown or not reported         70  Male      W               White      U                 Unknown or not reported   WI                  Wife         
 1991  Maricopa, AZ     Glendale           Yes            71  Female    W               White      N                 Not of Hispanic origin          69  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1993  Maricopa, AZ     Phoenix            Yes            71  Female    W               White      N                 Not of Hispanic origin          74  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1994  Yuma, AZ         Yuma County        Yes            71  Female    W               White      N                 Not of Hispanic origin          68  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2009  Coconino, AZ     Flagstaff          Yes            70  Female    W               White      N                 Not of Hispanic origin          62  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1990  Gila, AZ         Payson             Yes            70  Female    W               White      N                 Not of Hispanic origin          70  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1980  Maricopa, AZ     Maricopa County    Yes            70  Female    W               White      N                 Not of Hispanic origin          73  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2006  Maricopa, AZ     Phoenix            Yes            70  Female    W               White      N                 Not of Hispanic origin          76  Male      W               White      H                 Hispanic origin           WI                  Wife         
 1976  Pima, AZ         Pima County        Yes            70  Female    W               White      U                 Unknown or not reported         70  Male      W               White      U                 Unknown or not reported   WI                  Wife         
 1995  Pima, AZ         Pima County        Yes            70  Female    W               White      N                 Not of Hispanic origin          77  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2006  Pima, AZ         Tucson             Yes            70  Female    W               White      N                 Not of Hispanic origin          71  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1989  Maricopa, AZ     Maricopa County    Yes            69  Female    W               White      N                 Not of Hispanic origin          82  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2012  Maricopa, AZ     Maricopa County    Yes            69  Female    W               White      N                 Not of Hispanic origin          66  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2016  Maricopa, AZ     Glendale           Yes            69  Female    W               White      N                 Not of Hispanic origin          69  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1988  Maricopa, AZ     Mesa               Yes            69  Female    W               White      U                 Unknown or not reported         63  Male      W               White      U                 Unknown or not reported   WI                  Wife         
 1985  Maricopa, AZ     Phoenix            Yes            69  Female    W               White      N                 Not of Hispanic origin          74  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2011  Maricopa, AZ     Tempe              Yes            69  Female    W               White      N                 Not of Hispanic origin          64  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2017  Pinal, AZ        Maricopa           Yes            69  Female    W               White      N                 Not of Hispanic origin          67  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2006  Yuma, AZ         Yuma County        Yes            69  Female    W               White      U                 Unknown or not reported         70  Male      W               White      U                 Unknown or not reported   WI                  Wife         
 2006  Yuma, AZ         Yuma               Yes            69  Female    W               White      N                 Not of Hispanic origin          71  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2007  Yuma, AZ         Yuma               Yes            69  Female    B               Black      N                 Not of Hispanic origin          71  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1990  Maricopa, AZ     Maricopa County    Yes            68  Female    W               White      N                 Not of Hispanic origin          65  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1979  Maricopa, AZ     Phoenix            Yes            68  Female    W               White      U                 Unknown or not reported         69  Male      W               White      U                 Unknown or not reported   WI                  Wife         
 1990  Maricopa, AZ     Youngtown          Yes            68  Female    W               White      N                 Not of Hispanic origin          61  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1986  Maricopa, AZ     Maricopa County    Yes            67  Female    W               White      N                 Not of Hispanic origin          71  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2000  Maricopa, AZ     Maricopa County    Yes            67  Female    W               White      N                 Not of Hispanic origin          67  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2003  Maricopa, AZ     Maricopa County    Yes            67  Female    W               White      N                 Not of Hispanic origin          68  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1987  Maricopa, AZ     Phoenix            Yes            67  Female    W               White      U                 Unknown or not reported         70  Male      W               White      U                 Unknown or not reported   WI                  Wife         
 1986  Maricopa, AZ     Scottsdale         Yes            67  Female    W               White      N                 Not of Hispanic origin          73  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2007  Mohave, AZ       Bullhead City      Yes            67  Female    W               White      N                 Not of Hispanic origin          43  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1993  Maricopa, AZ     Maricopa County    Yes            66  Female    W               White      N                 Not of Hispanic origin          83  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2012  Maricopa, AZ     Phoenix            Yes            66  Female    W               White      N                 Not of Hispanic origin          64  Male      W               White      U                 Unknown or not reported   WI                  Wife         
 1986  Maricopa, AZ     Scottsdale         Yes            66  Female    W               White      N                 Not of Hispanic origin          66  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1997  Yavapai, AZ      Yavapai County     Yes            66  Female    W               White      U                 Unknown or not reported         71  Male      W               White      U                 Unknown or not reported   WI                  Wife         
 2005  Yavapai, AZ      Prescott Valley    Yes            66  Female    W               White      N                 Not of Hispanic origin          69  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1995  Maricopa, AZ     Glendale           Yes            65  Female    W               White      N                 Not of Hispanic origin          55  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1985  Maricopa, AZ     Phoenix            Yes            65  Female    W               White      N                 Not of Hispanic origin          81  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1989  Maricopa, AZ     Phoenix            Yes            65  Female    W               White      N                 Not of Hispanic origin          71  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2010  Maricopa, AZ     Phoenix            Yes            65  Female    W               White      U                 Unknown or not reported         56  Male      W               White      U                 Unknown or not reported   WI                  Wife         
 2012  Mohave, AZ       Bullhead City      Yes            65  Female    W               White      N                 Not of Hispanic origin          61  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1996  Pima, AZ         Tucson             Yes            65  Female    W               White      N                 Not of Hispanic origin          66  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2008  Maricopa, AZ     Glendale           Yes            64  Female    W               White      N                 Not of Hispanic origin          65  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2012  Maricopa, AZ     Phoenix            Yes            64  Female    W               White      U                 Unknown or not reported         83  Male      W               White      U                 Unknown or not reported   WI                  Wife         
 1992  Santa Cruz, AZ   Nogales            Yes            64  Female    W               White      H                 Hispanic origin                 82  Male      W               White      H                 Hispanic origin           WI                  Wife         
 1992  Mohave, AZ       Bullhead City      Yes            63  Female    W               White      N                 Not of Hispanic origin          66  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2010  Pima, AZ         Tucson             Yes            63  Female    W               White      N                 Not of Hispanic origin          57  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2006  Maricopa, AZ     Maricopa County    Yes            62  Female    W               White      N                 Not of Hispanic origin          74  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2011  Pima, AZ         Tucson             Yes            62  Female    W               White      N                 Not of Hispanic origin          59  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1981  Yavapai, AZ      Prescott           Yes            62  Female    W               White      N                 Not of Hispanic origin          64  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2006  Coconino, AZ     Flagstaff          Yes            61  Female    W               White      N                 Not of Hispanic origin          64  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2017  Maricopa, AZ     Mesa               Yes            61  Female    W               White      N                 Not of Hispanic origin          60  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1990  Maricopa, AZ     Phoenix            Yes            61  Female    W               White      N                 Not of Hispanic origin          65  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2003  Maricopa, AZ     Phoenix            Yes            61  Female    A               Asian      N                 Not of Hispanic origin          57  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 2015  Maricopa, AZ     Phoenix            Yes            61  Female    W               White      N                 Not of Hispanic origin          67  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         
 1987  Pinal, AZ        Pinal County       Yes            61  Female    W               White      U                 Unknown or not reported         61  Male      W               White      U                 Unknown or not reported   WI                  Wife         
 1987  Maricopa, AZ     Maricopa County    Yes            60  Female    W               White      U                 Unknown or not reported         71  Male      W               White      U                 Unknown or not reported   WI                  Wife         
 1987  Maricopa, AZ     Maricopa County    Yes            60  Female    W               White      U                 Unknown or not reported         68  Male      W               White      U                 Unknown or not reported   WI                  Wife         
 2017  Maricopa, AZ     Buckeye            Yes            60  Female    W               White      N                 Not of Hispanic origin          43  Male      B               Black      N                 Not of Hispanic origin    WI                  Wife         
 2011  Maricopa, AZ     Glendale           Yes            60  Female    A               Asian      N                 Not of Hispanic origin          61  Male      A               Asian      N                 Not of Hispanic origin    WI                  Wife         
 1998  Maricopa, AZ     Phoenix            Yes            60  Female    W               White      H                 Hispanic origin                 58  Male      W               White      H                 Hispanic origin           WI                  Wife         
 2014  Mohave, AZ       Kingman            Yes            60  Female    A               Asian      N                 Not of Hispanic origin          64  Male      A               Asian      N                 Not of Hispanic origin    WI                  Wife         
 1986  Mohave, AZ       Bullhead City      Yes            60  Female    W               White      N                 Not of Hispanic origin          62  Male      W               White      N                 Not of Hispanic origin    WI                  Wife         

</div>

You could also use 
      
      relationship == "Wife"  & 
          between (vic_age, 60, 998)  
          

You might also notice that there is a Male "wife" as a victim, reflecting how poorly many police agencies fill out these forms. 


#### Gun-related killings {-}

This is actually much more difficult than it sounds. Try to build it one piece at a time.  Here is how I might build the conditions: 
Guns:

        ... weapon_code %in% c("11", "12", "13", "14", "15")

(This is a text variable even though it looks like numbers - that means you need the quotes. Don't forget to use the "c" for "combine into a list" before the list of values)^[ If you wanted to go further with filtering, you might look at the `regular expressions` available for more sophisticated filtering using the `str_detect` function. In this case,  `str_detect (weapon_code, "^1")` searches for anything in the field that begins with a "1".]

Since 2015:

        weapon_code %in% c("11", "12", "13", "14", "15") &
        year >= 2015


Young men: 

        weapon_code %in% c("11", "12", "13", "14", "15") &
        year >= 2015 & 
        between (vic_age, 15, 29)

Black and Hispanic victims:

        weapon_code %in% c("11", "12", "13", "14", "15") &
        year >= 2015 & 
        between (vic_age, 15, 29)  &
        (vic_race_code  == "B" | vic_ethnic_code = "H")
        

That last one is the trickiest -- If you want to find both African-American AND Hispanic victims, you need to look for a race code of "B" OR an ethnicity code of "H". Those have to be in a parenthese in order not to be confused with the other conditions. (I'm going to select just some of the columns and order it by the year and month of the murder, showing only the most recent). (NOTE: Eliminate the last line of this code if you haven't installed and activated the "DT" package, which makes searchable, sortable tables.)  



```r
murder_data %>%
  filter ( weapon_code %in% c("11", "12", "13", "14", "15") &
           year >= 2015 & 
           between (vic_age, 15, 29)  &
           (vic_race_code  == "B" | vic_ethnic_code == "H")
        ) %>%
  select (year, month, cnty_name, state_abbr, solved, vic_age, vic_race, vic_ethnic,  weapon, relationship, circumstance ) %>%
  arrange (year, month) %>%
  tail (50) %>%
  datatable( options = list(scrollX = '500px'))
```

<!--html_preserve--><div id="htmlwidget-2e12d02b3e834f6a4990" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-2e12d02b3e834f6a4990">{"x":{"filter":"none","data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50"],[2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018,2018],[10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12],["Clark, NV","Multnomah, OR","Multnomah, OR","Salt Lake, UT","Benton, WA","Pierce, WA","Pierce, WA","Spokane, WA","King, WA","Gila, AZ","Gila, AZ","Maricopa, AZ","Maricopa, AZ","Maricopa, AZ","Maricopa, AZ","Maricopa, AZ","Maricopa, AZ","Pima, AZ","Pima, AZ","Pima, AZ","El Paso, CO","El Paso, CO","Jefferson, CO","Bernalillo, NM","Bernalillo, NM","Clark, NV","Clark, NV","Clark, NV","Clark, NV","Clark, NV","Clark, NV","Clark, NV","Multnomah, OR","Washington, OR","Yakima, WA","Maricopa, AZ","Maricopa, AZ","Maricopa, AZ","Maricopa, AZ","Logan, CO","Denver, CO","Denver, CO","Denver, CO","Bernalillo, NM","Clark, NV","Clark, NV","Franklin, WA","Pierce, WA","Snohomish, WA","Yakima, WA"],["NV","OR","OR","UT","WA","WA","WA","WA","WA","AZ","AZ","AZ","AZ","AZ","AZ","AZ","AZ","AZ","AZ","AZ","CO","CO","CO","NM","NM","NV","NV","NV","NV","NV","NV","NV","OR","OR","WA","AZ","AZ","AZ","AZ","CO","CO","CO","CO","NM","NV","NV","WA","WA","WA","WA"],["Yes","No","No","No","Yes","No","Yes","Yes","Yes","Yes","Yes","Yes","No","Yes","Yes","Yes","No","Yes","Yes","No","Yes","Yes","Yes","Yes","Yes","No","Yes","No","No","Yes","Yes","Yes","No","Yes","Yes","No","Yes","Yes","No","Yes","Yes","Yes","Yes","Yes","Yes","Yes","Yes","No","Yes","Yes"],[26,21,27,18,28,28,18,15,26,22,22,24,24,24,19,28,18,28,16,25,26,23,28,18,18,20,22,24,29,19,16,17,26,19,16,22,23,18,22,15,28,23,20,15,26,18,29,17,23,22],["White","Black","Black","White","Black","Black","Black","Black","White","White","White","Black","Black","Black","White","Black","Black","Black","Black","White","Black","Black","White","White","White","Black","Black","White","White","Black","Black","Black","Black","White","White","White","Black","Black","Black","Black","Black","Black","Black","White","Black","Black","White","Black","Black","White"],["Hispanic origin","Unknown or not reported","Unknown or not reported","Hispanic origin","Not of Hispanic origin","Unknown or not reported","Not of Hispanic origin","Unknown or not reported","Hispanic origin","Hispanic origin","Hispanic origin","Not of Hispanic origin","Unknown or not reported","Unknown or not reported","Hispanic origin","Unknown or not reported","Unknown or not reported","Unknown or not reported","Not of Hispanic origin","Hispanic origin","Not of Hispanic origin","Not of Hispanic origin","Hispanic origin","Hispanic origin","Hispanic origin","Not of Hispanic origin","Not of Hispanic origin","Hispanic origin","Hispanic origin","Not of Hispanic origin","Not of Hispanic origin","Not of Hispanic origin","Unknown or not reported","Hispanic origin","Hispanic origin","Hispanic origin","Unknown or not reported","Unknown or not reported","Not of Hispanic origin","Not of Hispanic origin","Not of Hispanic origin","Not of Hispanic origin","Not of Hispanic origin","Hispanic origin","Not of Hispanic origin","Not of Hispanic origin","Hispanic origin","Not of Hispanic origin","Not of Hispanic origin","Hispanic origin"],["Handgun - pistol, revolver, etc","Firearm, type not stated","Handgun - pistol, revolver, etc","Handgun - pistol, revolver, etc","Handgun - pistol, revolver, etc","Firearm, type not stated","Handgun - pistol, revolver, etc","Handgun - pistol, revolver, etc","Handgun - pistol, revolver, etc","Handgun - pistol, revolver, etc","Handgun - pistol, revolver, etc","Handgun - pistol, revolver, etc","Handgun - pistol, revolver, etc","Firearm, type not stated","Handgun - pistol, revolver, etc","Handgun - pistol, revolver, etc","Firearm, type not stated","Handgun - pistol, revolver, etc","Handgun - pistol, revolver, etc","Handgun - pistol, revolver, etc","Handgun - pistol, revolver, etc","Handgun - pistol, revolver, etc","Handgun - pistol, revolver, etc","Firearm, type not stated","Handgun - pistol, revolver, etc","Firearm, type not stated","Handgun - pistol, revolver, etc","Firearm, type not stated","Handgun - pistol, revolver, etc","Handgun - pistol, revolver, etc","Handgun - pistol, revolver, etc","Handgun - pistol, revolver, etc","Firearm, type not stated","Handgun - pistol, revolver, etc","Firearm, type not stated","Firearm, type not stated","Firearm, type not stated","Handgun - pistol, revolver, etc","Handgun - pistol, revolver, etc","Handgun - pistol, revolver, etc","Handgun - pistol, revolver, etc","Handgun - pistol, revolver, etc","Handgun - pistol, revolver, etc","Handgun - pistol, revolver, etc","Handgun - pistol, revolver, etc","Handgun - pistol, revolver, etc","Firearm, type not stated","Firearm, type not stated","Handgun - pistol, revolver, etc","Firearm, type not stated"],["Stranger","Relationship not determined","Relationship not determined","Relationship not determined","Other - known to victim","Relationship not determined","Friend","Stranger","Relationship not determined","Stranger","Stranger","Stranger","Relationship not determined","Acquaintance","Stranger","Relationship not determined","Relationship not determined","Stranger","Acquaintance","Relationship not determined","Relationship not determined","Friend","Other - known to victim","Acquaintance","Stranger","Relationship not determined","Relationship not determined","Relationship not determined","Other - known to victim","Stranger","Stranger","Girlfriend","Relationship not determined","Friend","Relationship not determined","Relationship not determined","Relationship not determined","Stranger","Relationship not determined","Friend","Relationship not determined","Relationship not determined","Stranger","Acquaintance","Other - known to victim","Acquaintance","Acquaintance","Relationship not determined","Relationship not determined","Relationship not determined"],["Felon killed by police","Other","Other arguments","Other arguments","Circumstances undetermined","Other arguments","Circumstances undetermined","Other arguments","Other","Circumstances undetermined","Circumstances undetermined","Felon killed by police","Circumstances undetermined","Circumstances undetermined","Narcotic drug laws","Circumstances undetermined","Circumstances undetermined","Other arguments","Narcotic drug laws","Gangland killings","Other arguments","Other arguments","Gangland killings","Other","Felon killed by police","Other - not specified","Felon killed by private citizen","Other - not specified","Other arguments","Felon killed by private citizen","Gangland killings","Other arguments","Other arguments","Other negligent handling of gun","Circumstances undetermined","Circumstances undetermined","Circumstances undetermined","Circumstances undetermined","Circumstances undetermined","Circumstances undetermined","Other arguments","Other arguments","Circumstances undetermined","Narcotic drug laws","Other arguments","Gangland killings","Other","Circumstances undetermined","Other","Circumstances undetermined"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>year<\/th>\n      <th>month<\/th>\n      <th>cnty_name<\/th>\n      <th>state_abbr<\/th>\n      <th>solved<\/th>\n      <th>vic_age<\/th>\n      <th>vic_race<\/th>\n      <th>vic_ethnic<\/th>\n      <th>weapon<\/th>\n      <th>relationship<\/th>\n      <th>circumstance<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"scrollX":"500px","columnDefs":[{"className":"dt-right","targets":[1,2,6]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

If this complex filter seems too complex, you can always chain one filter after another to check your data as you go. For example, you could do this: 

         murder_data %>%
            filter ( weapon_code %in% c("11", "12", "13", "14", "15") ) %>%
            filter ( vic_race_code == "B" | vic_ethnic_code == "H") ....
            
            
            
### Group by 


#### "The most" {-}


1. County with the most killings



```r
murder_data %>%
  group_by (state_abbr, cnty_name) %>%
  summarise ( cases = n() ) %>%
  arrange (desc (cases))
```

<div class="kable-table">

state_abbr   cnty_name               cases
-----------  ---------------------  ------
AZ           Maricopa, AZ            10128
NV           Clark, NV                5649
WA           King, WA                 3256
CO           Denver, CO               2955
AZ           Pima, AZ                 2854
NM           Bernalillo, NM           2361
OR           Multnomah, OR            1792
WA           Pierce, WA               1539
UT           Salt Lake, UT            1431
CO           El Paso, CO              1037
CO           Arapahoe, CO              975
NV           Washoe, NV                817
WA           Spokane, WA               741
NM           Santa Fe, NM              692
WA           Yakima, WA                672
CO           Adams, CO                 588
AZ           Pinal, AZ                 540
WA           Snohomish, WA             521
OR           Marion, OR                471
CO           Jefferson, CO             443
AZ           Mohave, AZ                416
OR           Lane, OR                  368
CO           Pueblo, CO                367
WA           Clark, WA                 330
AZ           Yuma, AZ                  319
OR           Clackamas, OR             317
NM           Chaves, NM                305
OR           Washington, OR            299
CO           Weld, CO                  293
AZ           Yavapai, AZ               292
NM           Dona Ana, NM              284
UT           Weber, UT                 272
ID           Ada, ID                   263
NM           San Juan, NM              246
OR           Jackson, OR               224
CO           Larimer, CO               213
AZ           Cochise, AZ               208
WA           Kitsap, WA                205
AZ           Coconino, AZ              204
ID           Canyon, ID                201
NM           Lea, NM                   197
UT           Utah, UT                  196
CO           Boulder, CO               195
WA           Thurston, WA              190
CO           Mesa, CO                  184
WA           Benton, WA                174
OR           Klamath, OR               172
MT           Yellowstone, MT           169
OR           Josephine, OR             164
WA           Whatcom, WA               161
NM           McKinley, NM              158
WA           Franklin, WA              152
WA           Skagit, WA                140
WA           Grant, WA                 136
OR           Douglas, OR               133
AZ           Navajo, AZ                132
UT           Davis, UT                 132
WY           Laramie, WY               128
AZ           Apache, AZ                127
ID           Kootenai, ID              126
WA           Cowlitz, WA               124
WA           Grays Harbor, WA          121
WY           Natrona, WY               115
OR           Umatilla, OR              114
NM           Eddy, NM                  112
OR           Linn, OR                  111
OR           Coos, OR                  110
OR           Deschutes, OR             109
NM           Valencia, NM              107
NM           Curry, NM                 106
WA           Lewis, WA                 105
WA           Chelan, WA                104
NV           Elko, NV                  101
MT           Cascade, MT                98
WY           Sweetwater, WY             95
WA           Mason, WA                  94
CO           Douglas, CO                93
NM           Otero, NM                  89
ID           Twin Falls, ID             87
ID           Bonneville, ID             86
AZ           Gila, AZ                   83
NM           Sandoval, NM               83
OR           Yamhill, OR                79
MT           Missoula, MT               76
WA           Clallam, WA                76
ID           Bannock, ID                75
WA           Walla Walla, WA            74
OR           Polk, OR                   71
WY           Fremont, WY                69
MT           Flathead, MT               68
WA           Okanogan, WA               68
WA           Stevens, WA                67
OR           Lincoln, OR                60
NM           Luna, NM                   58
NV           Lyon, NV                   58
NM           San Miguel, NM             57
NV           Nye, NV                    57
ID           Boise, ID                  56
AZ           Santa Cruz, AZ             55
NM           Rio Arriba, NM             53
WY           Campbell, WY               53
CO           Fremont, CO                52
OR           Benton, OR                 52
OR           Wasco, OR                  52
UT           Tooele, UT                 50
AZ           La Paz, AZ                 49
ID           Cassia, ID                 49
MT           Lewis and Clark, MT        49
UT           Washington, UT             49
CO           La Plata, CO               48
ID           Nez Perce, ID              48
ID           Bingham, ID                47
NM           Taos, NM                   46
CO           Garfield, CO               45
OR           Clatsop, OR                45
UT           Carbon, UT                 45
CO           Las Animas, CO             44
NV           Humboldt, NV               44
OR           Malheur, OR                44
CO           Montezuma, CO              43
ID           Bonner, ID                 43
OR           Columbia, OR               43
UT           Uintah, UT                 43
OR           Union, OR                  42
NM           Cibola, NM                 40
NM           Grant, NM                  40
WA           Island, WA                 40
WA           Douglas, WA                39
OR           Tillamook, OR              38
WA           Adams, WA                  38
WY           Carbon, WY                 38
NV           Carson City city, NV       37
UT           Iron, UT                   37
WY           Uinta, WY                  37
OR           Curry, OR                  36
CO           Montrose, CO               35
CO           Otero, CO                  35
MT           Lake, MT                   35
MT           Silver Bow, MT             35
NV           Douglas, NV                34
CO           Teller, CO                 33
ID           Shoshone, ID               33
NM           Lincoln, NM                33
WA           Klickitat, WA              33
WY           Albany, WY                 33
CO           Alamosa, CO                31
CO           Delta, CO                  31
ID           Latah, ID                  31
MT           Gallatin, MT               31
UT           Box Elder, UT              31
NV           Churchill, NV              30
NV           White Pine, NV             30
OR           Jefferson, OR              30
UT           Cache, UT                  30
WY           Sheridan, WY               30
CO           Morgan, CO                 29
ID           Payette, ID                29
AZ           Graham, AZ                 28
CO           Park, CO                   28
NM           Roosevelt, NM              28
WY           Park, WY                   28
CO           Rio Grande, CO             27
ID           Elmore, ID                 27
CO           Eagle, CO                  26
CO           Summit, CO                 25
ID           Jerome, ID                 25
WA           Jefferson, WA              25
WY           Converse, WY               25
ID           Idaho, ID                  24
MT           Lincoln, MT                24
NM           Quay, NM                   24
NM           Sierra, NM                 24
OR           Grant, OR                  24
WA           Asotin, WA                 24
WA           Kittitas, WA               24
WA           Pacific, WA                24
WA           Skamania, WA               24
CO           Logan, CO                  23
NM           Socorro, NM                23
UT           Duchesne, UT               23
UT           Grand, UT                  23
UT           Summit, UT                 23
WY           Lincoln, WY                23
ID           Minidoka, ID               22
WY           Sublette, WY               22
CO           Saguache, CO               21
MT           Big Horn, MT               21
MT           Deer Lodge, MT             21
WA           Pend Oreille, WA           21
CO           Moffat, CO                 20
ID           Boundary, ID               20
MT           Hill, MT                   20
MT           Roosevelt, MT              20
OR           Hood River, OR             20
CO           Clear Creek, CO            19
NM           Torrance, NM               19
OR           Crook, OR                  19
ID           Jefferson, ID              18
NV           Lander, NV                 18
NV           Pershing, NV               18
UT           Sevier, UT                 18
WA           Whitman, WA                18
WY           Big Horn, WY               18
CO           Prowers, CO                17
ID           Blaine, ID                 17
MT           Custer, MT                 17
MT           Sanders, MT                17
NM           Guadalupe, NM              17
UT           Millard, UT                17
WA           Ferry, WA                  17
CO           Archuleta, CO              16
MT           Carbon, MT                 16
OR           Baker, OR                  16
CO           Gilpin, CO                 15
CO           Grand, CO                  15
CO           Huerfano, CO               15
ID           Benewah, ID                15
WY           Platte, WY                 15
CO           Broomfield, CO             14
CO           Routt, CO                  14
MT           Ravalli, MT                14
UT           Emery, UT                  14
WA           San Juan, WA               14
WY           Hot Springs, WY            14
WY           Johnson, WY                14
CO           Conejos, CO                13
CO           Rio Blanco, CO             13
ID           Gooding, ID                13
ID           Owyhee, ID                 13
ID           Power, ID                  13
MT           Rosebud, MT                13
NM           Colfax, NM                 13
NV           Storey, NV                 13
OR           Harney, OR                 13
OR           Morrow, OR                 13
UT           Beaver, UT                 13
CO           Pitkin, CO                 12
NV           Mineral, NV                12
OR           Lake, OR                   12
CO           Bent, CO                   11
CO           Chaffee, CO                11
ID           Madison, ID                11
MT           Valley, MT                 11
UT           San Juan, UT               11
WY           Goshen, WY                 11
WY           Teton, WY                  11
ID           Clearwater, ID             10
ID           Franklin, ID               10
ID           Fremont, ID                10
ID           Gem, ID                    10
ID           Washington, ID             10
MT           Glacier, MT                10
MT           Phillips, MT               10
NM           Catron, NM                 10
NV           Lincoln, NV                10
UT           Sanpete, UT                10
UT           Wasatch, UT                10
WY           Crook, WY                  10
CO           Kit Carson, CO              9
CO           Lake, CO                    9
ID           Custer, ID                  9
ID           Lemhi, ID                   9
ID           Oneida, ID                  9
ID           Valley, ID                  9
UT           Kane, UT                    9
WY           Washakie, WY                9
AZ           Greenlee, AZ                8
CO           Elbert, CO                  8
CO           Lincoln, CO                 8
MT           Dawson, MT                  8
NM           Los Alamos, NM              8
NM           Union, NM                   8
WY           Weston, WY                  8
CO           Gunnison, CO                7
CO           Hinsdale, CO                7
ID           Lincoln, ID                 7
MT           Beaverhead, MT              7
MT           Fergus, MT                  7
MT           Musselshell, MT             7
CO           Crowley, CO                 6
MT           Broadwater, MT              6
MT           Chouteau, MT                6
MT           Stillwater, MT              6
OR           Sherman, OR                 6
OR           Wallowa, OR                 6
UT           Juab, UT                    6
UT           Morgan, UT                  6
CO           Phillips, CO                5
CO           San Miguel, CO              5
CO           Sedgwick, CO                5
CO           Yuma, CO                    5
ID           Adams, ID                   5
ID           Bear Lake, ID               5
ID           Caribou, ID                 5
ID           Lewis, ID                   5
MT           Meagher, MT                 5
MT           Mineral, MT                 5
MT           Park, MT                    5
MT           Pondera, MT                 5
MT           Sweet Grass, MT             5
WA           Columbia, WA                5
WA           Wahkiakum, WA               5
CO           Custer, CO                  4
CO           San Juan, CO                4
CO           Washington, CO              4
MT           Blaine, MT                  4
MT           Madison, MT                 4
MT           Powell, MT                  4
MT           Toole, MT                   4
UT           Daggett, UT                 4
WA           Lincoln, WA                 4
CO           Baca, CO                    3
ID           Clark, ID                   3
ID           Teton, ID                   3
MT           Granite, MT                 3
NM           Hidalgo, NM                 3
NV           Esmeralda, NV               3
WY           Niobrara, WY                3
CO           Cheyenne, CO                2
CO           Costilla, CO                2
CO           Jackson, CO                 2
CO           Mineral, CO                 2
ID           Butte, ID                   2
ID           Camas, ID                   2
MT           Jefferson, MT               2
MT           Richland, MT                2
MT           Sheridan, MT                2
MT           Teton, MT                   2
MT           Treasure, MT                2
NV           Eureka, NV                  2
OR           Wheeler, OR                 2
UT           Wayne, UT                   2
CO           Dolores, CO                 1
MT           Carter, MT                  1
MT           Daniels, MT                 1
MT           Fallon, MT                  1
MT           Garfield, MT                1
MT           Golden Valley, MT           1
MT           Liberty, MT                 1
MT           McCone, MT                  1
MT           Powder River, MT            1
MT           Wheatland, MT               1
NM           Harding, NM                 1
NM           Mora, NM                    1
OR           Gilliam, OR                 1
UT           Garfield, UT                1
UT           Piute, UT                   1
UT           Rich, UT                    1
WA           Garfield, WA                1

</div>

Why is this answer not surprising? (Hint: Clark County, Nevada, has about half the population of Maricopa.) We'll get to ways to normalize this in later chapters.

To just get the police shootings, filter the above query for `circumstance_code == "81"` before the `group_by`

2. Murders by state and year

(I'm putting the most recent year at the top)


```r
murder_data %>% 
  group_by (year, state_abbr) %>%
  summarise (cases = n() ) %>%
  #bonus: Calculate the total number of cases by year:
  mutate ( total_cases = sum(cases) )  %>%
  pivot_wider (names_from = state_abbr, values_from = cases) %>%
  arrange ( desc (year)) %>%
  #Extra! fancy table that requires the DT package.
  datatable( options = list(scrollX= "400px", 
                            pageLength = "5", 
                            lengthMenu = c(5, 10, 50)
                            )
             )
```

<!--html_preserve--><div id="htmlwidget-7b4cc52370fe599b6949" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-7b4cc52370fe599b6949">{"x":{"filter":"none","data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43"],[2018,2017,2016,2015,2014,2013,2012,2011,2010,2009,2008,2007,2006,2005,2004,2003,2002,2001,2000,1999,1998,1997,1996,1995,1994,1993,1992,1991,1990,1989,1988,1987,1986,1985,1984,1983,1982,1981,1980,1979,1978,1977,1976],[1613,1773,1448,1299,1227,1249,1223,1233,1241,1282,1351,1466,1467,1479,1464,1397,1373,1346,1149,1331,1417,1401,1475,1582,1541,1382,1383,1264,1153,1140,1300,1212,1350,1206,1117,1122,1135,1104,1295,1137,1056,949,943],[425,484,394,344,313,383,365,379,400,370,453,516,509,473,458,482,446,448,385,424,396,401,390,478,438,362,345,308,301,291,306,266,321,264,248,225,247,237,293,233,242,231,169],[248,252,208,189,165,186,172,167,145,165,160,161,176,177,216,190,181,154,134,201,195,175,182,219,187,221,232,213,166,166,206,211,247,204,192,214,193,230,198,171,194,176,183],[37,48,47,32,30,30,29,31,22,22,23,51,33,42,32,28,36,33,17,26,36,43,50,48,40,32,38,17,34,28,35,35,32,24,37,36,25,45,30,56,46,51,48],[40,43,37,38,30,16,23,19,23,28,28,15,21,23,29,22,13,22,12,11,11,16,null,19,null,null,20,18,1,22,19,null,2,30,32,23,1,23,29,33,36,30,27],[168,166,111,105,128,119,112,132,142,156,144,164,111,139,158,113,149,98,126,147,157,114,144,120,115,102,101,115,96,108,134,131,145,138,79,81,115,4,141,125,87,91,115],[239,311,228,203,185,168,136,155,175,183,183,208,242,225,187,202,191,197,135,174,184,196,227,174,176,137,136,139,105,98,104,82,110,101,97,118,130,159,154,125,93,83,78],[115,131,111,85,84,85,97,92,93,98,92,82,107,97,105,78,76,102,71,95,140,113,139,146,178,154,163,163,125,148,161,166,184,133,147,113,143,118,141,112,121,106,98],[69,82,76,61,72,51,57,55,58,41,47,65,52,60,58,61,57,82,54,58,66,75,67,78,70,69,54,55,53,46,48,56,55,53,49,56,55,54,53,54,49,36,41],[255,242,213,224,206,194,215,183,175,207,210,186,207,226,208,204,208,199,203,182,215,250,258,288,317,287,274,221,249,211,273,254,225,234,216,226,192,208,222,184,164,129,162],[17,14,23,18,14,17,17,20,8,12,11,18,9,17,13,17,16,11,12,13,17,18,18,12,20,18,20,15,23,22,14,11,29,25,20,30,34,26,34,44,24,16,22]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>year<\/th>\n      <th>total_cases<\/th>\n      <th>AZ<\/th>\n      <th>CO<\/th>\n      <th>ID<\/th>\n      <th>MT<\/th>\n      <th>NM<\/th>\n      <th>NV<\/th>\n      <th>OR<\/th>\n      <th>UT<\/th>\n      <th>WA<\/th>\n      <th>WY<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"scrollX":"400px","pageLength":"5","lengthMenu":[5,10,50],"columnDefs":[{"className":"dt-right","targets":[1,2,3,4,5,6,7,8,9,10,11,12]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->
Does this mean that these states have suddenly become more dangerous? What about population growth? 

**Alternative method**

The `janitor` package (which you may need to install) has a way to create cross-tabulations like this more simply. The function is `tabyl` (to distinguish from other table operations in R, which you probably want to avoid).  Here's an example: 


```r
murder_data %>%
  tabyl ( year , state_abbr) %>%
  arrange ( desc (year) ) %>%
  head () %>%
  #to make a nicer looking table, with the knitr() package
  kable()
```



 year    AZ    CO   ID   MT    NM    NV    OR   UT    WA   WY
-----  ----  ----  ---  ---  ----  ----  ----  ---  ----  ---
 2018   425   248   37   40   168   239   115   69   255   17
 2017   484   252   48   43   166   311   131   82   242   14
 2016   394   208   47   37   111   228   111   76   213   23
 2015   344   189   32   38   105   203    85   61   224   18
 2014   313   165   30   30   128   185    84   72   206   14
 2013   383   186   30   16   119   168    85   51   194   17




3. Percent of murders by relationship:


```r
murder_data %>%
  group_by (relationship) %>%
  summarise (num_of_cases = n() ) %>%
  mutate (total_cases = sum(num_of_cases) ,
          # This rounds to 1 digit.
          pct_cases = round (num_of_cases / total_cases * 100 , 1)
          ) %>%
  # you could un-select the total cases since they'll always be the same , but for illustratio purposes I'm keeping it.
  arrange ( desc (num_of_cases)) 
```

<div class="kable-table">

relationship                   num_of_cases   total_cases   pct_cases
----------------------------  -------------  ------------  ----------
Relationship not determined           15774         56075        28.1
Acquaintance                          11935         56075        21.3
Stranger                               9988         56075        17.8
Wife                                   2890         56075         5.2
Friend                                 2368         56075         4.2
Other - known to victim                2349         56075         4.2
Girlfriend                             1893         56075         3.4
Son                                    1260         56075         2.2
Daughter                               1005         56075         1.8
Husband                                 904         56075         1.6
Other family                            873         56075         1.6
Neighbor                                727         56075         1.3
Boyfriend                               669         56075         1.2
Mother                                  559         56075         1.0
Brother                                 534         56075         1.0
Father                                  480         56075         0.9
In-law                                  365         56075         0.7
Ex-wife                                 287         56075         0.5
Common-law wife                         178         56075         0.3
Sister                                  168         56075         0.3
Stepson                                 163         56075         0.3
Stepfather                              159         56075         0.3
Homosexual relationship                 135         56075         0.2
Stepdaughter                            102         56075         0.2
Common-law husband                       84         56075         0.1
Ex-husband                               76         56075         0.1
Employer                                 74         56075         0.1
Employee                                 53         56075         0.1
Stepmother                               23         56075         0.0

</div>

**Alternative method with `janitor::tabyl`**


```r
murder_data %>%
  tabyl (relationship) %>%
  adorn_pct_formatting (digits=1)   %>%
  #this last part turns it into a normal data frame
  arrange ( desc(n)) %>%
  as_tibble()
```

<div class="kable-table">

relationship                       n  percent 
----------------------------  ------  --------
Relationship not determined    15774  28.1%   
Acquaintance                   11935  21.3%   
Stranger                        9988  17.8%   
Wife                            2890  5.2%    
Friend                          2368  4.2%    
Other - known to victim         2349  4.2%    
Girlfriend                      1893  3.4%    
Son                             1260  2.2%    
Daughter                        1005  1.8%    
Husband                          904  1.6%    
Other family                     873  1.6%    
Neighbor                         727  1.3%    
Boyfriend                        669  1.2%    
Mother                           559  1.0%    
Brother                          534  1.0%    
Father                           480  0.9%    
In-law                           365  0.7%    
Ex-wife                          287  0.5%    
Common-law wife                  178  0.3%    
Sister                           168  0.3%    
Stepson                          163  0.3%    
Stepfather                       159  0.3%    
Homosexual relationship          135  0.2%    
Stepdaughter                     102  0.2%    
Common-law husband                84  0.1%    
Ex-husband                        76  0.1%    
Employer                          74  0.1%    
Employee                          53  0.1%    
Stepmother                        23  0.0%    

</div>

Why is this answer not surprising? (Hint: Clark County, Nevada, has about half the population of Maricopa.) We'll get to ways to normalize this in later chapters.

To just get the police shootings, filter the above query for `circumstance_code == "81"` before the `group_by`

2. Murders by state and year

(I'm putting the most recent year at the top)


```r
murder_data %>% 
  group_by (year, state_abbr) %>%
  summarise (cases = n() ) %>%
  #bonus: Calculate the total number of cases by year:
  mutate ( total_cases = sum(cases) )  %>%
  pivot_wider (names_from = state_abbr, values_from = cases) %>%
  arrange ( desc (year)) %>%
  #Extra! fancy table that requires the DT package.
  datatable( options = list(scrollX= "400px", 
                            pageLength = "5", 
                            lengthMenu = c(5, 10, 50)
                            )
             )
```

<!--html_preserve--><div id="htmlwidget-f9137aa906628db4eaa3" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-f9137aa906628db4eaa3">{"x":{"filter":"none","data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43"],[2018,2017,2016,2015,2014,2013,2012,2011,2010,2009,2008,2007,2006,2005,2004,2003,2002,2001,2000,1999,1998,1997,1996,1995,1994,1993,1992,1991,1990,1989,1988,1987,1986,1985,1984,1983,1982,1981,1980,1979,1978,1977,1976],[1613,1773,1448,1299,1227,1249,1223,1233,1241,1282,1351,1466,1467,1479,1464,1397,1373,1346,1149,1331,1417,1401,1475,1582,1541,1382,1383,1264,1153,1140,1300,1212,1350,1206,1117,1122,1135,1104,1295,1137,1056,949,943],[425,484,394,344,313,383,365,379,400,370,453,516,509,473,458,482,446,448,385,424,396,401,390,478,438,362,345,308,301,291,306,266,321,264,248,225,247,237,293,233,242,231,169],[248,252,208,189,165,186,172,167,145,165,160,161,176,177,216,190,181,154,134,201,195,175,182,219,187,221,232,213,166,166,206,211,247,204,192,214,193,230,198,171,194,176,183],[37,48,47,32,30,30,29,31,22,22,23,51,33,42,32,28,36,33,17,26,36,43,50,48,40,32,38,17,34,28,35,35,32,24,37,36,25,45,30,56,46,51,48],[40,43,37,38,30,16,23,19,23,28,28,15,21,23,29,22,13,22,12,11,11,16,null,19,null,null,20,18,1,22,19,null,2,30,32,23,1,23,29,33,36,30,27],[168,166,111,105,128,119,112,132,142,156,144,164,111,139,158,113,149,98,126,147,157,114,144,120,115,102,101,115,96,108,134,131,145,138,79,81,115,4,141,125,87,91,115],[239,311,228,203,185,168,136,155,175,183,183,208,242,225,187,202,191,197,135,174,184,196,227,174,176,137,136,139,105,98,104,82,110,101,97,118,130,159,154,125,93,83,78],[115,131,111,85,84,85,97,92,93,98,92,82,107,97,105,78,76,102,71,95,140,113,139,146,178,154,163,163,125,148,161,166,184,133,147,113,143,118,141,112,121,106,98],[69,82,76,61,72,51,57,55,58,41,47,65,52,60,58,61,57,82,54,58,66,75,67,78,70,69,54,55,53,46,48,56,55,53,49,56,55,54,53,54,49,36,41],[255,242,213,224,206,194,215,183,175,207,210,186,207,226,208,204,208,199,203,182,215,250,258,288,317,287,274,221,249,211,273,254,225,234,216,226,192,208,222,184,164,129,162],[17,14,23,18,14,17,17,20,8,12,11,18,9,17,13,17,16,11,12,13,17,18,18,12,20,18,20,15,23,22,14,11,29,25,20,30,34,26,34,44,24,16,22]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>year<\/th>\n      <th>total_cases<\/th>\n      <th>AZ<\/th>\n      <th>CO<\/th>\n      <th>ID<\/th>\n      <th>MT<\/th>\n      <th>NM<\/th>\n      <th>NV<\/th>\n      <th>OR<\/th>\n      <th>UT<\/th>\n      <th>WA<\/th>\n      <th>WY<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"scrollX":"400px","pageLength":"5","lengthMenu":[5,10,50],"columnDefs":[{"className":"dt-right","targets":[1,2,3,4,5,6,7,8,9,10,11,12]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->
Does this mean that these states have suddenly become more dangerous? What about population growth? 

NOTE: Later on, we'll get to other packages, which includes `janitor` --  a useful way to clean data. That package has a much easier way to produce tables while formatting them well. If you've already installed and loaded the package, here's another way to do the same thing: 



```r
murder_data %>%
  tabyl ( year , state_abbr) %>%
  arrange ( desc (year) ) %>%
  head () %>%
  kable()
```



 year    AZ    CO   ID   MT    NM    NV    OR   UT    WA   WY
-----  ----  ----  ---  ---  ----  ----  ----  ---  ----  ---
 2018   425   248   37   40   168   239   115   69   255   17
 2017   484   252   48   43   166   311   131   82   242   14
 2016   394   208   47   37   111   228   111   76   213   23
 2015   344   189   32   38   105   203    85   61   224   18
 2014   313   165   30   30   128   185    84   72   206   14
 2013   383   186   30   16   119   168    85   51   194   17




3. Percent of murders by relationship:


```r
murder_data %>%
  group_by (relationship) %>%
  summarise (num_of_cases = n() ) %>%
  mutate (total_cases = sum(num_of_cases) ,
          # This rounds to 1 digit.
          pct_cases = round (num_of_cases / total_cases * 100 , 1)
          ) %>%
  # you could un-select the total cases since they'll always be the same , but for illustratio purposes I'm keeping it.
  arrange ( desc (num_of_cases)) 
```

<div class="kable-table">

relationship                   num_of_cases   total_cases   pct_cases
----------------------------  -------------  ------------  ----------
Relationship not determined           15774         56075        28.1
Acquaintance                          11935         56075        21.3
Stranger                               9988         56075        17.8
Wife                                   2890         56075         5.2
Friend                                 2368         56075         4.2
Other - known to victim                2349         56075         4.2
Girlfriend                             1893         56075         3.4
Son                                    1260         56075         2.2
Daughter                               1005         56075         1.8
Husband                                 904         56075         1.6
Other family                            873         56075         1.6
Neighbor                                727         56075         1.3
Boyfriend                               669         56075         1.2
Mother                                  559         56075         1.0
Brother                                 534         56075         1.0
Father                                  480         56075         0.9
In-law                                  365         56075         0.7
Ex-wife                                 287         56075         0.5
Common-law wife                         178         56075         0.3
Sister                                  168         56075         0.3
Stepson                                 163         56075         0.3
Stepfather                              159         56075         0.3
Homosexual relationship                 135         56075         0.2
Stepdaughter                            102         56075         0.2
Common-law husband                       84         56075         0.1
Ex-husband                               76         56075         0.1
Employer                                 74         56075         0.1
Employee                                 53         56075         0.1
Stepmother                               23         56075         0.0

</div>

Again, using the `tabyl` function from the `janitor` package:


```r
murder_data %>%
  tabyl (relationship) %>%
  adorn_pct_formatting (digits=1)  %>%
  kable()
```



relationship                       n  percent 
----------------------------  ------  --------
Acquaintance                   11935  21.3%   
Boyfriend                        669  1.2%    
Brother                          534  1.0%    
Common-law husband                84  0.1%    
Common-law wife                  178  0.3%    
Daughter                        1005  1.8%    
Employee                          53  0.1%    
Employer                          74  0.1%    
Ex-husband                        76  0.1%    
Ex-wife                          287  0.5%    
Father                           480  0.9%    
Friend                          2368  4.2%    
Girlfriend                      1893  3.4%    
Homosexual relationship          135  0.2%    
Husband                          904  1.6%    
In-law                           365  0.7%    
Mother                           559  1.0%    
Neighbor                         727  1.3%    
Other - known to victim         2349  4.2%    
Other family                     873  1.6%    
Relationship not determined    15774  28.1%   
Sister                           168  0.3%    
Son                             1260  2.2%    
Stepdaughter                     102  0.2%    
Stepfather                       159  0.3%    
Stepmother                        23  0.0%    
Stepson                          163  0.3%    
Stranger                        9988  17.8%   
Wife                            2890  5.2%    


#### Putting it all together {-}
  
  First, isolate the domestic violence cases. Let's see what our choices are: 
  

```r
murder_data %>%
  group_by (relationship_code, relationship) %>%
  summarise (n())
```

<div class="kable-table">

relationship_code   relationship                     n()
------------------  ----------------------------  ------
AQ                  Acquaintance                   11935
BF                  Boyfriend                        669
BR                  Brother                          534
CH                  Common-law husband                84
CW                  Common-law wife                  178
DA                  Daughter                        1005
EE                  Employee                          53
ER                  Employer                          74
FA                  Father                           480
FR                  Friend                          2368
GF                  Girlfriend                      1893
HO                  Homosexual relationship          135
HU                  Husband                          904
IL                  In-law                           365
MO                  Mother                           559
NE                  Neighbor                         727
OF                  Other family                     873
OK                  Other - known to victim         2349
SD                  Stepdaughter                     102
SF                  Stepfather                       159
SI                  Sister                           168
SM                  Stepmother                        23
SO                  Son                             1260
SS                  Stepson                          163
ST                  Stranger                        9988
UN                  Relationship not determined    15774
WI                  Wife                            2890
XH                  Ex-husband                        76
XW                  Ex-wife                          287

</div>

Here's one way to get the answer (eliminating cases in which we don't know the victim's ethnicity)

  

```r
murder_data %>%
  filter ( relationship_code %in% c("BF", "BR", "CH", "CW", "DA", "FA", 
                                    "GF", "HO", "HU", "IL", "MO", "OF", "SD", "SF", 
                                    "SI", "SM", "SO", "WI", "XH", "XW")   & 
          vic_ethnic_code %in% c("H", "N")
        ) %>%
   group_by ( state_abbr, vic_ethnic ) %>%
   summarise (cases = n() ) %>%
   #calculate total by state and percent
   mutate ( total_cases = sum(cases), 
            pct_cases = cases / total_cases * 100 ) %>%
   #get rid of case counts
   select ( -cases ) %>%
   #sort by state
   arrange ( state_abbr ) %>%
   # put ethnicity in columns
   pivot_wider ( values_from = pct_cases, names_from = vic_ethnic)  
```

<div class="kable-table">

state_abbr    total_cases   Hispanic origin   Not of Hispanic origin
-----------  ------------  ----------------  -----------------------
AZ                   2289         26.256007                 73.74399
CO                    367         21.253406                 78.74659
ID                     92         10.869565                 89.13043
MT                     32         12.500000                 87.50000
NM                    258         59.302326                 40.69767
NV                    259         18.146718                 81.85328
OR                    883          5.209513                 94.79049
UT                     92         13.043478                 86.95652
WA                    578          7.958477                 92.04152
WY                     65         13.846154                 86.15385

</div>
  
**Alternative  Using the `janitor::tabyl` function**


```r
murder_data %>%
  filter ( relationship_code %in% c("BF", "BR", "CH", "CW", "DA", "FA", 
                                    "GF", "HO", "HU", "IL", "MO", "OF", "SD", "SF", 
                                    "SI", "SM", "SO", "WI", "XH", "XW")   & 
          vic_ethnic_code %in% c("H", "N")
        ) %>% 
  tabyl ( state_abbr, vic_ethnic) %>%
  # include column and row totals
  adorn_totals ( c("row", "col")) %>%
  #calculate % of row total (within state)
  adorn_percentages ( "row") %>%
  # remove decimal places
  adorn_pct_formatting (digits=1) %>% 
  # include # of cases
  adorn_ns %>%
  # turn it into a regular data frame
  as_tibble()
```

<div class="kable-table">

state_abbr   Hispanic origin   Not of Hispanic origin   Total         
-----------  ----------------  -----------------------  --------------
AZ           26.3%  (601)      73.7% (1688)             100.0% (2289) 
CO           21.3%   (78)      78.7%  (289)             100.0%  (367) 
ID           10.9%   (10)      89.1%   (82)             100.0%   (92) 
MT           12.5%    (4)      87.5%   (28)             100.0%   (32) 
NM           59.3%  (153)      40.7%  (105)             100.0%  (258) 
NV           18.1%   (47)      81.9%  (212)             100.0%  (259) 
OR           5.2%   (46)       94.8%  (837)             100.0%  (883) 
UT           13.0%   (12)      87.0%   (80)             100.0%   (92) 
WA           8.0%   (46)       92.0%  (532)             100.0%  (578) 
WY           13.8%    (9)      86.2%   (56)             100.0%   (65) 
Total        20.5% (1006)      79.5% (3909)             100.0% (4915) 

</div>
  
