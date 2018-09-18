//**** VECTOR-CREATING FUNCTIONS
VCT V() {return V(0,0); };                          // makes null vector                                                             
VCT V(float dx, float dy) {return new VCT(dx,dy); };  // make vector <dx,dy>
VCT V(VCT U) {return new VCT(U.dx,U.dy); };                                                         // returns a copy of U
VCT V(PNT P, PNT Q) {return new VCT(Q.x-P.x,Q.y-P.y);}; 
VCT Scaled(float s, VCT V) {return V(s*V.dx,s*V.dy);}                                                // sV
VCT Divided(VCT V, float d) {return V(V.dx/d,V.dy/d);}                                                // V/d
VCT Normalized(VCT V) {float n = normOf(V); if (n==0) return V(); else return Divided(V,n);};      // V/||V|| (Unit vector : normalized version of V)
VCT Inversed(VCT V) { return V(-V.dx,-V.dy); }                                                                 // -V
VCT Sum(VCT U, VCT V) {return V(U.dx+V.dx,U.dy+V.dy);}                                                   // U+V 
VCT Sum(VCT U,float s,VCT V) {return Sum(U,Scaled(s,V));}                                                   // U+sV
VCT Sum(float u, VCT U, float v, VCT V) {return Sum(Scaled(u,U),Scaled(v,V));}                          // uU+vV
VCT Rotated(VCT V) {return V(-V.dy,V.dx);};                                                             // V' = V turned right 90 degrees (as seen on screen)
VCT Rotated(VCT V, float a) { return Sum(cos(a),V,sin(a),Rotated(V)); }                                 // V rotated by angle a in radians
VCT Reflection(VCT V, VCT N) { return Sum(V,-2.*dot(V,N),N);};                                          // reflection OF V wrt unit normal vector N

//**** POINT-CREATING FUNCTIONS THAT USE POINT+VECTOR FORM 
PNT P(PNT P, VCT V) {return P(P.x + V.dx, P.y + V.dy); } 
PNT P(PNT P, float s, VCT V) {return P(P,Scaled(s,V)); }                                                    //  P+sV (P transalted by sV)

//**** MEASURES COMPUTED FROM VECTORS 
float normOf(VCT V) {return(sqrt(sq(V.dx)+sq(V.dy)));}
boolean isNull(VCT V) {return((abs(V.dx)+abs(V.dy)<0.000001));}                                            // useful to avoid divide by zero norm of a vector
float angle(VCT V) {return(atan2(V.dy,V.dx)); }                                                            // angle of V from horizontal
float dot(VCT U, VCT V) {return U.dx*V.dx+U.dy*V.dy; }                                                     // dot product U*V=|U| |V| cos(U^V)
float det(VCT U, VCT V) {return dot(Rotated(U),V); }                                                       // det product U'*V=|U||V| sin(U^V)
float angle (VCT U, VCT V) {return atan2(det(U,V),dot(U,V)); };                                            // angle <U,V> (between -PI and PI)

//**** INTERPOLATION BETWEEN VECTORS
VCT LERP(VCT U, float s, VCT V) {return V(U.dx+s*(V.dx-U.dx),U.dy+s*(V.dy-U.dy));};                      // (1-s)U+sV (Linear interpolation between vectors)
VCT LPM(VCT U, float s, VCT V) // steady interpolation from U to V
  {
  float a = angle(U,V); 
  VCT W = Rotated(U,s*a); 
  float u = normOf(U), v=normOf(V); 
  return Scaled(pow(v/u,s),W); 
  } 


//**** DISPLAY OF VECTORS AS LINES OR ARROWS STARTING FROM GIVEN POINT
void drawVectorLineFrom(PNT P, VCT V) {line(P.x,P.y,P.x+V.dx,P.y+V.dy); }                                              // show V as line-segment from P 
void arrow(PNT P, PNT Q) {arrow(P,V(P,Q));}
void arrow(PNT P, VCT V) 
  {
  drawVectorLineFrom(P,V);  
  float n=normOf(V); 
  if(n<0.01) return;  // too short a vector
  // otherwise continue
     float s=max(min(0.2,20./n),6./n);       // show V as arrow from P 
     PNT Q=P(P,V); 
     VCT U = Scaled(-s,V); 
     VCT W = Rotated(Scaled(.3,U)); 
     drawTriangle(P(P(Q,U),W), Q, P(P(Q,U),-1,W));
  } 

//**** VECTOR CLASS
class VCT 
  { 
  float dx=0, dy=0; 
  VCT (float pdx, float pdy) {dx = pdx; dy = pdy;}
  void setTo(float pdx, float pdy) {dx = pdx; dy = pdy;}
  void setTo(VCT V) {dx = V.dx; dy = V.dy; }
  void add(float u, float v) {dx += u; dy += v;}
  void add(VCT V) {dx += V.dx; dy += V.dy;}   
  void add(float s, VCT V) {dx += s*V.dx; dy += s*V.dy;}   
  }
