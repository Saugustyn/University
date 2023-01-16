--12.01
--Identyfikatory i nazwy wyk�ad�w na kt�re nie zosta� zapisany �aden student. Dane posortowane malej�co wed�ug nazw wyk�ad�w
select m.module_id, module_name from modules m
left join students_modules sm on sm.module_id = m.module_id
where sm.module_id is null
order by m.module_id desc

--12.02
--Identyfikatory i nazwy wyk�ad�w oraz nazwiska wyk�adowc�w prowadz�cych wyk�ady, na kt�re nie zapisa� si� �aden student.
select m.module_id, module_name, e.surname from modules m
left join students_modules sm on sm.module_id = m.module_id
join employees e on m.lecturer_id = e.employee_id
where sm.module_id is null

--12.03
--Identyfikatory (pod nazw� lecturer_id) i nazwiska wszystkich wyk�adowc�w wraz z nazwami wyk�ad�w, kt�re prowadz�. Dane posortowane rosn�co wed�ug nazwisk.
select l.lecturer_id, surname, module_name from employees e
join lecturers l on e.employee_id = l.lecturer_id
left join modules m on l.lecturer_id = m.lecturer_id
order by surname asc

--12.04
--Identyfikatory, nazwiska i imiona pracownik�w, kt�rzy s� wyk�adowcami.
select lecturer_id, surname, first_name from employees e
join lecturers l on e.employee_id = l.lecturer_id

--12.05
--Identyfikatory, nazwiska i imiona pracownik�w, kt�rzy nie s� wyk�adowcami.

select lecturer_id, surname, first_name from employees e
left join lecturers l on e.employee_id = l.lecturer_id
where l.lecturer_id is null

--12.06
--Identyfikatory, imiona, nazwiska i numery grup student�w, kt�rzy nie s� zapisani na �aden wyk�ad. Dane posortowane rosn�co wed�ug nazwisk i imion.
select s.student_id, first_name, surname, group_no from students s 
left join students_modules sm on s.student_id = sm.student_id
where sm.student_id is null
order by surname, first_name asc

--12.07
--Nazwiska, imiona i identyfikatory student�w, kt�rzy przyst�pili do egzaminu co najmniej raz oraz daty egzamin�w. 
--Je�li student danego dnia przyst�pi� do wielu egzamin�w, jego dane maj� si� pojawi� tylko raz. Dane posortowane rosn�co wzgl�dem dat.

select distinct s.surname, s.first_name, s.student_id, exam_date from student_grades sg
join students s on sg.student_id = s.student_id
order by exam_date asc

--12.08
--Nazwy wszystkich wyk�ad�w, liczby godzin przewidziane na ka�dy z nich oraz identyfikatory, nazwiska i imiona prowadz�cych. Dane posortowane rosn�co wed�ug nazw wyk�ad�w a nast�pnie nazwisk i imion prowadz�cych.
select module_name, no_of_hours, employee_id, surname, first_name from modules m
left join employees e on m.lecturer_id = e.employee_id
order by module_name, surname, first_name asc

--12.09
--Identyfikatory, nazwiska i imiona student�w zapisanych na wyk�ad z Statistics, posortowane rosn�co wed�ug nazwiska i imienia.
select s.student_id, surname, first_name from students s
join students_modules sm on s.student_id = sm.student_id
join modules m on sm.module_id = m.module_id
where module_name = 'Statistics'
order by surname, first_name asc

--12.10
--Nazwiska, imiona i stopnie/tytu�y naukowe pracownik�w Department of Informatics. Dane posortowane rosn�co wed�ug nazwisk i imion.
select surname, first_name, acad_position from lecturers l
join employees e on l.lecturer_id = e.employee_id
where department = 'Department of Informatics'
order by surname, first_name asc

--12.11
--Nazwiska i imiona wszystkich pracownik�w, a dla tych, kt�rzy s� wyk�adowcami tak�e nazwy katedr. Dane posortowane rosn�co wed�ug nazwisk oraz malej�co wed�ug imion.
select surname, first_name, department from employees e
left join lecturers l on e.employee_id = l.lecturer_id
order by surname asc, first_name desc

--12.12
--Nazwiska i imiona wszystkich wyk�adowc�w wraz z nazwami katedr, w kt�rych pracuj�. Dane posortowane rosn�co wed�ug nazwisk oraz malej�co wed�ug imion.
select surname, first_name, department from lecturers l
join employees e on l.lecturer_id = e.employee_id
order by surname asc, first_name desc

--12.13
--Identyfikatory, nazwiska, imiona i stopnie/tytu�y naukowe wyk�adowc�w, kt�rzy nie prowadz� �adnego wyk�adu. Dane posortowane malej�co wed�ug stopni naukowych.
select employee_id, surname, first_name, acad_position from employees e
join lecturers l on e.employee_id = l.lecturer_id
left join modules m on l.lecturer_id = m.lecturer_id
where m.lecturer_id is null
order by acad_position desc

--12.14
--Imiona i nazwiska wszystkich student�w, nazwy wyk�ad�w, na kt�re s� zapisani, nazwiska prowadz�cych te wyk�ady (pole ma mie� nazw� lecturer_surname) oraz nazwy katedr, w kt�rych ka�dy z wyk�adowc�w pracuje. 
--Dane posortowane malej�co wed�ug nazw wyk�ad�w a nast�pnie rosn�co wed�ug nazwisk wyk�adowc�w.

