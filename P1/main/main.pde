// base code 01 for graphics class 2018, Jarek Rossignac

// **** LIBRARIES
import processing.pdf.*;    // to save screen shots as PDFs, does not always work: accuracy problems, stops drawing or messes up some curves !!!
import java.awt.Toolkit;
import java.awt.datatransfer.*;


// **** GLOBAL VARIABLES

// COLORS
color // set more colors using Menu >  Tools > Color Selector
   black=#000000, grey=#5F5F5F, white=#FFFFFF, 
   red=#FF0000, green=#00FF01, blue=#0300FF,  
   yellow=#FEFF00, cyan=#00FDFF, magenta=#FF00FB, 
   orange=#FCA41F, dgreen=#026F0A, brown=#AF6E0B;
color[] color_array = new color[]{red, green, blue, yellow, cyan, magenta, orange, dgreen, brown};
// FILES and COUNTERS
String PicturesFileName = "SixteenPoints";
int frameCounter=0;
int pictureCounterPDF=0, pictureCounterJPG=0, pictureCounterTIF=0; // appended to file names to avoid overwriting captured images

// PICTURES
PImage FaceStudent1, FaceStudent2; // picture of student's face as /data/XXXXX.jpg in sketch folder !!!!!!!!

// TEXT
PFont bigFont; // Font used for labels and help text

// KEYBOARD-CONTROLLED BOOLEAM TOGGLES AND SELECTORS 
int method=0; // selects which method is used to set knot values (0=uniform, 1=chordal, 2=centripetal)
boolean animating=true; // must be set by application during animations to force frame capture
boolean texturing=false; // fill animated quad with texture
boolean showArrows=true;
boolean showInstructions=true;
boolean showLabels=true;
boolean showLERP=true;
boolean showLPM=true;
boolean fill=true;
boolean filming=false;  // when true frames are captured in FRAMES for a movie
boolean inputing = false;
int nConfiged = 0;

// flags used to control when a frame is captured and which picture format is used 
boolean recordingPDF=false; // most compact and great, but does not always work
boolean snapJPG=false;
boolean snapTIF=false;   

// ANIMATION
float totalAnimationTime=9; // at 1 sec for 30 frames, this makes the total animation last 90 frames
float time=0;

//POINTS 
int pointsCountMax = 32;         //  max number of points
int pointsCount=4;               // number of points used
PNT[] Point = new PNT[pointsCountMax];   // array of points
PNT A, B, C, D; // Convenient global references to the first 4 control points 
PNT P; // reference to the point last picked by mouse-click



// **** SETUP *******
void setup()               // executed once at the begining LatticeImage
  {
  size(800, 800, P2D);            // window size
  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing
  bigFont = createFont("AdobeFanHeitiStd-Bold-32", 16); textFont(bigFont); // font used to write on screen
  FaceStudent1 = loadImage("data/student1.jpg");  // file containing photo of student's face
  FaceStudent2 = loadImage("data/student2.jpg");  // file containing photo of student's face
  declarePoints(Point); // creates objects for 
  readPoints("data/points.pts");
  A=Point[0]; B=Point[1]; C=Point[2]; D=Point[3]; // sets the A B C D pointers
  textureMode(NORMAL); // addressed using [0,1]^2
  } // end of setup


