#' International Airline Passengers
#' 
#' Number of international airline passengers (in thousands) recorded monthly
#' from January 1949 to December 1960.
#' 
#' 
#' @name airpass.df
#' @docType data
#' @format A time series with 144 observations.
#' @keywords datasets
NULL





#' Apples Data
#' 
#' These data come from a classic long-term experiment conducted at the East
#' Malling Research Station, Kent, which is the centre four research into apple
#' growing in the U.K. Commercial apple trees consist of two parts grafted
#' together. The lowest part, the \emph{rootstock}, largely determines the size
#' of the tree, while the upper part (the \emph{scion}) determines the fruit
#' characteristics. Rootstocks propagated by cuttings (i.e. asexually produced)
#' were once thought to result in smaller trees than those propagated from
#' seeds (i.e. sexually produced). This hypothesis was re-examined in an
#' experiment begun in 1918. Several trees of each type of 16 types of
#' rootstock were planted, all trees having the same scion. Rootstocks I-IX
#' were asexually produced, while X-XVI were sexually produced. In the winter
#' of 1933-4 a number of trees were removed to make room for more, and the data
#' presented here consists of the above ground weights of 104 trees felled in
#' this period. No trees of types VIII, XI or XIV were felled.  The description
#' is from Lee (\cite{Lee, A.J. Data analysis. An introduction based on R.
#' University of Auckland 1994}). The data are from Andrews and Herzberg
#' (1985).
#' 
#' 
#' @name apples.df
#' @docType data
#' @format The data consist of a data frame with 104 observations on 3
#' variables. \tabular{rlll}{ [,1] \tab Rootstock \tab factor \tab levels (I,
#' II, III, IV, IX, V, VI, VII, X, XII, XIII, XV, XVI) \cr [,2] \tab Weight
#' \tab integer \tab . \cr [,3] \tab Propagated \tab factor \tab levels
#' (cutting, seed) }
#' @keywords datasets
NULL





#' Changes in Pupil Size with Emotional Arousal
#' 
#' Data from an experiment to measure the effect of different images on
#' emotional arousal, by measuring changes in pupil diameter. The experiment
#' used 20 males and 20 females. Images included a nude man, nude woman,
#' infant, and a landscape.
#' 
#' 
#' @name arousal.df
#' @docType data
#' @format A data frame with 160 observations on 3 variables. \tabular{rlll}{
#' [,1] \tab arousal \tab numeric \tab Change in the subject's pupil size \cr
#' [,2] \tab gender \tab factor \tab Subject's gender (female, male) \cr [,3]
#' \tab picture \tab factor \tab Picture shown to subject (infant, landscape,
#' nude female, nude male) }
#' @keywords datasets
NULL





#' US Beer Production
#' 
#' Monthly United States beer production figures (in millions of 31-gallon
#' barrels) for the period July 1970 to June 1978.
#' 
#' 
#' @name beer.df
#' @docType data
#' @format A time series with 96 observations.
#' @keywords datasets
NULL





#' Body Image and Ethnicity
#' 
#' Data collected to examine how women from various ethnic groups rate their
#' body image. All subjects were slightly underweight for their body size.
#' 
#' 
#' @name body.df
#' @docType data
#' @format A data frame with 246 observations on 8 variables. \tabular{rlll}{
#' [,1] \tab ethnicity \tab factor \tab Subject's ethnicity (Asian, Europn,
#' Maori, Pacific) \cr [,2] \tab married \tab . \tab . \cr [,3] \tab bodyim
#' \tab factor \tab Subject's rating of themself (slight.uw, right, slight.ow,
#' mod.ow, very.ow)\cr [,4] \tab sm.ever \tab . \tab . \cr [,5] \tab weight
#' \tab . \tab . \cr [,6] \tab height \tab . \tab . \cr [,7] \tab age \tab .
#' \tab . \cr [,8] \tab stressgp \tab . \tab . }
#' @keywords datasets
NULL





