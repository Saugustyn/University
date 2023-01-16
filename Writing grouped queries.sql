--4a.01
--Liczba student�w zarejestrowanych w bazie danych.
select count(*) from students

--4a.02
--Liczba student�w, kt�rzy s� przypisani do jakiej� grupy.
select count(*) from students
where group_no is not null

--4a.03
--Liczba student�w, kt�rzy nie s� przypisani do �adnej grupy.
select count(*) from students
where group_no is null

--4a.04
--Liczba grup, do kt�rych jest przypisany co najmniej jeden student.
select count(distinct group_no) from students

--4a.05
--Nazwy grup, do kt�rych zapisany jest przynajmniej jeden student wraz z liczb� student�w zapisanych do ka�dej grupy. 
--Kolumna zwracaj�ca liczb� student�w ma mie� nazw� no_of_students. Dane posortowane rosn�co wed�ug liczby student�w.
select group_no, count(student_id) as no_of_students  from students
group by group_no
having count(student_id) > 0 and group_no is not null
order by no_of_students asc

--4a.06
--Nazwy grup, do kt�rych zapisanych jest przynajmniej trzech student�w wraz z liczb� tych student�w. Kolumna zwracaj�ca liczb� student�w ma mie� nazw� no_of_students. Dane posortowane rosn�co wed�ug liczby student�w.
select group_no, count(*) as no_of_students  from students
group by group_no
having count(*) > 2 and group_no is not null
order by no_of_students asc

--4a.07
--Wszystkie mo�liwe oceny oraz ile razy ka�da z ocen zosta�a przyznana (kolumna ma mie� nazw� no_of_grades). Dane posortowane wed�ug ocen.
select g.grade, count(sg.student_id) as no_of_grades  from grades g
left join student_grades sg on g.grade = sg.grade
group by g.grade

--4a.08
--Nazwy wszystkich katedr oraz ile godzin wyk�ad�w w sumie maj� pracownicy zatrudnieni w  tych katedrach. Kolumna zwracaj�ca liczb� godzin ma mie� nazw� total_hours. Dane posortowane rosn�co wed�ug kolumny total_hours.
select d.department, sum(m.no_of_hours) as total_hours  from departments d
left join lecturers l on d.department = l.department
left join modules m on m.lecturer_id = l.lecturer_id
group by d.department
order by total_hours asc

--4a.09
--Nazwisko ka�dego wyk�adowcy wraz z liczb� prowadzonych przez niego wyk�ad�w. Kolumna zawieraj�ca liczb� wyk�ad�w ma mie� nazw� no_of_modules. Dane posortowane malej�co wed�ug nazwiska.
select e.surname, count(module_id) as no_of_modules from lecturers l
left join modules m on l.lecturer_id = m.lecturer_id
join employees e on l.lecturer_id = e.employee_id
group by e.surname, l.lecturer_id
order by e.surname desc

--4a.10
--Nazwiska i imiona wyk�adowc�w prowadz�cych co najmniej dwa wyk�ady wraz z liczb� prowadzonych przez nich wyk�ad�w. Dane posortowane malej�co wed�ug liczby wyk�ad�w a nast�pnie rosn�co wed�ug nazwiska.
select e.surname, count(module_id) as no_of_modules from lecturers l
left join modules m on l.lecturer_id = m.lecturer_id
join employees e on l.lecturer_id = e.employee_id
group by e.surname, l.lecturer_id
having count(module_id) >1
order by no_of_modules desc  ,e.surname asc

--4a.11
--Nazwiska i imiona wszystkich student�w o nazwisku Bowen, kt�rzy otrzymali przynajmniej jedn� ocen� wraz ze �redni� ocen (ka�dego Bowena z osobna). 
--Kolumna zwracaj�ca �redni� ma mie� nazw� avg_grade. Dane posortowane malej�co wed�ug nazwisk i malej�co wed�ug imion.

select s.surname, s.first_name, avg(grade) from students s
join student_grades sg on s.student_id = sg.student_id
where s.surname = 'Bowen'
group by s.surname, s.first_name
order by surname, first_name desc

--4a.12
--Nazwiska i imiona wyk�adowc�w, kt�rzy prowadz� co najmniej jeden wyk�ad wraz ze �redni� ocen jakie dali studentom (je�li wyk�adowca nie da� do tej pory �adnej oceny, tak�e ma si� pojawi� na li�cie). 
--Kolumna zwracaj�ca �redni� ma mie� nazw� avg_grade. Dane posortowane malej�co wed�ug �redniej.
select e.first_name, e.surname, avg(grade) from employees e
join modules m on e.employee_id = m.lecturer_id
left join student_grades sg on m.module_id = sg.module_id
group by e.employee_id, e.first_name, e.surname
order by avg(grade) desc

--4a.13a
--Nazwy wyk�ad�w oraz kwot�, jak� uczelnia musi przygotowa� na wyp�aty pracownikom prowadz�cym wyk�ady ze Statistics i Economics (osobno). 
--Je�li jest wiele wyk�ad�w o nazwie Statistics lub Economics, suma dla nich ma by� obliczona ��cznie. Zapytanie ma wi�c zwr�ci� dwa rekordy (jeden dla wyk�ad�w ze Statistics, drugi dla Economics).
--Kwot� za jeden wyk�ad nale�y obliczy� jako iloczyn stawki godzinowej prowadz�cego wyk�adowcy oraz liczby godzin przeznaczonych na wyk�ad.
select module_name, sum(no_of_hours * overtime_rate) from modules m
join lecturers l on m.lecturer_id = l.lecturer_id
join acad_positions a on l.acad_position = a.acad_position
where module_name in('Statistics', 'Economics')
group by module_name

