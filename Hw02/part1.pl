% Islam Goktan Selcuk 
% 141044071

:- dynamic(student/3).
:- dynamic(room/3).
:- dynamic(course/6).
:- dynamic(instructor/3).
:- dynamic(occupancy/2).
:- dynamic(registered_student/2).

student(1, [cse341, cse343, cse331], no).
student(2, [cse341, cse343], no).
student(3, [cse341, cse331], no).
student(4, [cse341], no).
student(5, [cse343, cse331], no).
student(6, [cse341, cse343, cse331], yes).
student(7, [cse341, cse343], no).
student(8, [cse341, cse331], yes).
student(9, [cse341], no).
student(10, [cse341, cse321], no).
student(11, [cse341, cse321], no).
student(12, [cse343, cse321], no).
student(13, [cse343, cse321], no).
student(14, [cse343, cse321], no).
student(15, [cse343, cse331], yes).

occupancy(z06, 8, cse341).
occupancy(z06, 9, cse341).
occupancy(z06, 10, cse341).
occupancy(z06, 11, cse341).

occupancy(z06, 13, cse331).
occupancy(z06, 14, cse331).
occupancy(z06, 15, cse331).

occupancy(z11, 8, cse343).
occupancy(z11, 9, cse343).
occupancy(z11, 10, cse343).
occupancy(z11, 11, cse343).

occupancy(z11, 14, cse321).
occupancy(z11, 15, cse321).
occupancy(z11, 16, cse321).

occupancy(z06, 8, cse331).

instructor(genc, cse341, projector).
instructor(turker, cse343, smartboard).
instructor(bayrakci, cse331, _).
instructor(gozupek, cse321, smartboard).

course(cse341, genc, 10, 4, z06, projector).
course(cse343, turker, 6, 3, z11, no_needs).
course(cse331, bayrakci, 5, 3, z06, no_needs).
course(cse321, gozupek, 10, 4, z11, no_needs).

room(z06, 10, [hcapped, projector]).
room(z11, 10, [hcapped, smartboard]).

% Ayni saatte ve ayni sinifta olan dersleri
% dondurur.
conflicts(X, Y) :-
  occupancy(A, Z, X),
  occupancy(A, Z, Y),
  not(X = Y).

% Verilen dersin ve sinifin uyumlulugunu dondurur.
assign(RoomId, CourseId) :-
  % Capacity ve ders icin gerekli ihtiyaclara bakilir
  room(RoomId, Capacity, A), 
  course(CourseId, _, Capacity, _, RoomId, B),
  % Dersi veren hocanin ihtiyacina bakilir.
  instructor(_, CourseId, Need),
  % Sinifin ihtiyaclari karsilayip karsilamadigi kontol edilir.
  (member(B, A); member(A, B); (A = B); (B = no_needs)),
  (member(Need, A); (Need = B); (Need = A)).

% Dersin ogrenci icin uygun olup olmadigini dondurur.
enroll(StudentId, CourseId) :-
  % Ogrencinin aldigi derslere ve engel durumuna bakilir.
  student(StudentId, CourseList, H),
  % Sinifin ogrenci icin ihtiyaci karsilayip
  % karsilamadigina bakilir.
  room(RoomId, _, NeedList),
  course(CourseId, _, _, _, RoomId, _),
  member(CourseId, CourseList),
  (
  	 % Eger ogrenci engelliyse sinifin buna uygun
  	 % olup olmadigi kontrol edilir.
     (   (H = yes), member(hcapped, NeedList) );
         (H = no)
  ).
