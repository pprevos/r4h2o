# 11. Writing Reports {#reporting}
This last section of the case study is another mini hackathon where you will be exploring the other variables in the customer survey. Besides the *Personal Involvement Index*, the survey also contains information about perceptions of quality, the level of hardship that customers reported to experience and the frequency at which they contact their water utility. The section will guide you to analyse this data and present the result in a report using RMarkdown.

The learning objectives for this session are:
- Fine-tune RMarkdown document settings.
- Practice analysing data with Tidyverse code
- Understand the principles of measuring service quality.

The next section explains some of the theoretical assumptions used in the customer survey you need to understand before you can analyse the data. 

## Creating documents with RMarkdown 
[Chapter 7](#dataproducts) discussed the data science workflow and using data products to share the results of the analysis. This section delves a bit deeper into the functionalities of RMarkdown as a tool to share data science.

When you create a new document, RStudio provides four options. The document option results in either a web page (HTML), a PDF document or an MS Word document. The presentation option provides two HTML templates, PDF or PowerPoint. Shiny is a tool for interactive websites and presentations.

{width: 60%, align: "center"}
![New RMarkdown file menu.](resources/11_reports/rmarkdown-menu.jpg)

X> Open the `chapter_11.Rmd` file in The `casestudy2` folder to experiment with the different options.

RMarkdown has a fine-grained system to set various options for the whole document and for each code chunk.  The top of the report contains the metadata in a format called [YAML](https://en.wikipedia.org/wiki/YAML). This is a data format often used to configure software. All YAML is contained within two lines with three dashes. A colon symbol assigns a value. 

The first three lines in the example below define the title, the author and the document date. These variables are used to create the document. If your template has placeholders for title, date and author, then the contents between quotation marks will appear in the final result.

The `output` variable defines the output format, which in this case is an MS Word document. YAML uses indentation to indicate values that are grouped together. For Microsoft Office and Libre Office documents, you can identify a reference document, as we saw in [chapter 7](#dataproducts). This can be your organisation's corporate style, assuming it is correctly formatted. For this method to work, the template needs to use styles to indicate the title, author, header, text and so on.

```
---
title: "Involvement with Tap Water"
author: "Peter Prevos"
date: "20 July 2020"
output: 
  word_document:
    reference_docx: template.dotx
---
```

The next section of your document contains the first code chunk which provides general options with the `knitr::opts_chunk$set()` function call. Using a double colon is a method to use a function from a package without loading the whole package. In this case, we are calling the `opts_chunk()` function from the knitr (knit R) package. This package is the main engine behind RMarkdown.

This package has many options to control the final result. To create a blank document, without any code or messages from the R console, it is best to add the following options to this function: `echo = FALSE, warning = FALSE, message = FALSE`. This means that the output will not show the code (echo is the output of a console). These options also prevent any messages and warnings from the R console to be printed.

Another document-wide option to set for good-looking documents is `dpi=300`. This option ensures that all graphics are generated with a high resolution.

The first code chunk is a good place to define all the variables you need and load and clean the data you need. This first chunk has `include = FALSE` as a default. This means that the final result will not contain any output from this section, even though the code is evaluated. 

Each code chunk can have its own display options. When your chunk produces a graph, you can set various graphics parameters, such as the caption or the size (in inches): `fig.cap = "...", fig.width = 6`. 

The RMarkdown website provides [](https://rmarkdown.rstudio.com/) extensive documentation on the various options. They also host the [RMarkdown Reference Guide](https://rstudio.com/wp-content/uploads/2015/03/rmarkdown-reference.pdf) which lists all available options in a five-page pdf file.

A final option that needs discussing is the working directory. The working directory is the starting point where R will look for files. When you open an RStudio project file, the working directory is set as the location that the project file is in. This saves you having to type long files names `c:\users\jdoe\...` and it makes a project portable.

The rules are slightly different for RMarkdown. The working directory for an RMarkdown file is the location it is stored at. You can change this behaviour by clicking the small triangle next to the knit button and select the Knit directory.

## Survey Items
The customer survey also contains data about some customer characteristics and how they perceive the quality of the service.

### Customer characteristics
The penultimate page of the survey started with two items related to the customer's relationship with their service provider. Customers were asked to indicate whether they struggle to pay their water bills when they fall due. This question used a seven-point Likert scale from "Strongly Disagree" to "Strongly Agree". 

The second question asked customers to indicate the frequency at which they contact their utility for support, also using a seven-point Likert scale: 
- Never
- Less than once a month
- Once a month
- 2--3 Times a month
- Once a week
- 2--3 Times a week
- Daily

### Service quality
Service quality is a construct that describes how customers perceive a service. Many statistically validated survey tools exist to measure service quality. The most well-known and oldest method is SERVQUAL. This is a tool that consists of over twenty items were customers provide insight into their views on a range of aspects of service quality.

The questions in this customer survey were used to develop a service quality measurement tool for tap water called SERVAQUA. This tool consists of 18 questions, which were measured using a seven-point Likert scale from "Strongly Disagree" to "Strongly Agree". The items were presented in random order. 

The survey looks at how customers view core and supplementary services. The core service of a water utility is obviously the water it supplies. The supplementary services relate to providing customers with assistance when they need to pay bills, have enquiries or have problems.

The core services of water utilities are homogeneous because the physical quality can be controlled at a high level of reliability through technology. The supplementary services are much more subject to variability due to the higher level of interaction between employees and customers. Whereas the core service is undifferentiated with no possibility of customisation, supplementary services need to meet the individual requirements of the customer. When supplementary services are required, the otherwise anonymous customer that is served at arm's length develops a direct relationship with the service provider.

The core service of water is expressed in questions about the technical quality of the water, and the supplementary services relate to the functional quality of tap water services.

### Technical Quality
The technical quality dimension was measured using five questions. The technical quality items are formulated in absolute terms to ensure that the highest score entails a perfect level of service. Based on these considerations, the following five-item instrument was used:

- Tap water is available whenever I need it.
- My tap water is always safe to drink.
- My tap water is always visually appealing.
- My tap water always has a pleasant taste.
- My tap water always has sufficient pressure.

### Functional Quality Questions
The survey includes 13 functional quality items that measure the non-physical aspects of customer service:

- My water bills are always accurate.
- The services provided by my water utility are reliable.
- My water utility always provides good customer service.
- I can always depend on the services of my water utility.
- Employees of my water utility have the knowledge to answer my questions.
- My water utility consistently provides the services they promise.
- Employees in my water utility give me prompt service.
- When I have problems, my water utility is sympathetic and understanding.
- My water utility has my best interests at heart.
- Employees of my water utility are always willing to help me.
- My water bills are easy to understand.
- Employees of my water utility are consistently polite.
- My water utility provides me with sufficient information.

This survey tool was validated using structural equation modelling. You can read about the detailed analysis of this data and the SERVQUAL model in [The Invisible Water Utility](http://hdl.handle.net/1959.9/561679) dissertation. The International Water Association has published a less-mathematical version of this research in the book _Customer Experience Management for Water Utilities_.

## Mini Hackathon
Now it is your turn to put what you have learned in practice and create a report about the remaining data in the customer survey. The `casestudy2` folder contains the `chapter_11.Rmd` file, which you can use as an example. This RMarkdown file includes some of the code discussed in chapters 8, 9 and 10. However, to the best way to learn is to start from scratch and type the code.

### Data Cleaning
Start your analysis with the raw data as we did in [chapter 8](#cleaning). Writing your code in that way ensures that it becomes reproducible. If you undertake the same survey again, then you can immediately repeat the analysis. Your report should mention some basic statistics about the raw data and some information about any responses that were removed in the method section.

### Data Exploration
The next step in your report explores the cleaned data, as we did in [chapter 9](#customers). The best way to explore data is to tell a visual story to summarise the contents of the data you are exploring.

### Data Analysis
Your analysis should contain a correlation matrix and a clustering solution of the survey items. 

Please note that hierarchical clustering is not the ideal method to analyse latent variables. It is only used here as an example. Structural equation modelling is more suitable to assess the statistical validity of survey instruments.

### Write a report
Your task is to write a small report that shows R output and some explanatory text. When you have completed your report, you can submit it to the discussion group.

The [final chapter](#close) of this course provides some closing comments and suggestions on how to further develop your skills.
