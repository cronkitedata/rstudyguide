# Verbs Part 4:  Combining data





You'll often find yourself attempting to put together two or more data sets. To add combine columns -- getting more variables -- use one of the `join` functions. To add rows -- stacking datasets -- use `bind_rows()`. This tutorial only addresses combining columns.

Reporters use joins to: 

* Add information from one table, such demogrphics, to another, such as a list of counties. 
* Use "lookup tables" from more traditional databases, which list codes that match to a dictionary of other values. For example, campaign finance data usually comes with a committee ID in donation datasets. Those ID's match to details on a candidate or political action committee in another. 
* Link a standardized list of names to link back to an unstandardized datasets.
* Match one set of records against a completely different one to find potential stories. Some of the most famous data journalism investigations used this kind of join to find, for example, school bus drivers who have DUI's or daycare centers run by people with serious criminal histories. 

## Key takeaways

* Combining two tables requires exact matches on one or more variables. Close matches don't count.
* Whenever you can get codes to go with your data, get them  -- you never know when you'll run across another dataset with the same code.
* You can use information from one table to learn more about another, especially when you have geographic information by county, Census tract or zip code.
For example, you might combine the number of murders in a county with its population to create a murder rate. 
* Many public records databases come with "lookup tables". Be sure to request them so you can match a code, such as "G" to its translation, such as "Great!"


### Adding rows instead of columns

Joining only adds columns (or variables) to your data. If you need to stack tables on top of each other, use the `bind_rows(data frame 1, data frame 2)` function. 

## Concepts of joining

In R, as in most other language, "joins" work by matching one table against another using a common variable. 
For example, the Federal Election Commission holds information about donors in one data frame, and information about candidates and other political action committees in another. They link together using the common identifier of a committee ID. 

![Campaign finance join](images/36-contrib-names.png)

![Campaign finance join](images/36-cand-names.png)

(They don't need to have the same name, and they don't need to be in the first column.)

The key is that the donor data includes the *many* donations to any given candidate, but the committee table only lists each political group once.  Even in this example, although Martha McSally and Kyrsten Sinema are listed twice, there are for two separate political entities. The reason to do this is that you never have to worry that any changes to the candidate information -- the treasurer, the address or the office sought -- carries over to the donation. It's only listed once, in the lookup table. Most large databases are constructed this way. For example:

* Your school records are held using your student ID, which means that your address only needs to be changed once, not in every class or in every account you have with the school. 
* An inspection record typically has three tables: An establishment (like a restaurant or a workplace), an inspection, and a violation. They're linked together using establishment ID's. 
* A court database usually has many types of records: A case record, a list of charges, sentences and defendants. 

Think back on the work we did to identify a `unit of analysis`. All of these databases have different tables, or data frames, for each unit of analysis. 

There two kinds of joins you'll most frequently use are: 

* `inner_join`: Only matching rows are kept. Anything without a match is dropped. These are usually used in databases built with joining in mind.
* `left_join` : Keep everything from the first table listed, drop anything that doesn't match from the second one, which you'll use when you need to join tables that come from different agencies or systems, and you're not sure you'll have a good match.

## Arizona immunization data

