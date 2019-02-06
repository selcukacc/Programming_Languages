% Islam Goktan Selcuk 
% 141044071

flight(edirne, erzurum, 5).
flight(erzurum, antalya, 2).
flight(antalya, izmir, 1).
flight(antalya, diyarbakir, 5).
flight(diyarbakir, ankara, 8).
flight(izmir, istanbul, 3).
flight(izmir, ankara, 6).
flight(istanbul, ankara, 2).
flight(istanbul, trabzon, 3).
flight(trabzon, ankara, 6).
flight(ankara, kars, 3).
flight(kars, gaziantep, 3).

% Verilen sehirlerin fact'inden mesafeyi verir.
route(X, Y, C) :-
    flight(X, Y, C).

% Verilen sehirlerin diger sehirler uzerinden arasindaki
% mesafeyi verir.
route(X, Y, T) :-
    flight(X, Z, Dist),
    route(Z, Y, Dist1),
    T is Dist1 + Dist.