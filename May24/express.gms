SET N /N1*N30/

VARIABLE z;
BINARY VARIABLE x;

EQUATIONS goals, lim, total;

goals.. SUM(N, 1/ord(N)*x(N)) =E= 2;
lim(N)..  z =L= 1/ord(N)*x(N) + (1-x(N))*100;;
total.. SUM(N, x(N)) =E= 11;

option optcr=0, optca=0;

option mip=cplex;
option optcr=0, optca=0;
model this /ALL/;
this.optfile=1;
solve this using mip maximizing z;
