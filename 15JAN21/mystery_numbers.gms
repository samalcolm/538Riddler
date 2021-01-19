 SET F prime factor /two, three, five, seven/
    P /first, second, third/
    N /N1*N8/

PARAMETER value /two 2, three 3, five 5, seven 7/

TABLE primes(N,F)
     two  three  five  seven
N1    1     1            2
N2    3     3
N3          3     1
N4    1                  2
N5    4                  1
N6    2     1            1
N7                1      2
N8    3           1
;

TABLE totals(P,F)
        two  three  five  seven
first    6     4     1      3
second   7     0     2      2
third    1     4     0      3

variable z;
integer variable d;
binary variable blah;
equations nums, total, obj, digit;

obj.. z =E= 1;
nums(N,F)..  SUM(P, d(F,P,N)) =E= primes(N,F);
total(P,F)..   SUM(N, d(F,P,N)) =E= totals(P,F);
digit(P,N)..   SUM(F, d(F,P,N)*log(value(F))) =L= log(9);

model this /nums, total, obj, digit/;
d.UP(F,P,N) = primes(N,F);

solve this using mip minimizing z;
parameter answer
          place /first 100, second 10, third 1/;

answer(N) = SUM(P, place(P)*PROD(F, value(F)**d.L(F,P,N)))  ;
