--11.01 (NULL w wyra�eniach i funkcjach agreguj�cych)

--a) 	Wykonaj zapytanie:
--SELECT 34+NULL
--i skomentuj wynik.
select 34+null
--null

--b) 	Wszystkie dane o tych pracownikach, dla kt�rych brakuje numeru PESEL lub daty zatrudnienia (warunek klauzuli WHERE napisz w taki spos�b aby by� SARG)
select * 
from employees 
where employment_date IS NULL OR pesel IS NULL

--c)	Zapytanie wybieraj�ce wszystkie dane z tabeli students_modules.
select * from students_modules

--d)	Zapytanie, kt�re dla ka�dego rekordu z tabeli students_modules zwr�ci informacj�, ile dni min�o od planowanego egzaminu (wykorzystaj funkcj� DateDiff). Dane posortowane malej�co wed�ug daty.
select student_id, module_id ,datediff(day, planned_exam_date, getdate()) from students_modules
order by planned_exam_date desc

--e)	Zapytanie zwracaj�ce wynik dzia�ania funkcji agreguj�cej COUNT na polu planned_exam_date tabeli students_modules. 
select count(planned_exam_date) from students_modules

--f)	Zapytanie zwracaj�ce wynik dzia�ania funkcji agreguj�cej COUNT(*) dla tabeli students_modules. 
select count(*) from students_modules

--11.02 (DISTINCT)

--a)	Zapytanie zwracaj�ce identyfikatory student�w wraz z datami przyst�pienia do egzamin�w. Je�li student danego dnia przyst�pi� do wielu egzamin�w, jego identyfikator ma si� pojawi� tylko raz. Dane posortowane malej�co wzgl�dem dat.
select distinct exam_date, student_id from student_grades
order by exam_date desc

--b)	Zapytanie zwracaj�ce identyfikatory student�w, kt�rzy przyst�pili do egzaminu w marcu 2018 roku. Identyfikator ka�dego studenta ma si� pojawi� tylko raz. Dane posortowane malej�co wed�ug identyfikator�w student�w
select distinct student_id from student_grades
where exam_date between '20180301' and '20180331'
order by student_id desc

--11.03
--Spr�buj wykona� zapytanie:
SELECT student_id, surname AS family_name
FROM students
WHERE family_name='Fisher'
--Wyja�nij dlaczego jest ono niepoprawne a nast�pnie je skoryguj.
SELECT student_id, surname AS family_name
FROM students
WHERE surname='Fisher'

--11.04 (SARG)
--Zapytanie zwracaj�ce module_name oraz lecturer_id z tabeli modules z tych rekord�w, dla kt�rych lecturer_id jest r�wny 8 lub NULL.
--Zapytanie napisz dwoma sposobami � raz wykorzystuj�c funkcj� COALESCE (jako drugi parametr przyjmij 0) raz tak, aby predykat podany w warunku WHERE by� SARG.

--1)
select module_name, lecturer_id
from modules
where lecturer_id=8 or coalesce(lecturer_id, 0) = 0
--2)
select module_name, lecturer_id from modules
where lecturer_id is null or lecturer_id = 8

--11.05 Wykorzystaj funkcj� CAST i TRY_CAST jako parametr instrukcji SELECT pr�buj�c zamieni� tekst ABC na liczb� typu INT.
select cast('ABC' as int)
select try_cast('abc' as int)

--11.06 Napisz trzy razy instrukcj� SELECT wykorzystuj�c funkcj� CONVERT zamieniaj�c� dzisiejsz� dat� na tekst. Jako ostatni parametr funkcji CONVERT podaj 101, 102 oraz 103.
select convert(varchar(12), getdate(), 101)
select convert(varchar(12), getdate(), 102)
select convert(varchar(12), getdate(), 103)

--11.07 (LIKE)
--Napisz zapytania z u�yciem operatora LIKE wybieraj�ce nazwy grup (wielko�� liter jest nieistotna):

--a)	zaczynaj�ce si� na DM
select group_no from groups
where group_no like 'DM%'
--b)	niemaj�ce w nazwie ci�gu '10'
select group_no from groups
where group_no not like '%10%'
--c)	kt�rych drugim znakiem jest M
select group_no from groups
where group_no like '_M%'
--d)	kt�rych przedostatnim znakiem jest 0 (zero)
select group_no from groups
where group_no like '%0_'
--e)	kt�rych ostatnim znakiem jest 1 lub 2
select group_no from groups
where group_no like '%[12]'
--f)	kt�rych pierwszym znakiem nie jest litera D
select group_no from groups
where group_no not like 'D%'
--g)	kt�rych drugim znakiem jest dowolna litera z zakresu A-P
select group_no from groups
where group_no like '_[A-P]%'

