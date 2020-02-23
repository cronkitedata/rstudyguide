# Verbs Part 4:  Combining data





You'll often find yourself with two separate dataframes, attempting to put them together somehow. To put them together by column, use a `join` function. To add rows based on common variable names, use `bind_rows()`. Most of this tutorial works vertically, by `joining` two dataframes together using common values in one or more columns. 

Reporters use joins to: 

* Add information from one table, such as Census data, to another, such as a list of counties. 
* Use "lookup tables" from more traditional databases, which list codes that match to a dictionary of other values. For example, campaign finance data usually comes with a committee ID in one table of contributions. It matches to details on a candidate or political action committee using that code. 
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

The key is that the donor data includes the *many* instances of any given candidate, but the committee table only lists each political group once.  Even in this example, although Martha McSally and Kyrsten Sinema are listed twice, there are for two separate political entities.

There two kinds of joins you'll most frequently use are: 

* `inner_join`: Only matching rows are kept. Anything without a match is dropped. 
* `left_join` : Keep everything from the first table listed, drop anything that doesn't match from the second one.

## Arizona immunization data

I matched up the information from most of the public and charter schools in Arizona against Department of Education statistics to find their federal ID numbers. There are two tables that have to be matched against one another: The immunization statistics by school, and the National Center for Education Statistics characteristics. They are both saved in the R dataset called [immune_to_nces.Rda](https://cronkitedata.github.io/rstudyguide/data/immune_to_nces.Rda)



There are 2,414 schools in the NCES database, but only 841 schools in the immunizations because we've only kept schools that had students in Grade 6. There were about 10 schools that I couldn't find in the NCES data, and their IDs are blank. 

Here are their variables: 


```r
glimpse(grade6_to_nces)
```

```
## Observations: 841
## Variables: 17
## $ rowid              <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14…
## $ nces_id            <chr> "040906000652", "040906000915", "040079703230…
## $ school_name        <chr> "ABRAHAM LINCOLN TRADITIONAL SCHOOL", "ACACIA…
## $ address            <chr> "10444 N 39TH AVE", "3021 W EVANS DR", "7102 …
## $ city               <chr> "PHOENIX", "PHOENIX", "TUCSON", "TUCSON", "PH…
## $ county             <chr> "MARICOPA", "MARICOPA", "PIMA", "PIMA", "MARI…
## $ zip_code           <chr> "85051", "85053", "85757", "85705", "85033", …
## $ school_nurse       <chr> "NO", "YES", "NO", "NO", "NO", "NO", "NO", "N…
## $ school_type        <chr> "PUBLIC", "PUBLIC", "CHARTER", "CHARTER", "CH…
## $ enrolled           <dbl> 59, 134, 53, 42, 113, 56, 75, 44, 45, 106, 53…
## $ num_immune_mmr     <dbl> 58, 134, 52, 40, 113, 55, 73, 39, 44, 105, 46…
## $ num_exempt_mmr     <dbl> 1, 0, 1, 2, 0, 1, 2, 0, 1, 1, 7, 3, 0, 0, 0, …
## $ num_compliance_mmr <dbl> 59, 134, 53, 42, 113, 56, 75, 44, 45, 106, 53…
## $ num_pbe            <dbl> 5, 2, 1, 0, 3, 6, 4, 0, 23, 4, 9, 3, 1, 1, 0,…
## $ num_medical_exempt <dbl> 2, 0, 0, 7, 0, 6, 0, 0, 0, 0, 1, 0, 0, 1, 0, …
## $ num_pbe_exempt_all <dbl> 5, 0, 1, 0, 0, 0, 1, 0, 2, 1, 10, 3, 0, 0, 0,…
## $ match_type         <chr> "Yes", "Manual", "Yes", "Yes", "Yes", "Yes", …
```


```r
glimpse (nces_master)
```

```
## Observations: 2,414
## Variables: 15
## $ rowid              <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14…
## $ nces_school_id     <chr> "040553000451", "040463000999", "040010601892…
## $ nces_district_id   <chr> "0405530", "0404630", "0400106", "0400417", "…
## $ nces_district_name <chr> "Nogales Unified District", "Marana Unified D…
## $ nces_school_name   <chr> "A J MITCHELL ELEMENTARY SCHOOL", "A. C. E.",…
## $ nces_school_type   <chr> "1-Regular school", "1-Regular school", "1-Re…
## $ nces_urban         <chr> "33-Town: Remote", "41-Rural: Fringe", "11-Ci…
## $ nces_student_ct    <dbl> 406, 10, 313, 444, 517, 608, 868, 643, NA, 61…
## $ nces_fte_teacher   <dbl> 20.50, 6.80, NA, NA, 25.60, 32.75, 45.87, 0.0…
## $ nces_ratio         <dbl> 19.80, 1.47, NA, NA, 20.20, 18.56, 18.92, NA,…
## $ nces_lowest        <chr> "Kindergarten", "7th Grade", "9th Grade", "9t…
## $ nces_highest       <chr> "5th Grade", "12th Grade", "12th Grade", "12t…
## $ nces_school_level  <chr> "Elementary", "High", "High", "High", "Elemen…
## $ nces_county_name   <chr> "Santa Cruz County", "Pima County", "Maricopa…
## $ nces_fips          <chr> "04023", "04019", "04013", "04013", "04025", …
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
ß
Here are two ways to join: 


```r
immune %>% 
  inner_join (school_list, by=c("nces_id" = "nces_school_id")) %>%
  glimpse
```

```
## Observations: 834
## Variables: 17
## $ rowid              <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14…
## $ nces_id            <chr> "040906000652", "040906000915", "040079703230…
## $ school_name        <chr> "ABRAHAM LINCOLN TRADITIONAL SCHOOL", "ACACIA…
## $ city               <chr> "PHOENIX", "PHOENIX", "TUCSON", "TUCSON", "PH…
## $ county             <chr> "MARICOPA", "MARICOPA", "PIMA", "PIMA", "MARI…
## $ zip_code           <chr> "85051", "85053", "85757", "85705", "85033", …
## $ school_nurse       <chr> "NO", "YES", "NO", "NO", "NO", "NO", "NO", "N…
## $ school_type        <chr> "PUBLIC", "PUBLIC", "CHARTER", "CHARTER", "CH…
## $ enrolled           <dbl> 59, 134, 53, 42, 113, 56, 75, 44, 45, 106, 53…
## $ num_immune_mmr     <dbl> 58, 134, 52, 40, 113, 55, 73, 39, 44, 105, 46…
## $ nces_district_id   <chr> "0409060", "0409060", "0400797", "0400368", "…
## $ nces_district_name <chr> "Washington Elementary School District", "Was…
## $ nces_school_type   <chr> "1-Regular school", "1-Regular school", "1-Re…
## $ nces_urban         <chr> "11-City: Large", "11-City: Large", "21-Subur…
## $ nces_ratio         <dbl> 18.56, 18.92, NA, NA, NA, NA, NA, NA, NA, 19.…
## $ nces_school_level  <chr> "Elementary", "Elementary", "Elementary", "Ot…
## $ nces_fips          <chr> "04013", "04013", "04019", "04019", "04013", …
```

You can see that the information from the federal Education Department was added to the immunization data, but we lost seven records -- the seven that I couldn't find in the federal department. 

To preserve these records, you'll usually "protect" one of the tables -- the one you care about most -- and keep everything, even if it doesn't match. To do that, use a "left" or "right" join, depending on whether you mention the table first or second. In this case: 


```r
immune %>%
  left_join ( school_list, by=c("nces_id"="nces_school_id") ) %>%
  glimpse()
```

```
## Observations: 841
## Variables: 17
## $ rowid              <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14…
## $ nces_id            <chr> "040906000652", "040906000915", "040079703230…
## $ school_name        <chr> "ABRAHAM LINCOLN TRADITIONAL SCHOOL", "ACACIA…
## $ city               <chr> "PHOENIX", "PHOENIX", "TUCSON", "TUCSON", "PH…
## $ county             <chr> "MARICOPA", "MARICOPA", "PIMA", "PIMA", "MARI…
## $ zip_code           <chr> "85051", "85053", "85757", "85705", "85033", …
## $ school_nurse       <chr> "NO", "YES", "NO", "NO", "NO", "NO", "NO", "N…
## $ school_type        <chr> "PUBLIC", "PUBLIC", "CHARTER", "CHARTER", "CH…
## $ enrolled           <dbl> 59, 134, 53, 42, 113, 56, 75, 44, 45, 106, 53…
## $ num_immune_mmr     <dbl> 58, 134, 52, 40, 113, 55, 73, 39, 44, 105, 46…
## $ nces_district_id   <chr> "0409060", "0409060", "0400797", "0400368", "…
## $ nces_district_name <chr> "Washington Elementary School District", "Was…
## $ nces_school_type   <chr> "1-Regular school", "1-Regular school", "1-Re…
## $ nces_urban         <chr> "11-City: Large", "11-City: Large", "21-Subur…
## $ nces_ratio         <dbl> 18.56, 18.92, NA, NA, NA, NA, NA, NA, NA, 19.…
## $ nces_school_level  <chr> "Elementary", "Elementary", "Elementary", "Ot…
## $ nces_fips          <chr> "04013", "04013", "04019", "04019", "04013", …
```

Here are the rows that were kept without a match :


```
## Observations: 7
## Variables: 17
## $ rowid              <dbl> 43, 209, 414, 452, 522, 785, 821
## $ nces_id            <chr> NA, NA, NA, NA, "590014800009", NA, NA
## $ school_name        <chr> "ARCADIA NEIGHBORHOOD LEARNING CENTER", "DENN…
## $ city               <chr> "SCOTTSDALE", "DENNEHOTSO", "JOSEPH CITY", "L…
## $ county             <chr> "MARICOPA", "APACHE", "NAVAJO", "MOHAVE", "AP…
## $ zip_code           <chr> "85251", "86535", "86032", "86403", "86538", …
## $ school_nurse       <chr> "YES", "NO", "NO", "YES", "NO", "YES", "YES"
## $ school_type        <chr> "PUBLIC", "PUBLIC", "PUBLIC", "PUBLIC", "PUBL…
## $ enrolled           <dbl> 52, 21, 33, 69, 38, 42, 86
## $ num_immune_mmr     <dbl> 49, 21, 28, 67, 38, 42, 86
## $ nces_district_id   <chr> NA, NA, NA, NA, NA, NA, NA
## $ nces_district_name <chr> NA, NA, NA, NA, NA, NA, NA
## $ nces_school_type   <chr> NA, NA, NA, NA, NA, NA, NA
## $ nces_urban         <chr> NA, NA, NA, NA, NA, NA, NA
## $ nces_ratio         <dbl> NA, NA, NA, NA, NA, NA, NA
## $ nces_school_level  <chr> NA, NA, NA, NA, NA, NA, NA
## $ nces_fips          <chr> NA, NA, NA, NA, NA, NA, NA
```

In real life, you'd have to decide how much you care about these missing codes -- does it ruin your story, or can you just mention that you were unable to get information for a handful of schools, amounting to about 350 students? 


## Resources

* The "[Relational data](https://r4ds.had.co.nz/relational-data.html)" chapter in the R for Data Science textbook has details on exactly how a complex data set might fit together. 
* [An example using a famous superheroes dataset](https://stat545.com/join-cheatsheet.html#left_joinsuperheroes-publishers), from Stat 545 at the University of British Columbia


### Practice

#### Immunization data {-} 

Create a new table from the immunizations and DOE data used in this example, then see if you can find any patterns in immunization rates by school district rather than by county. (Note that charter school companies are each their own district.) Do the same by looking at urban vs. rural schools. 

#### Campaign finance data {-}

There are two tables saved in the R data file, "[azcampfin.Rda](https://cronkitedata.github.io/rstudyguide/data/azcampfin.Rda)". One holds information on contributions available from the offiical FEC database as of Feb. 23, 2020 and the other holds information on the candidates and committees. 

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

