class EDGE // POINT
  { 
  PNT A=P(), B=P(); // Start and End vertices
  EDGE (PNT P, PNT Q) {A.setTo(P); B.setTo(Q);}; // Creates edge
  PNT PNTnearB() {return P(B,20,Normalized(V(A,B)));}
  }
EDGE E (PNT P, PNT Q) {return new EDGE(P,Q);}

void drawEdge(EDGE E) {drawEdge(E.A,E.B);} 
void drawEdgeAsArrow(EDGE E) {arrow(E.A,E.B);} 

EDGE LERP(EDGE E0, float t, EDGE E1) // LERP between EDGE endpoints
  {
  PNT At = LERP(E0.A,time,E1.A); 
  PNT Bt = LERP(E0.B,time,E1.B);
  return E(At,Bt);
  }

// **** You must replace this code by the correct solution ***
EDGE LPM(EDGE E0, float t, EDGE E1) // LERP between EDGE endpoints 
  {
  //implemented by Zhao Yan
  SIMILARITY s = new SIMILARITY(E0.A, E0.B, E1.A, E1.B);
  PNT At = s.Apply(E0.A, t);
  PNT Bt = s.Apply(E0.B, t);
  return E(At,Bt);
  }
