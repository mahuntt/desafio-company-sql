create schema if not exists company;
use company;

create table employee(
	fname varchar(15) not null,
	Minit char(3),
	Lname varchar(15) not null,
	Ssn char(9) not null,
	Bdate date,
	Address varchar(200),
	Sex char(3),
	Salary decimal(10,2),
	Super_ssn char(9),
	Dno int not null,
	primary key(Ssn)
);

insert into employee (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno)
	values
		("Carlos", "S", "Segal", 123456789, "1956-02-17", "Rua do Limoeiro 20, Centro - Jardim das Flores", "M", "45000", "123456788", "1"),
        ("Bruno", "S", "Segal", 123498789, "1966-02-27", "Rua do Limoeiro 270, Centro - Jardim das Flores", "M", "35000", "321456788", "2"),
        ("Rubia", "S", "Dantas", 176556789, "1986-05-12", "Rua da Asturia 20, Centro - Jardim das Orquideas", "F", "22000", "332146788", "3");
        
create table departament(
	Dname varchar(20) not null,
	Dnumber int not null,
	Mgr_ssn char(9),
	Mgr_start_date date,
	primary key (Dnumber),
	unique (Dname),
	foreign key (Mgr_ssn) references employee(Ssn)
);

insert into departament (Dname, Dnumber, Mgr_ssn, Mgr_start_date)
	values
    ("Headquarters", 1, 176556789, "2002-04-02"),
    ("Administration", 4, 123498789, "1995-01-01"),
    ("Research", 5, 123456789, "1988-05-22");
    
create table dept_locations(
	Dnumber int not null auto_increment,
	Dlocation varchar(15),
	primary key (Dnumber, Dlocation),
	foreign key (Dnumber) references departament(Dnumber)
);

insert into dept_locations (Dnumber, Dlocation)
	values
	("1", "Houston"),
    ("4", "Stafford"),
    ("5", "Bellaire"),
    ("5", "Sugarland");
   
create table project(
	Pname varchar(20) not null,
	Pnumber int not null,
	Plocation varchar(20),
	Dnumber int not null,
	primary key (Pnumber),
	unique (Pname),
	foreign key (Dnumber) references departament(Dnumber)
);

insert into project (Pname, Pnumber, Plocation, Dnumber)
	values
	("ProductX", "1", "Bellaire", "5"),
    ("ProductY", "2", "Sugarland", "5"),
    ("ProductZ", "3", "Houston", "4"),
    ("ProductK", "4", "Houston", "1");

create table works_on(
	Essn char(9) not null,
	Pno int not null,
	Hours decimal(3,1) not null,
	primary key (Essn, Pno),
	foreign key (Essn) references employee(Ssn),
	foreign key (Pno) references project(Pnumber)
);

insert into works_on (Essn, Pno, Hours)
	values
    (123456789, 1, 17.3),
    (123456789, 2, 7.35),
    (123498789, 1, 20.0),
    (123498789, 2, 45.0);

create table dependent(
	Essn char(9) not null,
	Dependent_name varchar(20) not null,
	Sex char,
	Bdate date,
	Relationship varchar(9),
	primary key (Essn, Dependent_name),
	foreign key (Essn) references employee(Ssn)
);

insert into dependent (Essn, Dependent_name, Sex, Bdate, Relationship)
	values
    (123456789, "Marcus", "M", "1999-02-01", "Son"),
    (123456789, "Alice", "F", "1989-07-01", "Daughter"),
    (123498789, "Theodore", "M", "1986-10-25", "Son");

select distinct d.DName, concat(e.Fname, " ", e.Lname) as Manager, Address
	from departament as d, employee as e, works_on as w, project p
	where (d.Dnumber = e.Dno and e.Ssn=d.Mgr_ssn and w.Pno = p.Pnumber)
	order by d.Dname, e.Fname, e.Lname;

select distinct d.DName, concat(e.Fname, " ", e.Lname) as Employee, p.Pname as Project_Name
	from departament as d, employee e, works_on w, project p
	where (d.Dnumber = e.Dno and e.Ssn = w.Essn and w.Pno = p.Pnumber);

select count(*) from employee, departament
	where Dno=Dnumber and Dname = "Headquarters";

select Dno, count(*), round(avg(Salary),2) from employee
	group by Dno;

select Dno, count(*) as Number_of_employees, round(avg(Salary),2) as Salary_avg from employee
	group by Dno;

select Pnumber, Pname, count(*)
	from project, works_on
	where Pnumber = Pno
	group by Pnumber, Pname;

select count(distinct Salary) from employee;
select sum(distinct Salary) as total_sal, max(Salary) as max_sal, min(Salary) as mini_sal, avg(Salary) as avg_sal from employee;

select sum(Salary), max(Salary), min(Salary), avg(Salary)
	from (employee join departament on Dno = Dnumber)
	where Dname = "Headquarters";

select Pnumber, Pname, count(*) as Number_of_register, round(avg(Salary),2) as AVG_Salary
	from project, works_on, employee
	where Pnumber = Pno and Ssn = Essn
	group by Pnumber, Pname
    having count(*) > 1;

update employee set Salary =
	case
		when Dno = 5 then Salary+ 2000
		when Dno = 4 then Salary+ 1500
		when Dno = 1 then Salary+ 3000
		else Salary + 0
end;

select * from employee join works_on on Ssn = Essn;

select Fname, Lname, Address
	from(employee join departament on Dno=Dnumber)
	where Dname = "Headquarters";
    
select concat(Fname, " ", Lname) as Name, Dno as Department_num, Pname as Project_Name, Pno as Project_Number, Plocation as Location from employee
	inner join works_on on Ssn=Essn
	inner join project on Pno=Pnumber
	order by Pnumber;

select concat(Fname, " ", Lname) as Name, Dno as Department_num, Pname as Project_Name, Pno as Project_Number, Plocation as Location from employee
	inner join works_on on Ssn=Essn
	inner join project on Pno=Pnumber
    where Plocation like "S%"
	order by Pnumber;

select Dnumber, Dname, concat(Fname," ", Lname) as Name, Salary, round(Salary*1.05,2) as Bonus from departament
	inner join dept_locations using(Dnumber)
	inner join employee on Ssn = Mgr_ssn;
    
select Dnumber, Dname, concat(Fname," ", Lname) as Manager, Salary, round(Salary*1.05,2) as Bonus from departament
	inner join dept_locations using(Dnumber)
	inner join (dependent inner join employee on Ssn = Essn) on Ssn = Mgr_ssn
	group by Dnumber;
