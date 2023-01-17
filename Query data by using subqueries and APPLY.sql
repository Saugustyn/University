--21.01
--Identyfikatory i nazwy wyk�ad�w, na kt�re nie zosta� zapisany �aden student. Dane posortowane malej�co wed�ug nazw wyk�ad�w. U�yj sk�adni podzapytania.
select module_name, module_id from modules
where module_id not in
(select module_id from students_modules)
order by module_name desc

--21.02
--Identyfikatory student�w, kt�rzy przyst�pili do egzaminu zar�wno 2018-03-22 jak i 2018 09 30. Dane posortowane malej�co wed�ug identyfikator�w. 
--Napisz dwie wersje tego zapytania: raz u�ywaj�c sk�adni podzapytania, drugi raz operatora INTERSECT.

select student_id from student_grades
where exam_date = '20180322' and student_id in
(select student_id from student_grades
where exam_date = '20180930')
order by student_id desc

select student_id from student_grades
where exam_date = '20180322'
intersect
select student_id from student_grades
where exam_date = '20180930'
order by student_id desc

--21.03
--Identyfikatory, nazwiska, imiona i numery grup student�w, kt�rzy zapisali si� zar�wno na wyk�ad o identyfikatorze 2 jak i 4. Dane posortowane malej�co wed�ug nazwisk.
--U�yj sk�adni podzapytania a w zapytaniu zewn�trznym tak�e z��czenia.
select sm.student_id, s.surname, s.first_name, s.group_no from students_modules sm
join students s on sm.student_id = s.student_id
where sm.module_id = 2 and sm.student_id in
(select sm.student_id from students_modules sm
where sm.module_id =4)
order by surname desc

--21.04
--Identyfikatory, nazwiska i imiona student�w, kt�rzy zapisali si� na wyk�ad z matematyki (Mathematics) ale nie zapisali si� na wyk�ad ze statystyki (Statistics). 

select student_id, surname, first_name
from students
where student_id in
(select sm.student_id from students_modules sm
join modules m on sm.module_id=m.module_id
where m.module_name = 'Mathematics' and sm.student_id not in
(select sm.student_id from students_modules sm
join modules m on sm.module_id=m.module_id
where m.module_name = 'Statistics'))

--21.05
--Imiona, nazwiska i numery grup student�w z grup, kt�rych nazwa zaczyna si� na DMIe i ko�czy cyfr� 1 i kt�rzy nie s� zapisani na wyk�ad z �Ancient history�.
--U�yj sk�adni zapytania negatywnego a w zapytaniu wewn�trznym tak�e z��czenia.

select first_name, surname, group_no from students
where group_no like 'DMIe%1' and student_id not in
(select student_id from students_modules sm
join modules m on sm.module_id = m.module_id
where module_name = 'Ancient history')

--21.06
--Nazwy wyk�ad�w o najmniejszej liczbie godzin. Zapytanie, opr�cz nazw wyk�ad�w, ma zwr�ci� tak�e liczb� godzin. U�yj operatora ALL.
select module_name, no_of_hours
from modules
where no_of_hours <= ALL
(select no_of_hours from modules)

--21.07
--Identyfikatory i nazwiska student�w, kt�rzy otrzymali ocen� wy�sz� od najni�szej. Dane ka�dego studenta maj� si� pojawi� tyle razy, ile takich ocen otrzyma�.
--U�yj operatora ANY. W zapytaniu nie wolno pos�ugiwa� si� liczbami oznaczaj�cymi oceny 2, 3, itd.) ani funkcjami agreguj�cymi (MIN, MAX).
select s.surname, s.first_name from student_grades sg
join students s on sg.student_id = s.student_id
where grade > ANY
(select grade from student_grades)

--21.08
--Napisz jedno zapytanie, kt�re zwr�ci dane o najm�odszym i najstarszym studencie (do po��czenia tych danych u�yj jednego z operator�w typu SET). W zapytaniu nie wolno u�ywa� funkcji agreguj�cych (MIN, MAX). U�yj operatora ALL.
select * from students
where date_of_birth <= ALL
(select date_of_birth from students
where date_of_birth is not null)
union
select * from students
where date_of_birth >= ALL
(select date_of_birth from students
where date_of_birth is not null)

--21.09a
--Identyfikatory, imiona i nazwiska student�w z grupy DMIe1011, kt�rzy otrzymali oceny z egzaminu wcze�niej, ni� wszyscy pozostali studenci z innych grup (nie uwzgl�dniamy student�w, kt�rzy nie s� zapisani do �adnej grupy). 
--Dane ka�dego studenta maj� si� pojawi� tylko raz. U�yj z��czenia i operatora ALL.
select distinct s.student_id, surname, first_name from students s
join student_grades sg on s.student_id = sg.student_id
where group_no = 'DMIe1011' and sg.exam_date < ALL
(select exam_date from student_grades sg
join students s on s.student_id = sg.student_id
where group_no <> 'DMIe1011')

--21.09b
--Jak wy�ej, ale tym razem nale�y uwzgl�dni� student�w, kt�rzy nie s� zapisani do �adnej grupy.
select distinct s.student_id, surname, first_name from students s
join student_grades sg on s.student_id = sg.student_id
where group_no = 'DMIe1011' and sg.exam_date < ALL
(select exam_date from student_grades sg
join students s on s.student_id = sg.student_id
where group_no <> 'DMIe1011' or group_no is null)

