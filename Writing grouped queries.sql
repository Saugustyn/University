--4a.01
--Liczba studentów zarejestrowanych w bazie danych.
select count(*) from students

--4a.02
--Liczba studentów, którzy s¹ przypisani do jakiejœ grupy.
select count(*) from students
where group_no is not null

--4a.03
--Liczba studentów, którzy nie s¹ przypisani do ¿adnej grupy.
select count(*) from students
where group_no is null

--4a.04
--Liczba grup, do których jest przypisany co najmniej jeden student.
select count(distinct group_no) from students

--4a.05
--Nazwy grup, do których zapisany jest przynajmniej jeden student wraz z liczb¹ studentów zapisanych do ka¿dej grupy. 
--Kolumna zwracaj¹ca liczbê studentów ma mieæ nazwê no_of_students. Dane posortowane rosn¹co wed³ug liczby studentów.
select group_no, count(student_id) as no_of_students  from students
group by group_no
having count(student_id) > 0 and group_no is not null
order by no_of_students asc

--4a.06
--Nazwy grup, do których zapisanych jest przynajmniej trzech studentów wraz z liczb¹ tych studentów. Kolumna zwracaj¹ca liczbê studentów ma mieæ nazwê no_of_students. Dane posortowane rosn¹co wed³ug liczby studentów.
select group_no, count(*) as no_of_students  from students
group by group_no
having count(*) > 2 and group_no is not null
order by no_of_students asc

--4a.07
--Wszystkie mo¿liwe oceny oraz ile razy ka¿da z ocen zosta³a przyznana (kolumna ma mieæ nazwê no_of_grades). Dane posortowane wed³ug ocen.
select g.grade, count(sg.student_id) as no_of_grades  from grades g
left join student_grades sg on g.grade = sg.grade
group by g.grade

--4a.08
--Nazwy wszystkich katedr oraz ile godzin wyk³adów w sumie maj¹ pracownicy zatrudnieni w  tych katedrach. Kolumna zwracaj¹ca liczbê godzin ma mieæ nazwê total_hours. Dane posortowane rosn¹co wed³ug kolumny total_hours.
select d.department, sum(m.no_of_hours) as total_hours  from departments d
left join lecturers l on d.department = l.department
left join modules m on m.lecturer_id = l.lecturer_id
group by d.department
order by total_hours asc

--4a.09
--Nazwisko ka¿dego wyk³adowcy wraz z liczb¹ prowadzonych przez niego wyk³adów. Kolumna zawieraj¹ca liczbê wyk³adów ma mieæ nazwê no_of_modules. Dane posortowane malej¹co wed³ug nazwiska.
select e.surname, count(module_id) as no_of_modules from lecturers l
left join modules m on l.lecturer_id = m.lecturer_id
join employees e on l.lecturer_id = e.employee_id
group by e.surname, l.lecturer_id
order by e.surname desc

--4a.10
--Nazwiska i imiona wyk³adowców prowadz¹cych co najmniej dwa wyk³ady wraz z liczb¹ prowadzonych przez nich wyk³adów. Dane posortowane malej¹co wed³ug liczby wyk³adów a nastêpnie rosn¹co wed³ug nazwiska.
select e.surname, count(module_id) as no_of_modules from lecturers l
left join modules m on l.lecturer_id = m.lecturer_id
join employees e on l.lecturer_id = e.employee_id
group by e.surname, l.lecturer_id
having count(module_id) >1
order by no_of_modules desc  ,e.surname asc

--4a.11
--Nazwiska i imiona wszystkich studentów o nazwisku Bowen, którzy otrzymali przynajmniej jedn¹ ocenê wraz ze œredni¹ ocen (ka¿dego Bowena z osobna). 
--Kolumna zwracaj¹ca œredni¹ ma mieæ nazwê avg_grade. Dane posortowane malej¹co wed³ug nazwisk i malej¹co wed³ug imion.

select s.surname, s.first_name, avg(grade) from students s
join student_grades sg on s.student_id = sg.student_id
where s.surname = 'Bowen'
group by s.surname, s.first_name
order by surname, first_name desc

--4a.12
--Nazwiska i imiona wyk³adowców, którzy prowadz¹ co najmniej jeden wyk³ad wraz ze œredni¹ ocen jakie dali studentom (jeœli wyk³adowca nie da³ do tej pory ¿adnej oceny, tak¿e ma siê pojawiæ na liœcie). 
--Kolumna zwracaj¹ca œredni¹ ma mieæ nazwê avg_grade. Dane posortowane malej¹co wed³ug œredniej.
select e.first_name, e.surname, avg(grade) from employees e
join modules m on e.employee_id = m.lecturer_id
left join student_grades sg on m.module_id = sg.module_id
group by e.employee_id, e.first_name, e.surname
order by avg(grade) desc

--4a.13a
--Nazwy wyk³adów oraz kwotê, jak¹ uczelnia musi przygotowaæ na wyp³aty pracownikom prowadz¹cym wyk³ady ze Statistics i Economics (osobno). 
--Jeœli jest wiele wyk³adów o nazwie Statistics lub Economics, suma dla nich ma byæ obliczona ³¹cznie. Zapytanie ma wiêc zwróciæ dwa rekordy (jeden dla wyk³adów ze Statistics, drugi dla Economics).
--Kwotê za jeden wyk³ad nale¿y obliczyæ jako iloczyn stawki godzinowej prowadz¹cego wyk³adowcy oraz liczby godzin przeznaczonych na wyk³ad.
select module_name, sum(no_of_hours * overtime_rate) from modules m
join lecturers l on m.lecturer_id = l.lecturer_id
join acad_positions a on l.acad_position = a.acad_position
where module_name in('Statistics', 'Economics')
group by module_name

