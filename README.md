<!--🔥 🐦 -->
<h1>
💎 notiflyer 
</h1> 
an inspiring new way of sending KPIs, alerts, or simple tabular data as emails powered by chart.js by converting raw data into meaningful visual graphs and charts.

notiflyer is an attempt to prove that ETL operations can be left out from the presentation layer and focusing on the KPIs derived from said analytical operations by capturing and storing end values in simple sql objects (_tables/views,etc._) in a statistical X/Y axis format.

![last commit](https://img.shields.io/github/last-commit/cleancoda/notiflyer)
![closed pull requests](https://img.shields.io/github/issues-pr-closed-raw/cleancoda/notiflyer)
![closed issues](https://img.shields.io/github/issues-closed-raw/cleancoda/notiflyer)
![contributors](https://img.shields.io/github/contributors/cleancoda/notiflyer)
![stars](https://img.shields.io/github/stars/cleancoda/notiflyer)
![license](https://img.shields.io/github/license/cleancoda/notiflyer)

<!--
![GitHub All Releases](https://img.shields.io/github/downloads/cleancoda/notiflyer/total.svg)
![GitHub release](https://img.shields.io/github/release/cleancoda/notiflyer.svg)
![GitHub commits since latest release (by date)](https://img.shields.io/github/commits-since/cleancoda/notiflyer/latest)
-->


# 🔥 features

- automates overhead tasks for sql such as:
  - sql agent jobs, maintenance
  - error/run logging
  - db mail setup & configuration, etc.
- data remains at core focus - leave the visualization logic to the application
- extensive configuration settings 📚

# 📑 about

the principle of this project is simple - focus on data over logic.

<!-- separate logic from data by breaking away from traditional, normalized and resource-intensive ways of running OLTP analytical queries for generating simple KPI metrics that end up causing massive loads on i/o, memory, etc. as it traverses through hundreds, if not thousands of entries/tables on a production database.

instead, abstract the layer of logic/ETL and introduce a new one that comprises of **_only_** the end-goal metric data stored in simple sql objects such as temporary/permanent tables or views (_support for functions/stored procedures is in progress_)

eventually leading to maintaining focus on developing sleek and light weight presentation layer focused queries, to generate clean visual representation of the dataset itself, that can be sliced and diced several ways, depending on the recepients' choice. -->

the notiflyer project is determined in keeping the need for technical know-how to a bare minimum when it comes to setup, configuring and maintaining of the application/service; as most end-users will be focused on handling the business/analytics side, generating the logic, writing and conjuring KPI formulas; and not be so much interested in the code that generates the visuals itself.

a common trend, that is seen ever so more in use recently, is to utilize as many micro-services as possible to break down a complex business process or function into smaller, more manageable units, and each one having their own responsible stakeholder.

with such an approach, the amount of data being generated and stored within an organization has increased exponentially. each micro-service brings along it's own set of rules and data to the keep track of it's own place/history in the overall business workflow/function/process, that it is part of.

while that might sound redundant and unnecessary, it provideds an opportunity to tap into these databases and generate your own metrics based on the data the micro-services may have generated so far, that could give you a better picture of how the workflow is performing.

<!-- most common use of such data would be to generate metrics that provide a better insight on the micro-service's performance, that can then in turn be e-mailed to designated recepients on a regular basis. these metrics, also known as key-performance-indicators (KPIs) can help navigate through making critical decisions related to the workflow. -->

if this metric deriving data is properly extracted, transformed and loaded, a variety of visual graphs/charts can be generated, giving you game changing insights that you otherwise would not have noticed or even cared for. 

most entities have started realizing the potential of historical data that has accumulated on their servers over years of usage, but do not know where to start slicing or dicing them. 

<!-- statistics? analytics? run it through python using pandas and generate charts? that is where things start getting complex when instead, low-level data (a log from SalesForce database showing # of new opportunities created per day for example) can be kept simple and easy to read. -->

generating complex dashboards using tools like Microsoft Power BI, Tableau or even running mathematical/statistical functions in Pandas using Python for example, would be overkill and in most cases, a waste of time, as it may or may not relate directly to your core/truth source of data in your enterprise.

however, consider given the ability to independently tap into said service database(s), and have the tools to quickly and easily generate visuals, graphs and charts that somehow describe a part of your entity's workflow as a snapshot, when if chained together with other such similar datasets, it could potentially describe the entire working of an entity as a snapshot, and could even be automatically sent to you in an email.

**this is where notiflyer shines.**

# 🖼️ design principles & architecture

notiflyer helps you convert your transformed (_etl completed prior_) data into a more "visual" representation using graphs/charts, adding colors, cleaning up data-types, generating legend-boxes, etc. to represent the plot points/values, describing a quick story of whatever metric you're looking at. all of this can be achieved by notiflyer, while you get to focus on writing efficient queries. 

consider the following structured query language script (example aims to be db-vendor agnostic), a simple query that fetches the count of orders, summarized by the order date. 

```sql
select
    year(DueDate) as as [year]
    ,count(ProductID) as [totalorders]
from
    AdventureWorks.Production.WorkOrder
where
    year(DueDate) > 2019
    and  year(DueDate) < 2023
group by
    year(DueDate)
order by
    [year];
```

the query can be passed to notiflyer "as-is" and it can generate a quick and easy visual chart such as:
<img src ="docs/assets/images/chart.webp">

the above example shows a bar chart representation of the number of orders a company received by date - a much cleaner way to describe a "story" about your data, while recognizing critical "trends" in your day-to-day operations. 

<!-- 
usually, critical metric (KPI) that you're really after, abstracting all the unnecessary details, rather than spending precious time reading and analyzing granular/tabular data, that not only requires a lot more time to break down, but also needs manual intervention every time. 

compare that to what notiflyer automatically sends to your email, and all you need is a quick glance to get all your valuable metrics in one go. 

however, if you've had the opportunity to work with automating reports, report-delivery, etc.; you will quickly ask, "what sets notiflyer apart from other reporting services?". many database vendors, including microsoft sql server, provide the ability to setup upa report subscription in SQL Reporting Services (SSRS) for example.  -->

after dealing with several kinds (vendor) of databases, enterprise resource planning softwares, and innumerable software-as-a-service programs over the years, one can appreciate the need for simplicity and having the ease of "knowledge-transfer", especially when it comes to adding yet another piece of software/technology to your existing business workflow task/stack.

notiflyer aims to have a number of features, but the one that matters most is **_Ease of Use_**. 

imagine the limitless & potential applications of such a service; from a complex business workflow to a simple reminder, it can do it all.. the best part is, you get to drive and be in control of your own data.

# 🏗️ setup

- TODO - add setup guide

# 👩‍🏫 documentation

- TODO - add (temporary) documentation
- TODO - convert documentation to wiki

_----_

- database vendors
  - [microsoft sql server](https://github.com/cleancoda/notiflyer/tree/development/documentation/mssql)

# 🗺️ roadmap

- TODO - add roadmap/planned-features/release-cycles

# 🙋 contribute

- TODO - add contribution guide

# 🪸 log

- 10092023_cleancoda - added basic structure to readme.md
- 10142023_cleancoda - reorganized readme.md structure
