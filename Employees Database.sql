DROP TABLE timecard_entries;
DROP TABLE timecards;
DROP TABLE projects;
DROP TABLE managers;
DROP TABLE employees;
DROP TABLE zipcodes;

CREATE TABLE zipcodes(
    zipcode CHAR(5),
    city    VARCHAR(20),
    state   CHAR(2),

    CONSTRAINT zipcode_PK PRIMARY KEY (zipcode)
);

CREATE TABLE employees(
    id          INT NOT NULL GENERATED ALWAYS AS IDENTITY,
    phone       VARCHAR(10) NOT NULL,
    first_name  VARCHAR(10) NOT NULL,
    last_name   VARCHAR(10) NOT NULL,
    street      VARCHAR(30) NOT NULL,
    zipcode     CHAR(5) NOT NULL,
    age         INT NOT NULL,
    salary      FLOAT NOT NULL,

    CONSTRAINT employees_PK PRIMARY KEY (id),
    CONSTRAINT employees_CK1 UNIQUE (phone, first_name, last_name),
    CONSTRAINT employees_CK2 UNIQUE (first_name, last_name, street, zipcode),
    CONSTRAINT employees_FK FOREIGN KEY (zipcode) REFERENCES zipcodes(zipcode)
);

CREATE TABLE managers(
    employeeID INT NOT NULL,
    managerID  INT NOT NULL,

    CONSTRAINT managers_PK PRIMARY KEY (employeeID, managerID),
    CONSTRAINT managers_FK1 FOREIGN KEY (employeeID) REFERENCES employees(id),
    CONSTRAINT managers_FK2 FOREIGN KEY (employeeID) REFERENCES employees(id)
);

CREATE TABLE timecards(
    serial_number   INT NOT NULL GENERATED ALWAYS AS IDENTITY,
    "year"          INT NOT NULL,
    week            INT NOT NULL,
    employee        INT NOT NULL,
    date_submitted  DATE NOT NULL,

    CONSTRAINT timecards_PK PRIMARY KEY (serial_number),
    CONSTRAINT timescards_CK UNIQUE ("year", week, employee),
    CONSTRAINT timecards_FK FOREIGN KEY (employee) REFERENCES employees(id)
);

CREATE TABLE projects(
    code        INT NOT NULL GENERATED ALWAYS AS IDENTITY,
    name        VARCHAR(20),
    budget      FLOAT NOT NULL,
    start_date  DATE NOT NULL,
    director    INT,

    CONSTRAINT projects_PK PRIMARY KEY (code),
    CONSTRAINT project_CK UNIQUE (name),
    CONSTRAINT project_FK FOREIGN KEY (director) REFERENCES employees(id)
);

CREATE TABLE timecard_entries(
    timecard    INT NOT NULL,
    project     INT NOT NULL,
    hours_spent DOUBLE NOT NULL,

    CONSTRAINT timecard_entries_PK PRIMARY KEY (timecard, project),
    CONSTRAINT timecard_entries_FK1 FOREIGN KEY (timecard) REFERENCES timecards(serial_number),
    CONSTRAINT timecard_entries_FK2 FOREIGN KEY (project) REFERENCES projects(code)
);

INSERT INTO zipcodes (zipcode, city, state)
VALUES ('91504', 'Burbank', 'CA'),
       ('90803', 'Long Beach', 'CA'),
       ('90808', 'Long Beach', 'CA'),
       ('91605', 'North Hollywood', 'CA'),
       ('90805', 'Long Beach', 'CA');

INSERT INTO employees (phone, first_name, last_name, street, zipcode, age, salary)
VALUES ('1234567890', 'Diane','Murphy','123 north xyz', '91504', 23, 45000),
       ('3456789012', 'Steve','Patterson', '423 north heck RD', '90803', 54, 80000),
       ('0987654321', 'Pamela', 'Castillo', '666 hell street', '91605', 19, 27000),
       ('8181818181', 'Jean', 'Dieb', '434 DMV', '90805', 22, 175000),
       ('5412456235', 'John', 'Quach', '546 not sure where', '91605', 21, 140000),
       ('1423163356', 'Newton', 'Bao', '436 near John', '90803', 23, 140000);

INSERT INTO managers(employeeID, managerID)
VALUES (1,4),
       (2,5),
       (3,6);

INSERT INTO timecards("year", week, employee, date_submitted)
VALUES (2019, 8, 4, '2019-3-3'),
       (2017, 22, 1, '2017-6-12'),
       (2019, 10, 5, '2019-3-22');
