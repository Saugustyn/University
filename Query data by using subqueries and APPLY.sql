--21.01
--Identyfikatory i nazwy wyk³adów, na które nie zosta³ zapisany ¿aden student. Dane posortowane malej¹co wed³ug nazw wyk³adów. U¿yj sk³adni podzapytania.
select module_name, module_id from modules
where module_id not in
(select module_id from students_modules)
order by module_name desc

--21.02
--Identyfikatory studentów, którzy przyst¹pili do egzaminu zarówno 2018-03-22 jak i 2018 09 30. Dane posortowane malej¹co wed³ug identyfikatorów. 
--Napisz dwie wersje tego zapytania: raz u¿ywaj¹c sk³adni podzapytania, drugi raz operatora INTERSECT.

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
--Identyfikatory, nazwiska, imiona i numery grup studentów, którzy zapisali siê zarówno na wyk³ad o identyfikatorze 2 jak i 4. Dane posortowane malej¹co wed³ug nazwisk.
--U¿yj sk³adni podzapytania a w zapytaniu zewnêtrznym tak¿e z³¹czenia.
select sm.student_id, s.surname, s.first_name, s.group_no from students_modules sm
join students s on sm.student_id = s.student_id
where sm.module_id = 2 and sm.student_id in
(select sm.student_id from students_modules sm
where sm.module_id =4)
order by surname desc

--21.04
--Identyfikatory, nazwiska i imiona studentów, którzy zapisali siê na wyk³ad z matematyki (Mathematics) ale nie zapisali siê na wyk³ad ze statystyki (Statistics). 

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
--Imiona, nazwiska i numery grup studentów z grup, których nazwa zaczyna siê na DMIe i koñczy cyfr¹ 1 i którzy nie s¹ zapisani na wyk³ad z „Ancient history”.
--U¿yj sk³adni zapytania negatywnego a w zapytaniu wewnêtrznym tak¿e z³¹czenia.

select first_name, surname, group_no from students
where group_no like 'DMIe%1' and student_id not in
(select student_id from students_modules sm
join modules m on sm.module_id = m.module_id
where module_name = 'Ancient history')

--21.06
--Nazwy wyk³adów o najmniejszej liczbie godzin. Zapytanie, oprócz nazw wyk³adów, ma zwróciæ tak¿e liczbê godzin. U¿yj operatora ALL.
select module_name, no_of_hours
from modules
where no_of_hours <= ALL
(select no_of_hours from modules)

--21.07
--Identyfikatory i nazwiska studentów, którzy otrzymali ocenê wy¿sz¹ od najni¿szej. Dane ka¿dego studenta maj¹ siê pojawiæ tyle razy, ile takich ocen otrzyma³.
--U¿yj operatora ANY. W zapytaniu nie wolno pos³ugiwaæ siê liczbami oznaczaj¹cymi oceny 2, 3, itd.) ani funkcjami agreguj¹cymi (MIN, MAX).
select s.surname, s.first_name from student_grades sg
join students s on sg.student_id = s.student_id
where grade > ANY
(select grade from student_grades)

--21.08
--Napisz jedno zapytanie, które zwróci dane o najm³odszym i najstarszym studencie (do po³¹czenia tych danych u¿yj jednego z operatorów typu SET). W zapytaniu nie wolno u¿ywaæ funkcji agreguj¹cych (MIN, MAX). U¿yj operatora ALL.
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
--Identyfikatory, imiona i nazwiska studentów z grupy DMIe1011, którzy otrzymali oceny z egzaminu wczeœniej, ni¿ wszyscy pozostali studenci z innych grup (nie uwzglêdniamy studentów, którzy nie s¹ zapisani do ¿adnej grupy). 
--Dane ka¿dego studenta maj¹ siê pojawiæ tylko raz. U¿yj z³¹czenia i operatora ALL.
select distinct s.student_id, surname, first_name from students s
join student_grades sg on s.student_id = sg.student_id
where group_no = 'DMIe1011' and sg.exam_date < ALL
(select exam_date from student_grades sg
join students s on s.student_id = sg.student_id
where group_no <> 'DMIe1011')

--21.09b
--Jak wy¿ej, ale tym razem nale¿y uwzglêdniæ studentów, którzy nie s¹ zapisani do ¿adnej grupy.
select distinct s.student_id, surname, first_name from students s
join student_grades sg on s.student_id = sg.student_id
where group_no = 'DMIe1011' and sg.exam_date < ALL
(select exam_date from student_grades sg
join students s on s.student_id = sg.student_id
where group_no <> 'DMIe1011' or group_no is null)

