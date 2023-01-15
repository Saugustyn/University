--14.00

--1. 	Instrukcj¹ SELECT wybierz identyfikatory, nazwiska, imiona i numery grup studentów zapisanych na wyk³ad o identyfikatorze 2. Posortuj dane wed³ug group_no.
select s.student_id, surname, first_name, group_no from students s
join students_modules sm on s.student_id = sm.student_id
where sm.module_id = 2
order by group_no

--2. 	Usuñ wszystkich studentów grupy DMIe1011 z wyk³adu o identyfikatorze 2 z jednoczesnym wyœwietleniem identyfikatorów tych studentów. Wskazówka: wykorzystaj sk³adniê DELETE based on a join. Nie korzystaj z transakcji.
begin tran

delete from sm
output deleted.student_id
from students s join students_modules sm 
on s.student_id=sm.student_id
where group_no='DMIe1011' AND module_id=2

--3.	Instrukcj¹ MERGE dokonaj takiej modyfikacji w bazie danych, aby wszyscy studenci z grupy DMIe1011 byli zapisani na wyk³ad nr 2 i tylko oni.
--		Studentów przypisanych dotychczas na wyk³ad nr 2 i nie nale¿¹cych do grupy DMIe1011 nale¿y przepisaæ na wyk³ad o identyfikatorze 26. Nie korzystaj z transakcji.

merge into students_modules AS sm
using students AS s
on s.student_id = sm.student_id AND module_id=2
when matched then
update set sm.module_id=26
when not matched and s.group_no='DMIe1011' then 
insert values (student_id, 2, NULL);

--4.	Wybierz identyfikatory, nazwiska, imiona i numery grup studentów zapisanych na wyk³ad o identyfikatorze 2.
select s.student_id, surname, first_name, group_no from students s
join students_modules sm on s.student_id = sm.student_id
where module_id = 2

--5.	SprawdŸ, czy wszyscy studenci z grupy DMIe1011 zostali zapisani na wyk³ad o identyfikatorze 2 wyœwietlaj¹c z tabeli studenci dane o studentach zapisanych do grupy DMIe1011.
select *
from students
where group_no='DMIe1011'

--6.	Wyœwietl identyfikatory studentów zapisanych na wyk³ad o identyfikatorze 26
select student_id
from students_modules
where module_id=26

rollback

--14.01 

--1.	Spróbuj dodaæ do tabeli students dane o studencie (wykorzystaj transakcjê): Andy Cooper, urodzony 1998-02-04, grupa MZa2020.
insert into students (first_name, surname, date_of_birth, group_no)
values ('Andy', 'Cooper', '19980204', 'MZa2020')

--2.	Spróbuj dodaæ do tabeli students dane o studencie (wykorzystaj transakcjê) Andy Cooper, urodzony 1998-02-04, grupa DMZa3011
begin tran
insert into students (first_name, surname, date_of_birth, group_no)
values ('Andy', 'Cooper', '19980204', 'DMZa3011')
rollback

--14.02

--Student o identyfikatorze 12 dokona³ dwóch wp³at:
--12 czerwca 2019 roku 500 pln
--22 czerwca 2019 roku 650 pln
--Jedn¹ instrukcj¹ INSERT zarejestruj ten fakt w bazie danych.

insert into tuition_fees (student_id, fee_amount, date_of_payment)
values (12, 500, '20190612'), (12, 650, '20190622')

--14.03
--Pracownicy o identyfikatorach 23 i 40 zostali wyk³adowcami. Pracownik o identyfikatorze 23 ma tytu³ master i zosta³ zatrudniony w Department of History, a pracownik o identyfikatorze 40 ma tytu³ doctor i zosta³ zatrudniony w Department of Psychology.

--1. 	Jedn¹ instrukcj¹ INSERT wprowadŸ te dane do bazy danych. W instrukcji pomiñ pierwszy nawias.
insert into lecturers values (23, 'Master','Department of History'), (40, 'Doctor','Department of Psychology')

