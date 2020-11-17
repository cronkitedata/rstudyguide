#  PPP data diary

Reveal is working on a project to find communities that may have been left out of the government's PPP program, and to see if they are disadvantaged or minority. I have assembled the PPP data and mapped it to a geographic unit called a PUMA, which is used by the Census to group neighborhoods and regions that have about 100,000 people and are designed with the input of local planners to create meaningful communities in major cities. 



## PPP loan sources

The government PPP data was downloaded as a single zip file from the Treasury  at <https://sba.app.box.com/s/ahn2exwfebgqruk714v3hnf75qdap3du>  (linked from <https://home.treasury.gov/policy-issues/cares-act/assistance-for-small-businesses/sba-paycheck-protection-program-loan-level-data> )

Unzipped, this creates a folder for each state and territory that contain lists of all small loans (less than $150,000) without names or industry designations, and one folder for all large loans nationally that contain these details but don't reveal the exact amount of the loans. 

They contain the Zip Code of the business but no address or other geographic details. I assume there are some errors in the Zip Codes. For example, about (TK) loans show Zip Codes in the wrong state. It's unclear whether the codes are wrong, or the state has a typo. (Most appear to be state typos, as a zip code in Maine, for example, is shown as a business in Missouri.)

These were aggregated by zip code to create four variables: 

* *n_small* = the number of small loans by zip code
* *n_large* = the number of large loans by zip code
* *small_amount* = the total amount of loans by zip code, for small loans
* *large_amount* = the **estimated minimum** amount of loans by zip code for large loans, using the bottom value of the range instead of the exact amount. 

## Number of businesses by Zip Code

One problem with analyzing just the loans is that there is no denominator -- how much or how many loans *should* have been awarded to businesses in each zip code? There are two sources for a count of businesses in small geographic areas: 

* Zip Code Business Patterns for 2018, part of the Census Bureau's County Business Pattern dataset. This lists the number of establishments, a snapshot of the employment, and the annual payroll for all private, non-agricultural businesses in a zip code. It does not include non-profits, government agencies, or self-employed individuals, so it is an undercount of the true number of eligible entities. However, it is already compiled at the same geographic level as the loans.  There are several ways to get to it, but the most complete file, which combines both industry detail of # estabs and payroll detail for zip totals, is at <https://www2.census.gov/programs-surveys/cbp/data/2018/ZBP2018.zip>

* USPS census tract business counts, available through an agreement with HUD. This is a more accurate count of eligible businesses, but does not contain corresponding Zip Codes. Unfortunately, census tracts don't match up very well with zip code tabulation areas, so the improvement in the coverage might be offset by the inaccuracy of the correspondence.

For now, I used the ZCBP data from the Census. 

### Converting Postal Service Zip codes to Census Zip Code Tabulation Areas

The Census Bureau only updates its ZCTA products once or twice a decade, while the Postal Service is constantly updating them. ZCTA's also don't account for the many Zip Codes that refer to Post Office boxes and to large businesses with their own, unique zip code. 

<https://udsmapper.org/zip-code-to-zcta-crosswalk/> has a crosswalk file that was created as part of Obamacare and for health care regions, to assess your community. It's free and downloadable, and lists the ZCTA that corresponds to almost all of these single-point zip codes.  Here is the big caveat they publish: 

        P.O. Box and large volume customer ZIP Codes may not correspond to residence location of census population using that ZIP Code- use with caution!

I'm not exactly sure what that means, but it suggests that they have done their best to locate these single point zip codes and they may skew per-capita calculations. 

### Joining zip codes, ZCTAs, businesses and loans

Simply aggregating and joining the business and loan files created a risk -- we might drop out any zip codes that had no loans, or any zip codes that didn't have businesses in the Census file. Instead, I used the mapper above as the "master" list of possible zip codes. 

The zip code aggregates for the loans were joined to this, inserting zero whenever there was no match. The same approach was used for the census data. 

There were: 
* 4943 zip codes out of 41,104 that had no loans. 

* About $10 million in loans had no zip code in the original PPP file, and another $20 million didn't map to any of the zip codes listed in crosswalk. It accounts for 299 Zip Codes, in which only 3 had more than 1 loan. That $20 million is 0.005 percent of the nearly $400 billion in loans documented in the files. 

