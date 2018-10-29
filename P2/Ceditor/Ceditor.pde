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
        tangent_method = 0,
        f=0, 
        maxf=2*30, 
        level=4, 
        method=5;
String SDA = "angle";
float defectAngle=0;
pt OriginP = P(100,100,0);
pts P = new pts(); // polyloop in 3D
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

void setup() {
  s1Face = loadImage("data/s1.jpg");
  s2Face = loadImage("data/s2.jpg");
  s3Face = loadImage("data/s3.jpg");

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
  initToruses(demoBiarc, demoTorus, P);
  
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
  pushMatrix();   // to ensure that we can restore the standard view before writing on the canvas
  setView();  // see pick tab
  showFloor(); // draws dance floor as yellow mat
  doPick(); // sets Of and axes for 3D GUI (see pick Tab)
  
  if (showPCC)
  {
    P.SETppToIDofVertexWithClosestScreenProjectionTo(Mouse()); // for picking (does not set P.pv)
    if(showControlInMainDemo) {fill(grey); P.drawClosedCurve(10);}  // draw control polygon 

    drawBiarcs(demoBiarc, P);
    if (change) updateToruses(demoBiarc, demoTorus, P);
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

  textSize(14);
  strokeWeight(1);
  popMatrix(); // done with 3D drawing. Restore front view for writing text on canvas

  if(mousePressed) {stroke(cyan); strokeWeight(3); noFill(); ellipse(mouseX,mouseY,20,20); strokeWeight(1);}
  if(keyPressed) {stroke(red); fill(white); ellipse(mouseX+14,mouseY+20,26,26); fill(red); text(key,mouseX-5+14,mouseY+4+20); strokeWeight(1); }
  if(scribeText) {fill(black); displayHeader();} // dispalys header on canvas, including my face
  displayFooter(); // shows menu at bottom, only if not filming
  change=false; // to avoid capturing frames when nothing happens (change is set uppn action)
  }