select s.surname, s.first_name, module_name, 
e.surname as lecturer_surname, l.department
from students s left join 
(((students_modules sm  join modules m on sm.module_id=m.module_id)
left join lecturers l on l.lecturer_id=m.lecturer_id)
left join employees e on l.lecturer_id=employee_id) 
on s.student_id=sm.student_id
order by module_name desc, e.surname

--12.15
--Liczba godzin wyk�ad�w, dla kt�rych nie da si� ustali� kwoty, jak� trzeba zap�aci� za ich przeprowadzenie.
select sum(no_of_hours) from modules m
left join lecturers l on m.lecturer_id = l.lecturer_id
where m.lecturer_id is null or l.acad_position is null

--12.16
--Identyfikatory, nazwy wyk�ad�w oraz nazwy katedr odpowiedzialnych za prowadzenie wyk�ad�w, dla kt�rych nie mo�na ustali� kwoty, jak� trzeba zap�aci� za ich przeprowadzenie.
select m.module_id, m.module_name, l.department from modules m
left join lecturers l on m.lecturer_id = l.lecturer_id
where m.lecturer_id is null or l.acad_position is null

--12.17
--Nazwy wszystkich wyk�ad�w, kt�rych nazwa zaczyna si� od s�owa computer (z uwzgl�dnieniem wielko�ci liter � wszystkie litery ma�e) 
--oraz liczb� godzin przewidzianych na ka�dy z tych wyk�ad�w, nazwiska prowadz�cych i nazwy katedr, w kt�rych pracuj�. Dane posortowane malej�co wed�ug nazwisk.
select m.module_name, m.no_of_hours, e.surname, l.department from modules m
left join lecturers l on m.lecturer_id = l.lecturer_id
join employees e on l.lecturer_id = e.employee_id
where m.module_name  collate polish_cs_as like 'computer%'
order by surname desc

--12.18
--Nazwy wszystkich wyk�ad�w, kt�rych nazwa zaczyna si� od s�owa Computer (z uwzgl�dnieniem wielko�ci liter � pierwsza litera du�a) 
--oraz liczb� godzin przewidzianych na ka�dy z tych wyk�ad�w, nazwiska prowadz�cych i nazwy katedr, w kt�rych pracuj�. Dane posortowane malej�co wed�ug nazwisk.
select m.module_name, m.no_of_hours, e.surname, l.department from modules m
left join lecturers l on m.lecturer_id = l.lecturer_id
left join employees e on l.lecturer_id = e.employee_id
where m.module_name  collate polish_cs_as like 'Computer%'
order by surname desc

--12.19
--Identyfikatory i nazwiska student�w, kt�rzy nie otrzymali dotychczas oceny z wyk�ad�w, na kt�re si� zapisali wraz z nazwami tych wyk�ad�w 
--(dane ka�dego studenta maj� si� pojawi� tyle razy z ilu wyk�ad�w nie otrzymali oceny). Dane posortowane rosn�co wed�ug identyfikator�w student�w.
select s.student_id, surname, module_name from students_modules sm
left join student_grades sg on sm.student_id = sg.student_id and sm.module_id = sg.module_id
join students s on sm.student_id = s.student_id
join modules m on sm.module_id = m.module_id
where sg.student_id is null
order by surname asc
--12.20
--Identyfikatory i nazwiska student�w, kt�rzy otrzymali oceny z wyk�ad�w, na kt�re si� zapisali wraz z nazwami tych wyk�ad�w i otrzymanymi ocenami 
--(dane ka�dego studenta maj� si� pojawi� tyle razy z ilu wyk�ad�w nie otrzymali oceny). Dane posortowane rosn�co wed�ug identyfikator�w student�w i nazw wyk�ad�w a nast�pnie malej�co wed�ug otrzymanych ocen.
select s.student_id, surname, module_name, grade from students_modules sm
join student_grades sg on sm.student_id = sg.student_id and sm.module_id = sg.module_id
join students s on sm.student_id = s.student_id
join modules m on sm.module_id = m.module_id
order by surname asc, grade desc

--12.21
--W polu department tabeli modules przechowywana jest informacja, kt�ra katedra jest odpowiedzialna za prowadzenie ka�dego z wyk�ad�w.
--Napisz zapytanie, kt�re zwr�ci nazwy wyk�ad�w, kt�re s� prowadzone przez wyk�adowc�, kt�ry nie jest pracownikiem katedry odpowiedzialnej za dany wyk�ad.
select module_name from modules m
join lecturers l on m.lecturer_id = l.lecturer_id
where m.department != l.department

--12.22
--Nazwiska, imiona i PESELe wyk�adowc�w, kt�rzy prowadz� przynajmniej jeden wyk�ad wraz z nazwami prowadzonych przez nich wyk�ad�w i napisem �wykladowca� w ostatniej kolumnie 
--oraz nazwiska, imiona, numery grup wszystkich student�w wraz z nazwami wyk�ad�w na kt�re si� zapisali i napisem �student� w ostatniej kolumnie. 
--Trzecia kolumna ma mie� nazw� pesel/grupa a ostatnia student/wykladowca.
--Dane posortowane rosn�co wed�ug nazw wyk�ad�w a nast�pnie wed�ug kolumny student/wykladowca.
select surname, first_name, PESEL as "pesel/grupa", module_name, 'wykladowca' as "student/wykladowca" from employees e
join modules m on e.employee_id = m.lecturer_id
union
select surname, first_name, group_no,module_name ,'student' 
from students s left join (students_modules sm 
join modules m on sm.module_id = m.module_id) on s.student_id = sm.student_id
order by module_name, [student/wykladowca] asc