#' Books Data
#' 
#' This data consists of 50 sentence lengths from each of 8 books. The books
#' \dQuote{Disclosure} and \dQuote{Rising Sun} were written by Michael
#' Crichton, whilst the others \dQuote{Four Past Midnight}, \dQuote{The Dark
#' Half}, \dQuote{ Eye of the Dragon}, \dQuote{The Shining}, \dQuote{The Stand}
#' and \dQuote{The Tommy-Knockers} where written by Stephen King. The pages and
#' sentences where chosen using a multistage design where the pages where
#' selected at random, and then sentences within each page were selected at
#' random. These data were collected by James Curran.
#' 
#' 
#' @name books.df
#' @docType data
#' @format The data frame consists of 400 observations on 2 variables.
#' \tabular{rlll}{ [,1] \tab length \tab integer \tab \cr [,2] \tab book \tab
#' factor \tab levels (4.Past.Mid, Dark.Half, Disclosure, Eye.Drag, \cr \tab
#' \tab \tab Rising.Sun, Shining, Stand, T.Knock) }
#' @keywords datasets
NULL





#' Bursary Results for Auckland Secondary Schools
#' 
#' Data for the 2001 Bursary results for 75 secondary schools in the Auckland
#' area. For each school the decile rating of the school is recorded along with
#' the percentage of eligible students who gain a B Bursary or better.
#' 
#' 
#' @name bursary.df
#' @docType data
#' @format A data frame with 75 observations on 2 variables. \tabular{rlll}{
#' [,1] \tab decile \tab numeric \tab Decile rating of the school \cr [,2] \tab
#' pass.rate \tab numeric \tab Percentage of eligible students who gained a 'B'
#' Busary or better }
#' @keywords datasets
NULL





#' Butterfat Data
#' 
#' This data gives the mean percentage of butterfat produced by different
#' Canadian pure-bred diary cattle. There are five different breeds and two age
#' groups, two years old and greater than five years old. For each combination
#' of breed and age, there are measurements for 10 cows.
#' 
#' 
#' @name butterfat.df
#' @docType data
#' @format A data frame with 100 observations on 3 variables. \tabular{rlll}{
#' [,1] \tab Butterfat \tab numeric \tab Mean percentage of butterfat per cow
#' \cr [,2] \tab Breed \tab factor \tab Breed (ayrshire, canadian, guernesy,
#' holst.fres, jersey) \cr [,3] \tab Age \tab factor \tab Age group (2yo,
#' mature) }
#' @references Hand, D.J., Daly, F., Lunn, A.D., McConway, K.J. \& Ostrowski,
#' E. (1994). \emph{A Handbook of Small Data Sets}. Boca Raton, Florida:
#' Chapman and Hall/CRC.
#' 
#' Sokal, R.R. \& Rohlf, F.J. (1981). \emph{Biometry}, 2nd edition. San
#' Francisco: W.H. Freeman, 368.
#' @source A Handbook of Small Data Sets
#' @keywords datasets
NULL





#' Age and Length of Camp Lake Bluegills
#' 
#' 66 bluegills were captured from Camp Lake, Minnesota. For each bluegill we
#' have the length of the fish, its age in years and its age in scale radius.
#' 
#' 
#' @name camplake.df
#' @docType data
#' @format A data frame with 66 observations on 3 variables. \tabular{rlll}{
#' [,1] \tab Age \tab numeric \tab Age of fish (years)\cr [,2] \tab
#' Scale.Radius \tab numeric \tab Age of fish (radius of the key scale (mm/100)
#' )\cr [,3] \tab Length \tab numeric \tab Length at capture (mm) }
#' @keywords datasets
NULL





#' Chalk Data
#' 
#' These data involve 11 laboratories and 2 brands of chalk. The laboratories
#' tested the density of the chalk. The main interest was whether the different
#' laboratories yielded the same density for the two different types of chalk.
#' 
#' 
#' @name chalk.df
#' @docType data
#' @format A data frame with 66 observations on 3 variables. \tabular{rlll}{
#' [,1] \tab Density \tab numeric \tab Density of the chalk \cr [,2] \tab Lab
#' \tab integer \tab Laboratory where testing done \cr [,3] \tab Chalk \tab
#' factor \tab Chalk tested (A, B) }
#' @keywords datasets
NULL





