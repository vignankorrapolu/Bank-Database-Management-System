create database company;
use company;

create table Employee(
emp_id int,
first_name varchar(20),
last_name varchar(20),
birth_date date,
sex varchar(1),
salary int,
super_id int,
branch_id int,
primary key(emp_id)
);

create table Branch(
branch_id int,
branch_name varchar(20),
mgr_id int,
mgr_start_date date,
primary key(branch_id),
foreign key(mgr_id) references Employee(emp_id) on delete set null
);

alter table employee
add foreign key (super_id)
references employee(emp_id)
on delete set null;

alter table employee
add foreign key (branch_id) 
references Branch(branch_id)
on delete set null;


create table Client(
client_id int,
client_name varchar(40),
branch_id int,
primary key(client_id),
foreign key(branch_id) references Branch(branch_id) on delete set null
);

create table works_with(
emp_id int,
client_id int,
total_sales int,
primary key(emp_id,client_id),
foreign key(client_id) references Client(client_id) on delete cascade,
foreign key(emp_id) references Employee(emp_id) on delete cascade
);

create table Branch_Supplier(
branch_id int,
supplier_name varchar(30),
supplier_type varchar(20),
primary key(branch_id,supplier_name),
foreign key (branch_id) references Branch(branch_id) on delete cascade
);

insert into Employee values(100,"David","Wallance",'1967-11-17',"M",250000,NULL,NULL); 

update Employee
set branch_id=1
where emp_id=100; 
 
insert into Employee values(101,"Jan","Levinson",'1961-05-11',"F",110000,100,1);
update Employee 
set branch_id=2
where emp_id=102;

insert into Employee values(102,"Michael","Scott",'1964-03-15',"M",75000,100,null);
insert into Employee values(103,"Angela","Martin",'1971-06-25',"F",63000,102,2);
insert into Employee values(104,"Kelly","Kapoor",'1980-02-05',"F",55000,102,2);
insert into Employee values(105,"Stanley","Hudson",'1958-02-19',"M",69000,102,2);
insert into Employee values(106,"Josh","Porter",'1969-09-05',"M",78000,100,3);
update employee
set branch_id=3
where emp_id=106;
insert into Employee values(107,"Andy","Bernard",'1973-07-22',"M",65000,106,3);
insert into Employee values(108,"Jim","Halpret",'1968-10-01',"M",71000,106,3);
select * from Employee;

insert into Branch values (1,"Corporate",100,"2006-02-09");
insert into Branch values (2,"Corporate",102,"1992-04-06");
insert into Branch values (3,"Corporate",106,"1998-02-13");
insert into Branch values (4,"Buffalo",null,null); 

update Branch
set branch_name="Scranton"
where branch_id=2;

update Branch
set branch_name="Stamford"
where branch_id=3;

select *from Branch;

insert into Client  Values (400,"Dunmore Highschool",2);
insert into Client  Values (401,"Lackawana Country",2);
insert into Client  Values (402,"FedEx",3);
insert into Client  Values (403,"John Daly Law,LLC",3);
insert into Client  Values (404,"Scanton Whitepages",2);
insert into Client  Values (405,"Times Newspaper",3);
insert into Client  Values (406,"FedEx",2);


insert into works_with values(105,400,55000);
insert into works_with values(102,401,267000);
insert into works_with values(108,402,22500);
insert into works_with values(107,403,5000);
insert into works_with values(108,403,12000);
insert into works_with values(105,404,33000);
insert into works_with values(107,405,26000);
insert into works_with values(102,406,15000);
insert into works_with values(105,406,130000);


insert into Branch_Supplier values(2,"Hammer Mill","Paper");
insert into Branch_Supplier values(2,"Uni-ball","Writing Utensils");
insert into Branch_Supplier values(3,"Patriot Paper","Paper");
insert into Branch_Supplier values(2,"J.T.Forms & Labels","Custom Forms");
insert into Branch_Supplier values(3,"Uni-ball","Writing Utensilsr");
insert into Branch_Supplier values(3,"Hammer Mill","Paper");
insert into Branch_Supplier values(3,"Stamford Labels","Custom Forms");



select * from Employee;
select * from Branch;
select * from Client;
select * from works_with;
select * from Branch_Supplier;

-- Find all employees ordered by salary
select * from Employee
order by salary;

-- Find all the Employee name ordered by sex then name
select * from Employee
order by sex,first_name,last_name;

-- Find the First 5 employee in table
select * from Employee
limit 5;

-- Find the First and Last name of all Employees
select first_name,last_name from Employee;

-- replace the first name with forename and last name with surname 
select first_name as forenames,last_name as surnames from Employee;

-- Find out the all different genders
select distinct sex from Employee;

-- Find the number of employees
select  count(emp_id) from Employee;

-- Find the number of female employees born after 1970
select count(emp_id) from Employee
where sex="F" and birth_date >="1970-01-01";

-- Find the average of all employees salaries
select avg(salary) from Employee;

-- Find the sum of all employee salaries
select sum(salary) from Employee;

-- Find the count of males and females in employees
select count(sex),sex from Employee
group by sex;

-- Find the total sales of each salesman
 select emp_id,sum(total_sales)
 from works_with
 group by emp_id ;
 
 -- Find any client who has LLC in name
 select * from Client
 where client_name like '%LLC';
 
 -- Find any branch suppliers who are in the label bussiness
 select * from Branch_Supplier
 where supplier_name like '%Labels'; 
 
 -- Find any employee born in  october
 select * from Employee
 where birth_date like "____-10-__";
 
 -- find any client who are in school
 select * from Client
 where client_name like "%school%";
 
 -- Find a list of all Employees and branch names
 select first_name as company_names from Employee
 union
 select branch_name from Branch;
 
 
 -- Find a list of all clients and branch_suppliers names
 select client_name as comapany_names from Client
 union 
 select supplier_name from Branch_Supplier;
 
 -- Find a list  of all Clients and branch suplier names 4
 select client_name,branch_id from Client
 union
 select supplier_name,branch_id from Branch_Supplier;
 
 
 -- Find all branches and the names of their managers
 
 select Employee.emp_id,Employee.first_name,Branch.branch_name from Employee
 join Branch
 on employee.emp_id=Branch.mgr_id;
 
 select Employee.emp_id,Employee.first_name,Branch.branch_name from Employee
 left join Branch
 on employee.emp_id=Branch.mgr_id;
 
  select Employee.emp_id,Employee.first_name,Branch.branch_name from Employee
 right join Branch
 on employee.emp_id=Branch.mgr_id;
 
 -- Find names of employees who have sold 
 -- over 30,000 to a single client
 select Employee.first_name from Employee
 where Employee.emp_id in (
	select works_with.emp_id 
	from works_with
	where works_with.total_sales > 30000
);

-- Find all Clients who  are handled by the branch
--  that Michael Scott manages
--  Assume you Know Michael ID

select Client.client_name 
from Client
where client.branch_id = (
	select Branch.branch_id from Branch
	where  Branch.mgr_id=102
);



select Branch_Supplier.supplier_name from Branch_Supplier
where Branch_Supplier.branch_id =(
	select Branch.branch_id from Branch
	where Branch.mgr_id=102
); 








