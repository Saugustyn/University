--4b.1a
--Nazwy katedr, w kt�rych pracuje co najmniej jeden wyk�adowca, tytu�y naukowe wyst�puj�ce w ramach ka�dej katedry oraz informacj� 
--o liczbie prowadzonych wyk�ad�w w ramach katedr i w katedrach przez ka�d� z grup wyk�adowc�w (wed�ug tytu�u naukowego). W zapytaniu nale�y pomin�� wyk�adowc�w, kt�rzy nie prowadz� �adnego wyk�adu.U�yj grupowania ROLLUP.
select l.department, acad_position, count(module_id) from lecturers l
join modules m on l.lecturer_id = m.lecturer_id
group by rollup(l.department, acad_position)

--4b.1b
--U�ywaj�c funkcji GROUPING zmodyfikuj zapytanie tak, aby zwr�ci�o informacj�, wzgl�dem kt�rych p�l jest wykonywane grupowanie.
select grouping(l.department), grouping(acad_position) ,l.department, acad_position, count(module_id) from lecturers l
join modules m on l.lecturer_id = m.lecturer_id
group by rollup(l.department, acad_position)

--4b.1c
--Zmodyfikuj zapytanie wy�wietlaj�c informacj� o sposobie grupowania przy pomocy funkcji GROUPING_ID.
select grouping_id(l.department, acad_position),l.department, acad_position, count(module_id) from lecturers l
join modules m on l.lecturer_id = m.lecturer_id
group by rollup(l.department, acad_position)


--4b.2a
--Numery grup, do kt�rych zapisany jest co najmniej jeden student, nazwy wszystkich wyk�ad�w, na kt�re studenci s� zapisani oraz informacj� o liczbie student�w w ramach ka�dej grupy oddzielnie zapisanych na poszczeg�lne wyk�ady.
select group_no, module_name, count(sm.student_id) from students s
left join students_modules sm on s.student_id = sm.student_id
left join modules m on sm.module_id = m.module_id
group by rollup (group_no, module_name)

--4b.2b
--Zmodyfikuj poprzednie zapytanie, aby zwraca�o wynik dzia�ania funkcji GROUPING_ID (kolumn� nazwij grp_id). 
select grouping_id(group_no, module_name) as grp_id, group_no, module_name, count(sm.student_id) from students s
left join students_modules sm on s.student_id = sm.student_id
left join modules m on sm.module_id = m.module_id
group by rollup (group_no, module_name)

--4b.2c
--Zmodyfikuj poprzednie zapytanie, aby zwraca�o jedynie rekordy, kt�re w polu grp_id maj� liczb� 1.
select grouping_id(group_no, module_name) as grp_id, group_no, module_name, count(sm.student_id) from students s
left join students_modules sm on s.student_id = sm.student_id
left join modules m on sm.module_id = m.module_id
group by rollup (group_no, module_name)
having grouping_id(group_no, module_name) =1


--4b.3
--Nazwy stopni/tytu��w naukowych, nazwy katedr oraz informacj�, ile godzin maj� poszczeg�lne grupy wyk�adowc�w (posiadaj�cych taki sam stopie�/tytu�) w ramach ka�dej katedry. U�yj funkcji GROUPING_ID lub GROUPING.
select grouping_id(acad_position, l.department) as grp_id, l.department, acad_position, sum(no_of_hours) from lecturers l
join modules m on l.lecturer_id = m.lecturer_id
group by rollup(l.department, acad_position)