#' Computer Questionnaire
#' 
#' Data from a test to see if a questionnaire was properly designed. The
#' questionnaire measures managers' technical knowledge of computers. The test
#' has 19 managers complete the questionnaire as well as rate their own
#' technical expertise.
#' 
#' 
#' @name computer.df
#' @docType data
#' @format A data frame with 19 observations on 2 variables. \tabular{rlll}{
#' [,1] \tab score \tab numeric \tab Questionnaire score \cr [,2] \tab
#' selfassess \tab ordered factor \tab Self-assessed level of expertise (1 =
#' low, 2 = medium, 3 = high) }
#' @keywords datasets
NULL





#' Stats 20x Summer School Data
#' 
#' Data from a summer school Stats 20x course. Each observation represents a
#' single student.
#' 
#' 
#' @name course.df
#' @docType data
#' @format A data frame with 146 observations on 15 variables. \tabular{rlll}{
#' [,1] \tab Grade \tab factor \tab Final grade for the course (A, B, C, D)\cr
#' [,2] \tab Pass \tab factor \tab Passed the course (No, Yes)\cr [,3] \tab
#' Exam \tab numeric \tab Mark in the final exam \cr [,4] \tab Degree \tab
#' factor \tab Degree enrolled in (BA, BCom, BSc, Other)\cr [,5] \tab Gender
#' \tab factor \tab Gender (Female, Male) \cr [,6] \tab Attend \tab factor \tab
#' Regularly attended class (No, Yes)\cr [,7] \tab Assign \tab numeric \tab
#' Assignment mark \cr [,8] \tab Test \tab numeric \tab Test mark \cr [,9] \tab
#' B \tab numeric \tab Mark for the short answer section of the exam \cr [,10]
#' \tab C \tab numeric \tab Mark for the long answer section of the exam \cr
#' [,11] \tab MC \tab numeric \tab Mark for the multiple choice section of the
#' exam \cr [,12] \tab Colour \tab factor \tab Colour of the exam booklet
#' (Blue, Green, Pink, Yellow)\cr [,13] \tab Stage1 \tab factor \tab Stage one
#' grade (A, B, C)\cr [,14] \tab Years.Since \tab numeric \tab Number of years
#' since doing Stage 1 \cr [,15] \tab Repeat \tab factor \tab Repeating the
#' paper (No, Yes) }
#' @keywords datasets
NULL





#' Exam Mark, Gender and Attendance for Stats 20x Summer School Students
#' 
#' Data from a summer school Stats 20x course. Each observation represents a
#' single student. It is of interest to see if there is a relationship between
#' a student's final examination mark and both their gender and whether they
#' regularly attend lectures.
#' 
#' 
#' @name course2way.df
#' @docType data
#' @format A data frame with 40 observations on 3 variables. \tabular{rlll}{
#' [,1] \tab Exam \tab numeric \tab Final exam mark (out of 100) \cr [,2] \tab
#' Gender \tab factor \tab Gender (Female, Male) \cr [,2] \tab Attend \tab
#' factor \tab Regularly attended or not (No, Yes) }
#' @keywords datasets
NULL





#' Prices and Weights of Diamonds
#' 
#' Prices of ladies' diamond rings from a Singaporean retailer and the weight
#' of their diamond stones.
#' 
#' 
#' @name diamonds.df
#' @docType data
#' @format A data frame with 48 observations on 2 variables. \tabular{rlll}{
#' [,1] \tab price \tab numeric \tab Price of ring (Singapore dollars) \cr [,2]
#' \tab weight \tab numeric \tab Weight of Diamond (carats) }
#' @keywords datasets
NULL





