# sql server documentation <a name="top"></a>

## navigation

- [overview](#overview)
  - [entity-relationship (er) diagram](#entity-relationship-er-diagram)
  - [custom database objects]
- [prerequisites](#prerequisites)
  - cpu/memory/storage
  - mssql version
  - containerization
- [installation guide](#installation-guide)
  - [quick start guide](#quick-start-guide)
  - [complete installation guide](#complete-installation-guide)
    - chartjs microservice container
    - application first-run configuration

## overview

todo:
this section will describe the inner workings and setup instructions

[scroll top](#top)

## entity-relationship (er) diagram

```mermaid
erDiagram


    notiflyer_tbJobManager {
        id int pk "identity(1,1)"
        name varchar(max) "job description"
        email_subject varchar(max)
        email_recepient varchar(max) "email recepients, separated by semi-colon"
        email_cc varchar(max) "email cc, separated by semi-colon"
        email_bcc varchar(max) "email bcc, separated by semi-colon"
		email_body_header varchar(max) "email body header (message), prior to grid components below"
        frequency char(1) "(d)aily, (w)eekly, (m)onthly"
		run_time varchar(5) "job run time hh:mm - follows 24 hours pattern"
		monday char(1) "enable job on day / frequency = (w)eekly"
		tuesday char(1) "enable job on day / frequency = (w)eekly"
		wednesday char(1) "enable job on day / frequency = (w)eekly"
		thursday char(1) "enable job on day / frequency = (w)eekly"
		friday char(1) "enable job on day / frequency = (w)eekly"
		saturday char(1) "enable job on day / frequency = (w)eekly"
		sunday char(1) "enable job on day / frequency = (w)eekly"
    }

    notiflyer_tbQuery {
        id int pk "identity(1,1)"
        name varchar(255) "query name"
		type char(1) "(q)uery, (f)unction, (s)tored procedure"
		query_select varchar(max) "SELECT statement portion of query"
		query_from_where varchar(max) "from/where statement potion of query"
		column_legend varchar(max) "column from select statement set as legend for dataset"
		column_x varchar(max) "x axis for dataset"
		column_y varchar(max) "y axis for dataset"
		graphtype varchar(max) "graph type (b)ar, (l)ine, (p)ie"
    }

    notiflyer_tbJobQueryGrid {
		id int pk "identity(1,1)"
		name varchar(255) "grid cell name"
		job_id int fk "foreign key reference - job id"
		query_id int fk "foreign key reference - query id"
		pos_id int "email body grid cell location 2x2x..n 1=1x1, 2=1x2, 3=2x1, 4=2x2, 5=3x1, 6=3x2"
    }

    notiflyer_tbJobQueryGridParameters {
        id int pk "identity(1,1)"
		job_query_grid_id int fk "foreign key reference - job query grid id"
		name varchar(255) "grid query parameter name"
		value varchar(255) "grid query parameter value"
    }

    notiflyer_tbAppConfig {
        id int pk "identity(1,1)"
        name varchar(max) "configuration name"
		value varchar(max) "configuration value"
    }

    notiflyer_tbAppLog {
        id bigint pk "identity(1,1)"
		job_id int fk "foreign key reference - job id"
        job_status boolean "job run outcome - true or false"
		log_datetime smalldatetime "defaults to current time"
		log_description varchar(max) "describes the event log"
    }

    notiflyer_tbJobManager ||--o{ notiflyer_tbJobQueryGrid : "several queries can be assigned to a single job in a grid format"
    notiflyer_tbJobQueryGrid ||--o{ notiflyer_tbJobQueryGridParameters : "each grid query can have own set of parameters"
    notiflyer_tbQuery ||--o{ notiflyer_tbJobQueryGrid : "query definition"

    notiflyer_tbAppLog ||--o{ notiflyer_tbJobManager : "logs job execution data"
```

[scroll top](#top)

## custom database objects

notiflyer relies on a set of custom sql objects that help facilitate the workflow in storing and configuring application specific settings, and setting up workflow jobs. this documentation strives to keep every custom object that notiflyer uses, documented for future upgrades/testing/debugging/maintenance.

the objective of defining these custom objects is to reaffirm it's need, definition and location/time of its utilization as part of the application

### tables

1. **notiflyer_tbAppConfig**

   - **_purpose/mission_**

   notiflyer (_currently_) relies on using email functionality provided by built-in system functionality specific to database vendors.

   **notiflyer_tbAppConfig** is considered as the "entry-point" for notiflyer to store several application-level configuration parameters, that would be either prepopulated by [install.sql](/src/mssql/99_install_app/install.sql) or asked to be manually enterered on the maiden run of the application based on the end-user's environment

   microsoft sql server serves emails via [database mail stored procedures](https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/database-mail-stored-procedures-transact-sql?view=sql-server-ver16), however, requires some preconfigured values to be passed along with the recipient/body of the email to ensure it can propagate correctly

   - **_maiden-run variables_** <a name="maiden-run-variables"></a>

   when the application is installed/run for the first time (maiden-run), either by running the [install.sql](/src/mssql/99_install_app/install.sql) script or using the [notiflyer_app](https://github.com/cleancoda/notiflyer_app) (_currently in development_) gui application, it will prompt the end-user to enter values for the following **required** configuration parameters

   | config-name          | description                        |
   | -------------------- | ---------------------------------- |
   | `sqlserver.name`     | name of the target mssql server    |
   | `sqlserver.username` | user-name with db_owner privileges |
   | `sqlserver.password` | password for above account         |
   | `sqlserver.database` | name of target database            |

2. **notiflyer_tbAppLog**

   - **_purpose/mission_**

   logging is a key part of the workflow to have a trail of breadcrumbs to follow back to the origin of the scenario. **notiflyer_tbAppLog** will capture each job run and mark down whether the run was successful and any additional notes/descriptions if necessary.

4. **notiflyer_tbQuery**

   - **_purpose/mission_**

   job query definitions for notiflyer will be stored in **notiflyer_tbQuery**

### views

### triggers

### functions

### stored procedures

### sql jobs

[scroll top](#top)

## prerequisites

[scroll top](#top)

## installation guide

notiflyer has a few moving parts that need to be setup and configured prior to going live for production use.

this documentation has been split into two sections:

- [quick start guide](#quick-start-guide)
- [complete installation guide](#complete-installation-guide)

[scroll top](#top)

### quick start guide

---

### complete installation guide

---

#### chartjs microservice container

notiflyer relies on an HTML5 javascript library [chartjs](https://github.com/chartjs/Chart.js), that accepts json payload parameters and returns an url to a dynamically generated image based off the parameters it receives.

the quickest way to deploy a runnable container in Docker would be to utilize another wrapper library called [quickchart](https://github.com/typpo/quickchart) that generates a web api for generating static charts

#### application first-run configuration

[scroll top](#top)