--2. 	Dodaj do tabeli departments nazwê katedry Department of Psychology i ponów próbê wprowadzenia informacji o zatrudnieniu pracowników o identyfikatorach 23 i 40 na odpowiednich stanowiskach wyk³adowców. 
insert into departments values('Department of Psychology')

--14.04

--1.	Utwórz tabelê o nazwie payments o nastêpuj¹cej strukturze (bez klucza podstawowego):
--student (int)
--fee (smallmoney)
--date (date)
create table payments(
student int,
fee smallmoney,
date date)

--2.	Instrukcj¹ INSERT…SELECT przepisz do tabeli payments wszystkie wp³aty dokonane w paŸdzierniku 2018 roku.
insert into payments(student,fee, date)
select student_id, fee_amount, date_of_payment  from tuition_fees
where date_of_payment between '20181001' and '20181031'

--14.05

--1. 	Utwórz procedurê o nazwie usp_payments, która bêdzie wymagaæ podania dwóch parametrów typu date i bêdzie wykonywaæ nastêpuj¹ce operacje (nie u¿ywaj transakcji):
--•	usunie zawartoœæ tabeli payments
--•	do tabeli payments doda wszystkie rekordy z tabeli tuition_fees, które dotycz¹ wp³at dokonanych w okresie podanym jako parametry zapytania.

create proc usp_payments @sd as date, @ed as date
as
truncate table payments;
insert into payments(student,fee, date)
select student_id, fee_amount, date_of_payment  from tuition_fees
where date_of_payment between @sd and @ed
go

--2.	Uruchom procedurê dla podanych dat. Za ka¿dym razem sprawdzaj zawartoœæ tabeli payments.
select * from payments

exec usp_payments '20180920', '20180930'

--14.06a
--Bez tworzenia tabeli instrukcj¹ CREATE skopiuj do tabeli myStudents wszystkie dane z tabeli students dotycz¹ce studentów z grupy DMIe1011. Po wykonaniu instrukcji wyœwietl zawartoœæ tabeli myStudents. Nie u¿ywaj transakcji.
select *
into myStudents
from students
where group_no = 'DMIe1011'

--14.06b
--Utwórz procedurê o nazwie usp_myStudents, która wykona dwie operacje. Usunie tabelê myStudents, jeœli taka istnieje w bazie danych (u¿yj instrukcji DROP TABLE IF exists myStudents) oraz przepisze do niej wszystkie dane z tabeli students dotycz¹ce studentów z grupy podanej jako parametr procedury.
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

--1.	Wyœwietl zawartoœæ tabeli acad_positions i zapamiêtaj stawki dla stanowisk full professor i habilitated associate professor (odpowiednio 80 i 65).
select * from acad_positions

--2.	Jedn¹ instrukcj¹ UPDATE zwiêksz stawki godzinowe dla tych dwóch stanowisk o 20% (u¿yj transakcji).
update acad_positions
set overtime_rate *= 1.2
where acad_position in('full professor', 'habilitated associate professor')

--14.08

--1.	SprawdŸ identyfikator wyk³adowcy prowadz¹cego wyk³ady o identyfikatorze 1 i 3.
select lecturer_id from modules
where module_id = 1
intersect
select lecturer_id from modules
where module_id = 3

--2.	Wyœwietl dane z tabeli students_modules dotycz¹ce wyk³adów o identyfikatorach 1 i 3 i sprawdŸ na kiedy s¹ zaplanowane egzaminy dla zapisanych studentów (pole planned_exam_date).
select * from students_modules
where module_id in (1, 3)

--3.	Jedn¹ instrukcj¹ UPDATE zmieñ planowane daty egzaminów (planned_exam_date) prowadzonych przez wyk³adowcê o identyfikatorze 4 na 26.09.2019.
update s
set planned_exam_date = '20190926'
from modules m join students_modules s
on m.module_id = s.module_id
where lecturer_id=4

