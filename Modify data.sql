--14.00

--1. 	Instrukcj� SELECT wybierz identyfikatory, nazwiska, imiona i numery grup student�w zapisanych na wyk�ad o identyfikatorze 2. Posortuj dane wed�ug group_no.
select s.student_id, surname, first_name, group_no from students s
join students_modules sm on s.student_id = sm.student_id
where sm.module_id = 2
order by group_no

--2. 	Usu� wszystkich student�w grupy DMIe1011 z wyk�adu o identyfikatorze 2 z jednoczesnym wy�wietleniem identyfikator�w tych student�w. Wskaz�wka: wykorzystaj sk�adni� DELETE based on a join. Nie korzystaj z transakcji.
begin tran

delete from sm
output deleted.student_id
from students s join students_modules sm 
on s.student_id=sm.student_id
where group_no='DMIe1011' AND module_id=2

--3.	Instrukcj� MERGE dokonaj takiej modyfikacji w bazie danych, aby wszyscy studenci z grupy DMIe1011 byli zapisani na wyk�ad nr 2 i tylko oni.
--		Student�w przypisanych dotychczas na wyk�ad nr 2 i nie nale��cych do grupy DMIe1011 nale�y przepisa� na wyk�ad o identyfikatorze 26. Nie korzystaj z transakcji.

merge into students_modules AS sm
using students AS s
on s.student_id = sm.student_id AND module_id=2
when matched then
update set sm.module_id=26
when not matched and s.group_no='DMIe1011' then 
insert values (student_id, 2, NULL);

--4.	Wybierz identyfikatory, nazwiska, imiona i numery grup student�w zapisanych na wyk�ad o identyfikatorze 2.
select s.student_id, surname, first_name, group_no from students s
join students_modules sm on s.student_id = sm.student_id
where module_id = 2

--5.	Sprawd�, czy wszyscy studenci z grupy DMIe1011 zostali zapisani na wyk�ad o identyfikatorze 2 wy�wietlaj�c z tabeli studenci dane o studentach zapisanych do grupy DMIe1011.
select *
from students
where group_no='DMIe1011'

--6.	Wy�wietl identyfikatory student�w zapisanych na wyk�ad o identyfikatorze 26
select student_id
from students_modules
where module_id=26

rollback

--14.01 

--1.	Spr�buj doda� do tabeli students dane o studencie (wykorzystaj transakcj�): Andy Cooper, urodzony 1998-02-04, grupa MZa2020.
insert into students (first_name, surname, date_of_birth, group_no)
values ('Andy', 'Cooper', '19980204', 'MZa2020')

--2.	Spr�buj doda� do tabeli students dane o studencie (wykorzystaj transakcj�) Andy Cooper, urodzony 1998-02-04, grupa DMZa3011
begin tran
insert into students (first_name, surname, date_of_birth, group_no)
values ('Andy', 'Cooper', '19980204', 'DMZa3011')
rollback

--14.02

--Student o identyfikatorze 12 dokona� dw�ch wp�at:
--12 czerwca 2019 roku 500 pln
--22 czerwca 2019 roku 650 pln
--Jedn� instrukcj� INSERT zarejestruj ten fakt w bazie danych.

insert into tuition_fees (student_id, fee_amount, date_of_payment)
values (12, 500, '20190612'), (12, 650, '20190622')

--14.03
--Pracownicy o identyfikatorach 23 i 40 zostali wyk�adowcami. Pracownik o identyfikatorze 23 ma tytu� master i zosta� zatrudniony w Department of History, a pracownik o identyfikatorze 40 ma tytu� doctor i zosta� zatrudniony w Department of Psychology.

--1. 	Jedn� instrukcj� INSERT wprowad� te dane do bazy danych. W instrukcji pomi� pierwszy nawias.
insert into lecturers values (23, 'Master','Department of History'), (40, 'Doctor','Department of Psychology')

--2. 	Dodaj do tabeli departments nazw� katedry Department of Psychology i pon�w pr�b� wprowadzenia informacji o zatrudnieniu pracownik�w o identyfikatorach 23 i 40 na odpowiednich stanowiskach wyk�adowc�w. 
insert into departments values('Department of Psychology')

--14.04

--1.	Utw�rz tabel� o nazwie payments o nast�puj�cej strukturze (bez klucza podstawowego):
--student (int)
--fee (smallmoney)
--date (date)
create table payments(
student int,
fee smallmoney,
date date)

