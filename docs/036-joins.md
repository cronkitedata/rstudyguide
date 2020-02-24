# Verbs Part 4:  Combining data





You'll often find yourself attempting to put together two or more data sets. To add combine columns -- getting more variables -- use one of the `join` functions. To add rows -- stacking datasets -- use `bind_rows()`. This tutorial only addresses combining columns.

Reporters use joins to: 

* Add information from one table, such demogrphics, to another, such as a list of counties. 
* Use "lookup tables" from more traditional databases, which list codes that match to a dictionary of other values. For example, campaign finance data usually comes with a committee ID in donation datasets. Those ID's match to details on a candidate or political action committee in another. 
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

To preserve these records, you'll usually protect one of the tables -- the one you care about most -- and keep everything, even if it doesn't match. To do that, use a `left` or `right` join, depending on whether you mention the table first or second. In this case: 


```r
immune_joined <- 
  immune %>%                                     # the table I want to protect
  left_join ( school_list,                       # the table I want to apply to my original data frame
              by=c("nces_id"="nces_school_id") ) # the variable that is the same in the two tables.

glimpse(immune_joined)
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

Here are the rows that were kept without a match:

<div class="kable-table">

 rowid  nces_id        school_name                                 city               county     zip_code   school_nurse   school_type    enrolled   num_immune_mmr  nces_district_id   nces_district_name   nces_school_type   nces_urban    nces_ratio  nces_school_level   nces_fips 
------  -------------  ------------------------------------------  -----------------  ---------  ---------  -------------  ------------  ---------  ---------------  -----------------  -------------------  -----------------  -----------  -----------  ------------------  ----------
    43  NA             ARCADIA NEIGHBORHOOD LEARNING CENTER        SCOTTSDALE         MARICOPA   85251      YES            PUBLIC               52               49  NA                 NA                   NA                 NA                    NA  NA                  NA        
   209  NA             DENNEHOTSO BOARDING SCHOOL                  DENNEHOTSO         APACHE     86535      NO             PUBLIC               21               21  NA                 NA                   NA                 NA                    NA  NA                  NA        
   414  NA             J.C.U.S.D. - JOSEPH CITY PRESCHOOL          JOSEPH CITY        NAVAJO     86032      NO             PUBLIC               33               28  NA                 NA                   NA                 NA                    NA  NA                  NA        
   452  NA             L.H.U.S.D. #1 - DEVELOPMENTAL PRESCHOOL     LAKE HAVASU CITY   MOHAVE     86403      YES            PUBLIC               69               67  NA                 NA                   NA                 NA                    NA  NA                  NA        
   522  590014800009   MANY FARMS COMMUNITY SCHOOL, INC            MANY FARMS         APACHE     86538      NO             PUBLIC               38               38  NA                 NA                   NA                 NA                    NA  NA                  NA        
   785  NA             ST THERESA LITTLE FLOWER PRESCHOOL          PHOENIX            MARICOPA   85018      YES            PUBLIC               42               42  NA                 NA                   NA                 NA                    NA  NA                  NA        
   821  NA             T.U.S.D.#1 - C. E. ROSE PRESCHOOL PROGRAM   TUCSON             PIMA       85714      YES            PUBLIC               86               86  NA                 NA                   NA                 NA                    NA  NA                  NA        

</div>

In real life, you'd have to decide how much you care about these missing schools -- does it ruin your story, or can you just mention that you were unable to get information for a handful of schools, amounting to about 350 students? 

#### Use the joined table {-}

Now I might want to look at rates of immunization by school district: 


```r
immune_joined %>%
  mutate (school_pct = num_immune_mmr / enrolled  * 100 ) %>%
  group_by (nces_district_name, county) %>%
  summarise ( num_schools = n() ,
              total_enrolled = sum(enrolled),
              total_immune = sum (num_immune_mmr),
              median_immune = median (school_pct)
              ) %>%
  mutate ( pct_immune = total_immune/ total_enrolled * 100) %>%
  select (nces_district_name, county, num_schools, pct_immune, total_enrolled,  median_immune) %>%
  arrange ( desc(num_schools), pct_immune) %>%
  kable (digits=1)