--11.08 (LIKE i COLLATE)
--Napisz zapytania z u�yciem operatora LIKE i/lub klauzuli COLLATE:

--a)	wybieraj�ce nazwy wyk�ad�w, kt�re w nazwie maj� liter� o (wielko�� liter nie ma znaczenia)
select module_name from modules
where module_name like '%o%'
--b)	wybieraj�ce nazwy wyk�ad�w, kt�re w nazwie maj� du�� liter� O
select module_name from modules
where module_name collate polish_cs_as like '%O%'
--c)	wybieraj�ce nazwy grup, kt�re w nazwie maj� trzeci� liter� i (wielko�� liter nie ma znaczenia)
select group_no from groups
where group_no like '__i%'
--d)	wybieraj�ce nazwy grup, kt�re w nazwie maj� trzeci� liter� ma�e i
select group_no from groups
where group_no collate polish_cs_as like '__i%'

--11.10
--Napisz zapytanie:
select distinct surname
from students
order by group_no
--Skoryguj zapytanie tak, aby zwraca�o nazwiska student�w z tabeli students posortowane wed�ug numeru grupy.
select surname
from students
order by group_no
 
 --11.11 (TOP)
--a)	Napisz zapytanie wybieraj�ce 5 pierwszych rekord�w z tabeli student_grades, kt�re w polu exam_date maj� najdawniejsze daty
select top(5) * from student_grades
order by exam_date asc
--b)	Skoryguj zapytanie z punktu a) dodaj�c klauzul� WITH TIES.
select top(5) with ties * from student_grades
order by exam_date asc

--11.12 (TOP, OFFSET)

--a)	Sprawd�, ile rekord�w jest w tabeli student_grades
select count(*) from student_grades
--b)	Wybierz 20% pocz�tkowych rekord�w z tabeli student_grades. Posortuj wynik wed�ug exam_date.
select top(20) percent * from student_grades
order by exam_date
--c)	Pomi� pierwszych 6 rekord�w i wybierz kolejnych 10 rekord�w z tabeli student_grades. Posortuj wynik wed�ug exam_date.
select * from student_grades
order by exam_date
offset 6 rows fetch next 10 rows only
--d)	Wybierz wszystkie rekordy z tabeli student_grades z pomini�ciem pierwszych 20 (sortowanie wed�ug exam_date).
select * from student_grades
order by exam_date
offset 20 rows

--11.13 (INTERSECT, UNION, EXCEPT)

--a)	Wszystkie nazwiska z tabel students i employees (ka�de ma si� pojawi� tylko raz) posortowane wed�ug nazwisk
select surname from students
union
select surname from employees
order by surname
--b)	Wszystkie nazwiska z tabel students i employees (ka�de ma si� pojawi� tyle razy ile razy wyst�puje w tabelach) posortowane wed�ug nazwisk
select surname from students
union all
select surname from employees
order by surname
--c)	Te nazwiska z tabeli students, kt�re nie wyst�puj� w tabeli employees
select surname from students
except
select surname from employees
order by surname
--d)	Te nazwiska z tabeli students, kt�re wyst�puj� tak�e w tabeli employees
select surname from students
intersect
select surname from employees
order by surname
--e)	Nazwy katedr, kt�rych pracownicy nie s� przypisani jako potencjalni prowadz�cy do �adnego wyk�adu (u�yj operatora EXCEPT)
select department from departments
except
select department from lecturers
--f)	Identyfikatory wyk�ad�w, kt�re nie wyst�puj� jako wyk�ady poprzedzaj�ce 
select module_id from modules
except
select preceding_module from modules
--g)	Te pary id_studenta, id_wykladu z tabeli students_modules, kt�rym nie zosta�a przyznana dotychczas �adna ocena
select student_id, module_id from students_modules
except
select student_id, module_id from student_grades
--h)	Identyfikatory student�w, kt�rzy zapisali si� zar�wno na wyk�ad o identyfikatorze 3 jak i 12
select student_id from students_modules 
where module_id = 3
intersect
select student_id from students_modules 
where module_id = 12
--i)	Nazwiska i imiona student�w wraz z numerami grup, zapisanych do grup o nazwach zaczynaj�cych si� na DMIe oraz nazwiska i imiona wyk�adowc�w wraz z nazwami katedr, w kt�rych pracuj�. Ostatnia kolumna ma mie� nazw� group_department. Dane posortowane rosn�co wed�ug ostatniej kolumny.
select surname, first_name, group_no as group_department  from students
where group_no collate polish_cs_as  like 'DMIe%'
union
select e.surname, e.first_name, l.department from lecturers l
join employees e on l.lecturer_id = e.employee_id
order by group_department

