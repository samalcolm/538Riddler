SET position /Ptop,P2*P4,Pbottom/
    color /red, yellow, green, blue, purple/
    ALIAS (color,c2)
parameter ff;
SET count /N1*N5/;

* X takes a value of 1 if piece is in position
binary variable X
variable z;

equations obj, positions, colors, gravity, onepiece;

* A dummy objective. Does nothing. Move along.
obj.. z =E= 1;

* piece can only be in a position that is big enough for it to fit
positions(color).. SUM(position$(ord(position) le ord(color)), X(position,color)) =L= 1;

* Each position must be occupied by a piece that fits, or be empty 
colors(position).. SUM(color$(ord(color) ge ord(position)),    X(position,color)) + X(position,'empty') =E= 1;

* piece can't be above an empty space that it fits
gravity(position,color)$(ord(position) le ord(color)-1).. X(position,color) =L= SUM(c2$(ord(c2) gt ord(position)), X(position+1,c2));

* at least one color (don't really need this - we could just not count the all zero solution
onepiece.. SUM((color,position)$(ord(color) ge ord(position)), X(position,color)) =G= 1;

* loop index. If program goes through all the iterates make upper limit bigger
SET K  /K1*K100/;
SET KK(K);

parameter XX, solutions;
XX(K, position,color) = 0;

equation cut;
* these constraints makes each already discovered solution infeasible
cut(KK)..  SUM((position,color), XX(KK, position,color)*X(position,color)) + SUM(position, XX(KK, position,'empty')*X(position,'empty')) =L= card(color)-1;

KK(K) = NO;
model make24 /obj, positions, colors, cut, gravity, onepiece/;

LOOP(K,
  solve make24 using mip maximizing z;
  
* Stop when no more feasible solutions can be found
  if (riddler0710.modelstat > 2, abort "Done!", riddler0710.modelstat);

  KK(K) = YES;
* save current solution to make new cut
  XX(K, position,color) = X.L(position,color);
  XX(K, position,'empty') = X.L(position,'empty');
* easier to read
  solutions(K, position,color) = XX(K, position,color);
  solutions(K, 'total','total') = SUM((position,color), XX(K, position,color));
);