#' Fire Damage and Distance from the Fire Station
#' 
#' House damage and distance from the fire station, of 15 house fires. Data
#' collected by an insurance company for homes in a particular area.
#' 
#' 
#' @name fire.df
#' @docType data
#' @format A data frame with 15 observations on 2 variables. \tabular{rlll}{
#' [,1] \tab damage \tab numeric \tab Damage (\$000s)\cr [,2] \tab distance
#' \tab numeric \tab Distance from the fire station (miles) }
#' @keywords datasets
NULL





#' Fruitfly Data
#' 
#' This data gives fecundity for female fruitflies, Drosophila melanogaster.
#' The fecundity is the number of eggs laid, per day, for the fruitfly's first
#' 14 days of life. There are three strains: A control group, NS, Nonselected
#' Strain, as well as RS, a strain bred for resistance to DDT and SS, a strain
#' bred for susceptibility to DDT. Each strain contains 25 measurements. It is
#' of interest to compare the level of fecundity across strains.
#' 
#' 
#' @name fruitfly.df
#' @docType data
#' @format A data frame with 75 observations on 2 variables. \tabular{rlll}{
#' [,1] \tab fecundity \tab numeric \tab Number of eggs laid, per day, per
#' fruitfly \cr [,2] \tab strain \tab factor \tab Strain of fruitfly (NS, RS,
#' SS) }
#' @references Hand, D.J., Daly, F., Lunn, A.D., McConway, K.J. \& Ostrowski,
#' E. (1994). \emph{A Handbook of Small Data Sets}. Boca Raton, Florida:
#' Chapman and Hall/CRC.
#' 
#' Sokal, R.R. \& Rohlf, F.J. (1981). \emph{Biometry}, 2nd edition. San
#' Francisco: W.H. Freeman, 239.
#' @source A Handbook of Small Data Sets
#' @keywords datasets
NULL





#' Sale and Advertised Prices of Houses
#' 
#' A random sample of 100 houses recently sold in Mt Eden, Auckland. For each
#' house we have the advertised price and the actual sale price.
#' 
#' 
#' @name house.df
#' @docType data
#' @format A data frame with 100 observations on 2 variables. \tabular{rlll}{
#' [,1] \tab advertised.price \tab numeric \tab Advertised price (\$)\cr [,2]
#' \tab sell.price \tab numeric \tab Final sale price (\$) }
#' @keywords datasets
NULL





#' Mean Family Incomes
#' 
#' Random sample of 152 families giving their mean income (\$000s). The sample
#' was taken by an advertising agency over their area of operations.
#' 
#' 
#' @name incomes.df
#' @docType data
#' @keywords datasets
NULL





#' Ages and Lengths of Lake Mary Bluegills
#' 
#' The ages and lengths of 78 bluegills captured from Lake Mary, Minnesota.
#' 
#' 
#' @name lakemary.df
#' @docType data
#' @format A data frame with 78 observations on 2 variables. \tabular{rlll}{
#' [,1] \tab Age \tab numeric \tab Age of the fish (years)\cr [,2] \tab Length
#' \tab numeric \tab Length at capture (mm) }
#' @keywords datasets
NULL





#' Los Angeles Rainfall
#' 
#' Annual rainfall (in inches) for Los Angeles from 1908 to 1973.
#' 
#' 
#' @name larain.df
#' @docType data
#' @format A time series with 66 observations.
#' @keywords datasets
NULL





#' Year and Price of Mazda Cars
#' 
#' Prices and ages of 124 Mazda cars collected from the Melbourne Age newspaper
#' in 1991.
#' 
#' 
#' @name mazda.df
#' @docType data
#' @format A data frame with 124 observations on 2 variables. \tabular{rlll}{
#' [,1] \tab price \tab numeric \tab Price (Australian dollars)\cr [,2] \tab
#' year \tab numeric \tab Year of manufacture }
#' @keywords datasets
NULL





#' Monthly Notifications of Meningococcal Disease
#' 
#' This data shows the monthly number of notifications meningococcal disease in
#' New Zealand from January 1990 to December 2001.
#' 
#' 
#' @name mening.df
#' @docType data
#' @format A data frame with 144 observations on 3 variables: Month, Year and
#' mening.
#' @keywords datasets
NULL





