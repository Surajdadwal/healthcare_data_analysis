                 --- Healthcare Data Analytics Project ---



-- 1. Patients Table
CREATE TABLE patients (
    id VARCHAR(100) PRIMARY KEY,
    birthdate DATE,
    deathdate DATE,
    prefix VARCHAR(10),
    first VARCHAR(50),
    last VARCHAR(50),
    suffix VARCHAR(10),
    maiden VARCHAR(50),
    marital VARCHAR(5),
    race VARCHAR(50),
    ethnicity VARCHAR(50),
    gender VARCHAR(5),
    birthplace VARCHAR(100),
    address VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(50),
    county VARCHAR(50),
    zip VARCHAR(20),
    lat NUMERIC(10, 8),
    lon NUMERIC(11, 8)
);

-- 2. Organizations Table
CREATE TABLE organizations (
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    zip VARCHAR(20),
    lat NUMERIC(10, 8), -- Lat/Lon ke liye precision jaruri hai
    lon NUMERIC(11, 8)
);

-- 3. Payers Table
CREATE TABLE payers (
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(100),
    address VARCHAR(255),
    city VARCHAR(100),
    state_headquartered VARCHAR(50),
    zip VARCHAR(20),
    phone VARCHAR(30)
);

-- 4. Encounters Table (Links Patients, Organizations, and Payers)
CREATE TABLE encounters (
    id VARCHAR(100) PRIMARY KEY,
    start_time TIMESTAMP,
    stop_time TIMESTAMP,
    patient_id VARCHAR(100),
    organization_id VARCHAR(100),
    payer_id VARCHAR(100),
    encounterclass VARCHAR(50),
    code VARCHAR(50),
    description TEXT,
    base_encounter_cost NUMERIC(15,2),
    total_claim_cost NUMERIC(15,2),
    payer_coverage NUMERIC(15,2),
    reasoncode VARCHAR(50),
    reasondescription TEXT
);

-- 5. Procedures Table
CREATE TABLE procedures (
    start_time TIMESTAMP,
    stop_time TIMESTAMP,
    patient_id VARCHAR(100),
    encounter_id VARCHAR(100),
    code VARCHAR(50),
    description TEXT,
    base_cost NUMERIC(15,2),
    reasoncode VARCHAR(50),
    reasondescription TEXT
);





SELECT 'patients' AS master_table, COUNT(*) FROM patients
UNION ALL
SELECT 'organizations', COUNT(*) FROM organizations
UNION ALL
SELECT 'payers', COUNT(*) FROM payers
UNION ALL
SELECT 'encounters', COUNT(*) FROM encounters
UNION ALL
SELECT 'procedures', COUNT(*) FROM procedures;





--Checking tables data--


SELECT * FROM patients LIMIT 100;

SELECT * FROM payers;

SELECT * FROM organizations;

SELECT * FROM procedures LIMIT 100;

SELECT * FROM encounters LIMIT 100;


              -- Patient & organization Analysis --

-- 1. How many total encounters have been recorded for each organization?
	  SELECT o.name AS organization_name,
	         COUNT(e.id) AS total_encounters
	  FROM organizations o
	  JOIN encounters e
	  ON o.id=e.organization_id
	  GROUP BY 1;


-- 2. Find the average age of patients categorized by their gender?

	  SELECT gender, AVG(AGE(CURRENT_DATE,birthdate)) AS avg_age
	  FROM patients
	  GROUP BY 1;

              -- Financial Analysis --

-- 3. Which insurance payer is covering the highest total claim cost?

	  SELECT p.name AS payer_name,
	         SUM(e.total_claim_cost) AS claim_cost,
			 SUM(e.payer_coverage) AS total_pay,
			 (SUM(e.total_claim_cost)- SUM(e.payer_coverage)) AS Final_cost
	  FROM payers p
	  JOIN encounters e
	  ON p.id=e.payer_id
	  GROUP BY 1;


-- 4. As above the question, show only Payers whose total pay greater than 10,00,000?

	  SELECT p.name AS payer_name,
	         SUM(e.total_claim_cost) AS claim_cost,
			 SUM(e.payer_coverage) AS total_pay,
			 (SUM(e.total_claim_cost)- SUM(e.payer_coverage)) AS Final_cost
	  FROM payers p
	  JOIN encounters e
	  ON p.id=e.payer_id
	  GROUP BY 1
	  HAVING SUM(e.payer_coverage)>1000000;




        -- Busniess Analysis and Business related question answers--


		      --- Level 1 ---

-- 1. Find the patients who have visited the hsopital again after a gap of at least one year?

	  SELECT DISTINCT e.patient_id,
	       REGEXP_REPLACE(p.first,'[^a-zA-Z]','','g')||' '||REGEXP_REPLACE(p.last,'[^a-zA-Z]','','g') AS full_name
	  FROM encounters e 
	  JOIN encounters e1
	  ON e.patient_id=e1.patient_id
	  JOIN patients p
	  ON p.id=e1.patient_id
	  WHERE e1.start_time>=e.stop_time + INTERVAL '1 Year';
	  

