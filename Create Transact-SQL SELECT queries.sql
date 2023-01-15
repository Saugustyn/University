--11.01 (NULL w wyra¿eniach i funkcjach agreguj¹cych)

--a) 	Wykonaj zapytanie:
--SELECT 34+NULL
--i skomentuj wynik.
select 34+null
--null

--b) 	Wszystkie dane o tych pracownikach, dla których brakuje numeru PESEL lub daty zatrudnienia (warunek klauzuli WHERE napisz w taki sposób aby by³ SARG)
select * 
from employees 
where employment_date IS NULL OR pesel IS NULL

--c)	Zapytanie wybieraj¹ce wszystkie dane z tabeli students_modules.
select * from students_modules

--d)	Zapytanie, które dla ka¿dego rekordu z tabeli students_modules zwróci informacjê, ile dni minê³o od planowanego egzaminu (wykorzystaj funkcjê DateDiff). Dane posortowane malej¹co wed³ug daty.
select student_id, module_id ,datediff(day, planned_exam_date, getdate()) from students_modules
order by planned_exam_date desc

--e)	Zapytanie zwracaj¹ce wynik dzia³ania funkcji agreguj¹cej COUNT na polu planned_exam_date tabeli students_modules. 
select count(planned_exam_date) from students_modules

--f)	Zapytanie zwracaj¹ce wynik dzia³ania funkcji agreguj¹cej COUNT(*) dla tabeli students_modules. 
select count(*) from students_modules

--11.02 (DISTINCT)

--a)	Zapytanie zwracaj¹ce identyfikatory studentów wraz z datami przyst¹pienia do egzaminów. Jeœli student danego dnia przyst¹pi³ do wielu egzaminów, jego identyfikator ma siê pojawiæ tylko raz. Dane posortowane malej¹co wzglêdem dat.
select distinct exam_date, student_id from student_grades
order by exam_date desc

--b)	Zapytanie zwracaj¹ce identyfikatory studentów, którzy przyst¹pili do egzaminu w marcu 2018 roku. Identyfikator ka¿dego studenta ma siê pojawiæ tylko raz. Dane posortowane malej¹co wed³ug identyfikatorów studentów
select distinct student_id from student_grades
where exam_date between '20180301' and '20180331'
order by student_id desc

--11.03
--Spróbuj wykonaæ zapytanie:
SELECT student_id, surname AS family_name
FROM students
WHERE family_name='Fisher'
--Wyjaœnij dlaczego jest ono niepoprawne a nastêpnie je skoryguj.
SELECT student_id, surname AS family_name
FROM students
WHERE surname='Fisher'

--11.04 (SARG)
--Zapytanie zwracaj¹ce module_name oraz lecturer_id z tabeli modules z tych rekordów, dla których lecturer_id jest równy 8 lub NULL.
--Zapytanie napisz dwoma sposobami – raz wykorzystuj¹c funkcjê COALESCE (jako drugi parametr przyjmij 0) raz tak, aby predykat podany w warunku WHERE by³ SARG.

--1)
select module_name, lecturer_id
from modules
where lecturer_id=8 or coalesce(lecturer_id, 0) = 0
--2)
select module_name, lecturer_id from modules
where lecturer_id is null or lecturer_id = 8

--11.05 Wykorzystaj funkcjê CAST i TRY_CAST jako parametr instrukcji SELECT próbuj¹c zamieniæ tekst ABC na liczbê typu INT.
select cast('ABC' as int)
select try_cast('abc' as int)

--11.06 Napisz trzy razy instrukcjê SELECT wykorzystuj¹c funkcjê CONVERT zamieniaj¹c¹ dzisiejsz¹ datê na tekst. Jako ostatni parametr funkcji CONVERT podaj 101, 102 oraz 103.
select convert(varchar(12), getdate(), 101)
select convert(varchar(12), getdate(), 102)
select convert(varchar(12), getdate(), 103)

--11.07 (LIKE)
--Napisz zapytania z u¿yciem operatora LIKE wybieraj¹ce nazwy grup (wielkoœæ liter jest nieistotna):

--a)	zaczynaj¹ce siê na DM
select group_no from groups
where group_no like 'DM%'
--b)	niemaj¹ce w nazwie ci¹gu '10'
select group_no from groups
where group_no not like '%10%'
--c)	których drugim znakiem jest M
select group_no from groups
where group_no like '_M%'
--d)	których przedostatnim znakiem jest 0 (zero)
select group_no from groups
where group_no like '%0_'
--e)	których ostatnim znakiem jest 1 lub 2
select group_no from groups
where group_no like '%[12]'
--f)	których pierwszym znakiem nie jest litera D
select group_no from groups
where group_no not like 'D%'
--g)	których drugim znakiem jest dowolna litera z zakresu A-P
select group_no from groups
where group_no like '_[A-P]%'

