--12.01
--Identyfikatory i nazwy wyk³adów na które nie zosta³ zapisany ¿aden student. Dane posortowane malej¹co wed³ug nazw wyk³adów
select m.module_id, module_name from modules m
left join students_modules sm on sm.module_id = m.module_id
where sm.module_id is null
order by m.module_id desc

--12.02
--Identyfikatory i nazwy wyk³adów oraz nazwiska wyk³adowców prowadz¹cych wyk³ady, na które nie zapisa³ siê ¿aden student.
select m.module_id, module_name, e.surname from modules m
left join students_modules sm on sm.module_id = m.module_id
join employees e on m.lecturer_id = e.employee_id
where sm.module_id is null

--12.03
--Identyfikatory (pod nazw¹ lecturer_id) i nazwiska wszystkich wyk³adowców wraz z nazwami wyk³adów, które prowadz¹. Dane posortowane rosn¹co wed³ug nazwisk.
select l.lecturer_id, surname, module_name from employees e
join lecturers l on e.employee_id = l.lecturer_id
left join modules m on l.lecturer_id = m.lecturer_id
order by surname asc

--12.04
--Identyfikatory, nazwiska i imiona pracowników, którzy s¹ wyk³adowcami.
select lecturer_id, surname, first_name from employees e
join lecturers l on e.employee_id = l.lecturer_id

--12.05
--Identyfikatory, nazwiska i imiona pracowników, którzy nie s¹ wyk³adowcami.

select lecturer_id, surname, first_name from employees e
left join lecturers l on e.employee_id = l.lecturer_id
where l.lecturer_id is null

--12.06
--Identyfikatory, imiona, nazwiska i numery grup studentów, którzy nie s¹ zapisani na ¿aden wyk³ad. Dane posortowane rosn¹co wed³ug nazwisk i imion.
select s.student_id, first_name, surname, group_no from students s 
left join students_modules sm on s.student_id = sm.student_id
where sm.student_id is null
order by surname, first_name asc

--12.07
--Nazwiska, imiona i identyfikatory studentów, którzy przyst¹pili do egzaminu co najmniej raz oraz daty egzaminów. 
--Jeœli student danego dnia przyst¹pi³ do wielu egzaminów, jego dane maj¹ siê pojawiæ tylko raz. Dane posortowane rosn¹co wzglêdem dat.

select distinct s.surname, s.first_name, s.student_id, exam_date from student_grades sg
join students s on sg.student_id = s.student_id
order by exam_date asc

--12.08
--Nazwy wszystkich wyk³adów, liczby godzin przewidziane na ka¿dy z nich oraz identyfikatory, nazwiska i imiona prowadz¹cych. Dane posortowane rosn¹co wed³ug nazw wyk³adów a nastêpnie nazwisk i imion prowadz¹cych.
select module_name, no_of_hours, employee_id, surname, first_name from modules m
left join employees e on m.lecturer_id = e.employee_id
order by module_name, surname, first_name asc

--12.09
--Identyfikatory, nazwiska i imiona studentów zapisanych na wyk³ad z Statistics, posortowane rosn¹co wed³ug nazwiska i imienia.
select s.student_id, surname, first_name from students s
join students_modules sm on s.student_id = sm.student_id
join modules m on sm.module_id = m.module_id
where module_name = 'Statistics'
order by surname, first_name asc

--12.10
--Nazwiska, imiona i stopnie/tytu³y naukowe pracowników Department of Informatics. Dane posortowane rosn¹co wed³ug nazwisk i imion.
select surname, first_name, acad_position from lecturers l
join employees e on l.lecturer_id = e.employee_id
where department = 'Department of Informatics'
order by surname, first_name asc

--12.11
--Nazwiska i imiona wszystkich pracowników, a dla tych, którzy s¹ wyk³adowcami tak¿e nazwy katedr. Dane posortowane rosn¹co wed³ug nazwisk oraz malej¹co wed³ug imion.
select surname, first_name, department from employees e
left join lecturers l on e.employee_id = l.lecturer_id
order by surname asc, first_name desc

--12.12
--Nazwiska i imiona wszystkich wyk³adowców wraz z nazwami katedr, w których pracuj¹. Dane posortowane rosn¹co wed³ug nazwisk oraz malej¹co wed³ug imion.
select surname, first_name, department from lecturers l
join employees e on l.lecturer_id = e.employee_id
order by surname asc, first_name desc

--12.13
--Identyfikatory, nazwiska, imiona i stopnie/tytu³y naukowe wyk³adowców, którzy nie prowadz¹ ¿adnego wyk³adu. Dane posortowane malej¹co wed³ug stopni naukowych.
select employee_id, surname, first_name, acad_position from employees e
join lecturers l on e.employee_id = l.lecturer_id
left join modules m on l.lecturer_id = m.lecturer_id
where m.lecturer_id is null
order by acad_position desc

--12.14
--Imiona i nazwiska wszystkich studentów, nazwy wyk³adów, na które s¹ zapisani, nazwiska prowadz¹cych te wyk³ady (pole ma mieæ nazwê lecturer_surname) oraz nazwy katedr, w których ka¿dy z wyk³adowców pracuje. 
--Dane posortowane malej¹co wed³ug nazw wyk³adów a nastêpnie rosn¹co wed³ug nazwisk wyk³adowców.

