//**** NEVILLE INTERPOLATING CURVES AND ANIMATIONS *** Project 1 for CS3451
PNT Neville(float a, PNT A, float b, PNT B, float t) 
  {
  //**UG** ADD YOUR CODE HERE INSTEAD OF LINE BELOW
  return LERP(A,t,B);  // INCORRET SOLUTION PROVIDED AS PLACEHOLDER
  }
  
PNT Neville(float a, PNT A, float b, PNT B, float c, PNT C, float t) 
  {
    //**UG** ADD YOUR CODE HERE INSTEAD OF LINE BELOW
  return  Neville(a,A,c,C,t);  // INCORRET SOLUTION PROVIDED AS PLACEHOLDER
  }
  
PNT Neville(float a, PNT A, float b, PNT B, float c, PNT C, float d, PNT D, float t) 
  {
  //**UG** ADD YOUR CODE HERE INSTEAD OF LINE BELOW
  return Neville(a,A,d,D,t);  // INCORRET SOLUTION PROVIDED AS PLACEHOLDER
  }

void drawNevilleCurve(float a, PNT A, float b, PNT B, float c, PNT C, float d, PNT D)
    {
    float du=1./90;
    beginShape(); 
      for(float u=0; u<=1.+du/2; u+=du) 
        vert(Neville(a,A,b,B,c,C,d,D,u)); // does not work yet (you must write that Neville function (in Tab points) )
    endShape(); 
    }

void showNevilleConstruction(float a, PNT A, float b, PNT B, float c, PNT C, float d, PNT D, float time) 
  {
  //**UG** ADD HERE YOUR SHOW NEVILLE CONSTRUCTION CODE, 
  }

//**** BEZIER INTERPOLATING CURVES AND ANIMATIONS 
PNT Bezier(PNT A, PNT B, float t) 
  {
  return LERP(A,t,B);  
  }
  
PNT Bezier(PNT A, PNT B, PNT C, float t) 
  {
  PNT S = Bezier(A,B,t);
  PNT E = Bezier(B,C,t);
  return  Bezier(S,E,t);
  }
  
PNT Bezier(PNT A, PNT B, PNT C, PNT D, float t) 
  {
  PNT S = Bezier(A,B,C,t);
  PNT E = Bezier(B,C,D,t);
  return  Bezier(S,E,t);
  }

void drawBezierCurve(PNT A, PNT B, PNT C)
    {
    float du=1./90;
    beginShape(); 
      for(float u=0; u<=1.+du/2; u+=du) 
        vert(Bezier(A,B,C,u)); // does not work yet (you must write that Neville function (in Tab points) )
    endShape(); 
    }

void drawBezierCurve(PNT A, PNT B, PNT C, PNT D)
    {
    float du=1./90;
    beginShape(); 
      for(float u=0; u<=1.+du/2; u+=du) 
        vert(Bezier(A,B,C,D,u)); // does not work yet (you must write that Neville function (in Tab points) )
    endShape(); 
    }

void showBezierConstruction(PNT A, PNT B, PNT C, PNT D, float t)
  {
  PNT Pab = Bezier(A,B,t),  Pbc = Bezier(B,C,t),  Pcd = Bezier(C,D,t);
  PNT          Pabc = Bezier(Pab,Pbc,t),      Pbcd = Bezier(Pbc,Pcd,t);
  PNT                   Pabcd = Bezier(Pabc,Pbcd,t);
  noFill();

  strokeWeight(14);
  stroke(orange,40); drawBezierCurve(A,B,C);   
  stroke(magenta,40); drawBezierCurve(B,C,D);  
  
  noStroke();
  fill(orange,100); drawCircle(Pabc,16); 
  fill(magenta,100); drawCircle(Pbcd,16);
  
  noFill();
 
  stroke(blue);
  strokeWeight(2);  drawEdge(A,B); drawEdge(B,C); drawEdge(C,D);
  strokeWeight(6);  drawEdge(A,Pab);  drawEdge(B,Pbc); drawEdge(C,Pcd);

  stroke(green);    
  strokeWeight(2);  drawEdge(Pab,Pbc); drawEdge(Pbc,Pcd); 
  strokeWeight(6); drawEdge(Pab,Pabc);  drawEdge(Pbc,Pbcd); 

  stroke(red);
  strokeWeight(2);  drawEdge(Pabc,Pbcd); 
  strokeWeight(6);  drawEdge(Pabc,Pabcd);  

  noStroke();
  float r=8;
  fill(blue); drawCircle(Pab,r); drawCircle(Pbc,r); drawCircle(Pcd,r);
  fill(green); drawCircle(Pabc,r); drawCircle(Pbcd,r); 
  fill(red); drawCircle(Pabcd,r);
  }