```



nces_district_name                                             county        num_schools   pct_immune   total_enrolled   median_immune
-------------------------------------------------------------  -----------  ------------  -----------  ---------------  --------------
Mesa Unified District                                          MARICOPA               56         97.5             4893            98.5
Chandler Unified District #80                                  MARICOPA               32         96.5             3497            96.9
Peoria Unified School District                                 MARICOPA               29         97.7             2555            97.9
Deer Valley Unified District                                   MARICOPA               28         95.5             2479            95.9
Gilbert Unified District                                       MARICOPA               26         96.8             2502            96.9
Paradise Valley Unified District                               MARICOPA               26         96.9             2239            97.9
Washington Elementary School District                          MARICOPA               26         98.8             2635            98.9
Tucson Unified District                                        PIMA                   23         99.6             2921           100.0
Dysart Unified District                                        MARICOPA               18         97.4             1776            98.0
Roosevelt Elementary District                                  MARICOPA               16         98.2             1056            98.6
Glendale Elementary District                                   MARICOPA               14         99.0             1469           100.0
Marana Unified District                                        PIMA                   12         97.4              910            97.8
Pendergast Elementary District                                 MARICOPA               12         98.4             1147            99.0
Sunnyside Unified District                                     PIMA                   12         99.7             1156           100.0
Phoenix Elementary District                                    MARICOPA               11         98.6              621           100.0
Scottsdale Unified District                                    MARICOPA                9         96.5             1673            96.5
Higley Unified School District                                 MARICOPA                9         97.6             1048            97.3
Alhambra Elementary District                                   MARICOPA                9         99.3             1493            99.6
Creighton Elementary District                                  MARICOPA                9         99.6              671           100.0
Florence Unified School District                               PINAL                   8         97.0              664            97.9
Laveen Elementary District                                     MARICOPA                8         98.2              768            98.3
Crane Elementary District                                      YUMA                    8         99.7              727           100.0
Kyrene Elementary District                                     MARICOPA                7         96.7             2039            96.7
Buckeye Elementary District                                    MARICOPA                7         97.4              587            98.1
Vail Unified School District                                   PIMA                    7         97.7             1063            97.4
Avondale Elementary District                                   MARICOPA                7         99.3              672            99.3
Cartwright Elementary District                                 MARICOPA                7         99.4             1806            99.5
Liberty Elementary District                                    MARICOPA                6         95.7              374            97.7
Humboldt Unified District                                      YAVAPAI                 6         96.7              457            96.3
Flowing Wells Unified District                                 PIMA                    6         97.8              414            98.1
Littleton Elementary District                                  MARICOPA                6         98.4              619            99.1
Sierra Vista Unified District                                  COCHISE                 6         98.8              402            98.8
Yuma Elementary District                                       YUMA                    6         98.8             1003            99.1
Gadsden Elementary District                                    YUMA                    6         99.8              632           100.0
American Leadership Academy  Inc.                              MARICOPA                5         91.9              467            92.9
Cave Creek Unified District                                    MARICOPA                5         93.2              468            94.5
J O Combs Unified School District                              PINAL                   5         94.7              379            93.6
Litchfield Elementary District                                 MARICOPA                5         95.9             1369            96.3
Lake Havasu Unified District                                   MOHAVE                  5         96.6              321            96.1
Amphitheater Unified District                                  PIMA                    5         98.0              915            97.5
Tempe School District                                          MARICOPA                5         98.8              840            97.4
Tolleson Elementary District                                   MARICOPA                4         95.2              357            99.3
Madison Elementary District                                    MARICOPA                4         95.8              671            96.6
Balsz Elementary District                                      MARICOPA                4         98.7              227            98.5
Chinle Unified District                                        APACHE                  4        100.0              188           100.0
Benjamin Franklin Charter School                               MARICOPA                3         87.7              253            92.2
Cottonwood-Oak Creek Elementary District                       YAVAPAI                 3         92.7              233            96.2
Queen Creek Unified District                                   MARICOPA                3         96.6              581            97.2
Apache Junction Unified District                               PINAL                   3         97.4              305            97.3
Osborn Elementary District                                     MARICOPA                3         97.8              324            97.8
Safford Unified District                                       GRAHAM                  3         98.3              232            98.7
Casa Grande Elementary District                                PINAL                   3         99.0              821            99.0
Isaac Elementary District                                      MARICOPA                3         99.2              730            99.5
Murphy Elementary District                                     MARICOPA                3        100.0              153           100.0
CITY Center for Collaborative Learning                         PIMA                    2         87.8               49            87.8
American Leadership Academy  Inc.                              PINAL                   2         91.0              178            94.3
Kingman Unified School District                                MOHAVE                  2         91.9              298            93.2
Nadaburg Unified School District                               MARICOPA                2         92.5               80            91.3
Snowflake Unified District                                     NAVAJO                  2         94.1              186            93.8
Center for Academic Success  Inc.                              COCHISE                 2         94.7               95            94.7
Saddle Mountain Unified School District                        MARICOPA                2         96.0              150            96.1
Wickenburg Unified District                                    MARICOPA                2         96.3              109            95.1
Tanque Verde Unified District                                  PIMA                    2         96.5              202            96.5
NA                                                             MARICOPA                2         96.8               94            97.1
Bullhead City School District                                  MOHAVE                  2         97.7              303            97.8
Fit Kids  Inc. dba Champion Schools                            MARICOPA                2         97.7              131            97.7
Leman Academy of Excellence  Inc.                              PIMA                    2         97.8              181            98.1
Catalina Foothills Unified District                            PIMA                    2         98.2              438            98.2
Parker Unified School District                                 LA PAZ                  2         98.2              166            98.9
Arizona Community Development Corporation                      PIMA                    2         98.4              127            98.8
Sahuarita Unified District                                     PIMA                    2         98.6              490            98.5
Douglas Unified District                                       COCHISE                 2         99.0              286            98.8
Palominas Elementary District                                  COCHISE                 2         99.2              120            99.1
Nogales Unified District                                       SANTA CRUZ              2         99.5              444            99.5
Union Elementary District                                      MARICOPA                2         99.6              235            99.5
Santa Cruz Valley Unified District                             SANTA CRUZ              2         99.6              249            99.6
Coolidge Unified District                                      PINAL                   2        100.0              203           100.0
Harvest Power Community Development Group  Inc.                YUMA                    2        100.0              152           100.0
NA                                                             APACHE                  2        100.0               59           100.0
Wellton Elementary District                                    YUMA                    1         56.0               25            56.0
Mountain Oak Charter School  Inc.                              YAVAPAI                 1         59.1               22            59.1
Desert Star Community School  Inc.                             YAVAPAI                 1         60.9               23            60.9
Valley of the Sun Waldorf Education Association  dba Desert    MARICOPA                1         64.3               28            64.3
Edkey  Inc. - Pathfinder Academy                               MARICOPA                1         66.7               45            66.7
Pine Forest Education Association  Inc.                        COCONINO                1         69.2               26            69.2
Franklin Phonetic Primary School Inc. 1                        YAVAPAI                 1         75.5               49            75.5
Edkey  Inc. - Sequoia Choice Schools                           MARICOPA                1         76.9               26            76.9
San Tan Montessori School  Inc.                                MARICOPA                1         78.7               94            78.7
Little Lamb Community School                                   MARICOPA                1         79.4               34            79.4
Sedona-Oak Creek JUSD #9                                       YAVAPAI                 1         79.4               34            79.4
Flagstaff Junior Academy                                       COCONINO                1         80.4               46            80.4
Painted Desert Montessori  LLC                                 MARICOPA                1         81.6               49            81.6
Legacy Traditional Charter School - Laveen Village             MARICOPA                1         82.0              128            82.0
Stepping Stones Academy                                        MARICOPA                1         82.1               28            82.1
Satori  Inc.                                                   PIMA                    1         82.8               29            82.8
LEAD Charter Schools                                           MARICOPA                1         83.3               42            83.3
Miami Unified District                                         GILA                    1         83.3               72            83.3
Imagine Coolidge Elementary  Inc.                              PINAL                   1         84.4              122            84.4
Joseph City Unified District                                   NAVAJO                  1         84.8               33            84.8
NA                                                             NAVAJO                  1         84.8               33            84.8
Benchmark School  Inc.                                         MARICOPA                1         85.5               55            85.5
Arizona Connections Academy Charter School  Inc.               MARICOPA                1         85.6              201            85.6
BASIS School Inc. 12                                           YAVAPAI                 1         85.7               91            85.7
Foothills Academy                                              MARICOPA                1         85.7               21            85.7
Keystone Montessori Charter School  Inc.                       MARICOPA                1         86.4               22            86.4
Arizona Montessori Charter School at Anthem                    MARICOPA                1         86.5               37            86.5
LEAD Charter Schools dba Leading Edge Academy Queen Creek      PINAL                   1         86.7               30            86.7
Choice Academies  Inc.                                         MARICOPA                1         86.8               53            86.8
Incito Schools                                                 MARICOPA                1         87.5               32            87.5
Kaizen Education Foundation dba Vista Grove Preparatory  1     MARICOPA                1         87.5               40            87.5
CAFA  Inc. dba Learning Foundation and Performing Arts Alta    MARICOPA                1         88.0               25            88.0
Tempe Preparatory Academy                                      MARICOPA                1         88.2               68            88.2
Legacy Traditional Charter School                              PINAL                   1         88.3              111            88.3
Acclaim Charter School                                         MARICOPA                1         88.6               44            88.6
Freedom Academy  Inc.                                          MARICOPA                1         88.6               44            88.6
Boys & Girls Clubs of the East Valley dba Mesa Arts Academy    MARICOPA                1         88.9               27            88.9
Villa Montessori Charter School                                MARICOPA                1         89.1               55            89.1
Show Low Unified District                                      NAVAJO                  1         89.1              193            89.1
Legacy Traditional School - Chandler                           MARICOPA                1         89.2              111            89.2
CAFA  Inc. dba Learning Foundation and Performing Arts Gilbe   MARICOPA                1         89.3               75            89.3
EAGLE South Mountain Charter  Inc.                             MARICOPA                1         89.9               79            89.9
Ball Charter Schools (Dobson)                                  MARICOPA                1         90.0               40            90.0
Heber-Overgaard Unified District                               NAVAJO                  1         90.0               40            90.0
The Charter Foundation  Inc.                                   MARICOPA                1         90.0               30            90.0
Mayer Unified School District                                  YAVAPAI                 1         90.2               41            90.2
Arete Preparatory Academy                                      MARICOPA                1         90.9               99            90.9
Mingus Springs Charter School                                  YAVAPAI                 1         90.9               22            90.9
Picacho Elementary District                                    PINAL                   1         90.9               22            90.9
Chino Valley Unified District                                  YAVAPAI                 1         91.0              178            91.0
Desert Heights Charter Schools                                 MARICOPA                1         91.2               57            91.2
Imagine Avondale Middle  Inc.                                  MARICOPA                1         91.5               82            91.5
BASIS School Inc. 9                                            MARICOPA                1         91.7              133            91.7
Phoenix Collegiate Academy  Inc.                               MARICOPA                1         91.8               49            91.8
Great Expectations Academy                                     PIMA                    1         91.9               37            91.9
Empower College Prep                                           MARICOPA                1         92.0               87            92.0
Cholla Academy                                                 MARICOPA                1         92.0               25            92.0
Legacy Traditional School - Glendale                           MARICOPA                1         92.3              117            92.3
Khalsa Family Services                                         PIMA                    1         92.6               27            92.6
Thatcher Unified District                                      GRAHAM                  1         92.6              149            92.6
BASIS School Inc. 6                                            COCONINO                1         92.6               95            92.6
Kingman Academy Of Learning                                    MOHAVE                  1         92.9              112            92.9
Archway Classical Academy Cicero                               MARICOPA                1         93.2              117            93.2
Cochise Community Development Corporation                      COCHISE                 1         93.3               30            93.3
Happy Valley East                                              PINAL                   1         93.3               45            93.3
Anthem Preparatory Academy                                     MARICOPA                1         93.4               76            93.4
Ridgeline Academy  Inc.                                        MARICOPA                1         93.5               46            93.5
Harvest Power Community Development Group  Inc.                MARICOPA                1         93.5               31            93.5
St Johns Unified District                                      APACHE                  1         93.7               63            93.7
West Gilbert Charter Elementary School  Inc.                   MARICOPA                1         93.8               32            93.8
Legacy Traditional School - North Chandler                     MARICOPA                1         93.8               65            93.8
Archway Classical Academy Lincoln                              MARICOPA                1         94.0              116            94.0
Happy Valley School  Inc.                                      MARICOPA                1         94.0               50            94.0
Reid Traditional Schools' Painted Rock Academy Inc.            MARICOPA                1         94.1               51            94.1
The Grande Innovation Academy                                  PINAL                   1         94.2               52            94.2
Scottsdale Preparatory Academy                                 MARICOPA                1         94.2              139            94.2
Naco Elementary District                                       COCHISE                 1         94.3               35            94.3
BASIS School Inc. 4                                            MARICOPA                1         94.4              162            94.4
Benson Unified School District                                 COCHISE                 1         94.5              109            94.5
Self Development Charter School                                MARICOPA                1         94.6               37            94.6
Paragon Management  Inc.                                       MARICOPA                1         94.8              213            94.8
Allen-Cochran Enterprises  Inc.                                MARICOPA                1         94.9               39            94.9
Bisbee Unified District                                        COCHISE                 1         95.0               40            95.0
Telesis Center for Learning  Inc.                              MOHAVE                  1         95.0               60            95.0
Academy of Mathematics and Science Inc. 1                      PIMA                    1         95.2               42            95.2
Kaizen Education Foundation dba Liberty Arts Academy           MARICOPA                1         95.2               21            95.2
Horizon Community Learning Center Inc. 2                       MARICOPA                1         95.3              127            95.3
Camp Verde Unified District                                    YAVAPAI                 1         95.3              107            95.3
Pima Prevention Partnership dba Pima Partnership Academy       PIMA                    1         95.5               22            95.5
BASIS School Inc. 14                                           MARICOPA                1         95.6               90            95.6
Legacy Traditional School - Gilbert                            MARICOPA                1         95.6              114            95.6
American Heritage Academy                                      YAVAPAI                 1         95.7               23            95.7
Ethos Academy - A Challenge Foundation Academy                 MARICOPA                1         95.7               23            95.7
Ball Charter Schools (Hearn)                                   MARICOPA                1         95.7               70            95.7
Grand Canyon Unified District                                  COCONINO                1         95.8               24            95.8
Red Rock Elementary District                                   PINAL                   1         95.8               48            95.8
The Charter Foundation  Inc.                                   PIMA                    1         95.8               24            95.8
Prescott Unified District                                      YAVAPAI                 1         95.8              289            95.8
BASIS School Inc. 7                                            MARICOPA                1         95.9              122            95.9
Kaizen Education Foundation dba South Pointe Junior High Sch   MARICOPA                1         95.9               49            95.9
Noah Webster Schools - Mesa                                    MARICOPA                1         96.0              124            96.0
Cicero Preparatory Academy                                     MARICOPA                1         96.0              101            96.0
Glendale Preparatory Academy                                   MARICOPA                1         96.0              101            96.0
Edkey  Inc. - Sequoia Charter School                           MARICOPA                1         96.1               76            96.1
Reid Traditional Schools' Valley Academy  Inc.                 MARICOPA                1         96.1               76            96.1
Northland Preparatory Academy                                  COCONINO                1         96.1              102            96.1
Leading Edge Academy Maricopa                                  PINAL                   1         96.1               77            96.1
Imagine Middle at Surprise  Inc.                               MARICOPA                1         96.1              129            96.1
Edkey  Inc. - Sequoia Pathway Academy                          PINAL                   1         96.2              104            96.2
SySTEM Schools                                                 MARICOPA                1         96.2               26            96.2
Pima Unified District                                          GRAHAM                  1         96.2               79            96.2
Chandler Preparatory Academy                                   MARICOPA                1         96.3              135            96.3
Daisy Education Corporation dba. Sonoran Science Academy Peo   MARICOPA                1         96.3               27            96.3
Legacy Traditional School - Surprise                           MARICOPA                1         96.3              219            96.3
CAFA  Inc. dba Learning Foundation Performing Arts School      MARICOPA                1         96.4               28            96.4
Edkey  Inc. - Sequoia Village School                           NAVAJO                  1         96.4               28            96.4
Fountain Hills Unified District                                MARICOPA                1         96.4              112            96.4
Leman Academy of Excellence  Inc.                              COCHISE                 1         96.4               28            96.4
Candeo Schools  Inc.                                           MARICOPA                1         96.5               57            96.5
Flagstaff Unified District                                     COCONINO                1         96.5              286            96.5
Prescott Valley Charter School                                 YAVAPAI                 1         96.6               29            96.6
Legacy Traditional Charter Schools - Casa Grande               PINAL                   1         96.6              146            96.6
South Valley Academy  Inc.                                     MARICOPA                1         96.6               59            96.6
Legacy Traditional School - Northwest Tucson                   PIMA                    1         96.7              123            96.7
Veritas Preparatory Academy                                    MARICOPA                1         96.7              123            96.7
Ajo Unified District                                           PIMA                    1         96.8               31            96.8
Bagdad Unified District                                        YAVAPAI                 1         96.8               31            96.8
Pointe Educational Services                                    MARICOPA                1         96.8               31            96.8
New World Educational Center                                   MARICOPA                1         96.9               32            96.9
Beaver Creek Elementary District                               YAVAPAI                 1         97.1               34            97.1
NA                                                             MOHAVE                  1         97.1               69            97.1
Globe Unified District                                         GILA                    1         97.1              105            97.1
Heritage Elementary School                                     MARICOPA                1         97.2              108            97.2
Pan-American Elementary Charter                                MARICOPA                1         97.2               72            97.2
Imagine Superstition Middle  Inc.                              PINAL                   1         97.3               37            97.3
Academy of Tucson  Inc.                                        PIMA                    1         97.3               75            97.3
Daisy Education Corporation dba Sonoran Science Academy        PIMA                    1         97.3               75            97.3
Legacy Traditional School - Avondale                           MARICOPA                1         97.4              151            97.4
Country Gardens Charter Schools                                MARICOPA                1         97.4               38            97.4
Trivium Preparatory Academy                                    MARICOPA                1         97.4              152            97.4
Round Valley Unified District                                  APACHE                  1         97.4              116            97.4
Tombstone Unified District                                     COCHISE                 1         97.5               40            97.5
BASIS School Inc. 3                                            PIMA                    1         97.6              124            97.6
BASIS School Inc. 5                                            MARICOPA                1         97.7              175            97.7
Acorn Montessori Charter School                                YAVAPAI                 1         97.8               45            97.8
ASU Preparatory Academy 1                                      MARICOPA                1         97.8               91            97.8
Twenty First Century Charter School  Inc. Bennett Academy      MARICOPA                1         97.8               46            97.8
Young Scholars Academy Charter School Corp.                    MOHAVE                  1         97.9               47            97.9
Success School                                                 MARICOPA                1         97.9               95            97.9
Mammoth-San Manuel Unified District                            PINAL                   1         98.0               49            98.0
Mohave Valley Elementary District                              MOHAVE                  1         98.0              102            98.0
Eduprize Schools  LLC                                          PINAL                   1         98.1              210            98.1
Academy Del Sol  Inc.                                          PIMA                    1         98.1               53            98.1
Calibre Academy                                                MARICOPA                1         98.2               55            98.2
Academy of Mathematics and Science South  Inc.                 MARICOPA                1         98.2               56            98.2
Blue Ridge Unified School District No. 32                      NAVAJO                  1         98.2              169            98.2
BASIS School Inc. 13                                           MARICOPA                1         98.3               58            98.3
Camelback Education  Inc                                       MARICOPA                1         98.3               59            98.3
Legacy Traditional Charter School - Maricopa                   PINAL                   1         98.4              128            98.4
Continental Elementary District                                PIMA                    1         98.6               70            98.6
Willcox Unified District                                       COCHISE                 1         98.6               74            98.6
Maricopa Unified School District                               PINAL                   1         98.9              262            98.9
Cortez Park Charter Middle School  Inc.                        MARICOPA                1         98.9               94            98.9
Eloy Elementary District                                       PINAL                   1         98.9               95            98.9
Fort Huachuca Accommodation District                           COCHISE                 1         99.0               99            99.0
Riverside Elementary District                                  MARICOPA                1         99.0              105            99.0
Wilson Elementary District                                     MARICOPA                1         99.3              139            99.3
Imagine Desert West Middle  Inc.                               MARICOPA                1         99.3              141            99.3
Payson Unified District                                        GILA                    1         99.4              168            99.4
Somerton Elementary District                                   YUMA                    1         99.4              338            99.4
BASIS School Inc. 2                                            MARICOPA                1         99.5              186            99.5
Academy of Mathematics and Science Inc. 2                      MARICOPA                1        100.0              113           100.0
Altar Valley Elementary District                               PIMA                    1        100.0               84           100.0
American Basic Schools LLC                                     MARICOPA                1        100.0               81           100.0
Aprender Tucson                                                PIMA                    1        100.0               27           100.0
Arizona School For The Arts                                    MARICOPA                1        100.0              112           100.0
Arizona State School for the Deaf and Blind                    MARICOPA                1        100.0               23           100.0
Arlington Elementary District                                  MARICOPA                1        100.0               29           100.0
Baboquivari Unified School District #40                        PIMA                    1        100.0               86           100.0
Ball Charter Schools (Val Vista)                               MARICOPA                1        100.0               23           100.0
BASIS School Inc. 10                                           MARICOPA                1        100.0              104           100.0
BASIS School Inc. 8                                            PIMA                    1        100.0              154           100.0
Bell Canyon Charter School  Inc                                MARICOPA                1        100.0               30           100.0
Career Success Schools                                         MARICOPA                1        100.0               23           100.0
Carpe Diem Collegiate High School                              YUMA                    1        100.0               46           100.0
Challenge School  Inc.                                         MARICOPA                1        100.0               42           100.0
Crown Charter School  Inc                                      MARICOPA                1        100.0               28           100.0
Daisy Education Corporation dba Paragon Science Academy        MARICOPA                1        100.0               46           100.0
Daisy Education Corporation dba Sonoran Science Academy - Ph   MARICOPA                1        100.0               31           100.0
Daisy Education Corporation dba. Sonoran Science Academy Dav   PIMA                    1        100.0               22           100.0
Destiny School  Inc.                                           GILA                    1        100.0               29           100.0
EAGLE College Prep Maryvale  LLC                               MARICOPA                1        100.0               43           100.0
Edkey  Inc. - Sequoia Ranch School                             MARICOPA                1        100.0               36           100.0
Excalibur Charter Schools  Inc.                                PINAL                   1        100.0               36           100.0
Fort Thomas Unified District                                   GRAHAM                  1        100.0               40           100.0
Fowler Elementary District                                     MARICOPA                1        100.0              250           100.0
Friendly House  Inc.                                           MARICOPA                1        100.0               45           100.0
Ganado Unified School District                                 APACHE                  1        100.0              108           100.0
Gila Bend Unified District                                     MARICOPA                1        100.0               59           100.0
Holbrook Unified District                                      NAVAJO                  1        100.0              112           100.0
Kaizen Education Foundation dba Havasu Preparatory Academy     MOHAVE                  1        100.0               33           100.0
Liberty Traditional Charter School                             MARICOPA                1        100.0               52           100.0
Maryvale Preparatory Academy                                   MARICOPA                1        100.0               52           100.0
Math and Science Success Academy  Inc.                         PIMA                    1        100.0               62           100.0
Mexicayotl Academy  Inc.                                       SANTA CRUZ              1        100.0               21           100.0
Mohave Accelerated Learning Center                             MOHAVE                  1        100.0               85           100.0
Montessori Day Public Schools Chartered  Inc.                  MARICOPA                1        100.0               24           100.0
Morenci Unified District                                       GREENLEE                1        100.0               98           100.0
Morrison Education Group  Inc.                                 MARICOPA                1        100.0               24           100.0
Noah Webster Schools-Pima                                      MARICOPA                1        100.0               32           100.0
P.L.C. Charter Schools                                         MARICOPA                1        100.0              117           100.0
Paramount Education Studies Inc                                MARICOPA                1        100.0               34           100.0
Pinon Unified District                                         NAVAJO                  1        100.0              103           100.0
Pioneer Preparatory School                                     MARICOPA                1        100.0               92           100.0
Presidio School                                                PIMA                    1        100.0               35           100.0
Ray Unified District                                           PINAL                   1        100.0               29           100.0
Red Mesa Unified District                                      APACHE                  1        100.0               35           100.0
San Carlos Unified District                                    GILA                    1        100.0              105           100.0
Sanders Unified District                                       APACHE                  1        100.0               58           100.0
Santa Cruz Elementary District                                 SANTA CRUZ              1        100.0               27           100.0
Self Development Academy-Phoenix                               MARICOPA                1        100.0               36           100.0
Skyline Gila River Schools  LLC                                PINAL                   1        100.0               25           100.0
Sonoran Science Academy - Broadway                             PIMA                    1        100.0               26           100.0
Southgate Academy  Inc.                                        PIMA                    1        100.0               61           100.0
Stanfield Elementary District                                  PINAL                   1        100.0               55           100.0
Superior Unified School District                               PINAL                   1        100.0               24           100.0
The Charter Foundation  Inc.                                   YUMA                    1        100.0               37           100.0
The Paideia Academies  Inc                                     MARICOPA                1        100.0               57           100.0
Tuba City Unified School District #15                          COCONINO                1        100.0               96           100.0
Tucson Country Day School  Inc.                                PIMA                    1        100.0               80           100.0
Tucson International Academy  Inc.                             PIMA                    1        100.0               23           100.0
Williams Unified District                                      COCONINO                1        100.0               54           100.0
Window Rock Unified District                                   APACHE                  1        100.0              156           100.0
Winslow Unified District                                       NAVAJO                  1        100.0              156           100.0
NA                                                             PIMA                    1        100.0               86           100.0



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

