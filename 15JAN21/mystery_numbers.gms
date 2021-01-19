* 538Riddler solution January 15, 2021

SET F prime factor /two, three, five, seven/
    C column /first, second, third/
    R row /N1*N8/

PARAMETER value /two 2, three 3, five 5, seven 7/

TABLE row(R,F) row prime factors 
       two  three  five  seven
row1    1     1            2
row2    3     3
row3          3     1
row4    1                  2
row5    4                  1
row6    2     1            1
row7                1      2
row8    3           1
;

TABLE column(C,F) column total prime factors 
        two  three  five  seven
first    6     4     1      3
second   7           2      2
third    1     4            3

variable z;
integer variable d;
equations nums, total, obj, digit;

* dummy objective
obj.. z =E= 1;

nums(R,F)..  SUM(C, d(F,C,R)) =E= row(R,F);
total(C,F)..   SUM(R, d(F,C,R)) =E= column(C,F);

digit(C,R)..   SUM(F, d(F,C,R)*log(value(F))) =L= log(9);
* PROD(F, value(F)**d(F,C,R)) =L= 9 doesn't work very well, so use log equivalent

model mystery /nums, total, obj, digit/;

solve mystery using mip minimizing z;

* convert facotrs back into regular old base 10 numbers
parameter answer
          place /first 100, second 10, third 1/;

answer(R) = SUM(C, place(C)*PROD(F, value(F)**d.L(F,C,R)))  ;