--2.	Instrukcj� INSERT�SELECT przepisz do tabeli payments wszystkie wp�aty dokonane w pa�dzierniku 2018 roku.
insert into payments(student,fee, date)
select student_id, fee_amount, date_of_payment  from tuition_fees
where date_of_payment between '20181001' and '20181031'

--14.05

--1. 	Utw�rz procedur� o nazwie usp_payments, kt�ra b�dzie wymaga� podania dw�ch parametr�w typu date i b�dzie wykonywa� nast�puj�ce operacje (nie u�ywaj transakcji):
--�	usunie zawarto�� tabeli payments
--�	do tabeli payments doda wszystkie rekordy z tabeli tuition_fees, kt�re dotycz� wp�at dokonanych w okresie podanym jako parametry zapytania.

create proc usp_payments @sd as date, @ed as date
as
truncate table payments;
insert into payments(student,fee, date)
select student_id, fee_amount, date_of_payment  from tuition_fees
where date_of_payment between @sd and @ed
go

--2.	Uruchom procedur� dla podanych dat. Za ka�dym razem sprawdzaj zawarto�� tabeli payments.
select * from payments

exec usp_payments '20180920', '20180930'

--14.06a
--Bez tworzenia tabeli instrukcj� CREATE skopiuj do tabeli myStudents wszystkie dane z tabeli students dotycz�ce student�w z grupy DMIe1011. Po wykonaniu instrukcji wy�wietl zawarto�� tabeli myStudents. Nie u�ywaj transakcji.
select *
into myStudents
from students
where group_no = 'DMIe1011'

--14.06b
--Utw�rz procedur� o nazwie usp_myStudents, kt�ra wykona dwie operacje. Usunie tabel� myStudents, je�li taka istnieje w bazie danych (u�yj instrukcji DROP TABLE IF exists myStudents) oraz przepisze do niej wszystkie dane z tabeli students dotycz�ce student�w z grupy podanej jako parametr procedury.
create proc usp_myStudents @group as char(10)
as
drop table if exists myStudents;
select *
into myStudents
from students
where group_no = @group
go

exec usp_myStudents 'ZMIe2011'
exec usp_myStudents 'DMZa3012'

--14.07

--1.	Wy�wietl zawarto�� tabeli acad_positions i zapami�taj stawki dla stanowisk full professor i habilitated associate professor (odpowiednio 80 i 65).
select * from acad_positions

--2.	Jedn� instrukcj� UPDATE zwi�ksz stawki godzinowe dla tych dw�ch stanowisk o 20% (u�yj transakcji).
update acad_positions
set overtime_rate *= 1.2
where acad_position in('full professor', 'habilitated associate professor')

--14.08

--1.	Sprawd� identyfikator wyk�adowcy prowadz�cego wyk�ady o identyfikatorze 1 i 3.
select lecturer_id from modules
where module_id = 1
intersect
select lecturer_id from modules
where module_id = 3

--2.	Wy�wietl dane z tabeli students_modules dotycz�ce wyk�ad�w o identyfikatorach 1 i 3 i sprawd� na kiedy s� zaplanowane egzaminy dla zapisanych student�w (pole planned_exam_date).
select * from students_modules
where module_id in (1, 3)

--3.	Jedn� instrukcj� UPDATE zmie� planowane daty egzamin�w (planned_exam_date) prowadzonych przez wyk�adowc� o identyfikatorze 4 na 26.09.2019.
update s
set planned_exam_date = '20190926'
from modules m join students_modules s
on m.module_id = s.module_id
where lecturer_id=4

--14.09a
--Studentka Katie Lancaster z zaj�� z przedmiotu Databases otrzyma�a dwie oceny (2 i 3,5). Okaza�o si�, �e ta druga ocena (3,5) oraz data jej wystawienia s� b��dne. Skoryguj ten b��d wpisuj�c ocen� 4,0 z dat� 30.09.2018.
--Wskaz�wka: w tabeli students odszukaj identyfikator tej studentki a w tabeli modules identyfikator przedmiotu. 
--Posiadaj�c te informacje sprawd� w tabeli student_grades, o kt�ry rekord chodzi i instrukcj� UPDATE dokonaj odpowiedniej modyfikacji. Przed instrukcj� UPDATE nale�y wykona� trzy instrukcje SELECT.

select student_id from students
where first_name = 'Katie' and surname = 'Lancaster' --10

select module_id from modules
where module_name = 'Databases' --11