--14.09a
--Studentka Katie Lancaster z zajêæ z przedmiotu Databases otrzyma³a dwie oceny (2 i 3,5). Okaza³o siê, ¿e ta druga ocena (3,5) oraz data jej wystawienia s¹ b³êdne. Skoryguj ten b³¹d wpisuj¹c ocenê 4,0 z dat¹ 30.09.2018.
--Wskazówka: w tabeli students odszukaj identyfikator tej studentki a w tabeli modules identyfikator przedmiotu. 
--Posiadaj¹c te informacje sprawdŸ w tabeli student_grades, o który rekord chodzi i instrukcj¹ UPDATE dokonaj odpowiedniej modyfikacji. Przed instrukcj¹ UPDATE nale¿y wykonaæ trzy instrukcje SELECT.

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
--Student Oliver Webb z zajêæ z przedmiotu Economics II otrzyma³ dwie oceny (2 i 4). Okaza³o siê, ¿e ta druga ocena (4) oraz data jej wystawienia s¹ b³êdne. 
--JEDN¥ INSTRUKCJ¥ MERGE skoryguj ten b³¹d wpisuj¹c ocenê 3,0 z dat¹ 15.10.2018.

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
--Zwiêksz overtime_rate dla stopnia master o 20 procent zapisuj¹c jednoczeœnie now¹ wartoœæ w zmiennej o nazwie @newValue. Wyœwietl zawartoœæ zmiennej @newValue na ekranie.
declare @newValue as smallmoney=null
update acad_positions
set @newValue=overtime_rate *= 1.2
where acad_position = 'master'
select @newValue

--14.11
--Anulowany zosta³ egzamin z przedmiotu Mathematics. Usuñ wszystkie oceny z tego przedmiotu. Wskazówka: wykorzystaj sk³adniê DELETE based on a join

delete from sg
from student_grades sg
join modules m on sg.module_id = m.module_id
where m.module_name = 'Mathematics'

--14.12

--1.	Wyœwietl te pary student_id, module_id z tabeli students_modules, dla których nie wpisano oceny do tabeli student_grades.
select sm.student_id, sm.module_id from students_modules sm
left join student_grades sg on sm.student_id = sg.student_id and sm.module_id = sg.module_id
where sg.student_id is null

--2.	Instrukcj¹ INSERT dodaj do tabeli grades ocenê 0.
insert into grades values (0)

--3.	Instrukcj¹ MERGE wszystkim studentom, którzy nie maj¹ oceny z wyk³adu, na który uczêszczaj¹ przypisz ocenê 0 z dat¹ dzisiejsz¹.
merge into student_grades sg
using students_modules sm
on sm.student_id = sg.student_id and sm.module_id = sg.module_id
when not matched
then insert values (student_id, module_id, getdate(), 0);

--14.13
--Jedn¹ instrukcj¹ INSERT do tabeli employees dodaj dwóch pracowników i wyœwietl nadane im identyfikatory:
--Jones Sylvia, employment_date: 20200403
--Edison George, PESEL 99062312345

insert into employees (surname, first_name, employment_date, PESEL)
output inserted.employee_id
values('Jones', 'Sylvia', '20200403', null),
('Edison', 'George', null, '99062312345')

--14.14
--1.	Instrukcj¹ CREATE TABLE utwórz tabelê #lastIncome o strukturze takiej jak tabela tuition_fees z jedn¹ ró¿nic¹: pole payment_id ma nie byæ autonumerowane.
create table #lastIncome(
payment_id int,
student_id int,
fee_amount smallmoney,
date_of_payment date)

--2.	Student o identyfikatorze 6 dokona³ dwóch wp³at: przedwczoraj 250 pln i dzisiaj 180 pln.
--Zarejestruj ten fakt w bazie danych z jednoczesnym zapisaniem wszystkich informacji o dokonanych wp³atach do tymczasowej tabeli #lastIncome.
insert into #lastIncome(student_id, fee_amount, date_of_payment)
output inserted.*
values(6, 250, getdate()-2),
(6,180, getdate())


--14.15
--Usuñ wyk³ad o identyfikatorze 24 z jednoczesnym wyœwietleniem wszystkich danych o tym wyk³adzie.

delete from modules
output deleted.*
where module_id = 24

