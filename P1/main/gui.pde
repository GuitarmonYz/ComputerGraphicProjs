void keyPressed()  // executed each time a key is pressed: sets the Boolean "keyPressed" till it is released   
                   // sets  char "key" state variables till another key is pressed or released
    { 
    if(key=='~') recordingPDF=true; // to snap an image of the canvas and save as zoomable a PDF, compact and great quality, but does not always work
    if(key=='!') snapJPG=true; // make a .PDF picture of the canvas, compact, poor quality
    if(key=='@') snapTIF=true; // make a .TIF picture of the canvas, better quality, but large file
    if(key=='#') showLabels=!showLabels;
    if(key=='$') ;
    if(key=='%') ;
    if(key=='^') ;
    if(key=='&') ; 
    if(key=='*') ;    
    if(key=='(') ;
    if(key==')') ;  
    if(key=='_') ;
    if(key=='+') ;

    if(key=='`') filming=!filming;  // filming on/off capture frames into folder IMAGES/MOVIE_FRAMES_TIF/
    if(key=='1') method=1;                  
    if(key=='2') method=2;
    if(key=='3') ;
    if(key=='4') makeFourSquares();
    if(key=='5') ;
    if(key=='6') ;
    if(key=='7') ; 
    if(key=='8') ;
    if(key=='9') ;
    if(key=='0') method=0;
    if(key=='-') {A=Point[0]; B=Point[1]; C=Point[2]; D=Point[3];}
    if(key=='=') ;

    if(key=='a') {animating=!animating;}
    if(key=='b') ; 
    if(key=='c') ; 
    if(key=='d') ;  
    if(key=='e') ;
    if(key=='f') fill=!fill;
    if(key=='g') ; 
    if(key=='h') ;
    if(key=='i') ;
    if(key=='j') ;
    if(key=='k') ; 
    if(key=='l') showLERP=!showLERP;
    if(key=='m') ;
    if(key=='n') ;
    if(key=='o') ;  
    if(key=='p') ;
    if(key=='q') ; 
    if(key=='r') {readPoints("data/points.pts"); } 
    if(key=='s') showLPM=!showLPM;
    if(key=='t') texturing=!texturing; 
    if(key=='u') ;
    if(key=='v') showArrows=!showArrows; 
    if(key=='w') writePoints("data/points.pts"); 
    if(key=='x') ;
    if(key=='y') ;
    if(key=='z') ; 

    if(key=='A') ;
    if(key=='B') ;  
    if(key=='C') {PicturesFileName=getClipboard(); println("PicturesFileName="+PicturesFileName);} // myFile
    if(key=='D') ;  
    if(key=='E') ;
    if(key=='F') ;
    if(key=='G') ; 
    if(key=='H') ; 
    if(key=='I') ; 
    if(key=='J') ;
    if(key=='K') ;
    if(key=='L') ;
    if(key=='M') ; 
    if(key=='N') ;
    if(key=='O') ;
    if(key=='P') ;
    if(key=='Q') ;
    if(key=='R') readPoints("data/"+PicturesFileName+".pts"); 
    if(key=='S') ;
    if(key=='T') ;
    if(key=='U') ;
    if(key=='V') ; 
    if(key=='W') writePoints("data/"+PicturesFileName+".pts"); 
    if(key=='X') ; 
    if(key=='Y') ;
    if(key=='Z') ;  

    if(key=='{') ;
    if(key=='}') ;
    if(key=='|') ; 
    if(key=='[') ;
    if(key==']') setToSquare(A,B,C,D); // places the first 4 points at vertices of a square 
    if(key=='\\') ;
    if(key==':') ; 
    if(key=='"') ;    
    if(key==';') ; 
    if(key=='\'') ;    
    if(key=='<') ;
    if(key=='>') ;
    if(key=='?') ;
    if(key==',') totalAnimationTime+=0.3; 
    if(key=='.') totalAnimationTime=max(0,totalAnimationTime-0.3);
    if(key=='/') {B.setTo(LERP(A,1./3,D)); C.setTo(LERP(A,2./3,D));}; // places points 1 and 2 evenly between points 0 and 3
  
    if(key==' ') showInstructions=!showInstructions; // toggle display of help text and authors picture 
  
    if (key == CODED) 
       {
       String pressed = "Pressed coded key ";
       if (keyCode == UP) {pressed="UP";   }
       if (keyCode == DOWN) {pressed="DOWN";   };
       if (keyCode == LEFT) {pressed="LEFT";   };
       if (keyCode == RIGHT) {pressed="RIGHT";   };
       if (keyCode == ALT) {pressed="ALT";   };
       if (keyCode == CONTROL) {pressed="CONTROL";   };
       if (keyCode == SHIFT) {pressed="SHIFT";   };
       println("Pressed coded key = "+pressed); 
       } 
    println("key pressed = "+key);
    }

void mousePressed()   // executed when the mouse is pressed
  {
  PNT M=Mouse();
  P=Point[0];
  for(int i=1; i<pointsCount; i++) if(dist(M,Point[i])<dist(M,P)) P=Point[i]; 
  }

void mouseDragged() // executed when the mouse is dragged (while mouse buttom pressed)
  {
  if (keyPressed) 
     {
     PNT O = P(width/2,height/2), M=Mouse(), P=PMouse();
     float s=dist(O,M)/dist(O,P);
     if (key=='x') {for(int i=0; i<pointsCount; i++) Point[i].teleport();} 
     if (key=='z') {for(int i=0; i<pointsCount; i++) Point[i].setTo(LERP(O,s,Point[i]));} 
     }  
  else {P.teleport();} // teleporting mouse motion
  }  

void mouseWheel(MouseEvent event) // reads mouse wheel and uses to zoom
  { 
  float s = event.getAmount();
  PNT O = P(width/2,height/2);
  for(int i=0; i<pointsCount; i++) Point[i].setTo(LERP(O,1.-s/100,Point[i]));
  }