select * from student_grades
where student_id = 10 and module_id = 11

update student_grades
set exam_date = '20180930', grade = 4
where student_id = 10 and module_id = 11 and grade = 3.5

--14.09b
--Student Oliver Webb z zaj�� z przedmiotu Economics II otrzyma� dwie oceny (2 i 4). Okaza�o si�, �e ta druga ocena (4) oraz data jej wystawienia s� b��dne. 
--JEDN� INSTRUKCJ� MERGE skoryguj ten b��d wpisuj�c ocen� 3,0 z dat� 15.10.2018.

merge into student_grades as tgt
using
(select s.student_id, m.module_id
from students s inner join students_modules sm on s.student_id=sm.student_id
inner join modules m ON sm.module_id=m.module_id
where surname='Webb' and first_name='Oliver' and module_name='Economics II')
as src
on src.student_id=tgt.student_id and src.module_id=tgt.module_id
when matched and grade=4 then
update set grade=3, exam_date='20181015';

--14.10
--Zwi�ksz overtime_rate dla stopnia master o 20 procent zapisuj�c jednocze�nie now� warto�� w zmiennej o nazwie @newValue. Wy�wietl zawarto�� zmiennej @newValue na ekranie.
declare @newValue as smallmoney=null
update acad_positions
set @newValue=overtime_rate *= 1.2
where acad_position = 'master'
select @newValue

--14.11
--Anulowany zosta� egzamin z przedmiotu Mathematics. Usu� wszystkie oceny z tego przedmiotu. Wskaz�wka: wykorzystaj sk�adni� DELETE based on a join

delete from sg
from student_grades sg
join modules m on sg.module_id = m.module_id
where m.module_name = 'Mathematics'

--14.12

--1.	Wy�wietl te pary student_id, module_id z tabeli students_modules, dla kt�rych nie wpisano oceny do tabeli student_grades.
select sm.student_id, sm.module_id from students_modules sm
left join student_grades sg on sm.student_id = sg.student_id and sm.module_id = sg.module_id
where sg.student_id is null

--2.	Instrukcj� INSERT dodaj do tabeli grades ocen� 0.
insert into grades values (0)

--3.	Instrukcj� MERGE wszystkim studentom, kt�rzy nie maj� oceny z wyk�adu, na kt�ry ucz�szczaj� przypisz ocen� 0 z dat� dzisiejsz�.
merge into student_grades sg
using students_modules sm
on sm.student_id = sg.student_id and sm.module_id = sg.module_id
when not matched
then insert values (student_id, module_id, getdate(), 0);

--14.13
--Jedn� instrukcj� INSERT do tabeli employees dodaj dw�ch pracownik�w i wy�wietl nadane im identyfikatory:
--Jones Sylvia, employment_date: 20200403
--Edison George, PESEL 99062312345

insert into employees (surname, first_name, employment_date, PESEL)
output inserted.employee_id
values('Jones', 'Sylvia', '20200403', null),
('Edison', 'George', null, '99062312345')

--14.14
--1.	Instrukcj� CREATE TABLE utw�rz tabel� #lastIncome o strukturze takiej jak tabela tuition_fees z jedn� r�nic�: pole payment_id ma nie by� autonumerowane.
create table #lastIncome(
payment_id int,
student_id int,
fee_amount smallmoney,
date_of_payment date)

--2.	Student o identyfikatorze 6 dokona� dw�ch wp�at: przedwczoraj 250 pln i dzisiaj 180 pln.
--Zarejestruj ten fakt w bazie danych z jednoczesnym zapisaniem wszystkich informacji o dokonanych wp�atach do tymczasowej tabeli #lastIncome.
insert into #lastIncome(student_id, fee_amount, date_of_payment)
output inserted.*
values(6, 250, getdate()-2),
(6,180, getdate())


--14.15
--Usu� wyk�ad o identyfikatorze 24 z jednoczesnym wy�wietleniem wszystkich danych o tym wyk�adzie.

delete from modules
output deleted.*
where module_id = 24

--14.16
--Zwi�ksz wszystkie stawki godzinowe o 10% z jednoczesnym wy�wietleniem wszystkich tytu��w naukowych, poprzednich stawek oraz stawek po zmianie. 
--Kolumna zawieraj�ca poprzednie stawki ma mie� nazw� old_rate a ta zawieraj�ca nowe stawki new_rate.

update acad_positions
set overtime_rate *= 1.1
output
deleted.overtime_rate as old_rate,
deleted.acad_position,
inserted.overtime_rate as new_rate