I matched up the information from most of the public and charter schools in Arizona against Department of Education statistics to find their federal ID numbers. There are two tables that have to be matched against one another: The immunization statistics by school, and the National Center for Education Statistics characteristics. They are both saved in the R dataset called [immune_to_nces.Rda](https://github.com/cronkitedata/rstudyguide/blob/master/data/immune_to_nces.Rda?raw=true), which you can add to your environment  using the `load()` command.



There are 2,414 schools in the NCES database, but only 841 schools in the immunizations because we've only kept schools that had students in Grade 6. There were seven schools that I couldn't find in the NCES data, and their IDs are blank. 

Here are their variables: 


```r
glimpse(grade6_to_nces)
```

```
## Rows: 841
## Columns: 17
## $ rowid              <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,…
## $ nces_id            <chr> "040906000652", "040906000915", "040079703230", "0…
## $ school_name        <chr> "ABRAHAM LINCOLN TRADITIONAL SCHOOL", "ACACIA ELEM…
## $ address            <chr> "10444 N 39TH AVE", "3021 W EVANS DR", "7102 W VAL…
## $ city               <chr> "PHOENIX", "PHOENIX", "TUCSON", "TUCSON", "PHOENIX…
## $ county             <chr> "MARICOPA", "MARICOPA", "PIMA", "PIMA", "MARICOPA"…
## $ zip_code           <chr> "85051", "85053", "85757", "85705", "85033", "8501…
## $ school_nurse       <chr> "NO", "YES", "NO", "NO", "NO", "NO", "NO", "NO", "…
## $ school_type        <chr> "PUBLIC", "PUBLIC", "CHARTER", "CHARTER", "CHARTER…
## $ enrolled           <dbl> 59, 134, 53, 42, 113, 56, 75, 44, 45, 106, 53, 87,…
## $ num_immune_mmr     <dbl> 58, 134, 52, 40, 113, 55, 73, 39, 44, 105, 46, 84,…
## $ num_exempt_mmr     <dbl> 1, 0, 1, 2, 0, 1, 2, 0, 1, 1, 7, 3, 0, 0, 0, 2, 2,…
## $ num_compliance_mmr <dbl> 59, 134, 53, 42, 113, 56, 75, 44, 45, 106, 53, 87,…
## $ num_pbe            <dbl> 5, 2, 1, 0, 3, 6, 4, 0, 23, 4, 9, 3, 1, 1, 0, 4, 0…
## $ num_medical_exempt <dbl> 2, 0, 0, 7, 0, 6, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0,…
## $ num_pbe_exempt_all <dbl> 5, 0, 1, 0, 0, 0, 1, 0, 2, 1, 10, 3, 0, 0, 0, 2, 2…
## $ match_type         <chr> "Yes", "Manual", "Yes", "Yes", "Yes", "Yes", "Yes"…
```


```r
glimpse (nces_master)
```

```
## Rows: 2,414
## Columns: 15
## $ rowid              <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,…
## $ nces_school_id     <chr> "040553000451", "040463000999", "040010601892", "0…
## $ nces_district_id   <chr> "0405530", "0404630", "0400106", "0400417", "04067…
## $ nces_district_name <chr> "Nogales Unified District", "Marana Unified Distri…
## $ nces_school_name   <chr> "A J MITCHELL ELEMENTARY SCHOOL", "A. C. E.", "AAE…
## $ nces_school_type   <chr> "1-Regular school", "1-Regular school", "1-Regular…
## $ nces_urban         <chr> "33-Town: Remote", "41-Rural: Fringe", "11-City: L…
## $ nces_student_ct    <dbl> 406, 10, 313, 444, 517, 608, 868, 643, NA, 61, 59,…
## $ nces_fte_teacher   <dbl> 20.50, 6.80, NA, NA, 25.60, 32.75, 45.87, 0.00, NA…
## $ nces_ratio         <dbl> 19.80, 1.47, NA, NA, 20.20, 18.56, 18.92, NA, NA, …
## $ nces_lowest        <chr> "Kindergarten", "7th Grade", "9th Grade", "9th Gra…
## $ nces_highest       <chr> "5th Grade", "12th Grade", "12th Grade", "12th Gra…
## $ nces_school_level  <chr> "Elementary", "High", "High", "High", "Elementary"…
## $ nces_county_name   <chr> "Santa Cruz County", "Pima County", "Maricopa Coun…
## $ nces_fips          <chr> "04023", "04019", "04013", "04013", "04025", "0401…
```

### Setting up the data {-}

In this case, we want to get information that the federal government had on the schools attached to the immunization data. In particular, we'd like to be able to generate statistics by district, by urbanization and type of school, and we'd like to keep the code for the county so we can link it up to other datasets.

To make it simple, I'll just create a small set of data for each table: 


```r
immune <- 
  grade6_to_nces %>%
  select (rowid, nces_id, school_name, city, county, zip_code, school_nurse, school_type,
          enrolled, num_immune_mmr) 


school_list <- 
  nces_master %>%
  select (nces_school_id, nces_district_id, nces_district_name, nces_school_type, 
          nces_urban, nces_ratio, nces_school_level, nces_fips)
```


### Apply the join {-}

Here are two ways to join: 


```r
immune %>% 
  inner_join (school_list, by=c("nces_id" = "nces_school_id")) %>%
  glimpse
```

```
## Rows: 834
## Columns: 17
## $ rowid              <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,…
## $ nces_id            <chr> "040906000652", "040906000915", "040079703230", "0…
## $ school_name        <chr> "ABRAHAM LINCOLN TRADITIONAL SCHOOL", "ACACIA ELEM…
## $ city               <chr> "PHOENIX", "PHOENIX", "TUCSON", "TUCSON", "PHOENIX…
## $ county             <chr> "MARICOPA", "MARICOPA", "PIMA", "PIMA", "MARICOPA"…
## $ zip_code           <chr> "85051", "85053", "85757", "85705", "85033", "8501…
## $ school_nurse       <chr> "NO", "YES", "NO", "NO", "NO", "NO", "NO", "NO", "…
## $ school_type        <chr> "PUBLIC", "PUBLIC", "CHARTER", "CHARTER", "CHARTER…
## $ enrolled           <dbl> 59, 134, 53, 42, 113, 56, 75, 44, 45, 106, 53, 87,…
## $ num_immune_mmr     <dbl> 58, 134, 52, 40, 113, 55, 73, 39, 44, 105, 46, 84,…
## $ nces_district_id   <chr> "0409060", "0409060", "0400797", "0400368", "04009…
## $ nces_district_name <chr> "Washington Elementary School District", "Washingt…
## $ nces_school_type   <chr> "1-Regular school", "1-Regular school", "1-Regular…
## $ nces_urban         <chr> "11-City: Large", "11-City: Large", "21-Suburb: La…
## $ nces_ratio         <dbl> 18.56, 18.92, NA, NA, NA, NA, NA, NA, NA, 19.13, N…
## $ nces_school_level  <chr> "Elementary", "Elementary", "Elementary", "Other",…
## $ nces_fips          <chr> "04013", "04013", "04019", "04019", "04013", "0401…
```

You can see that the information from the federal Education Department was added to the immunization data, but we lost seven records -- the seven that I couldn't find in the federal department. 

To preserve these records, you'll usually protect one of the tables -- the one you care about most -- and keep everything, even if it doesn't match. To do that, use a `left` or `right` join, depending on whether you mention the table first or second. In this case: 


```r
immune_joined <- 
  immune %>%                                     # the table I want to protect
  left_join ( school_list,                       # the table I want to apply to my original data frame
              by=c("nces_id"="nces_school_id") ) # the variable that is the same in the two tables.

glimpse(immune_joined)
```

```
## Rows: 841
## Columns: 17
## $ rowid              <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,…
## $ nces_id            <chr> "040906000652", "040906000915", "040079703230", "0…
## $ school_name        <chr> "ABRAHAM LINCOLN TRADITIONAL SCHOOL", "ACACIA ELEM…
## $ city               <chr> "PHOENIX", "PHOENIX", "TUCSON", "TUCSON", "PHOENIX…
## $ county             <chr> "MARICOPA", "MARICOPA", "PIMA", "PIMA", "MARICOPA"…
## $ zip_code           <chr> "85051", "85053", "85757", "85705", "85033", "8501…
## $ school_nurse       <chr> "NO", "YES", "NO", "NO", "NO", "NO", "NO", "NO", "…
## $ school_type        <chr> "PUBLIC", "PUBLIC", "CHARTER", "CHARTER", "CHARTER…
## $ enrolled           <dbl> 59, 134, 53, 42, 113, 56, 75, 44, 45, 106, 53, 87,…
## $ num_immune_mmr     <dbl> 58, 134, 52, 40, 113, 55, 73, 39, 44, 105, 46, 84,…
## $ nces_district_id   <chr> "0409060", "0409060", "0400797", "0400368", "04009…
## $ nces_district_name <chr> "Washington Elementary School District", "Washingt…
## $ nces_school_type   <chr> "1-Regular school", "1-Regular school", "1-Regular…
## $ nces_urban         <chr> "11-City: Large", "11-City: Large", "21-Suburb: La…
## $ nces_ratio         <dbl> 18.56, 18.92, NA, NA, NA, NA, NA, NA, NA, 19.13, N…
## $ nces_school_level  <chr> "Elementary", "Elementary", "Elementary", "Other",…
## $ nces_fips          <chr> "04013", "04013", "04019", "04019", "04013", "0401…
```

Here are the rows that were kept without a match:

<div class="kable-table">

| rowid|nces_id      |school_name                               |city             |county   |zip_code |school_nurse |school_type | enrolled| num_immune_mmr|nces_district_id |nces_district_name |nces_school_type |nces_urban | nces_ratio|nces_school_level |nces_fips |
|-----:|:------------|:-----------------------------------------|:----------------|:--------|:--------|:------------|:-----------|--------:|--------------:|:----------------|:------------------|:----------------|:----------|----------:|:-----------------|:---------|
|    43|NA           |ARCADIA NEIGHBORHOOD LEARNING CENTER      |SCOTTSDALE       |MARICOPA |85251    |YES          |PUBLIC      |       52|             49|NA               |NA                 |NA               |NA         |         NA|NA                |NA        |
|   209|NA           |DENNEHOTSO BOARDING SCHOOL                |DENNEHOTSO       |APACHE   |86535    |NO           |PUBLIC      |       21|             21|NA               |NA                 |NA               |NA         |         NA|NA                |NA        |
|   414|NA           |J.C.U.S.D. - JOSEPH CITY PRESCHOOL        |JOSEPH CITY      |NAVAJO   |86032    |NO           |PUBLIC      |       33|             28|NA               |NA                 |NA               |NA         |         NA|NA                |NA        |
|   452|NA           |L.H.U.S.D. #1 - DEVELOPMENTAL PRESCHOOL   |LAKE HAVASU CITY |MOHAVE   |86403    |YES          |PUBLIC      |       69|             67|NA               |NA                 |NA               |NA         |         NA|NA                |NA        |
|   522|590014800009 |MANY FARMS COMMUNITY SCHOOL, INC          |MANY FARMS       |APACHE   |86538    |NO           |PUBLIC      |       38|             38|NA               |NA                 |NA               |NA         |         NA|NA                |NA        |
|   785|NA           |ST THERESA LITTLE FLOWER PRESCHOOL        |PHOENIX          |MARICOPA |85018    |YES          |PUBLIC      |       42|             42|NA               |NA                 |NA               |NA         |         NA|NA                |NA        |
|   821|NA           |T.U.S.D.#1 - C. E. ROSE PRESCHOOL PROGRAM |TUCSON           |PIMA     |85714    |YES          |PUBLIC      |       86|             86|NA               |NA                 |NA               |NA         |         NA|NA                |NA        |

</div>

In real life, you'd have to decide how much you care about these missing schools -- does it ruin your story, or can you just mention that you were unable to get information for a handful of schools, amounting to about 350 students? 

#### Use the joined table {-}

Now I might want to look at which school districts have low immunization rates: 


```r
immune_joined %>%
  # by school 
  mutate (school_pct = num_immune_mmr / enrolled  * 100 ) %>%
  # by district
  group_by (nces_district_name, county) %>%
  summarise ( num_schools = n() ,
              total_enrolled = sum(enrolled),
              total_immune = sum (num_immune_mmr),
              median_immune = median (school_pct)
              ) %>%
  # district total pct (immunized / total students)
  mutate ( pct_immune = total_immune/ total_enrolled * 100) %>%
  select (nces_district_name, county, num_schools, pct_immune, total_enrolled,  median_immune) %>%
  filter (median_immune <= 93) %>%
  head (10) %>%
  kable (digits=1)
```

```
## `summarise()` has grouped output by 'nces_district_name'. You can override using the `.groups` argument.
```



|nces_district_name                               |county   | num_schools| pct_immune| total_enrolled| median_immune|
|:------------------------------------------------|:--------|-----------:|----------:|--------------:|-------------:|
|Acclaim Charter School                           |MARICOPA |           1|       88.6|             44|          88.6|
|American Leadership Academy  Inc.                |MARICOPA |           5|       91.9|            467|          92.9|
|Arete Preparatory Academy                        |MARICOPA |           1|       90.9|             99|          90.9|
|Arizona Connections Academy Charter School  Inc. |MARICOPA |           1|       85.6|            201|          85.6|
|Arizona Montessori Charter School at Anthem      |MARICOPA |           1|       86.5|             37|          86.5|
|Ball Charter Schools (Dobson)                    |MARICOPA |           1|       90.0|             40|          90.0|
|BASIS School Inc. 12                             |YAVAPAI  |           1|       85.7|             91|          85.7|
|BASIS School Inc. 6                              |COCONINO |           1|       92.6|             95|          92.6|
|BASIS School Inc. 9                              |MARICOPA |           1|       91.7|            133|          91.7|
|Benchmark School  Inc.                           |MARICOPA |           1|       85.5|             55|          85.5|



## Resources

* The "[Relational data](https://r4ds.had.co.nz/relational-data.html)" chapter in the R for Data Science textbook has details on exactly how a complex data set might fit together. 
* [An example using a famous superheroes dataset](https://stat545.com/join-cheatsheet.html#left_joinsuperheroes-publishers), from Stat 545 at the University of British Columbia


### Practice

#### Immunization data {-} 

Create a new table from the immunizations and DOE data used in this example, then see if you can find any patterns in immunization rates by school district rather than by county. (Note that charter school companies are each their own district.) Do the same by looking at urban vs. rural schools. 

#### Campaign finance data {-}

There are two tables saved in the R data file, "[azcampfin.Rda](https://github.com/cronkitedata/rstudyguide/blob/master/data/azcampfin.Rda?raw=true)". One holds information on contributions available from the offiical FEC database as of Feb. 23, 2020 and the other holds information on the candidates and committees. 

The following codes are used in this dataset, which you may want to save into data frame. Here is some code you can use to create a lookup table for the transaction types. These codes can be joined with the column called `transaction_tp` in the contributions (or `arizona20`) data frame. 


```r
transaction_types <- tribble (
  ~tcode, ~contrib_type,
  "10",   "To a Super PAC",
  "11",   "Native American tribal",
  "15",   "Individual contrib",
  "15C",  "From a candidate",
  "15E",  "Earmarked (eg, ActBlue)",
  "20Y",  "Non-federal refund",
  "22Y",  "Refund to indiv.",
  "24I",  "Earmarked check passed on",
  "24T",  "Earmarked contrib passed on",
  "30",   "To a convention account",
  "31",   "To a headquarters account",
  "32",   "To a recount effort",
  "41Y",   "Refund from headquarters account"
  )
```

(These are pretty complicated definitions in the federal campaign finance world. For now, don't worry much about what they mean. Refunds are shown in the data as negative numbers, which is what you want.)

Try to analyze some of this by putting together the datasets and finding interesting items or patterns. 