--21.10
--Nazwy wyk³adów, którym przypisano najwiêksz¹ liczbê godzin (wraz z liczb¹ godzin).Wyko¬rzystaj sk³adniê podzapytania z operatorem =. W zapytaniu wewnêtrznym u¿yj funkcji MAX.
select module_name, no_of_hours from modules
where no_of_hours =(
select max(no_of_hours) from modules)

--21.11 
--Nazwy wyk³adów, którym przypisano liczbê godzin wiêksz¹ od najmniejszej. U¿yj funkcji MIN i sk³adni podzapytania z operatorem >.
select module_name, no_of_hours from modules
where no_of_hours >(
select min(no_of_hours) from modules)

--21.12a
--Wszystkie dane o najstarszym studencie z ka¿dej grupy. U¿yj fujnkcji MIN i sk³adni podzapytania skorelowanego z operatorem =.
select * from students s1
where date_of_birth =
(select min(date_of_birth) from students s2
where s1.group_no = s2.group_no)

--21.12b
--Wszystkie numery grup z tabeli students posortowane wed³ug numerów grup. Ka¿da grupa ma siê pojawiæ jeden raz.
select distinct group_no from students
order by group_no

--21.13
--Identyfikatory, nazwiska i imiona studentów, którzy otrzymali ocenê 5.0. Nazwisko ka¿dego studenta ma siê pojawiæ jeden raz. U¿yj operatora EXISTS.
select student_id, surname, first_name from students s
where exists
(select student_id from student_grades sg
where s.student_id = sg.student_id and grade = 5 )

--21.14a
--Wszystkie dane o wyk³adach, w których uczestnictwo wymaga wczeœniejszego uczestnictwa w wyk³adzie o identyfikatorze 3. U¿yj operatora EXISTS.
select * from modules m1
where exists
(select * from modules m2
where preceding_module = 3 and m1.module_id = m2.module_id)

--21.14b
--Nazwy wyk³adów, w których uczestnictwo wymaga wczeœniejszego uczestnictwa w wyk³adzie z matematyki (Mathematics). U¿yj operatora EXISTS.
select module_name from modules m1
where exists(
select module_name from modules m2
where m1.module_id = m2.module_id and preceding_module in
(select module_id from modules
where module_name = 'Mathematics'))

--21.15a
--Dane studentów z grupy DMIe1011 wraz z najwczeœniejsz¹ dat¹ planowanego dla nich egzaminu (pole planned_exam_date w tabeli students_modules). 
--Zapytanie nie zwraca danych o studentach, którzy nie maj¹ wyznaczonej takiej daty. Sortowanie rosn¹ce wed³ug planned_exam_date a nastêpnie student_id. U¿yj operatora APPLY.
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
--Jak wy¿ej, tylko zapytanie ma zwróciæ najpóŸniejsz¹ datê planowanego egzaminu. Ponadto zapytanie ma tak¿e zwróciæ dane o studentach, którzy nie maj¹ wyznaczonej takiej daty. 
--Sortowanie rosn¹ce wed³ug planned_exam_date. U¿yj operatora APPLY.
select * from students s
outer apply
(select top(1) planned_exam_date
from students_modules sm
where s.student_id=sm.student_id 
order by planned_exam_date desc) as t
where group_no='DMIe1011'
order by planned_exam_date asc

--21.16a
--Identyfikatory i nazwiska studentów oraz dwie najlepsze oceny dla ka¿dego studenta wraz z datami ich przyznania. 
--Zapytanie uwzglêdnia tylko studentów, którym zosta³a przyznana co najmniej jedna ocena. U¿yj operatora APPLY.
select student_id, surname, grade, exam_date from students s
cross apply
(select top(2) grade, exam_date from student_grades sg
where s.student_id = sg.student_id
order by grade desc) as t

--21.16b
--Identyfikatory i nazwiska studentów oraz dwie najgorsze oceny dla ka¿dego studenta wraz z datami ich przyznania. 
--Zapytanie uwzglêdnia tak¿e studentów, którym nie zosta³a przyznana ¿adna ocena. U¿yj operatora APPLY.
select student_id, surname, grade, exam_date from students s
outer apply
(select top(2)grade, exam_date from student_grades sg
where s.student_id = sg.student_id
order by grade asc) as t

--21.17
--Identyfikatory i nazwiska studentów oraz kwoty dwóch ostatnich wp³at za studia wraz z datami tych wp³at. 
--Zapytanie uwzglêdnia tak¿e studentów, którzy nie dokonali ¿adnej wp³aty. U¿yj operatora APPLY.
select student_id, surname, fee_amount from students s
outer apply
(select top(2)fee_amount from tuition_fees f
where s.student_id = f.student_id
order by date_of_payment desc) as t

--21.18
--Nazwê modu³u poprzedzaj¹cego dla modu³u Databases.
select module_name from modules
where module_id in(
select preceding_module from modules
where module_name = 'Databases')
