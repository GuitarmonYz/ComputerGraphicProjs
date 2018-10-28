  //  ******************* Basecode for P2 ***********************
Boolean 
        animating=true, 
        PickedFocus=false, 
        center=true, 
        track=false, 
        showViewer=false, 
        showBalls=false, 
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
        showPCC = true,
        showBiarc = false,
        
        showTorusesInMainDemo = true,
        showRopesInMainDemo = true,
        showBiarcsInMainDemo = true,
        showControlInMainDemo = true;

//CEditor Demo
float   
        t=0, 
        s=0;
int     
        f=0, 
        maxf=2*30, 
        level=4, 
        method=5;
String SDA = "angle";
float defectAngle=0;
pt OriginP = P(100,100,0);
pts P = new pts(); // polyloop in 3D
//pts Q = new pts(); // second polyloop in 3D
//pts R = new pts(); // inbetweening polyloop L(P,t,Q);
int     demoTorusnv = 20,
        demoTorusnu = 40,
        demoTorusunv = 12;
int     demoTorusnRope = 4,
        demoTorusnMaxRope = 10;
float   demoTorusRopeTwist = 0;
boolean demoTorusMainTorusVisibility = true;
biarc[] demoBiarc = new biarc[20];
torus[] demoTorus = new torus[40];


//torus demo
pt OriginT = new pt(0,0,300);
vec XAxis = new vec(1,0,0);
torus TorusDemo = new torus();
vec TorusDemo_GOV = new vec(20, 0, 0);

//biarc demo
int arrowLen = 80;
pt OriginB = new pt(0,0,30);
pt[] biarcPoints = new pt[4];
biarc Biarc;
boolean biarcPickLock = false;
int pick_point = -1;

//tangents demo
pts P_T = new pts();

void setup() {
  myFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  textureMode(NORMAL);          
  size(1000, 1000, P3D); // P3D means that we will do 3D graphics
  if (showPCC) F.setTo(OriginP);
  else if (showTorus) F.setTo(OriginT);
  else if (showBiarc) F.setTo(OriginB);
  
  //PCC Setup
  P.declare(); 
  P.loadPts("data/pts");  
  for (int i = 0; i < 20; i++) demoBiarc[i] = new biarc();
  for (int i = 0; i < 40; i++) demoTorus[i] = new torus();
  drawBiarcs(demoBiarc, P);
  for (int i = 0; i < 100; i++)
  {
    demoTorus[i] = new torus();
  }
  drawToruses(demoBiarc, demoTorus, P);
  P_T.declare();
  P_T.loadPts("data/pts3");
  //TorusDemo Setup
  TorusDemo = new torus(OriginT, XAxis, new vec(0,0,200), TorusDemo_GOV, TorusDemo_GOV, 0.4, 40, 100, 10);
  
  // BiarcDemo Setup
  biarcPoints[0] = P(100,0,50);
  biarcPoints[1] = P(-100,0,50);
  biarcPoints[2] = P(P(100, 0, 50), V(arrowLen,U(V(0, -1, 1))));
  biarcPoints[3] = P(P(-100, 0, 50), V(arrowLen, U(V(1, 1, 1))));
  Biarc = new biarc(biarcPoints[0], biarcPoints[1], U(V(biarcPoints[0], biarcPoints[2])), U(V(biarcPoints[1],biarcPoints[3])));
  
  noSmooth();
  frameRate(30);
}


void draw() {
  background(255);
  //hint(ENABLE_DEPTH_TEST); 
  pushMatrix();   // to ensure that we can restore the standard view before writing on the canvas
  setView();  // see pick tab
  showFloor(); // draws dance floor as yellow mat
  doPick(); // sets Of and axes for 3D GUI (see pick Tab)
  
  if (showPCC)
  {
    P.SETppToIDofVertexWithClosestScreenProjectionTo(Mouse()); // for picking (does not set P.pv)
    if(showControlInMainDemo) {fill(grey); P.drawClosedCurve(10);}  // draw control polygon 
    // fill(yellow,100); P.showPicked(); 

    drawBiarcs(demoBiarc, P);
    if (change)
    {
      updateToruses(demoBiarc, demoTorus, P);
    }
    drawToruses(demoTorus, P);
  }
  
  if (showTorus)
  {
    TorusDemo.SETppToIDofVertexWithClosestScreenProjectionTo(Mouse());
    TorusDemo.drawTorus();
    TorusDemo.drawControlPoints(8);
  }
  
  if (showBiarc) {
    Biarc.drawBiarc();
    Biarc.updateNearestPoint();
    noStroke();
    fill(red);
    arrow(biarcPoints[0], biarcPoints[2], 15);
    fill(green);
    arrow(biarcPoints[1], biarcPoints[3], 15);
  }

  // if (showTangent) {
  //   // float[] r = new float[]{0};
  //   // vec tangent = getTangentByCircle(P.G[0], P.G[1], P.G[2], P.G[1], r);
  //   // arrow(P.G[1], P(P.G[1], V(40,tangent)), 15);
  //   // sphere(P.G[0], 10);
  //   // sphere(P.G[1], 10);
  //   // sphere(P.G[2], 10);
    
  //   vec[] tangents = getTangentsByThreeCircle(P_T);
  //   stroke(red);
  //   for (int i = 0; i < tangents.length; i++) {
  //     arrow(P_T.G[i], P(P_T.G[i], V(40,tangents[i])), 15);
  //     sphere(P_T.G[i], 10);
  //   }
    
  // }

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
  strokeWeight(1);
  popMatrix(); // done with 3D drawing. Restore front view for writing text on canvas
  

  
  
  //hint(DISABLE_DEPTH_TEST); // no z-buffer test to ensure that help text is visible
  //  if(method==4) scribeHeader("Quintic UBS",2);
  //  if(method==3) scribeHeader("Cubic UBS",2);
  //  if(method==2) scribeHeader("Jarek J-spline",2);
  //  if(method==1) scribeHeader("Four Points",2);
  //  if(method==0) scribeHeader("Quadratic UBS",2);

  // used for demos to show red circle when mouse/key is pressed and what key (disk may be hidden by the 3D model)
  if(mousePressed) {stroke(cyan); strokeWeight(3); noFill(); ellipse(mouseX,mouseY,20,20); strokeWeight(1);}
  if(keyPressed) {stroke(red); fill(white); ellipse(mouseX+14,mouseY+20,26,26); fill(red); text(key,mouseX-5+14,mouseY+4+20); strokeWeight(1); }
  if(scribeText) {fill(black); displayHeader();} // dispalys header on canvas, including my face
  displayFooter(); // shows menu at bottom, only if not filming
  //if(filming && (animating || change)) saveFrame("FRAMES/F"+nf(frameCounter++,4)+".tif");  // save next frame to make a movie
  change=false; // to avoid capturing frames when nothing happens (change is set uppn action)
  //change=true;
  }