--14.16
--Zwiêksz wszystkie stawki godzinowe o 10% z jednoczesnym wyœwietleniem wszystkich tytu³ów naukowych, poprzednich stawek oraz stawek po zmianie. 
--Kolumna zawieraj¹ca poprzednie stawki ma mieæ nazwê old_rate a ta zawieraj¹ca nowe stawki new_rate.

update acad_positions
set overtime_rate *= 1.1
output
deleted.overtime_rate as old_rate,
deleted.acad_position,
inserted.overtime_rate as new_rate

--14.17

--1.	Wyœwietl dane o wszystkich wyk³adach, dla których liczba godzin jest mniejsza ni¿ 15.
select * from modules where no_of_hours <15

--2.	Zmieñ liczbê godzin dla wszystkich wyk³adów, dla których liczba ta jest mniejsza ni¿ 15 na 15. Zwróæ identyfikatory tych wyk³adów, ich nazwy oraz poprzedni¹ i aktualn¹ liczbê godzin.
update modules
set no_of_hours = 15
output inserted.*,
deleted.no_of_hours
where no_of_hours <15

--14.18a
/*Napisz instrukcjê MERGE wprowadzaj¹c poprawne dane do tabeli student_grades. Jeœli danemu studentowi z danego modu³u podanego dnia ocena zosta³a wpisana, skoryguj j¹, jeœli nie, wpisz j¹. 
Wyœwietl na ekranie nazwê akcji wykonanej na rekordzie (INSERT lub UPDATE), student_id, module_id oraz ocenê poprzedni¹ (jeœli istnia³a) i now¹. */
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
/*Do tabeli groups spróbuj dodaæ pole o nazwie field_of_study typu varchar(100) z atrybutem NULL bez wartoœci domyœlnej i bez WITH VALUES. 
Wyœwietl zawartoœæ tabeli groups i sprawdŸ, ¿e sk³ada siê ona z dwóch pól oraz ¿e pole field_of_study jest wype³nione wartoœci¹ NULL.*/

ALTER TABLE groups ADD field_of_study varchar(100) NULL
SELECT * FROM groups

--14.19b
/*Do tabeli groups spróbuj dodaæ pole o nazwie field_of_study typu varchar(100) z atrybutem NULL i wartoœci¹ domyœln¹ ‘EMPTY’ bez klauzuli WITH VALUES. 
Wyœwietl zawartoœæ tabeli groups i sprawdŸ, ¿e sk³ada siê ona z dwóch pól oraz ¿e pole field_of_study jest wype³nione wartoœci¹ NULL.*/
ALTER TABLE groups ADD field_of_study1 varchar(100) NULL
CONSTRAINT fos_default default('Empty')
SELECT * FROM groups

--14.19d
/*Do tabeli groups spróbuj dodaæ pole o nazwie field_of_study typu varchar(100) z atrybutem NULL i wartoœci¹ domyœln¹ ‘EMPTY’ z klauzul¹ WITH VALUES. 
Wyœwietl zawartoœæ tabeli groups i sprawdŸ, ¿e sk³ada siê ona z dwóch pól oraz ¿e pole field_of_study jest wype³nione wartoœci¹ EMPTY.*/
ALTER TABLE groups ADD field_of_study2 varchar(100) NULL
CONSTRAINT fos_default2 default('Empty') with values
SELECT * FROM groups

--14.19e
/*Do tabeli groups spróbuj dodaæ pole o nazwie field_of_study typu varchar(100) z atrybutem NOT NULL i wartoœci¹ domyœln¹ ‘EMPTY’ bez klauzuli WITH VALUES. 
Wyœwietl zawartoœæ tabeli groups i sprawdŸ, ¿e sk³ada siê ona z dwóch pól oraz ¿e pole field_of_study jest wype³nione wartoœci¹ EMPTY.*/
ALTER TABLE groups ADD field_of_study4 varchar(100) NOT NULL
CONSTRAINT fos_default4 default('Empty')
SELECT * FROM groups

--14.20a
--Z tabeli students spróbuj usun¹æ pole surname. Wyœwietl zawartoœæ tabeli students i sprawdŸ, ¿e usuniêcie kolumny siê powiod³o. Skomentuj takie dzia³anie systemu.
alter table students drop column surname
select * from students