#' Merger Days
#' 
#' A random selection of 38 consummated mergers from the USA, 1982, giving the
#' number of days between the date the merger was announced and the date the
#' merger became effective.
#' 
#' 
#' @name mergers.df
#' @docType data
#' @keywords datasets
NULL





#' Length of Mozart's Movements
#' 
#' Length of movements from 11 of Mozart's early symphonies and 11 of his late
#' symphonies.
#' 
#' 
#' @name mozart.df
#' @docType data
#' @format A data frame with 88 observations on 3 variables. \tabular{rlll}{
#' [,1] \tab Time \tab numeric \tab Time of each movement (seconds) \cr [,2]
#' \tab Movement \tab factor \tab Movement (M1, M2, M3, M4) \cr [,3] \tab
#' Period \tab factor \tab Period that the symphony was written (early, late) }
#' @keywords datasets
NULL





#' Nail Polish Data
#' 
#' These data were collected to determine whether quick drying nail polish or
#' regular nail polish dried faster. The time for each type of nail polish to
#' dry was recorded.
#' 
#' 
#' @name nail.df
#' @docType data
#' @format A data frame with 60 observations on 2 variables. \tabular{rlll}{
#' [,1] \tab polish \tab factor \tab Type of polish (Regular, Quick) \cr [,2]
#' \tab dry \tab integer \tab Time (in seconds) for the polish to dry }
#' @keywords datasets
NULL





#' Oyster Abundances over Different Sites
#' 
#' Data from an experiment to determine the abundance of oysters recruiting
#' from three sites in two different estuaries in New South Whales. One in
#' Georges River and two in Port Stephens. The number of oysters were recorded
#' for 10 cm by 10 cm panels over a two year period.
#' 
#' 
#' @name oysters.df
#' @docType data
#' @format A data frame with 87 observations on 2 variables. \tabular{rlll}{
#' [,1] \tab Oysters \tab numeric \tab Number of oysters on each experimental
#' panel \cr [,2] \tab Site \tab factor \tab Location of the experimental
#' panels (GR = Georges River, PS1 = First Port Stephens Site, PS2 = Second
#' Port Stephens Site) }
#' @keywords datasets
NULL





#' Peruvian Indians
#' 
#' A random sample of Peruvian Indians born in the Andes mountains, but who
#' have since migrated to lower altitudes. The sample was collected to assess
#' the long term effects of altitude on blood pressure.
#' 
#' 
#' @name peru.df
#' @docType data
#' @format A data frame with 39 observations on 5 variables. \tabular{rlll}{
#' [,1] \tab age \tab numeric \tab Subject's age \cr [,2] \tab years \tab
#' numeric \tab Number of years since migration \cr [,3] \tab weight \tab
#' numeric \tab Subject's weight (kg) \cr [,4] \tab height \tab numeric \tab
#' Subject's height (mm) \cr [,5] \tab BP \tab numeric \tab Subject's systolic
#' blood pressure (mm Hg) }
#' @keywords datasets
NULL





#' Cloud Seeding and Levels of Rainfall
#' 
#' Data from an experiment to see if seeding clouds with Silver Nitrate effects
#' the amount of rainfall.
#' 
#' 
#' @name rain.df
#' @docType data
#' @format A data frame with 50 observations on 2 variables. \tabular{rlll}{
#' [,1] \tab rain \tab numeric \tab Amount of rain \cr [,2] \tab seed \tab
#' factor \tab Whether the clouds are seeded or not (seeded, unseeded) }
#' @source Chambers, Cleveland, Kleiner, Tukey. (1983). Graphical Methods for
#' Data Analysis.
#' @keywords datasets
NULL