INSERT INTO timecards("year", week, employee, date_submitted)
VALUES (2021, 45, 2, '2021-11-20');
INSERT INTO timecards("year", week, employee, date_submitted)
VALUES (2021, 47, 1, '2021-11-25');
INSERT INTO timecards("year", week, employee, date_submitted)
VALUES (2021, 32, 6, '2021-6-27');

INSERT INTO projects (name, budget, start_date, director)
VALUES ('project 1', 700000, '2021-3-10', 6),
       ('project 2', 1000000, '2022-12-12', 3),
       ('Project3', 200000, '2020-1-1', 2);

UPDATE projects
SET start_date = '2021-1-1'
WHERE name = 'Project3';

INSERT INTO timecard_entries (timecard, project, hours_spent)
VALUES (1, 1, 53),
       (3,2, 67);
INSERT INTO timecard_entries (timecard, project, hours_spent)
VALUES(4, 3, 112);
INSERT INTO timecard_entries (timecard, project, hours_spent)
VALUES(5, 3, 24);
INSERT INTO timecard_entries (timecard, project, hours_spent)
VALUES(6, 1, 56);

--1
SELECT m.first_name, m.last_name, m.age, date_submitted
FROM employees m INNER JOIN timecards ON id = employee
                             INNER JOIN employees e ON m.id = e.id
WHERE m.salary >= 75000 AND timecards."year" = 2019 AND timecards.week >= 5 AND timecards.week <= 11 AND e.age > 20;

--2
SELECT first_name, last_name, serial_number, date_submitted, name, hours_spent
FROM employees INNER JOIN timecards ON id = employee
	            INNER JOIN timecard_entries ON serial_number = timecard
	            INNER JOIN projects ON project = code
WHERE timecard_entries.hours_spent >= 50;


--3
SELECT e.first_name, e.last_name, e.salary, m.managerID--,COALESCE(em.first_name, '') ,COALESCE( em.last_name, '')--retrieve manager if any. not sure how to do it
FROM employees e INNER JOIN zipcodes ON e.zipcode = zipcodes.zipcode
                 LEFT OUTER JOIN managers m on e.id = m.employeeID
                --LEFT OUTER JOIN employees  em ON m.managerID = em.id
WHERE zipcodes.city = 'Long Beach' AND state = 'CA'
UNION
SELECT e.first_name, e.last_name, e.salary --retrieve manager if any. not sure how to do it
FROM managers m INNER JOIN employees e ON m.managerID = e.id
                 LEFT OUTER JOIN zipcodes ON zipcodes.zipcode = e.zipcode
WHERE zipcodes.city = 'Long Beach' AND state = 'CA'
;


--4
--In SQL and RA, retrieve the name and salary of employees who serve as manager to some
-- employees and also direct projects. Include in the result the name and budget of
-- projects directed by the employee.
SELECT e.first_name, e.last_name, e.salary, p.name, p.budget
FROM managers m INNER JOIN employees e ON m.managerID = e.id
                INNER JOIN projects p ON p.director = e.id;

--5
--In SQL and RA, retrieve the name, budget, and director of every project started in the current year (this needs to
-- work when executed in any year). Include in the result, the timecards and hours spent as submitted by the director.

SELECT p.name, p.budget, p.director, te.timecard, te.hours_spent
FROM projects p INNER JOIN employees e on p.director = e.id
                INNER JOIN timecards t on e.id = t.employee
                INNER JOIN timecard_entries te ON t.serial_number = te.timecard
WHERE YEAR(p.start_date) = YEAR(CURRENT DATE);

--6
-- The company wants to introduce a policy whereby an employee's salary should not be more than 5% the salary of
-- their manager nor of directors of projects that they have submitted timecards for. Write a RA expression and
-- a SQL statement to determine whether or not data in a database satisfies this policy. This problem requires
-- that you explain how the result of the RA expression and SQL statement can be used to answer this question.
-- It should be clear from the result whether the policy is satisfied or not; that is, someone shouldn't have to
-- go through the result one row at a time to find the answer.

--Managers and Directors
SELECT e.first_name, e.last_name
    FROM managers m INNER JOIN employees e ON e.id = m.managerID
UNION
SELECT e.first_name, e.last_name
    FROM projects p INNER JOIN employees e ON e.id = p.director
;
--Employees working under a project
SELECT e.first_name, e.last_name
    FROM employees e INNER JOIN timecards t on e.id = t.employee
                     INNER JOIN timecard_entries te on t.serial_number = te.timecard

UNION

--Employees with managers
SELECT e.first_name, e.last_name
    FROM managers m INNER JOIN employees e ON e.id = m.employeeID
;



