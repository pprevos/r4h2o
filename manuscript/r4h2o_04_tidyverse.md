# 4. Exploring Data with the Tidyverse Packages {#tidyverse}

Now that we have covered the basics of the R language, it is time to analyse some data. The next four sessions use water quality data from a reticulation network which we analyse for compliance with regulations. 

This chapter has the following learning objectives:
* Understand the principles of R packages
* Load and describe a CSV data set
* Summarise rectangular data

The data and code for this session are available in the `chapter_04.R` file in the `casestudy1` folder of your RStudio project.

## R Libraries
One of the most powerful features of the R language is that developers can write extensions, the so-called packages. R has a large community of users who develop code and make it freely available to other users. 

Thousands of specialised packages are available that undertake a vast range of complex tasks. You can, for example, use R as a GIS and analyse spatial data, or implement machine learning. Other packages help you to access data from various sources, such as SQL databases. R packages can also help you present the results of your analysis as a presentation, report or interactive dashboard.

The majority of R packages are available on [CRAN](https://cran.r-project.org/), the *Comprehensive R Archive Network*. You can install packages in R with the `install.packages()` function. Within RStudio, you install packages in the *Tools* menu. When you install a package, RStudio downloads a library of files and stores them for future use. The words package and library are sometimes used interchangeably. In R, a package is a collection of R functions, data and compiled code. The location where the packages are stored is called the library.

The CRAN repository contains many packages with specific functionality to analyse water, some of which are:
* [baytrends](https://cran.r-project.org/web/packages/baytrends/index.html): Long Term Water Quality Trend Analysis.
* [biotic](https://cran.r-project.org/web/packages/biotic/index.html): Calculation of Freshwater Biotic Indices.
* [CityWaterBalance](https://cran.r-project.org/web/packages/CityWaterBalance/index.html): Track Flows of Water Through an Urban System.
* [driftR](https://cran.r-project.org/web/packages/driftR/index.html): Drift Correcting Water Quality Data.
* [EmiStatR](https://cran.r-project.org/web/packages/EmiStatR/index.html): Emissions and Statistics in R for Wastewater and Pollutants in Combined Sewer Systems.

Each package has formal documentation, and some packages have vignettes, which explain how to use the specific functions in a bit more detail.

## Introducing the Tidyverse
One of the most popular collections of R packages for analysing data is the [Tidyverse](https://www.tidyverse.org/), developed by R guru Hadley Wickham and many others. Doing 'tidy' data science is a style of coding that has a strong following. Tidy data science relates to writing code and cleaning data in a way that promotes reproducibility.

The Tidyverse packages provide enhanced functionality to extract, transform, visualise and analyse data. The features offered by these packages are more versatile, easier to use and understand than the base R code.

Computer scientists call software like the Tidyverse ‘syntactic sugar‘, which means that it simplifies the syntax

X> Install the Tidyverse collection of packages using `install.packages("tidyverse")`.

Installing the complete Tidyverse can take a little while. If you are working with the desktop version, make sure you have sufficient access rights to install and run the packages.

After you install a package, you need to initialise it with the `library()` function. When you execute `library(tidyverse)`, the console will show confirmation of the loaded packages. You can ignore the conflicts at the end. These warnings relate to functions that override existing functionality. When you initiate the Tidyverse library, the following packages are loaded by default:

* [dplyr](https://dplyr.tidyverse.org/): Manipulating and analysing data.
* [ggplot2](https://ggplot2.tidyverse.org/): Visualise data.
* [forcats](https://forcats.tidyverse.org/): Working with factor variables.
* [purrr](https://purrr.tidyverse.org/): Functional programming. 
* [readr](https://readr.tidyverse.org/): Read and write read rectangular data (like csv).
* [stringr](https://stringr.tidyverse.org/): Manipulate text.
* [tibble](https://tibble.tidyverse.org/): Working with rectangular data (tables).
* [tidyr](https://tidyr.tidyverse.org/): Data transformation.

Many other packages are available that follow the principles of the Tidyverse. 

The Tidyverse developers frequently update the software. You can see if updates are available, and optionally install them, by running `tidyverse_update()`. You can also upgrade packages in the *Tools > Check for Package Updates* menu in RStudio.

## Case Study 1
The first case study looks at water quality data in the eleven towns on the island of Gormsey. Each town has a set of sample points at the customer tap. Gormsey’s laboratory regularly samples these taps and tests the water for a range of parameters. The laboratory stores all results in a CSV file, which we use for this case study. In reality, water utilities sample hundreds of different parameters at different frequencies at the water treatment plant and the water network. Analysing this data is a common activity for water professionals. The data for this case study only contains three parameters.

This file contains samples for [turbidity](https://en.wikipedia.org/wiki/Turbidity), [Escherichia coli](https://en.wikipedia.org/wiki/Escherichia_coli) and [trihalomethanes](https://en.wikipedia.org/wiki/Trihalomethane) (THMs). E Coli is a coliform bacterium that can cause gastroenteritis. THMs are a group of chemical compounds that are predominantly formed as a by-product when chlorine is used to disinfect drinking water. Long-term exposure to high level of these byproducts can cause diseases such as cancer. Turbidity is a measure of the cloudiness of a liquid. It is not only a measure of the aesthetics of drinking water, it is also a indicator for other issues.

{width: 60%, align: center}
![Turbidity measurement](https://www.youtube.com/watch?v=qz8xHQJw6qY)

## Exploring the Case Study Data
The first step to undertake when you receive a new data set is to explore and review its content. Before we start exploring this data, we need to load the Tidyverse collection of packages with `library(tidyverse)`. If we don't do this first, R will not recognise most of the functions we will be using.

The *readr* package of the Tidyverse contains functions to read and write CSV files. R also has a base function, but the Tidyverse alternative is faster and better able to assign the correct data format. You can load the data with the `read_csv()` function.

X> Create an R script and copy and evaluate the code as you read through this chapter.

You can also watch the screencast that demonstrates the functionality explained in this chapter. The best way to learn is to type the expressions in this chapter as you read the text or view the video. A productive way to comprehend the information is to change the examples and study the output.

{width: 60%, align: center}
![Chapter 4 screencast.](https://www.youtube.com/watch?v=vPwsrMhoLY8)

{format: r, line-numbers: false}
```
library(tidyverse)
gormsey <- read_csv("casestudy1/gormsey.csv")
```

The text between quotation marks is the path to the file and its name. Note that R uses the forward-slash `/`, common in Unix systems, and not the Windows backslash (`\`) to form a path. Every R session has a working directory, and all paths are relative to that folder. When you work in a project, RStudio saves the working directory for future sessions. 

You can find see the current working directory with the `getwd()` function, which you can run in the console. Without a working directory, you would have to specify the complete path, such as: 

`C:/Users/peterp/Documents/r4h2o/casestudy2/gormsey.csv`. 

In this example, the working directory is `C:/Users/peterp/Documents/r4h2o/`. Using an RStudio project saves you having to type this every time.

The `read_csv()` function assumes that the first row contains the field names and the following rows contain the data, organised in columns. After you type the quotation marks, you can use the tab button to select a file.

After loading the data, R shows a summary. In this example, we have seven columns in various data formats. The double format are numbers. The data also contains a date and some character values.

{format: r, line-numbers: false}
```
Parsed with column specification:
cols(
  Sample_No = col_double(),
  Date_Sampled = col_date(format = ""),
  Sample_Point = col_character(),
  Town = col_character(),
  Measure = col_character(),
  Result = col_double(),
  Units = col_character()
)
```

The `gormsey` variable is now visible in the *Environment* tab. The `gormsey` variable is a data frame, which is a tabular set of data with rows (observations) and columns (variables), very much like a spreadsheet. Within the Tidyverse, a data frame is called a *Tibble*. This quaint term is a reference to the New Zealand accent of the leading developer of this software, Hadley Wickam. Tibbles have the same properties as a data frame but have some extended capabilities to make life easier. The words data-frame and tibble are used interchangeably.

Each column is a variable, which is also called a data field or a parameter. Each row holds an observation or a measurement. The table below shows two rows of the data frame.

{title="Gormsey data summary."}
| Sample_No | Date_Sampled | Sample_Point | Town      | Measure   | Result | Units      |
|-----------|--------------|--------------|-----------|-----------|--------|------------|
| 5890227   | 2018-12-30   | S11765       | Southwold | Turbidity | 0.2    | NTU        |
| 5890156   | 2018-12-23   | S16870       | Wakefield | E Coli    | 0      | orgs/100ml |
| ...       |              |              |           |           |        |            |

The data in this case study has the following fields:

* `Sample_No`: Reference number of the sample.
* `Date_Sampled`: The sampling date.
* `Sample_Point`: The reference number of the sample point.
* `Town`: The town in Gormsey.
* `Measure`: The type of measurement.
* `Result`: The result of the laboratory test.
* `Units`: The units of the result (NTU, mg/l or orgs/100ml).

Each of these columns within a data frame is a vector, like the ones we saw in the previous session. All data frames are rectangular, which means that all vectors in a data frame have the same length.

R can read many types of data. Some specialised extensions can connect R to Excel spreadsheets, SQL databases, scrape data from websites, GIS layers, and many other sources. The data for this case study uses synthetic (simulated) laboratory data.

Spreadsheets are not ideal sources for corporate data. Nevertheless, many organisations maintain spreadsheets as their single source of truth. If a spreadsheet is indeed your only solution to store data, you should stick to some simple rules to be able to easily use it in R, or any other data science package:

* Use only the top row as a header.
* Don't use colours to indicate values.
* Prevent using spaces in column names.
* Don't add any calculations in the data tab. 
* Every cell should be a data point or remain empty.

Following these guidelines, you can store your data in a clean way that simplifies analysing the results with R, or any other analytical software.

### Inspect the data
The next step is to inspect the data. When you type the name of the variable in the console, RStudio only displays the first ten rows. Any columns that don't fit on the screen are truncated.

The `names()` function displays all names of the columns as a vector of characters. You can also use this function to rename the variables in a data frame.

The `dim()` function shows the number of rows and columns in a data frame.

{format: r, line-numbers: false}
```
names(gormsey)

dim(gormsey)
```

Q> Use the `nrow()` and `ncol()` functions on the Gormsey data. What does it show?

I> Answer: The `nrow()` and `ncol()` functions list the number of rows and columns for a data frame. The result of each function call is a single number. The `dim()` function shows both results in a vector of two numbers.

### Explore the data
We now know how much data we have and what type of information it contains. R and the Tidyverse also have several functions to view the content of a data frame.

When you type the name of a variable in the console, R will show you the data. With large sets, the results will very quickly scroll through the screen. The Tidyverse will only show the first few rows of a data frame or Tibble and truncates any columns that don't fit on the screen.

The Tidyverse function to summarise a data frame is `glimpse()`. When executing this function on the Gormsey data, we see:

{format: r, line-numbers: false}
```
Rows: 2,879
Columns: 7
$ Sample_No    <dbl> 5890227, 5890156, 5890156, 5765947, 5765948, 5765928, 57…
$ Date_Sampled <date> 2018-12-30, 2018-12-23, 2018-12-23, 2018-09-05, 2018-09…
$ Sample_Point <chr> "S11765", "S16870", "S16870", "S13840", "S17696", "S1497…
$ Town         <chr> "Southwold", "Wakefield", "Wakefield", "Wakefield", "Tar…
$ Measure      <chr> "Turbidity", "Turbidity", "E Coli", "Turbidity", "Turbid…
$ Result       <dbl> 0.200, 0.200, 0.000, 0.200, 0.200, 0.200, 0.200, 0.011, …
$ Units        <chr> "NTU", "NTU", "Orgs/100mL", "NTU", "NTU", "NTU", "NTU", …
```

The `glimpse()` function shows the number of rows and columns, the names of the variables, their types and the first few data points. You can also obtain this information by clicking on the triangle next to the variable name in the Environment tab in RStudio.

The `View()` function (note the capital V) opens the data in a separate read-only window. This function is the most convenient way to inspect data visually. You can also view the data this way by clicking on the variable name in the Environment tab. You cannot edit the data, but you can sort the information by column by clicking on the variable name.

{format: r, line-numbers: false}
```
View(gormsey)
```

### Explore variables
To view any of the variables within a data frame, you need to add the column name after a `$`, e.g. `gormsey$Result`. When you execute this command, R shows a vector of the observations within this variable. You can use this vector in calculations, as explained in the previous session.

If you want to use only a subset of a vector, you can indicate the index number between square brackets. For example: `gormsey$Results[1:10]` shows the first ten results.

R has various ways to view or analyse a subset of the data. The most basic approach is to add the number of the row and column between square brackets. For example, `turbidity[1:10, 4:5]` shows the first ten rows and the fourth and fifth variable. When there is no value in either the place for the rows or the columns, R shows all values. 

{format: r, line-numbers: false}
```
gormsey[, 4:5]  ## Show all rows with column four and five

gormsey[12:18, ] ## Show all variables for row 12 to 18

gormsey$Date[1:12]
```

This syntax can also include the names of variables, e.g. `gormsey[1:10, c("Town", "Result")]` shows the first ten rows of the Town and the result.

You can subset a vector data frame by adding an index number between square brackets. For vectors, you add one number to indicate the element number. For a data frame, you use two numbers: `[rows, columns]`. When you omit either the row or column number, R shows all available rows or columns.

Besides numerical values, you can also add formulas as indices, for example: `gormsey[, n * 2]`. Please note that R is a mathematical language and the index numbers thus start at one. In generic programming languages, the index starts at zero. 

Q> What is the result of the last sample in the Gormsey data? Hint, use the `nrow()` function.

I> Answer: `gormsey[nrow(gormsey), ]`

### Filtering data
You can also filter the data using conditions. If, for example, you like to see only the turbidity data, then you can subset the data:

{format: r, line-numbers: false}
```
gormsey[gormsey$Measure == "Turbidity", ]
```

This method looks similar to what we discussed above. The difference is that the row indicator now shows an equation. When you execute the equation between brackets separately, you see a list of values that are either `TRUE` or `FALSE`. These values indicate whether the variable at that location meets the condition. For example, the following code results in a vector with the values `TRUE` and `FALSE`.

{format: r, line-numbers: false}
```
a <- 1:2
a == 1
```

Variables that are either TRUE or FALSE are called boolean or logical, and they are the building blocks of computer science. These variables are useful to indicate conditions and can also be used in calculations. The code below results in a vector with the values 2 and 0.

{format: r, line-numbers: false}
```
a <- c(TRUE, FALSE)
a * 2
```

You can also use all the common relational operators to test for complex conditions:

* `x < y` less than
* `x > y ` greater than
* `x <= y` less than or equal to
* `x >= y` greater than or equal to
* `x == y` equal to each other
* `x != y` not equal to each other

R also evaluates relations between character strings, using alphabetical order. In R, `"small" > "large"` results in TRUE because *s* comes after *l*.

You can build elaborate conditionals by combining more than one condition with logical operations. Some of the most common options are:

* `! x`: not `x`$
* `x & y`: logical and (`x`$ AND `y`$)
* `x | y`: logical or (`x`$ OR `y`$)

An example of a logical operation would be the expression `"small" > "large" & 1 == 2`, which results in FALSE because the first condition is true, but the second one is false, so they are not both true.

The Tidyverse method uses the `filter()` function, which is more convenient than using square brackets. The first parameter in this function is the data frame you need to filter, and the second parameter is the condition. 

{format: r, line-numbers: false}
```
turbidity <- filter(gormsey, Measure == "Turbidity")
```

Note that this method is tidier than the brackets method because we don't have to add the data frame name and `$` to the variables. Figure 4.1 illustrates the principles of filtering a data frame.

{width: 80%}
![Figure 4.1: Filtering a data frame: `filter(gormsey, Measure == "Turbidity")`](resources/04_tidyverse/filter.png)

We can apply this knowledge to our case study to test subsets of the data: `filter(gormsey, Town == "Strathmore" & Measure == "Turbidity" & Result > 1)` shows the turbidity samples in Strathmore with a result greater than 1 NTU. Note that testing for equality requires two equal signs.

Q> How many turbidity results in all Towns, except Strathmore, are lower than 0.1 NTU?

I> Answer: Subset the data for all results less than 0.1 NTU *and* where the Town is not Strathmore. The `nrow()` function counts the results: `nrow(filter(gormsey, Town != "Strathmore" & Result < 0.1))`.

### Counting results
The last exploratory activity to be discussed is to count the number of results. The `table()` function in base R lets you quickly view the content of a data frame or a vector. To find out how many samples each measure has, you can use:

{format: r, line-numbers: false}
```
table(gormsey$Measure)
```

The Tidyverse equivalent of this function is `count()`. The equivalent of the previous example is `count(gormsey, measure)`. Note the difference in syntax. The first argument in the function is the data frame, and the second is the variable we want to count. We can now combine these functions to create a table of the number of turbidity results for each Town. First, we create a subset of the data, and then we count the results. The output of this function is a new data frame with the results of the count.

{format: r, line-numbers: false}
```
turbidity_count <- count(turbidity, Town)
turbidity_count
```

Two further useful functions are `length()` and `unique()`. These two functions result in the length of a vector and the distinct values within a vector.

{format: r, line-numbers: false}
```
length(gormsey$Measure)
unique(gormsey$Measure)
```

## Quiz 2: Exploring Water Quality Data
You now have reviewed a series of functions that you can use to load and explore the laboratory data. With this knowledge, you can complete the next five quiz questions.

{quiz, id: q2, attempts: 10}
# Quiz 2: Exploring data
Load the Gormsey water quality data from the first case study and answer these five questions. You can use any of the following functions:

* `nrow()`: Count the number of rows in a data frame
* `glimpse()`: Summarise the content of a data frame
* `filter()`: Filter a data frame by a condition
* `unique()`: Show the distinct values for a vector
* `length()`: Count the number of elements in a vector.

? How many results does the Gormsey data contain?

a) 7
B) 2879
c) 516
d) 3

? How many E. coli results were recorded in Gormsey? 

a) 1145
B) 1470
c) 264
d) 2879

? What is the maximum turbidity measurement in Blancathey?

A) 0.5
b) 0.15
c) 8.25
d) 1.0

? What is the data type of the `Town` field?

a) Integer
b) Numeric
c) Factor
D) Character

? What is the median THM result in Swadlincote and Wakefield?

a) 0.125
b) 0.051
c) 0.033
D) 0.037

? How many E Coli results breached the regulations? The limit for E Coli is 0 org/100ml.

a) 1
b) 0
c) 1468
D) 3

? How many distinct measures are present in the data?

A) 3
b) 2879
c) 12
d) 0

That's it for the second quiz. If you get stuck, you can find the answers in the `quiz_02.R` file in the `casestudy1` folder. You can also watch the video to see the solutions.

{width: 60%, align: middle}
![Answers to quiz 1](https://www.youtube.com/watch?v=Z9BRc2dljS8)
{/quiz}

## Further Study
Several R libraries provide additional functionality to read other file formats:
* [readxl](https://readxl.tidyverse.org/): Tidyverse package to read Excel files.
* [RODBC](https://cran.r-project.org/web/packages/RODBC/index.html): Interface for databases such as SQL.
* [rvest](https://rvest.tidyverse.org/): Tidyverse package to scrape data from websites.

X> Before you proceed to the next chapter, try and load a CSV file you use in your daily work and explore the data to practice your skills.

The [next chapter](#statistics) explains how to use R and the Tidyverse to explore the data and determine whether the results are following the relevant regulations. 
