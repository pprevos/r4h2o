# 16. In Closing {#close}

You have reached the end of the /Data Science for Water Professionals/ course. I hope you find it interesting and useful to see how writing code enables you to analyse data in a way that is useful, sound and aesthetic.


As stated in the introduction, the purpose of this course is to introduce you to the possibilities of the R language. My aim is to motivate you to want to learn more about writing data science code to manage this precious resource.

The best path towards the digital water utility is to educate established professionals in the possibilities of data science. You might not do this as your day job, but it will certainly help you communicate with coding experts if you need a problem to be solved.

This course barely touches the surface of what can be achieved with writing code. The open source nature of the R language means that there is a strong community of people willing to help you increase your skills. This section closes with some suggestions on how to expand your skills in R coding.

This last chapter provides some suggestions on how to hone your skills

## Searching for answers
The chapter about the [basics](#basics) of the R language explains how to read the built-in help file. If the help entry is not very helpful, then you can find  answer to your problem using your favourite search engine. You will quickly realise that there will be very few problems that have not already been experienced and solved by somebody else. The R language is an open source project and many analysts share their code on websites and forums.

## Forums
Your search engine will most likely divert you to one of the many online forums where developers help each other. Websites such as [stackoverflow](https://stackoverflow.com/questions/tagged/r) and [Reddit](https://www.reddit.com/r/rstats/) have active communities where you can ask coding questions. On [Twitter](https://twitter.com/search?q=%23rstats), use the #RStats hashtag connect fellow data scientists.

Before you post anything on these websites, check to see whether your question has not already be answered, perhaps in a slightly different form.

The best way to ensure you receive a useful answer is to be as specific as possible. Add an example of your code and include some data. This is called a Minimum Working Example (MWE).  An MWE enables the other members of the community to replicate your problem and increases the chances that you receive and answer.

For example, you like to know how to convert a wide data frame to a long version, as we saw in [chapter 9]{#manipulation}. In this case, you could provide a specific example that shows the before and after situation:

{format: r, line-numbers: false}
```
df_wide <- tibble(A = c(1, 2),
             B = c(12, 34),
             C = c(43, 76),
             D = c(5, 12))

df_long <- tibble(A = c(1, 2, 1, 2, 1, 2),
             var = c("B", "B", "C", "C", "D", "D"),
			 val = c(12, 34, 43, 76, 5, 12)
```

Most forums have internal rules, make sure you familiarise yourself with these rules to increase the likelihood that you receive a useful answer. 

## Further Study
If you like to develop your skills further, then I highly recommend to systematically study the R language through some of the many available courses.

A great place to systematically learn about R is [DataCamp](https://www.datacamp.com/). This website provides free introduction courses and paid advanced courses. DataCamp also provides courses about other languages, such as Python, SQL and even spreadsheets. 

For a thorough in-depth course on data science with the R language, I recommend the [Data Science Specialisation](https://www.coursera.org/specializations/jhu-data-science) by John Hopkins University on the Coursera platform.

If you like to know more about the Tidyverse, then please read the [R for Data Science](https://r4ds.had.co.nz/). This book is freely available on the web, or you can purchase a paper copy from an a retailer.

## Thanks
Thanks for making it to the end of this course. The LeanPub system is very flexible and this course is regularly updated with clarifications and possibly future further chapter.

I would appreciate any feedback on how to improve this course. You can contact me through my Twitter handle @LucidManager or through my [website](https://lucidmanager.org/).



