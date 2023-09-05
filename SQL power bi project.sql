# Create a data base named project
CREATE DATABASE project;

Use project;

Select *
From hr;
# Since the employee id is saved as ï»¿i, Change it to emp_id and give is 20 Characters
ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

# Confirm Datatype
DESCRIBE hr;

Select birthdate
From hr;
# Since Birthday is saved in multiple formats, organize into one format

UPDATE hr
SET birthdate = CASE
	WHEN birthdate Like "%/%" THEN date_format(str_to_date(birthdate, "%m/%d/%Y"), "%Y-%m-%d")
    WHEN birthdate Like "%-%" THEN date_format(str_to_date(birthdate, "%m-%d-%Y"), "%Y-%m-%d")
    ELSE NULL
END;
# To confirm change has been made
Select birthdate
From hr;

# Since date is saved as a text, it should be converted to a date format
ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

# To confirm
DESCRIBE hr;

# Since hire_date has the same problems with birthdate, modifications will be made
UPDATE hr
SET hire_date = CASE
	WHEN hire_date Like "%/%" THEN date_format(str_to_date(hire_date, "%m/%d/%Y"), "%Y-%m-%d")
    WHEN hire_date Like "%-%" THEN date_format(str_to_date(hire_date, "%m-%d-%Y"), "%Y-%m-%d")
    ELSE NULL
END;


ALTER TABLE hr
MODIFY COLUMN hire_date DATE;
Select hire_date
From hr;
ALTER TABLE hr
MODIFY hire_date DATE;

# Since the termdate has time attached to it, we will have to remove it
 UPDATE hr 
 SET termdate = date(str_to_date(termdate,"%Y-%m-%d %H:%i:%s UTC"))
 WHERE termdate IS NOT NULL AND termdate!= '';
#To confirm
 Select termdate
 From hr;
# Modify
ALTER TABLE hr
MODIFY termdate DATE;
ALTER TABLE hr 
CHANGE COLUMN termdate termdate DATE NULL DEFAULT NULL ; 
INSERT INTO hr (termdate) VALUES (NULL);
select termdate
from hr
# OMO, e no gree change to date ooh. Hopefully, I would transform while at power BI

#Add an age column
ALTER TABLE hr 
ADD COLUMN age INT;
Select *
From hr;
# Fill up age Column
UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());

Select age
From hr;

SELECT
min(age) AS Youngest,
max(age) AS Oldest
from hr;

#Finding out the People below adult age
Select count(*)
From hr 
where age < 18;

#Questions from Datatset

#1. What is the gender breakerdown for employees? 
 Select gender, count(*) AS COUNT
 From hr
 where age >= 18 AND termdate=""
 Group By gender;

#2. What is the race/ethnicity breakerdown for employees? 
 Select race, count(*) AS COUNT
 From hr
 where age >= 18 AND termdate=""
 Group By race
 Order by Count(*) Desc;
 
#3. What is the age distribution for employees? 
Select min(age) AS Youngest,
max(age) AS Oldest
from hr
where age >= 18 AND termdate="";

SELECT 
Case
	When age >= 18 AND age <= 24 THEN '18-24'
    When age >= 25 AND age <= 34 THEN '26-34'
    When age >= 35 AND age <= 44 THEN '35-44'
    When age >=45 AND age <= 54 THEN '45-54'
    When age >= 55 AND age <= 64 THEN '55-64'
    Else '65+'
    END AS age_group, gender,
    Count(*) AS count
From hr
where age >= 18 AND termdate=""
Group by age_group, gender
order by age_group,gender;

#4. How many employees work at headquaters vs remote locations?
Select location , count(*) as Count
from hr
where age >= 18 AND termdate=""
Group by location;
 
 #5. What is the average leghth of employment for employees who have been terminated?
 Select
 avg(datediff(termdate,hire_date)) / 365 As  avg_lenghth_employment
 From hr
 Where termdate <= curdate() and termdate <> "" and age >=18
 
 #6. How does the gender distribution vary across department and job titles?
Select department, gender, Count(*) AS Count
 from hr
 where age >= 18 and termdate = ""
 Group by department , gender
 order by department;
 
 # 7 What is the distribution of job title across the company?
 Select jobtitle, Count(*) AS Count
 from hr
 where age >= 18 and termdate = ""
 Group by jobtitle
 order by jobtitle desc;
 
#8. Department with the highest turnover rate?
Select department,
total_count,
terminated_count,
terminated_count/total_count AS termination_rate
From(
Select department,
count(*) as total_count,
SUM(case when termdate<>"" and termdate<=curdate()THEN 1 Else 0 END )
from hr 
where age >=18
Group by department 
) As subquery
Order by termination_rate desc;

# 9. What is the distribution of employee across location by city and state?
select location_state, count(*) as count
from hr
where age >= 18 AND termdate=""
Group by location_state
order by count desc;


















