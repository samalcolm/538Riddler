SET F prime factor /two, three, five, seven/
    C column /first, second, third/
    R row /N1*N8/

PARAMETER value /two 2, three 3, five 5, seven 7/

TABLE row total factors primes(R,F)
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

TABLE column total factors totals(C,F)
        two  three  five  seven
first    6     4     1      3
second   7     0     2      2
third    1     4     0      3

variable z;
integer variable d;
equations nums, total, obj, digit;

* dummy objective
obj.. z =E= 1;

nums(R,F)..  SUM(C, d(F,C,R)) =E= primes(R,F);
total(C,F)..   SUM(R, d(F,C,R)) =E= totals(C,F);

digit(C,R)..   SUM(F, d(F,C,R)*log(value(F))) =L= log(9);
* PROD(F, value(F)**d(F,C,R)) =L= 9 doesn't work very well, so use log equivalent

* can't ask for more factors than are available for a given row, so an upper vlaue is set
d.UP(F,C,R) = primes(R,F);

model mystery /nums, total, obj, digit/;

solve mystery using mip minimizing z;

* convert facotrs back into base 10 numbers
parameter answer
          place /first 100, second 10, third 1/;

answer(R) = SUM(C, place(C)*PROD(F, value(F)**d.L(F,C,R)))  ;
