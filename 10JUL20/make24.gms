SET position /Ptop,P2*P4,Pbottom/
    piece /red, yellow, green, blue, purple/
    ALIAS (piece,p2)
parameter ff;
SET count /N1*N5/;

binary variable X;
variable z;

equations obj, positions, pieces, gravity, onepiece;

obj.. z =E= 1;

* piece can only be in a position that is big enough for it to fit
positions(piece).. SUM(position$(ord(position) le ord(piece)), X(position,piece)) =L= 1;

* Each position must be occupied by a piece that fits, or be empty 
pieces(position).. SUM(piece$(ord(piece) ge ord(position)),    X(position,piece)) + X(position,'empty') =E= 1;

* piece can't be above an empty space that it fits
gravity(position,piece)$(ord(position) le ord(piece)-1).. X(position,piece) =L= SUM(p2$(ord(p2) gt ord(position)), X(position+1,p2));

* at least one piece (don't really need this - we could just not count the all zero solution
onepiece.. SUM((piece,position)$(ord(piece) ge ord(position)), X(position,piece)) =G= 1;

* loop index. If program goes through all, make it bigger
SET K  /K1*K100/;
SET KK(K);

parameter XX, solutions;
XX(K, position,piece) = 0;

equation cut;
* these constraints makes each already discovered solution infeasible
cut(KK)..  SUM((position,piece), XX(KK, position,piece)*X(position,piece)) + SUM(position, XX(KK, position,'empty')*X(position,'empty')) =L= card(piece)-1;

KK(K) = NO;
model riddler0710 /obj, positions, pieces, cut, gravity, onepiece/;

LOOP(K,
  solve riddler0710 using mip maximizing z;
* Stop when no more solutions can be found
  if (riddler0710.modelstat > 2, abort "Done!", riddler0710.modelstat);

  KK(K) = YES;
* save current solution to make new cut
  XX(K, position,piece) = X.L(position,piece);
  XX(K, position,'empty') = X.L(position,'empty');
* easier to read
  solutions(K, position,piece) = XX(K, position,piece);
  solutions(K, 'total','total') = SUM((position,piece), XX(K, position,piece));
);

