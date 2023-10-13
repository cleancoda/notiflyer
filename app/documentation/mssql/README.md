# sql server documentation <a name="top"></a>

## navigation
- [overview](#overview)
    - [entity-relationship (er) diagram](#erdiagram)  
- [prerequisites](#prerequisites)
    - cpu/memory/storage
    - mssql version
    - containerization
- [installation guide](#installation-guide)
    - quick start guide
    - complete installation guide
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

    notiflyer_tbAppConfig {
        id int pk "identity(1,1)"
        name varchar(max) "configuration name"
		value varchar(max) "configuration value"
    }

    notiflyer_tbAppEmailConfig {
        id integer pk "identity(1,1)"
		name varchar(max) "configuration name"
		value varchar(max) "configuration value"
    }

    notiflyer_tbJobManager ||--o{ notiflyer_tbJobQueryGrid : "many queries can be assigned to a single job"
    notiflyer_tbQuery ||--o{ notiflyer_tbJobQueryGrid : defined-in
```
[scroll top](#top)
## prerequisites
[scroll top](#top)
## installation guide
[scroll top](#top)