--4a.14a
--Sumaryczn� kwot�, jak� uczelnia musi wyp�aci� wyk�adowcom ��cznie z tytu�u prowadzenia przez nich wyk�ad�w.
select sum(no_of_hours * overtime_rate) from modules m
join lecturers l on m.lecturer_id = l.lecturer_id
join acad_positions a on l.acad_position = a.acad_position

--4a.13c
--Kwot�, jak� uczelnia musi przygotowa� na wyp�aty z tytu�u prowadzenia wyk�ad�w, kt�rym nie jest przypisany �aden wyk�adowca, 
--przy za�o�eniu, �e za godzin� takiego wyk�adu nale�y zap�aci� �redni� z pola overtime_rate w tabeli acad_positions.
select
(select sum(no_of_hours) from modules
where lecturer_id is null)
*
(select avg(overtime_rate) from acad_positions)
--4a.13d
--Kwot�, jak� uczelnia musi przygotowa� na wyp�aty z tytu�u prowadzenia wszystkich wyk�ad�w, za kt�re nie mo�na ustali� stawki godzinowej. 
--Przyjmij za�o�enie, �e za godzin� takiego wyk�adu nale�y zap�aci� maksymaln� warto�� z pola overtime_rate w tabeli acad_positions.
select
(select sum(no_of_hours) from modules m
left join lecturers l on m.lecturer_id = l.lecturer_id
where m.lecturer_id is null or acad_position is null)
*
(select max(overtime_rate) from acad_positions)
--4a.14
--Nazwiska i imiona wyk�adowc�w wraz z sumaryczn� liczb� godzin wyk�ad�w prowadzonych przez ka�dego z nich z osobna ale tylko w przypadku, gdy suma godzin prowadzonych wyk�ad�w jest wi�ksza od 30. 
--Kolumna zwracaj�ca liczb� godzin ma mie� nazw� no_of_hours. Dane posortowane malej�co wed�ug liczby godzin.
select e.surname, e.first_name, sum(no_of_hours) as no_of_hours  from employees e
join modules m on e.employee_id = m.lecturer_id
group by m.lecturer_id, e.surname, e.first_name
having sum(no_of_hours) > 30
order by sum(no_of_hours) desc

--4a.15
--Nazwy wszystkich grup oraz liczb� student�w zapisanych do ka�dej grupy (kolumna ma mie� nazw� no_of_students). Dane posortowane rosn�co wed�ug liczby student�w a nast�pnie numeru grupy.
select g.group_no, count(s.student_id) from groups g
left join students s on g.group_no = s.group_no
group by g.group_no
order by count(s.student_id), g.group_no asc

--4a.16
--Nazwy wszystkich wyk�ad�w, kt�rych nazwa zaczyna si� liter� A oraz �redni� ocen ze wszystkich tych wyk�ad�w osobno (je�li jest wiele takich wyk�ad�w, to �rednia ma by� obliczona dla ka�dego z nich oddzielnie). 
--Je�li z danego wyk�adu nie ma �adnej oceny, tak�e powinien on pojawi� si� na li�cie. Kolumna ma mie� nazw� average.
select m.module_name, avg(grade) from modules m
left join student_grades sg on m.module_id = sg.module_id
where m.module_name like 'a%'
group by  m.module_name

--4a.17
--Nazwy grup, do kt�rych jest zapisanych co najmniej dw�ch student�w, liczba student�w zapisanych do tych grup (kolumna ma mie� nazw� no_of_students) oraz �rednie ocen dla ka�dej grupy (kolumna ma mie� nazw� average_grade). 
--Dane posortowane malej�co wed�ug �redniej.
select group_no, count(s.student_id), avg(grade) from students s
join student_grades sg on s.student_id = sg.student_id
group by group_no
having count(s.student_id) >= 2
order by avg(grade) desc

--4a.18
--Nazwy tych katedr (department), w kt�rych pracuje co najmniej 2 doktor�w (doctor) wraz z liczb� doktor�w pracuj�cych w tych katedrach (ta ostatnia kolumna ma mie� nazw� no_of_doctors). 
--Dane posortowane malej�co wed�ug liczby doktor�w i rosn�co wed�ug nazw katedr.
select department, count(*) from lecturers
where acad_position = 'doctor'
group by department
having count(*) >= 2

--4a.19
--Identyfikatory, nazwy wyk�ad�w oraz nazwy katedr odpowiedzialnych za prowadzenie wyk�ad�w, dla kt�rych nie mo�na ustali� kwoty, jak� trzeba zap�aci� za ich przeprowadzenie 
--wraz z nazwiskiem i imieniem dowolnego spo�r�d pracownik�w tych katedr. Dane posortowane wed�ug module_id.
select module_id, module_name, m.department, 
min(concat(surname,' ',first_name)) as lecturer_name
from modules m join lecturers l 
on m.department=l.department
join employees on l.lecturer_id=employee_id
where m.lecturer_id is null
group by module_id, module_name, m.department
order by module_id
