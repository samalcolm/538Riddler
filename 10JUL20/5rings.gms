* 576 Riddler from 10 July, 2020.
*  '5 rings' as a set covering problem
* Find all the ways the 5 rings can be arranged on the column
SET position top to bottom /Ptop,P2,P3,P4,Pbottom/
    ring /red, yellow, green, blue, purple/
    ALIAS (ring,c2)

* X takes a value of 1 if (ring) is in (position), and zero otherwise
binary variable X
variable z;

equations obj, positions, rings, gravity, onepiece;

* A dummy objective. Does nothing. Move along.
obj.. z =E= 1;

* each ring can only be in a position that is big enough for it to fit
positions(ring).. SUM(position$(ord(position) le ord(ring)), X(position,ring)) =L= 1;

* Each position must be occupied by one ring that fits, or be empty 
rings(position).. SUM(ring$(ord(ring) ge ord(position)),    X(position,ring)) + X(position,'empty') =E= 1;

* a ring can't be above an empty space that it fits
gravity(position,ring)$(ord(position) le ord(ring)-1).. X(position,ring) =L= SUM(c2$(ord(c2) gt ord(position)), X(position+1,c2));

* there must be at least one ring (don't really need this - we could just not count the all zero solution
onepiece.. SUM((ring,position)$(ord(ring) ge ord(position)), X(position,ring)) =G= 1;

* loop index. If program goes through all the iterates make upper limit bigger
SET K  /K1*K100/;
SET KK(K);

parameter XX, solutions;
XX(K, position,ring) = 0;

equation cut;
* these constraints makes each already discovered solution infeasible
cut(KK)..  SUM((position,ring), XX(KK, position,ring)*X(position,ring)) + SUM(position, XX(KK, position,'empty')*X(position,'empty')) =L= card(ring)-1;

KK(K) = NO;
model stacking_rings /obj, positions, rings, cut, gravity, onepiece/;

LOOP(K,
  solve stacking_rings using mip maximizing z;
  
* Stop when no more feasible solutions can be found
  if (stacking_rings.modelstat > 2, abort "Done!", stacking_rings.modelstat);

  KK(K) = YES;
* save current solution to make new cut
  XX(K, position,ring) = X.L(position,ring);
  XX(K, position,'empty') = X.L(position,'empty');
* easier to read
  solutions(K, position,ring) = XX(K, position,ring);
  solutions(K, 'total','total') = SUM((position,ring), XX(K, position,ring));
);