select s.surname, s.first_name, module_name, 
e.surname as lecturer_surname, l.department
from students s left join 
(((students_modules sm  join modules m on sm.module_id=m.module_id)
left join lecturers l on l.lecturer_id=m.lecturer_id)
left join employees e on l.lecturer_id=employee_id) 
on s.student_id=sm.student_id
order by module_name desc, e.surname

--12.15
--Liczba godzin wyk³adów, dla których nie da siê ustaliæ kwoty, jak¹ trzeba zap³aciæ za ich przeprowadzenie.
select sum(no_of_hours) from modules m
left join lecturers l on m.lecturer_id = l.lecturer_id
where m.lecturer_id is null or l.acad_position is null

--12.16
--Identyfikatory, nazwy wyk³adów oraz nazwy katedr odpowiedzialnych za prowadzenie wyk³adów, dla których nie mo¿na ustaliæ kwoty, jak¹ trzeba zap³aciæ za ich przeprowadzenie.
select m.module_id, m.module_name, l.department from modules m
left join lecturers l on m.lecturer_id = l.lecturer_id
where m.lecturer_id is null or l.acad_position is null

--12.17
--Nazwy wszystkich wyk³adów, których nazwa zaczyna siê od s³owa computer (z uwzglêdnieniem wielkoœci liter – wszystkie litery ma³e) 
--oraz liczbê godzin przewidzianych na ka¿dy z tych wyk³adów, nazwiska prowadz¹cych i nazwy katedr, w których pracuj¹. Dane posortowane malej¹co wed³ug nazwisk.
select m.module_name, m.no_of_hours, e.surname, l.department from modules m
left join lecturers l on m.lecturer_id = l.lecturer_id
join employees e on l.lecturer_id = e.employee_id
where m.module_name  collate polish_cs_as like 'computer%'
order by surname desc

--12.18
--Nazwy wszystkich wyk³adów, których nazwa zaczyna siê od s³owa Computer (z uwzglêdnieniem wielkoœci liter – pierwsza litera du¿a) 
--oraz liczbê godzin przewidzianych na ka¿dy z tych wyk³adów, nazwiska prowadz¹cych i nazwy katedr, w których pracuj¹. Dane posortowane malej¹co wed³ug nazwisk.
select m.module_name, m.no_of_hours, e.surname, l.department from modules m
left join lecturers l on m.lecturer_id = l.lecturer_id
left join employees e on l.lecturer_id = e.employee_id
where m.module_name  collate polish_cs_as like 'Computer%'
order by surname desc

--12.19
--Identyfikatory i nazwiska studentów, którzy nie otrzymali dotychczas oceny z wyk³adów, na które siê zapisali wraz z nazwami tych wyk³adów 
--(dane ka¿dego studenta maj¹ siê pojawiæ tyle razy z ilu wyk³adów nie otrzymali oceny). Dane posortowane rosn¹co wed³ug identyfikatorów studentów.
select s.student_id, surname, module_name from students_modules sm
left join student_grades sg on sm.student_id = sg.student_id and sm.module_id = sg.module_id
join students s on sm.student_id = s.student_id
join modules m on sm.module_id = m.module_id
where sg.student_id is null
order by surname asc
--12.20
--Identyfikatory i nazwiska studentów, którzy otrzymali oceny z wyk³adów, na które siê zapisali wraz z nazwami tych wyk³adów i otrzymanymi ocenami 
--(dane ka¿dego studenta maj¹ siê pojawiæ tyle razy z ilu wyk³adów nie otrzymali oceny). Dane posortowane rosn¹co wed³ug identyfikatorów studentów i nazw wyk³adów a nastêpnie malej¹co wed³ug otrzymanych ocen.
select s.student_id, surname, module_name, grade from students_modules sm
join student_grades sg on sm.student_id = sg.student_id and sm.module_id = sg.module_id
join students s on sm.student_id = s.student_id
join modules m on sm.module_id = m.module_id
order by surname asc, grade desc

--12.21
--W polu department tabeli modules przechowywana jest informacja, która katedra jest odpowiedzialna za prowadzenie ka¿dego z wyk³adów.
--Napisz zapytanie, które zwróci nazwy wyk³adów, które s¹ prowadzone przez wyk³adowcê, który nie jest pracownikiem katedry odpowiedzialnej za dany wyk³ad.
select module_name from modules m
join lecturers l on m.lecturer_id = l.lecturer_id
where m.department != l.department

--12.22
--Nazwiska, imiona i PESELe wyk³adowców, którzy prowadz¹ przynajmniej jeden wyk³ad wraz z nazwami prowadzonych przez nich wyk³adów i napisem „wykladowca” w ostatniej kolumnie 
--oraz nazwiska, imiona, numery grup wszystkich studentów wraz z nazwami wyk³adów na które siê zapisali i napisem „student” w ostatniej kolumnie. 
--Trzecia kolumna ma mieæ nazwê pesel/grupa a ostatnia student/wykladowca.
--Dane posortowane rosn¹co wed³ug nazw wyk³adów a nastêpnie wed³ug kolumny student/wykladowca.
select surname, first_name, PESEL as "pesel/grupa", module_name, 'wykladowca' as "student/wykladowca" from employees e
join modules m on e.employee_id = m.lecturer_id
union
select surname, first_name, group_no,module_name ,'student' 
from students s left join (students_modules sm 
join modules m on sm.module_id = m.module_id) on s.student_id = sm.student_id
order by module_name, [student/wykladowca] asc







