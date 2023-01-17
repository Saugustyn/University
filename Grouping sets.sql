--4b.1a
--Nazwy katedr, w których pracuje co najmniej jeden wyk³adowca, tytu³y naukowe wystêpuj¹ce w ramach ka¿dej katedry oraz informacjê 
--o liczbie prowadzonych wyk³adów w ramach katedr i w katedrach przez ka¿d¹ z grup wyk³adowców (wed³ug tytu³u naukowego). W zapytaniu nale¿y pomin¹æ wyk³adowców, którzy nie prowadz¹ ¿adnego wyk³adu.U¿yj grupowania ROLLUP.
select l.department, acad_position, count(module_id) from lecturers l
join modules m on l.lecturer_id = m.lecturer_id
group by rollup(l.department, acad_position)

--4b.1b
--U¿ywaj¹c funkcji GROUPING zmodyfikuj zapytanie tak, aby zwróci³o informacjê, wzglêdem których pól jest wykonywane grupowanie.
select grouping(l.department), grouping(acad_position) ,l.department, acad_position, count(module_id) from lecturers l
join modules m on l.lecturer_id = m.lecturer_id
group by rollup(l.department, acad_position)

--4b.1c
--Zmodyfikuj zapytanie wyœwietlaj¹c informacjê o sposobie grupowania przy pomocy funkcji GROUPING_ID.
select grouping_id(l.department, acad_position),l.department, acad_position, count(module_id) from lecturers l
join modules m on l.lecturer_id = m.lecturer_id
group by rollup(l.department, acad_position)


--4b.2a
--Numery grup, do których zapisany jest co najmniej jeden student, nazwy wszystkich wyk³adów, na które studenci s¹ zapisani oraz informacjê o liczbie studentów w ramach ka¿dej grupy oddzielnie zapisanych na poszczególne wyk³ady.
select group_no, module_name, count(sm.student_id) from students s
left join students_modules sm on s.student_id = sm.student_id
left join modules m on sm.module_id = m.module_id
group by rollup (group_no, module_name)

--4b.2b
--Zmodyfikuj poprzednie zapytanie, aby zwraca³o wynik dzia³ania funkcji GROUPING_ID (kolumnê nazwij grp_id). 
select grouping_id(group_no, module_name) as grp_id, group_no, module_name, count(sm.student_id) from students s
left join students_modules sm on s.student_id = sm.student_id
left join modules m on sm.module_id = m.module_id
group by rollup (group_no, module_name)

--4b.2c
--Zmodyfikuj poprzednie zapytanie, aby zwraca³o jedynie rekordy, które w polu grp_id maj¹ liczbê 1.
select grouping_id(group_no, module_name) as grp_id, group_no, module_name, count(sm.student_id) from students s
left join students_modules sm on s.student_id = sm.student_id
left join modules m on sm.module_id = m.module_id
group by rollup (group_no, module_name)
having grouping_id(group_no, module_name) =1


--4b.3
--Nazwy stopni/tytu³ów naukowych, nazwy katedr oraz informacjê, ile godzin maj¹ poszczególne grupy wyk³adowców (posiadaj¹cych taki sam stopieñ/tytu³) w ramach ka¿dej katedry. U¿yj funkcji GROUPING_ID lub GROUPING.
select grouping_id(acad_position, l.department) as grp_id, l.department, acad_position, sum(no_of_hours) from lecturers l
join modules m on l.lecturer_id = m.lecturer_id
group by rollup(l.department, acad_position)