--21.10
--Nazwy wyk�ad�w, kt�rym przypisano najwi�ksz� liczb� godzin (wraz z liczb� godzin).Wyko�rzystaj sk�adni� podzapytania z operatorem =. W zapytaniu wewn�trznym u�yj funkcji MAX.
select module_name, no_of_hours from modules
where no_of_hours =(
select max(no_of_hours) from modules)

--21.11 
--Nazwy wyk�ad�w, kt�rym przypisano liczb� godzin wi�ksz� od najmniejszej. U�yj funkcji MIN i sk�adni podzapytania z operatorem >.
select module_name, no_of_hours from modules
where no_of_hours >(
select min(no_of_hours) from modules)

--21.12a
--Wszystkie dane o najstarszym studencie z ka�dej grupy. U�yj fujnkcji MIN i sk�adni podzapytania skorelowanego z operatorem =.
select * from students s1
where date_of_birth =
(select min(date_of_birth) from students s2
where s1.group_no = s2.group_no)

--21.12b
--Wszystkie numery grup z tabeli students posortowane wed�ug numer�w grup. Ka�da grupa ma si� pojawi� jeden raz.
select distinct group_no from students
order by group_no

--21.13
--Identyfikatory, nazwiska i imiona student�w, kt�rzy otrzymali ocen� 5.0. Nazwisko ka�dego studenta ma si� pojawi� jeden raz. U�yj operatora EXISTS.
select student_id, surname, first_name from students s
where exists
(select student_id from student_grades sg
where s.student_id = sg.student_id and grade = 5 )

--21.14a
--Wszystkie dane o wyk�adach, w kt�rych uczestnictwo wymaga wcze�niejszego uczestnictwa w wyk�adzie o identyfikatorze 3. U�yj operatora EXISTS.
select * from modules m1
where exists
(select * from modules m2
where preceding_module = 3 and m1.module_id = m2.module_id)

--21.14b
--Nazwy wyk�ad�w, w kt�rych uczestnictwo wymaga wcze�niejszego uczestnictwa w wyk�adzie z matematyki (Mathematics). U�yj operatora EXISTS.
select module_name from modules m1
where exists(
select module_name from modules m2
where m1.module_id = m2.module_id and preceding_module in
(select module_id from modules
where module_name = 'Mathematics'))

--21.15a
--Dane student�w z grupy DMIe1011 wraz z najwcze�niejsz� dat� planowanego dla nich egzaminu (pole planned_exam_date w tabeli students_modules). 
--Zapytanie nie zwraca danych o studentach, kt�rzy nie maj� wyznaczonej takiej daty. Sortowanie rosn�ce wed�ug planned_exam_date a nast�pnie student_id. U�yj operatora APPLY.
select * from students s
cross apply
(select top(1) planned_exam_date
from students_modules sm
where s.student_id=sm.student_id 
and planned_exam_date is not null
) as t
where group_no='DMIe1011'
order by planned_exam_date, student_id


--21.15b
--Jak wy�ej, tylko zapytanie ma zwr�ci� najp�niejsz� dat� planowanego egzaminu. Ponadto zapytanie ma tak�e zwr�ci� dane o studentach, kt�rzy nie maj� wyznaczonej takiej daty. 
--Sortowanie rosn�ce wed�ug planned_exam_date. U�yj operatora APPLY.
select * from students s
outer apply
(select top(1) planned_exam_date
from students_modules sm
where s.student_id=sm.student_id 
order by planned_exam_date desc) as t
where group_no='DMIe1011'
order by planned_exam_date asc

--21.16a
--Identyfikatory i nazwiska student�w oraz dwie najlepsze oceny dla ka�dego studenta wraz z datami ich przyznania. 
--Zapytanie uwzgl�dnia tylko student�w, kt�rym zosta�a przyznana co najmniej jedna ocena. U�yj operatora APPLY.
select student_id, surname, grade, exam_date from students s
cross apply
(select top(2) grade, exam_date from student_grades sg
where s.student_id = sg.student_id
order by grade desc) as t

--21.16b
--Identyfikatory i nazwiska student�w oraz dwie najgorsze oceny dla ka�dego studenta wraz z datami ich przyznania. 
--Zapytanie uwzgl�dnia tak�e student�w, kt�rym nie zosta�a przyznana �adna ocena. U�yj operatora APPLY.
select student_id, surname, grade, exam_date from students s
outer apply
(select top(2)grade, exam_date from student_grades sg
where s.student_id = sg.student_id
order by grade asc) as t

--21.17
--Identyfikatory i nazwiska student�w oraz kwoty dw�ch ostatnich wp�at za studia wraz z datami tych wp�at. 
--Zapytanie uwzgl�dnia tak�e student�w, kt�rzy nie dokonali �adnej wp�aty. U�yj operatora APPLY.
select student_id, surname, fee_amount from students s
outer apply
(select top(2)fee_amount from tuition_fees f
where s.student_id = f.student_id
order by date_of_payment desc) as t

--21.18
--Nazw� modu�u poprzedzaj�cego dla modu�u Databases.
select module_name from modules
where module_id in(
select preceding_module from modules
where module_name = 'Databases')