#' Seeds Data
#' 
#' These data record the number of seeds (out of 100) that germinated when
#' given different amounts of water. The seeds were either exposed to light or
#' kept in the dark. Four identical boxes were used for each combination of
#' water and light
#' 
#' 
#' @name seeds.df
#' @docType data
#' @format A data frame with 48 observations on 3 variables. \tabular{rlll}{
#' [,1] \tab Light \tab integer \tab Seeds exposed to light (N=No, Y=Yes) \cr
#' [,2] \tab Water \tab integer \tab Amount of water, higher levels correspond
#' to more water (1, 2, 3, 4, 5, 6) \cr [,3] \tab Count \tab integer \tab
#' Number of seeds that germinated (out of 100) }
#' @keywords datasets
NULL





#' Sheep Data
#' 
#' Sheep Data
#' 
#' 
#' @name sheep.df
#' @docType data
#' @format A data frame with 100 observations on 3 variables. \tabular{rlll}{
#' [,1] \tab Weight \tab integer \tab . \cr [,2] \tab Copper \tab factor \tab
#' levels (No, Yes) \cr [,3] \tab Cobalt \tab factor \tab levels (No, Yes) }
#' @keywords datasets
NULL





#' Skulls Data
#' 
#' Male Egyptian skulls from five different epochs. Each skull has had four
#' measurements taken of it, BH, Basibregmatic Height, BL, Basialveolar Length,
#' MB, Maximum Breadth and NH, Nasal Height. It is of interest to investigate
#' the change in shape over time. A gradual change, would indicate inbreeding
#' of the populations. This data only includes the maximum breadth
#' measurements.
#' 
#' 
#' @name skulls.df
#' @docType data
#' @format A data frame with 150 observations on 2 variables. \tabular{rlll}{
#' [,1] \tab measurement \tab integer \tab \cr [,2] \tab year \tab integer \tab
#' }
#' @references Hand, D.J., Daly, F., Lunn, A.D., McConway, K.J. \& Ostrowski,
#' E. (1994). \emph{A Handbook of Small Data Sets}. Boca Raton, Florida:
#' Chapman and Hall/CRC.
#' 
#' Thomson, A. \& Randall-Maciver, R. (1905). \emph{Ancient Races of the
#' Thebaid}. Oxford: Oxford University Press.
#' @source A Handbook of Small Data Sets
#' @keywords datasets
NULL




#' Snapper Weight Data
#' 
#' Weight and length measurements of 844 snapper (\href{https://en.wikipedia.org/wiki/Australasian_snapper}{Pagrus auratus})
#' caught in the Hauraki Gulf, near Auckland, New Zealand.
#' 
#' 
#' @name snapper.df
#' @docType data
#' @format A data frame with 844 observations on 2 variables.
#' \describe{
#' \item{len}{Fork length in centimetres. The fork length of a fish measured from the tip of the snout to 
#' the end of the middle caudal fin rays and is used in fishes in which it is difficult to tell where the vertebral column ends. 
#' Essentially it is the measurement from the tip of the 'nose' of the fish to the 'vee' in the tail.}
#' \item{wgt}{Weight of the fish in kilograms (kg).}
#' }
#' 
#' @source Russell Millar, University of Auckland.
#' @keywords datasets
NULL




#' Soya Bean Yields
#' 
#' Data from an experiment to examine the effects of different planting times
#' on the yield of soya beans, given four different cultivars.
#' 
#' 
#' @name soyabean.df
#' @docType data
#' @format A data frame with 32 observations on 3 variables. \tabular{rlll}{
#' [,1] \tab yield \tab numeric \tab Yield of each plant \cr [,2] \tab cultivar
#' \tab factor \tab Cultivar used (cult1, cult2, cult3, cult4)\cr [,3] \tab
#' planttime \tab factor \tab Month of planting (Novemb, Decemb) }
#' @source Littler, R. University of Waikato
#' @keywords datasets
NULL





#' Comparison of Three Teaching Methods
#' 
#' Data from an experiment to assess the impact of three different teaching
#' methods on language ability. 30 students were randomly allocated into three
#' groups, one for each method. The students' IQ before instruction and a
#' language test score after instruction were recorded.
#' 
#' 
#' @name teach.df
#' @docType data
#' @format A data frame with 30 observations on 3 variables. \tabular{rlll}{
#' [,1] \tab lang \tab numeric \tab Language test score after instruction \cr
#' [,2] \tab IQ \tab numeric \tab Student's IQ \cr [,3] \tab method \tab factor
#' \tab Teaching method (1, 2, 3) }
#' @keywords datasets
NULL





