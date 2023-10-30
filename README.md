<!--🔥 🐦 -->
<h1>
🔥 notiflyer 🐦
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

# 📑 about

the principle of this project is simple - focus on the data over logic.

separate logic from data by breaking away from traditional, normalized and resource-intensive ways of running OLTP analytical queries for generating simple KPI metrics that end up causing massive loads on i/o, memory, etc. as it traverses through hundreds, if not thousands of entries/tables on a production database.

instead, abstract the layer of logic/ETL and introduce a new one that comprises of **_only_** the end-goal metric data stored in simple sql objects such as temporary/permanent tables or views (_support for functions/stored procedures is in progress_)

eventually leading to maintaining focus on developing sleek and light weight presentation layer focused queries, to generate clean visual representation of the dataset itself, that can be sliced and diced several ways, depending on the recepients' choice.

# 💎 features

- automates overhead tasks for sql such as:
  - sql agent jobs, maintenance
  - error/run logging
  - db mail setup & configuration, etc.
- data remains at core focus - leave the visualization logic to the application
- extensive configuration settings 📚

# 🖼️ design principles & architecture

this project is determined in keeping the need for technical know-how to a bare minimum when it comes to setup, configuring and maintaining; as most of the end-users for this application, would be focused on handling the business/analytics side and not so much the code.

a common trend in business recently, has been to utilize as many micro-services as possible to break down a complex business process or function into smaller, more manageable units, and each one having their own responisble stakeholder.

with such an approach, the amount of data being generated and stored within an organization has increased exponentially. each micro-service brings along it's own set of rules and data to the keep track of it's own place/history in the overall business workflow/function/process, that it is part of.

while that might sound redundant and unnecessary, it provideds an opportunity to tap into these databases and generate your own metrics based on the data the micr-services may have generated so far, that could give you a better picture of how the workflow is performing.

most common use of such data would be to generate metrics that provide a better insight on the micro-service's performance, that can then in turn be e-mailed to designated recepients on a regular basis. these metrics, also known as key-performance-indicators (KPIs) can help navigate through making critical decisions related to the workflow.

if this metric deriving data is properly extracted, transformed and loaded, a variety of visual graphs/charts can be generated, giving you game changing insights that you otherwise would not have realized. most entities have started realizing the potential of historical data that has accumulated on their servers, but do not know how to utilize them. statistics? analytics? run it through python using pandas and generate charts? that is where things start getting complex when instead, low-level data (a log from SalesForce database showing # of new opportunities created per day for example) can be kept simple and easy to read.

generating complex dashboards using tools like Microsoft Power BI or Tableau would be overkill and a waste of time for simple quick and easy charts that quickly describe a part of your entity's workflow as a snapshot, when if chained together with other such similar datasets, it could potentially describe the entire working of an entity as a snapshot in an email.

**this is where notiflyer shines.**

notiflyer helps you convert your clean and simple data into a more "visual" representation using graphs/charts, adding colors, cleaning up data-types, generating legend-boxes, etc. to represent the plot points/values, describing a quick story of whatever metric you're looking at. all of this can be achieved by notiflyer, while you get to focus on writing efficient queries. 

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

the simple example above shows a bar chart represenation of the number of orders a company received by date; a much cleaner way to describe a "story" about your data, while recognizing critical "trends" in your day-to-day operations, as opposed to reading granular/tabular data, that also requires a lot more time to break down, as compared to needing just a quick glance at what notiflyer generates for you instead.

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
