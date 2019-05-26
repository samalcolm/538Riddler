option limrow=100;
* only need to compute for N-1 astronauts, since remaining astronaut claims the leftovers
SET A Astronaut labels /A1*A2/
    N unique endpoint outcomes (Nflips plus 1) /1*5/
    K /K1*K100/;

parameter Nflips number of flips;
Nflips = card(N)-1;
parameter pnum number of each branch endpoint (binomial coefficient);
pnum(N) =fact(Nflips)/(fact(Nflips-(ord(N)-1))*fact(ord(N)-1));

POSITIVE VARIABLE p probability of heads;
VARIABLE z;
BINARY VARIABLE x select ord(K) branches of solution N for astronaut A;

EQUATIONS  obj, outcome, combin;

*dummy objective; we're just finding feasibile solution(s)
obj.. z =E= 1;

* set each astronauts probability = 1/3
outcome(A).. SUM(N, SUM(K$(ord(K) le pnum(N)), ord(K)*x(A,N,K))*p**(Nflips-(ord(N)-1))*(1-p)**(ord(N)-1)) =E= 1/(card(A)+1);

* can only assign as many branches as there are
combin(N).. SUM(A, SUM(K$(ord(K) le pnum(N)), ord(K)*x(A,N,K))) =L= pnum(N);

* some helpful devices
p.UP=1;
p.L=0.5;
p.LO=0.001;

* optimization stuff
option minlp=couenne
option optcr=0, optca=0;
model coins /all/ ;
coins.optfile=1;
solve coins using minlp minimizing z;

parameter result;
* check that probability for each astronaut = 1/3 should be the same as the outcome equation level
result(A) = SUM(N, SUM(K$(ord(K) le pnum(N)),  ord(K)*x.L(A,N,K))*p.L**(Nflips-(ord(N)-1))*(1-p.L)**(ord(N)-1))