#' Technitron Salary Information
#' 
#' Salary information for all salaried employees of the Technitron Company.
#' 
#' 
#' @name technitron.df
#' @docType data
#' @format A data frame with 46 observations on 8 variables. \tabular{rlll}{
#' [,1] \tab salary \tab numeric \tab Annual Salary (\$)\cr [,2] \tab yrs.empl
#' \tab numeric \tab Number of years employed at Technitron \cr [,3] \tab
#' prior.yrs \tab numeric \tab Number of years prior experience \cr [,4] \tab
#' edu \tab numeric \tab Years of education after high school \cr [,5] \tab id
#' \tab numeric \tab Company identification number \cr [,6] \tab gender \tab
#' numeric \tab Gender (0 = female, 1 = male)\cr [,7] \tab dept \tab numeric
#' \tab Department employee works in (1 = Sales, 2 = Purchasing, 3 =
#' Advertising, 4 = Engineering) \cr [,8] \tab super \tab numeric \tab Number
#' of employees supervised }
#' @keywords datasets
NULL





#' Effect of a New Drug on Thyroid Weights
#' 
#' Data from an experiment to asses the effect of a new drug on the weight of
#' the thyroid gland using 16 laboratory animals. The animals were randomly
#' assigned into either a control group, or a treatment group, and each animal
#' had its bodyweight recorded at the beginning of the experiment and its
#' thyroid weight measured at the end of the experiment.
#' 
#' 
#' @name thyroid.df
#' @docType data
#' @format A data frame with 16 observations on 3 variables. \tabular{rlll}{
#' [,1] \tab thyroid \tab numeric \tab Weight of thyroid gland after 7 days
#' (mg)\cr [,2] \tab body \tab numeric \tab Animal body weight before
#' experiment began (g) \cr [,3] \tab group \tab factor \tab Animal's group (1
#' = control, 2 = drug) }
#' @keywords datasets
NULL





#' Crest Toothpaste
#' 
#' Two random samples of households, one of households who purchase Crest
#' toothpaste and one of households who do not. For each household the age is
#' recorded of the person responsible for purchasing the toothpaste.
#' 
#' 
#' @name toothpaste.df
#' @docType data
#' @format A data frame with 20 observations on 2 variables. \tabular{rlll}{
#' [,1] \tab purchasers \tab numeric \tab Age of the person in the household
#' responsible for purchases of Crest \cr [,2] \tab nonpurchasers \tab numeric
#' \tab Age of the person in the household responsible for purchases of other
#' brands of toothpaste \cr }
#' @keywords datasets
NULL





#' Zoo Attendance during an Advertising Campaign
#' 
#' Data for 455 days of attendance records for Auckland Zoo, from January 1,
#' 1993. Note that only 440 values are given due to missing values. It was of
#' interest to assess whether an advertising campaign was effective in
#' increasing attendance.
#' 
#' 
#' @name zoo.df
#' @docType data
#' @format A data frame with 440 observations on 6 variables. \tabular{rlll}{
#' [,1] \tab attendance \tab numeric \tab Number of visitors \cr [,2] \tab time
#' \tab numeric \tab Time in days since the start of the study \cr [,3] \tab
#' sun.yesterday \tab numeric \tab Hours of sunshine the previous day \cr [,4]
#' \tab tv.adds \tab numeric \tab Average spending on TV advertising in the
#' previous week (\$000 per day)\cr [,5] \tab nice.day \tab factor \tab
#' Assessment based on number of hours of sunshine (0 = No, 1 = Yes)\cr [,6]
#' \tab day.type \tab factor \tab Type of day (1 = ordinary weekday, 2 =
#' weekend day, 3 = school holiday weekday, 4 = public holday) }
#' @keywords datasets
NULL