// **** DRAW
void draw()      // executed at each frame (30 times per second)
  {
  int n = 0;
  if(!inputing && nConfiged > 0) n = nConfiged;
  else  n = 4;
  if(recordingPDF) startRecordingPDF(); // starts recording graphics to make a PDF
  
  if(showInstructions) showHelpScreen(); // display help screen with student's name and picture and project title

  else // display frame
    {
    background(white); // erase screen
    A=Point[0]; B=Point[1]; C=Point[2]; D=Point[3]; // sets the A B C D pointers
        
    // Update animation time
    if(animating) 
      {
      if(time<1) time+=1./(totalAnimationTime*frameRate); // advance time
      else  time=0; // reset time to the beginning
      }
    
   // WHEN USING 4 CONTROL POINTS:  Use this for morphing edges (in 6491)
   if(pointsCount==4)
      {
      if (texturing) {
        float step_width = 1.0 / n;
        for (int i = 0; i < n; i++) {
          for (int j = 0; j < n; j++) {
             drawSQUINTTileTextured(A, B, C, D, i * step_width, j * step_width, step_width, FaceStudent1); 
          }
        }
      } else {
        float step_width = 1.0 / n;
        for (int i = 0; i <= n; i++) {
          drawSQUINTcurve(A, B, C, D, i * step_width, false);
          drawSQUINTcurve(A, B, C, D, i * step_width, true);
          for (int j = 0; j <= n; j++) {
            drawCircle(SQUINTmap(A, B, C, D, i * step_width, j * step_width), 2);
          }
        }
      }
      
      //int color_idx = 0;
      //for (float u = 0; u <= n; u+=step_width) {
      //  for (float v = 0; v <= n; v+=step_width) {
      //    fill(color_array[color_idx % 9]); stroke(color_idx % 9);
      //    color_idx++;
      //    drawCircle(SQUINTmap(A, B, C, D, u, v), 2);
      //  }
      //}
          
      // Draw and label control points
      if(showLabels) // draw names of control points
        {
        textAlign(CENTER, CENTER); // to position the label around the point
        stroke(black); strokeWeight(1); // attribute of circle around the label
        showLabelInCircle(A,"A"); showLabelInCircle(B,"B"); showLabelInCircle(C,"C"); showLabelInCircle(D,"D"); 
         }
      else // draw small dots at control points
        {
        fill(brown); stroke(brown); 
        drawCircle(A,4); drawCircle(B,4); drawCircle(C,4); drawCircle(D,4);
        }
      noFill(); 
      
      } // end of when 4 points
      


     
    if(pointsCount==16)
      {    
        
        if(showLabels) // draw names of control points
        {
        textAlign(CENTER, CENTER); // to position the label around the point
        stroke(black); strokeWeight(1); // attribute of circle around the label
        for(int i=0; i<pointsCount; i++) showLabelInCircle(Point[i],Character.toString((char)(int)(i+65)));
        }
        else // draw small dots at control points
        {
        fill(blue); stroke(blue); strokeWeight(2);  
        for(int i=0; i<pointsCount; i++) drawCircle(Point[i],4);
        }
        
        for(int i=0; i<4; i++) {
          drawNevilleCurve(0, Point[0+i], 0.333, Point[4+i], 0.666, Point[8+i], 1, Point[12+i]);
        }
        for(int i=0; i<4;i++) {
          drawEdge(Point[i*4], Point[i*4+1]);
          drawEdge(Point[i*4+1], Point[i*4+2]);
          drawEdge(Point[i*4+2], Point[i*4+3]);
          drawEdge(Point[i*4+3], Point[i*4]);
        }
        
        strokeWeight(20); stroke(red,100); // semitransparent
       // *** replace {At,Bt..} by QUAD OBJECT in the code below
       PNT At=P(), Bt=P(), Ct=P(), Dt=P();
       NevillQuads(At,Bt,Ct,Dt,Point,time); 
         
       drawQuad(At, Bt, Ct, Dt);
       
        
      /*  
        
      for(int i=0; i<4; i++) {  
        drawSQUINTcurve(Point[i*4], Point[i*4+1], Point[i*4+2], Point[i*4+3], 0.0, true);
        drawSQUINTcurve(Point[i*4], Point[i*4+1], Point[i*4+2], Point[i*4+3], 1.0, true);
        drawSQUINTcurve(Point[i*4], Point[i*4+1], Point[i*4+2], Point[i*4+3], 0.0, false);
        drawSQUINTcurve(Point[i*4], Point[i*4+1], Point[i*4+2], Point[i*4+3], 1.0, false);
      }
      if(showLabels) // draw names of control points
        {
        textAlign(CENTER, CENTER); // to position the label around the point
        stroke(black); strokeWeight(1); // attribute of circle around the label
        for(int i=0; i<pointsCount; i++) showLabelInCircle(Point[i],Character.toString((char)(int)(i+65)));
        }
      else // draw small dots at control points
        {
        fill(blue); stroke(blue); strokeWeight(2);  
        for(int i=0; i<pointsCount; i++) drawCircle(Point[i],4);
        }
        
      strokeWeight(20); stroke(red,100); // semitransparent
       // *** replace {At,Bt..} by QUAD OBJECT in the code below
       PNT At=P(), Bt=P(), Ct=P(), Dt=P();
       if(showLERP) 
         {
         LERPquads(At,Bt,Ct,Dt,Point,time);
         noFill(); noStroke(); 
         if(texturing) {
           float step_width = 1.0 / n;
            for (int i = 0; i < n; i++) {
              for (int j = 0; j < n; j++) {
               drawSQUINTTileTextured(At, Bt, Ct, Dt, i * step_width, j * step_width, step_width, FaceStudent1); 
              }
            }
          }
         else
           {
           float step_width = 1.0 / n;
            for (int i = 0; i <= n; i++) {
              drawSQUINTcurve(At, Bt, Ct, Dt, i * step_width, false);
              drawSQUINTcurve(At, Bt, Ct, Dt, i * step_width, true);
              for (int j = 0; j <= n; j++) {
              drawCircle(SQUINTmap(At, Bt, Ct, Dt, i * step_width, j * step_width), 2);
            }
        }
           }
         }
       if(showLPM) 
         {
         LPMquads(At,Bt,Ct,Dt,Point,time);
         noFill(); noStroke(); 
         if(texturing) {
           float step_width = 1.0 / n;
              for (int i = 0; i < n; i++) {
                for (int j = 0; j < n; j++) {
                 drawSQUINTTileTextured(At, Bt, Ct, Dt, i * step_width, j * step_width, step_width, FaceStudent1); 
          }
        }
       }
         else
           {
           float step_width = 1.0 / n;
        for (int i = 0; i <= n; i++) {
          drawSQUINTcurve(At, Bt, Ct, Dt, i * step_width, false);
          drawSQUINTcurve(At, Bt, Ct, Dt, i * step_width, true);
          for (int j = 0; j <= n; j++) {
            drawCircle(SQUINTmap(At, Bt, Ct, Dt, i * step_width, j * step_width), 2);
          }
        }
           }
         }
         */
      } // end of when 16 points
    } 

  if(recordingPDF) endRecordingPDF();  // end saving a .pdf file with the image of the canvas
  if(snapTIF) snapPictureToTIF();   
  if(snapJPG) snapPictureToJPG();   
  if(filming) snapFrameToTIF(); // saves image on canvas as movie frame 
  
  } // end of draw()