* Only four zip codes in the Census Bureau file were mismatched to the crosswalk, including one catch-all zip code of 99999. None were in urban areas that would be included in PUMAs. 


The aggregate number of loans, amount of loans, and baseline Census data were then aggregated again to the Zip Code Tabulation Areas, or ZCTA's, used in the Census. 

## ZCTA to PUMA

I used the GeoCorr engine at the Missouri Data Center to create a national zcta-to-puma shapefile. This has a weighting variable that shows how much of the population of a ZCTA is in a PUMA.  

Although PUMA's are created using Census tracts, this mapping was done using zip code tabulation areas, which approximate the Post Office's Zip Code system, but fold in post office boxes and large single-Zip Code businesses into a geographic region. 

Nationally, about 70 percent of the zip code areas in the Census fall entirely within a PUMA. Another 28 percent have more than half of the population falling within one PUMA. 

However, there were a number of zip codes in the loan data that didn't match to any puma. One reason might be a difference in timing -- PUMA definitions are due for a refresh and have not been updated since 2010, so any new zip codes don't match to them yet. Another might have to do with government installations and other weird geographies. For example, it appears that all of the 22 missing zip codes in Washington DC refer to government agencies.(Why they would have loans is another question!)

In the end, there were 158 ZCTA's with data that didn't match to a PUMA, accounting for about 2,000 loans (1,420 small and 578 large), and about $61 million in small loans and $305 in large loans. Virtually all of them are in large cities. 

I'm actually not sure what to do about this, but if it goes much further, we'll want to examine exactly why these aren't matching, and see how much can be done manually to fix it. 


## PUMA totals

Because the borders don't match in all cases, I decided to use the sum of the zip code areas for demographic data, rather than apply the actual PUMA demographics to the zip code totals. 

ASU has a subscription to Social Explorer, which makes acquiring demographic data from the American Community Survey quite easy. There, I calculated some basic totals for each ZCTA, including the total population by race and ethnicity; population estimates for college graduates, dropouts, and unemployed. I also picked up the median income, but it's not easily aggregated. 

Census ZCTAs don't have states or counties, so I went back to the geocorrespondence engine at University of Missouri to get the list of counties in each PUMA. There are small places that have more than one county in a PUMA, but we're only interested in the larger ones.  

#### Calculations by PUMA

Using these computed totals, I calculated the total White Non-Hispanic; Black;  and Latino population for each PUMA. Our thesis is that Black -- and sometimes Latino -- communities were overlooked in the PPP. Most areas with large Native American populations aren't large enough to have meaningful PUMA's, and I'm not sure what the rules were for tribal loans, so I think we'll have to go back to that if we are interested later on. 

Using this list, I extracted from the data all counties with at least 500,000 people. 

Here are some descriptives on how the percentages break out in PUMA's for large counties: 

      county_size          black_pct          hispanic_pct       bl_hisp_pct      pct_bus_loans    amt_per_worker  
      Length:1135        Min.   :0.0002247   Min.   :0.007291   Min.   :0.03203   Min.   :0.4106   Min.   : 639.2  
      Class :character   1st Qu.:0.0342537   1st Qu.:0.086936   1st Qu.:0.19214   1st Qu.:0.5918   1st Qu.:2753.5  
      Mode  :character   Median :0.0770053   Median :0.182843   Median :0.34642   Median :0.6560   Median :3375.1  
                         Mean   :0.1469106   Mean   :0.254997   Mean   :0.40191   Mean   :0.6754   Mean   :3410.7  
                         3rd Qu.:0.1845633   3rd Qu.:0.365756   3rd Qu.:0.58299   3rd Qu.:0.7401   3rd Qu.:3980.6  
                         Max.   :0.9501576   Max.   :0.964177   Max.   :0.98527   Max.   :1.0000   Max.   :7255.6  


(This refers to the 1,135 PUMAs that are in 132 large counties.)


This suggests some cutoffs that are somewhat different than the cutoffs for the whole country. One way to do it is to combine Black and Latino percentages so that each puma has only one category - high, medium or low Black / Hispanic.  The orginal cutoffs of 15, 50 and 100 percent still work but they may be alittle skewed toward that middle category. 


## More tk

Next up: The analysis of different areas. 



