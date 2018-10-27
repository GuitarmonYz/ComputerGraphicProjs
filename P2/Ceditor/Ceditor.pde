  //  ******************* Basecode for P2 ***********************
Boolean 
  animating=true, 
  PickedFocus=false, 
  center=true, 
  track=false, 
  showViewer=false, 
  showBalls=false, 
  showControl=true, 
  showCurve=true, 
  showPath=true, 
  showKeys=true, 
  showSkater=false, 
  scene1=false,
  solidBalls=false,
  showCorrectedKeys=true,
  showQuads=true,
  showVecs=true,
  showTube=false,
  
  showTorus = false,
  showEditorDemo = true,
  showBiarc = false;

//CEditor Demo
float 
  t=0, 
  s=0;
int
  f=0, maxf=2*30, level=4, method=5;
String SDA = "angle";
float defectAngle=0;
pt OriginalO = P(100,100,0);
pts P = new pts(); // polyloop in 3D
pts Q = new pts(); // second polyloop in 3D
pts R = new pts(); // inbetweening polyloop L(P,t,Q);
int demoTorusnv = 4,
    demoTorusnu = 40,
    demoTorusunv = 4;

biarc[] demoBiarc = new biarc[50];
torus[] demoTorus = new torus[100];

int twistCnt = 0;
float initialDiff = 0;
boolean flg = true;


//torus demo
pt Origin = new pt(0,0,300);
vec XAxis = new vec(1,0,0);
torus TorusDemo = new torus();
vec TorusDemo_GOV = new vec(50, 0, 0);

//biarc demo
pt[] biarcPoints = new pt[4];
biarc Biarc;
boolean biarcPickLock = false;
int pick_point = -1;

void setup() {
  myFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  textureMode(NORMAL);          
  size(1000, 1000, P3D); // P3D means that we will do 3D graphics
  
  //CEditorDemo Setup
  P.declare(); Q.declare(); R.declare();
  P.loadPts("data/pts");  Q.loadPts("data/pts2"); 
  drawBiarcs(demoBiarc, P);
  for (int i = 0; i < 100; i++)
  {
    demoTorus[i] = new torus();
  }
  drawToruses(demoBiarc, demoTorus, P);
  
  //TorusDemo Setup
  TorusDemo = new torus(Origin, XAxis, new vec(0,0,200), TorusDemo_GOV, TorusDemo_GOV, 0.4, 40, 100, 4);
  if (showTorus) F.setTo(Origin);
  
  // BiarcDemo Setup
  biarcPoints[0] = P(100,0,0);
  biarcPoints[1] = P(-100,0,0);
  biarcPoints[2] = P(P(100, 0, 0), V(40,U(V(0, -1, 1))));
  biarcPoints[3] = P(P(-100, 0, 0), V(40, U(V(1, 1, 1))));
  Biarc = new biarc(biarcPoints[0], biarcPoints[1], U(V(biarcPoints[0], biarcPoints[2])), U(V(biarcPoints[1],biarcPoints[3])));
  
  

  noSmooth();
  frameRate(30);
}


void draw() {
  background(255);
  hint(ENABLE_DEPTH_TEST); 
  pushMatrix();   // to ensure that we can restore the standard view before writing on the canvas
  setView();  // see pick tab
  showFloor(); // draws dance floor as yellow mat
  doPick(); // sets Of and axes for 3D GUI (see pick Tab)
  
  if (showEditorDemo)
  {
// P is a polyloop in 3D: declared in pts
    //P.resetOnCircle(6,100); Q.copyFrom(P); // use this to get started if no model exists on file: move points, save to file, comment this line
    // loads saved models from file (comment out if they do not exist yet)
    P.SETppToIDofVertexWithClosestScreenProjectionTo(Mouse()); // for picking (does not set P.pv)
    // R.copyFrom(P);
    // for(int i=0; i<level; i++)
    //   {
    //   Q.copyFrom(R); 
    //   if(method==5) {Q.subdivideDemoInto(R);}
    //   //if(method==4) {Q.subdivideQuinticInto(R);}
    //   //if(method==3) {Q.subdivideCubicInto(R); }
    //   //if(method==2) {Q.subdivideJarekInto(R); }
    //   //if(method==1) {Q.subdivideFourPointInto(R);}
    //   //if(method==0) {Q.subdivideQuadraticInto(R); }
    //   }
    //R.displaySkater();

    //fill(blue); if(showCurve) Q.drawClosedCurve(3);
    if(showControl) {fill(grey); P.drawClosedCurve(10);}  // draw control polygon 
    fill(yellow,100); P.showPicked(); 

    drawBiarcs(demoBiarc, P);
    drawToruses(demoBiarc, demoTorus, P);
  }
  
  if (showTorus)
  {
    TorusDemo.SETppToIDofVertexWithClosestScreenProjectionTo(Mouse());
    TorusDemo.drawTorus();
  }
  
  if (showBiarc) {
    Biarc.drawBiarc();
    Biarc.updateNearestPoint();
    arrow(biarcPoints[0], biarcPoints[2], 15);
    arrow(biarcPoints[1], biarcPoints[3], 15);
  }

  //if(animating)  
  //  {
  //  f++; // advance frame counter
  //  if (f>maxf) // if end of step
  //    {
  //    P.next();     // advance dv in P to next vertex
 ////     animating=true;  
  //    f=0;
  //    }
  //  }
  //t=(1.-cos(PI*f/maxf))/2; //t=(float)f/maxf;

  //if(track) F=_LookAtPt.move(X(t)); // lookAt point tracks point X(t) filtering for smooth camera motion (press'.' to activate)
  textSize(14);
  popMatrix(); // done with 3D drawing. Restore front view for writing text on canvas
  

  
  
  hint(DISABLE_DEPTH_TEST); // no z-buffer test to ensure that help text is visible
    if(method==4) scribeHeader("Quintic UBS",2);
    if(method==3) scribeHeader("Cubic UBS",2);
    if(method==2) scribeHeader("Jarek J-spline",2);
    if(method==1) scribeHeader("Four Points",2);
    if(method==0) scribeHeader("Quadratic UBS",2);

  // used for demos to show red circle when mouse/key is pressed and what key (disk may be hidden by the 3D model)
  if(mousePressed) {stroke(cyan); strokeWeight(3); noFill(); ellipse(mouseX,mouseY,20,20); strokeWeight(1);}
  if(keyPressed) {stroke(red); fill(white); ellipse(mouseX+14,mouseY+20,26,26); fill(red); text(key,mouseX-5+14,mouseY+4+20); strokeWeight(1); }
  if(scribeText) {fill(black); displayHeader();} // dispalys header on canvas, including my face
  if(scribeText && !filming) displayFooter(); // shows menu at bottom, only if not filming
  if(filming && (animating || change)) saveFrame("FRAMES/F"+nf(frameCounter++,4)+".tif");  // save next frame to make a movie
  change=false; // to avoid capturing frames when nothing happens (change is set uppn action)
  change=true;
  }
