//**** POINT CLASS
class PNT // POINT
  { 
  float x=0, y=0; 
  PNT (float px, float py) {x = px; y = py;};
  void moveBy(float dx, float dy) {x += dx; y += dy;}
  void teleport() {moveBy(mouseX-pmouseX,mouseY-pmouseY);}
  void setTo(PNT P) {x = P.x; y = P.y;} // copies coordinates from another points
  void setTo(float px, float py) {x = px; y = py;}
  } // end of PNT class

//**** POINT-CREATING FUNCTIONS
PNT P() {return P(0,0); };                                        // makes point at origin                                                                       
PNT P(float x, float y) {return new PNT(x,y); };                   // make point (x,y)
PNT P(PNT Q) {return new PNT(Q.x,Q.y); };                   // make copy of Q
PNT Mouse() {return P(mouseX,mouseY);}              // current mouse position
PNT PMouse() {return P(pmouseX,pmouseY);}           // previous mouse position
PNT LERP(PNT A, float t, PNT B) {return P(A.x+t*(B.x-A.x),A.y+t*(B.y-A.y));} // Lerp (1-t)A+tB, Weighted average of points

//**** FUNCTIONS THAT MEASURE PROPERTIES OF POINTS
float dist(PNT P, PNT Q) {return sqrt(sq(Q.x-P.x)+sq(Q.y-P.y));}     // Distance |PQ|      

//**** COMMANDS FOR DISPLAYING GRAPHIC PRIMITIVES AND TEXT USING POINTS
void drawCircle(PNT C, float r) {ellipse(C.x, C.y, 2*r, 2*r);};    // draws circ(C,r)                                     
void showLabelInCircle(PNT P, String S) {fill(white); drawCircle(P,13); fill(black); writeLabel(P,S);} // Writes S in circle of current color                      
void drawEdge(PNT A, PNT B)  {line(A.x,A.y,B.x,B.y);}    // render edge [A,B]
void drawTriangle(PNT A, PNT B, PNT C)  {beginShape();  vert(A); vert(B); vert(C); endShape(CLOSE);}    // render triangle A, B, C
void drawQuad(PNT A, PNT B, PNT C, PNT D)  {beginShape();  vert(A); vert(B); vert(C); vert(D); endShape(CLOSE);}  // render quad A, B, C, D
void drawOpenQuad(PNT A, PNT B, PNT C, PNT D)  {beginShape();  vert(A); vert(B); vert(C); vert(D); endShape();}  // render quad A, B, C, D
void vert(PNT P) {vertex(P.x,P.y);};  // use between beginShape and endShape to display polylines   
void writeLabel(PNT P, String S) {text(S, P.x-1.,P.y-2.5); }       // writes string S near P

void drawSQUINTcurve(PNT A, PNT B, PNT C, PNT D, float u, boolean virticle)
{
  beginShape();
  strokeWeight(5); 
  if (virticle) {
    stroke(red,100);
    for (int i = 0; i <= 100; i+=2) {
      vert(SQUINTmap(A, B, C, D, (float)i/100.0, u)); //<>//
    }
  } else {
    stroke(blue,100);
    for (int i = 0; i <= 100; i+=2) {
      vert(SQUINTmap(A, B, C, D, u, (float)i/100.0));
    }
  }
  endShape();
}

// Teextyre mapping
void vert(PNT P, float u, float v) {vertex(P.x,P.y,u,v);};  // use between beginShape and endShape to display polygon with texture   
void drawQuadTextured(PNT A, PNT B, PNT C, PNT D, PImage pix)  // render quad A, B, C, D with texture inside
  {
  beginShape();  
   texture(pix);
   vert(A,0,0); vert(B,1,0); vert(C,1,1); vert(D,0,1); 
  endShape(CLOSE);
  }  

void drawSQUINTTileTextured(PNT A, PNT B, PNT C, PNT D, float u, float v, float step_width, PImage pix)
{
  beginShape();
  texture(pix);
  for (float i = u; i < u + step_width; i+=0.02) {
    vert(SQUINTmap(A, B, C, D, i, v), i, v);
  }
  for (float i = v; i < v + step_width; i+=0.02) {
    vert(SQUINTmap(A, B, C, D, u+step_width, i), u+step_width, i);
  }
  for (float i = u+step_width; i > u; i-=0.02) {
    vert(SQUINTmap(A, B, C, D, i, v+step_width), i, v+step_width);
  }
  for (float i = v+step_width; i > v; i-=0.02) {
    vert(SQUINTmap(A, B, C, D, u, i), u, i);
  }
  endShape(CLOSE);
}


//**** TOOLS FOR PROCESSING SETS OR ARRAYS OF POINTS
void setToSquare(PNT A, PNT B, PNT C, PNT D) // set A, B, C, D to be the vertices of a square
  {
  A.setTo(200,200); B.setTo(600,200); C.setTo(600,600); D.setTo(200,600); pointsCount=4;
  }
 
void makeFourSquares() // arranges 16 control points into 4 neat squares. For CS6491 and possibly for the advanced part of CS3451
  {
  pointsCount=16;
  PNT O = P(width/2,height/2);
  for(int i=0; i<4; i++)
    {
    float d=(float)width/16*(i+2);
    Point[4*i+0]=P(O); Point[4*i+0].moveBy(-d+1,-d-1);  Point[4*i+1]=P(O); Point[4*i+1].moveBy(d+3,-d-4); 
    Point[4*i+2]=P(O); Point[4*i+2].moveBy(d-1,d+1);   Point[4*i+3]=P(O); Point[4*i+3].moveBy(-d-4,d+3); 
    }
  }

void declarePoints(PNT[] Points)  // creates objects for all Point[i], MUST BE DONE AT INITALIZATION
  {
  for (int i=0; i<pointsCountMax; i++) Point[i]=P(); // initializes ALL Point[i] to (0,0)
  }              
 
 
// ***** FILE I/O FOR ARRAY OF POINTS
// fn is initialized and can be changed using the clipboard.

void writePoints(String fn)  // Writes point-count and point coordinates to file fn
    {
    String [] inppts = new String [pointsCount+1];
    int s=0;
    inppts[s++]=str(pointsCount);
    for (int i=0; i<pointsCount; i++) {inppts[s++]=str(Point[i].x)+","+str(Point[i].y);}
    saveStrings(fn,inppts);
    };
  

// The sketch will crash if file fn does not exist! 
void readPoints(String fn) // reads point-count and point coordinates from file fn
    {
    println("loading points from file: "+fn); 
    String [] ss = loadStrings(fn);
    String subpts;
    int s=0;   int comma, comma1, comma2;   float x, y;   int a, b, c;
    pointsCount = int(ss[s++]); print("pointsCount="+pointsCount);
    for(int k=0; k<pointsCount; k++) {
      int i=k+s; 
      comma=ss[i].indexOf(',');   
      x=float(ss[i].substring(0, comma));
      y=float(ss[i].substring(comma+1, ss[i].length()));
      Point[k].setTo(x,y);
      };
    }; 
