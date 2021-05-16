use 학사db;

select S.name as 학생, C.name as 과목, D.name as 전공
from student as S, course as C, department as D, instructor as I, course_taken as CT
where S.id = CT.sid 
  and C.id = CT.cid
  and C.instructor = I.pid
  and D.id = S.major
  and I.name = '이장택';