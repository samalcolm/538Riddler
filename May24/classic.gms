option limrow=100;
SET A /A1*A4/
    N /1*7/
    K /K1*K100/;

parameter NN;
NN = card(N)-1;
parameter blah, pnum;
pnum(N) =fact(NN)/(fact(NN-(ord(N)-1))*fact(ord(N)-1));

POSITIVE VARIABLE p;
VARIABLE z;
BINARY VARIABLE x;

EQUATIONS  obj, outcome, combin, yadda;

*dummy objective; we're just finding feasibile solution(s)
obj.. z =E= 1;

* set each astronauts probability = 1/3
outcome(A).. SUM(N, SUM(K$(ord(K) le pnum(N)), ord(K)*x(A,N,K))*p**(NN-(ord(N)-1))*(1-p)**(ord(N)-1)) =E= 1/(card(A)+1);
* can only assign as many branches as there are
combin(N).. SUM(A, SUM(K$(ord(K) le pnum(N)), ord(K)*x(A,N,K))) =L= pnum(N);
yadda(A,N).. SUM(K$(ord(K) le pnum(N)), x(A,N,K)) =L= 1;

p.UP=1;
p.L=0.5;
p.LO=0.001;
option minlp=couenne
option optcr=0, optca=0;
model this /all/ ;
this.optfile=1;
solve this using minlp minimizing z;

parameter result;
* check that probability for each astronaut = 1/3
result(A) = SUM(N, SUM(K$(ord(K) le pnum(N)),  ord(K)*x.L(A,N,K))*p.L**(NN-(ord(N)-1))*(1-p.L)**(ord(N)-1))