--11.08 (LIKE i COLLATE)
--Napisz zapytania z u¿yciem operatora LIKE i/lub klauzuli COLLATE:

--a)	wybieraj¹ce nazwy wyk³adów, które w nazwie maj¹ literê o (wielkoœæ liter nie ma znaczenia)
select module_name from modules
where module_name like '%o%'
--b)	wybieraj¹ce nazwy wyk³adów, które w nazwie maj¹ du¿¹ literê O
select module_name from modules
where module_name collate polish_cs_as like '%O%'
--c)	wybieraj¹ce nazwy grup, które w nazwie maj¹ trzeci¹ literê i (wielkoœæ liter nie ma znaczenia)
select group_no from groups
where group_no like '__i%'
--d)	wybieraj¹ce nazwy grup, które w nazwie maj¹ trzeci¹ literê ma³e i
select group_no from groups
where group_no collate polish_cs_as like '__i%'

--11.10
--Napisz zapytanie:
select distinct surname
from students
order by group_no
--Skoryguj zapytanie tak, aby zwraca³o nazwiska studentów z tabeli students posortowane wed³ug numeru grupy.
select surname
from students
order by group_no
 
 --11.11 (TOP)
--a)	Napisz zapytanie wybieraj¹ce 5 pierwszych rekordów z tabeli student_grades, które w polu exam_date maj¹ najdawniejsze daty
select top(5) * from student_grades
order by exam_date asc
--b)	Skoryguj zapytanie z punktu a) dodaj¹c klauzulê WITH TIES.
select top(5) with ties * from student_grades
order by exam_date asc

--11.12 (TOP, OFFSET)

--a)	SprawdŸ, ile rekordów jest w tabeli student_grades
select count(*) from student_grades
--b)	Wybierz 20% pocz¹tkowych rekordów z tabeli student_grades. Posortuj wynik wed³ug exam_date.
select top(20) percent * from student_grades
order by exam_date
--c)	Pomiñ pierwszych 6 rekordów i wybierz kolejnych 10 rekordów z tabeli student_grades. Posortuj wynik wed³ug exam_date.
select * from student_grades
order by exam_date
offset 6 rows fetch next 10 rows only
--d)	Wybierz wszystkie rekordy z tabeli student_grades z pominiêciem pierwszych 20 (sortowanie wed³ug exam_date).
select * from student_grades
order by exam_date
offset 20 rows

--11.13 (INTERSECT, UNION, EXCEPT)

--a)	Wszystkie nazwiska z tabel students i employees (ka¿de ma siê pojawiæ tylko raz) posortowane wed³ug nazwisk
select surname from students
union
select surname from employees
order by surname
--b)	Wszystkie nazwiska z tabel students i employees (ka¿de ma siê pojawiæ tyle razy ile razy wystêpuje w tabelach) posortowane wed³ug nazwisk
select surname from students
union all
select surname from employees
order by surname
--c)	Te nazwiska z tabeli students, które nie wystêpuj¹ w tabeli employees
select surname from students
except
select surname from employees
order by surname
--d)	Te nazwiska z tabeli students, które wystêpuj¹ tak¿e w tabeli employees
select surname from students
intersect
select surname from employees
order by surname
--e)	Nazwy katedr, których pracownicy nie s¹ przypisani jako potencjalni prowadz¹cy do ¿adnego wyk³adu (u¿yj operatora EXCEPT)
select department from departments
except
select department from lecturers
--f)	Identyfikatory wyk³adów, które nie wystêpuj¹ jako wyk³ady poprzedzaj¹ce 
select module_id from modules
except
select preceding_module from modules
--g)	Te pary id_studenta, id_wykladu z tabeli students_modules, którym nie zosta³a przyznana dotychczas ¿adna ocena
select student_id, module_id from students_modules
except
select student_id, module_id from student_grades
--h)	Identyfikatory studentów, którzy zapisali siê zarówno na wyk³ad o identyfikatorze 3 jak i 12
select student_id from students_modules 
where module_id = 3
intersect
select student_id from students_modules 
where module_id = 12
--i)	Nazwiska i imiona studentów wraz z numerami grup, zapisanych do grup o nazwach zaczynaj¹cych siê na DMIe oraz nazwiska i imiona wyk³adowców wraz z nazwami katedr, w których pracuj¹. Ostatnia kolumna ma mieæ nazwê group_department. Dane posortowane rosn¹co wed³ug ostatniej kolumny.
select surname, first_name, group_no as group_department  from students
where group_no collate polish_cs_as  like 'DMIe%'
union
select e.surname, e.first_name, l.department from lecturers l
join employees e on l.lecturer_id = e.employee_id
order by group_department