--14.17

--1.	Wy�wietl dane o wszystkich wyk�adach, dla kt�rych liczba godzin jest mniejsza ni� 15.
select * from modules where no_of_hours <15

--2.	Zmie� liczb� godzin dla wszystkich wyk�ad�w, dla kt�rych liczba ta jest mniejsza ni� 15 na 15. Zwr�� identyfikatory tych wyk�ad�w, ich nazwy oraz poprzedni� i aktualn� liczb� godzin.
update modules
set no_of_hours = 15
output inserted.*,
deleted.no_of_hours
where no_of_hours <15

--14.18a
/*Napisz instrukcj� MERGE wprowadzaj�c poprawne dane do tabeli student_grades. Je�li danemu studentowi z danego modu�u podanego dnia ocena zosta�a wpisana, skoryguj j�, je�li nie, wpisz j�. 
Wy�wietl na ekranie nazw� akcji wykonanej na rekordzie (INSERT lub UPDATE), student_id, module_id oraz ocen� poprzedni� (je�li istnia�a) i now�. */
BEGIN TRAN
MERGE INTO student_grades AS tgt
USING (VALUES
(26, 6, '20180926', 5), 
(32, 12, '20180302', 4.5), 
(3, 2, '20180915', 3),
(29, 15, '20181015', 4.5)
)
AS src(student_id, module_id, exam_date, grade)
ON src.student_id = tgt.student_id 
AND src.module_id=tgt.module_id AND src.exam_date=tgt.exam_date
WHEN MATCHED THEN
UPDATE SET tgt.grade = src.grade
WHEN NOT MATCHED THEN
INSERT VALUES
(src.student_id, src.module_id, src.exam_date, src.grade)
OUTPUT
$action AS the_action,
inserted.student_id,
inserted.module_id,
deleted.grade AS old_grade,
inserted.grade AS new_grade;
ROLLBACK

--14.19a
/*Do tabeli groups spr�buj doda� pole o nazwie field_of_study typu varchar(100) z atrybutem NULL bez warto�ci domy�lnej i bez WITH VALUES. 
Wy�wietl zawarto�� tabeli groups i sprawd�, �e sk�ada si� ona z dw�ch p�l oraz �e pole field_of_study jest wype�nione warto�ci� NULL.*/

ALTER TABLE groups ADD field_of_study varchar(100) NULL
SELECT * FROM groups

--14.19b
/*Do tabeli groups spr�buj doda� pole o nazwie field_of_study typu varchar(100) z atrybutem NULL i warto�ci� domy�ln� �EMPTY� bez klauzuli WITH VALUES. 
Wy�wietl zawarto�� tabeli groups i sprawd�, �e sk�ada si� ona z dw�ch p�l oraz �e pole field_of_study jest wype�nione warto�ci� NULL.*/
ALTER TABLE groups ADD field_of_study1 varchar(100) NULL
CONSTRAINT fos_default default('Empty')
SELECT * FROM groups

--14.19d
/*Do tabeli groups spr�buj doda� pole o nazwie field_of_study typu varchar(100) z atrybutem NULL i warto�ci� domy�ln� �EMPTY� z klauzul� WITH VALUES. 
Wy�wietl zawarto�� tabeli groups i sprawd�, �e sk�ada si� ona z dw�ch p�l oraz �e pole field_of_study jest wype�nione warto�ci� EMPTY.*/
ALTER TABLE groups ADD field_of_study2 varchar(100) NULL
CONSTRAINT fos_default2 default('Empty') with values
SELECT * FROM groups

--14.19e
/*Do tabeli groups spr�buj doda� pole o nazwie field_of_study typu varchar(100) z atrybutem NOT NULL i warto�ci� domy�ln� �EMPTY� bez klauzuli WITH VALUES. 
Wy�wietl zawarto�� tabeli groups i sprawd�, �e sk�ada si� ona z dw�ch p�l oraz �e pole field_of_study jest wype�nione warto�ci� EMPTY.*/
ALTER TABLE groups ADD field_of_study4 varchar(100) NOT NULL
CONSTRAINT fos_default4 default('Empty')
SELECT * FROM groups

--14.20a
--Z tabeli students spr�buj usun�� pole surname. Wy�wietl zawarto�� tabeli students i sprawd�, �e usuni�cie kolumny si� powiod�o. Skomentuj takie dzia�anie systemu.
alter table students drop column surname
select * from students