-- 2. Find the most common procedures performed based on the patient's race and gender?

	  SELECT p.race,p.gender,pr.description ,COUNT(pr.description)
	  FROM patients p
	  JOIN procedures pr
	  ON p.id=pr.patient_id
	  GROUP BY 1,2,3
	  ORDER BY 4 DESC;


-- 3. Find the total number of encounters that happend each month?

	  SELECT TO_CHAR(start_time,'YYYY-MM') AS monthly,
	         COUNT(*) AS total_encounters
      FROM encounters
	  GROUP BY 1
	  ORDER BY 1 ;


-- 4. Find the patients whose total claim cost is significantly higher than the average claim cost of all patients?

	  SELECT DISTINCT patient_id
	  FROM encounters
	  WHERE total_claim_cost>(SELECT ROUND(AVG(total_claim_cost),2) FROM encounters);


-- 5. Which payer has the fastest processing time on average?

	  SELECT p.id AS payer_id,
	         p.name AS payer_name,
			 AVG(e.stop_time-e.start_time) AS avg_time
	  FROM payers p
	  JOIN encounters e
	  ON p.id=e.payer_id
	  GROUP BY 1,2
	  ORDER BY 3 ;


	          -- Level 2 --

-- 6. Identify the top 5 most frequent medical conditions(reason for visit) across all encounters?

	  SELECT description,COUNT(*) AS total_procedures
	  FROM procedures
	  GROUP BY 1
	  ORDER BY 2 DESC
	  LIMIT 5;


-- 7. List the encounters that have a total claim cost higher than the average total claim cost of all encounters,and include the organization's name for those encounters?

	  SELECT e.patient_id,o.name AS organization_name,e.total_claim_cost
	  FROM encounters e
	  JOIN organizations o
	  ON e.organization_id=o.id
	  WHERE e.total_claim_cost>(SELECT ROUND(AVG(total_claim_cost),2) FROM encounters)
	  ORDER BY 3 DESC;


-- 8. Count how many paitent are covered by each payer?
	  SELECT p.id AS payer_id,
	         p.name AS payer_name,
			 COUNT(e.patient_id) AS total_patient
	  FROM payers p
	  JOIN encounters e
	  ON p.id=e.payer_id
	  GROUP BY 1,2
	  ORDER BY 3 DESC;


-- 9. Calculate the total claim cost generated by each organization?

	  SELECT o.id,o.name,SUM(e.total_claim_cost) AS total_revenue
	  FROM organizations o
	  JOIN encounters e
	  ON o.id=e.organization_id
	  GROUP BY 1,2
	  ORDER BY 3 DESC;


-- 10. Generate "Patient Summary Report" as patient name,total encounters,total claim cost,name of the most frequent organization they visited?

--    Using Subquery

	   SELECT REGEXP_REPLACE(p.first,'[^a-zA-Z]','','g')||' '||REGEXP_REPLACE(p.last,'[^a-zA-Z]','','g') AS "Full Name",
	          COUNT(DISTINCT e.id) AS total_encounters,
			  SUM(e.total_claim_cost) AS total_claim_cost,
			  (SELECT o.name
			   FROM organizations o
			   JOIN encounters e1
			   ON o.id=e1.organization_id
			   WHERE e1.patient_id=p.id
			   GROUP BY 1
			   ORDER BY COUNT(*) DESC
			   LIMIT 1) AS favorite_organization
	   FROM patients p
	   JOIN encounters e
	   ON p.id=e.patient_id
	   GROUP BY p.id,p.first,p.last;

	   
--    Using Window Function


	   WITH patient_stats AS(
            SELECT e.patient_id,
			       e.organization_id,
				   COUNT(*) OVER(PARTITION BY e.patient_id,e.organization_id) AS org_visit_count,
				   SUM(e.total_claim_cost) OVER(PARTITION BY e.patient_id) AS total_patient_cost,
				   COUNT(e.id) OVER(PARTITION BY e.patient_id ) AS total_encounters,
				   ROW_NUMBER() OVER(PARTITION BY e.patient_id ORDER BY COUNT(*) DESC )AS rn
			FROM encounters e
			GROUP BY e.patient_id,e.organization_id,e.id,e.total_claim_cost
	   )

	   SELECT REGEXP_REPLACE(p.first,'[^a-zA-Z]','','g')||' '||REGEXP_REPLACE(p.last,'[^a-zA-Z]','','g') AS "Patient Name",
	          ps.total_encounters,
			  ps.total_patient_cost,
			  o.name AS favorite_organization
	   FROM patient_stats ps
	   JOIN patients p ON ps.patient_id=p.id
	   JOIN organizations o ON ps.organization_id=o.id
	   WHERE ps.rn=1;


	  
                       ---- End ----