--4a.14a
--Sumaryczn¹ kwotê, jak¹ uczelnia musi wyp³aciæ wyk³adowcom ³¹cznie z tytu³u prowadzenia przez nich wyk³adów.
select sum(no_of_hours * overtime_rate) from modules m
join lecturers l on m.lecturer_id = l.lecturer_id
join acad_positions a on l.acad_position = a.acad_position

--4a.13c
--Kwotê, jak¹ uczelnia musi przygotowaæ na wyp³aty z tytu³u prowadzenia wyk³adów, którym nie jest przypisany ¿aden wyk³adowca, 
--przy za³o¿eniu, ¿e za godzinê takiego wyk³adu nale¿y zap³aciæ œredni¹ z pola overtime_rate w tabeli acad_positions.
select
(select sum(no_of_hours) from modules
where lecturer_id is null)
*
(select avg(overtime_rate) from acad_positions)
--4a.13d
--Kwotê, jak¹ uczelnia musi przygotowaæ na wyp³aty z tytu³u prowadzenia wszystkich wyk³adów, za które nie mo¿na ustaliæ stawki godzinowej. 
--Przyjmij za³o¿enie, ¿e za godzinê takiego wyk³adu nale¿y zap³aciæ maksymaln¹ wartoœæ z pola overtime_rate w tabeli acad_positions.
select
(select sum(no_of_hours) from modules m
left join lecturers l on m.lecturer_id = l.lecturer_id
where m.lecturer_id is null or acad_position is null)
*
(select max(overtime_rate) from acad_positions)
--4a.14
--Nazwiska i imiona wyk³adowców wraz z sumaryczn¹ liczb¹ godzin wyk³adów prowadzonych przez ka¿dego z nich z osobna ale tylko w przypadku, gdy suma godzin prowadzonych wyk³adów jest wiêksza od 30. 
--Kolumna zwracaj¹ca liczbê godzin ma mieæ nazwê no_of_hours. Dane posortowane malej¹co wed³ug liczby godzin.
select e.surname, e.first_name, sum(no_of_hours) as no_of_hours  from employees e
join modules m on e.employee_id = m.lecturer_id
group by m.lecturer_id, e.surname, e.first_name
having sum(no_of_hours) > 30
order by sum(no_of_hours) desc

--4a.15
--Nazwy wszystkich grup oraz liczbê studentów zapisanych do ka¿dej grupy (kolumna ma mieæ nazwê no_of_students). Dane posortowane rosn¹co wed³ug liczby studentów a nastêpnie numeru grupy.
select g.group_no, count(s.student_id) from groups g
left join students s on g.group_no = s.group_no
group by g.group_no
order by count(s.student_id), g.group_no asc

--4a.16
--Nazwy wszystkich wyk³adów, których nazwa zaczyna siê liter¹ A oraz œredni¹ ocen ze wszystkich tych wyk³adów osobno (jeœli jest wiele takich wyk³adów, to œrednia ma byæ obliczona dla ka¿dego z nich oddzielnie). 
--Jeœli z danego wyk³adu nie ma ¿adnej oceny, tak¿e powinien on pojawiæ siê na liœcie. Kolumna ma mieæ nazwê average.
select m.module_name, avg(grade) from modules m
left join student_grades sg on m.module_id = sg.module_id
where m.module_name like 'a%'
group by  m.module_name

--4a.17
--Nazwy grup, do których jest zapisanych co najmniej dwóch studentów, liczba studentów zapisanych do tych grup (kolumna ma mieæ nazwê no_of_students) oraz œrednie ocen dla ka¿dej grupy (kolumna ma mieæ nazwê average_grade). 
--Dane posortowane malej¹co wed³ug œredniej.
select group_no, count(s.student_id), avg(grade) from students s
join student_grades sg on s.student_id = sg.student_id
group by group_no
having count(s.student_id) >= 2
order by avg(grade) desc

--4a.18
--Nazwy tych katedr (department), w których pracuje co najmniej 2 doktorów (doctor) wraz z liczb¹ doktorów pracuj¹cych w tych katedrach (ta ostatnia kolumna ma mieæ nazwê no_of_doctors). 
--Dane posortowane malej¹co wed³ug liczby doktorów i rosn¹co wed³ug nazw katedr.
select department, count(*) from lecturers
where acad_position = 'doctor'
group by department
having count(*) >= 2

--4a.19
--Identyfikatory, nazwy wyk³adów oraz nazwy katedr odpowiedzialnych za prowadzenie wyk³adów, dla których nie mo¿na ustaliæ kwoty, jak¹ trzeba zap³aciæ za ich przeprowadzenie 
--wraz z nazwiskiem i imieniem dowolnego spoœród pracowników tych katedr. Dane posortowane wed³ug module_id.
select module_id, module_name, m.department, 
min(concat(surname,' ',first_name)) as lecturer_name
from modules m join lecturers l 
on m.department=l.department
join employees on l.lecturer_id=employee_id
where m.lecturer_id is null
group by module_id, module_name, m.department
order by module_id
