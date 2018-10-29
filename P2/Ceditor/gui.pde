void keyPressed() 
  {
//  if(key=='`') picking=true; 
  if(key=='?') scribeText=!scribeText;
  if(key=='!') snapPicture();
  if(key=='~') filming=!filming;
  if(key==']') showBalls=!showBalls;
  if(key=='f') {P.setPicekdLabel(key);}
  if(key=='s') {P.setPicekdLabel(key);}
  // if(key=='b') {P.setPicekdLabel(key);}
  if(key=='c') {P.setPicekdLabel(key);}
  if(key=='F') {P.addPt(Of,'f');}
  if(key=='S') {P.addPt(Of,'s');}
  if(key=='B') {P.addPt(Of,'b');}
  if(key=='C') {P.addPt(Of,'c');}
  //if(key=='m') {method=(method+1)%5;}
  
  if(key==']') {showQuads=!showQuads;}
  if(key=='{') {showCurve=!showCurve;}
  if(key=='\\') {showKeys=!showKeys;}
  if(key=='}') {showPath=!showPath;}
  if(key=='|') {showCorrectedKeys=!showCorrectedKeys;}
  if(key=='=') {showTube=!showTube;}
  //if(key=='3') {P.resetOnCircle(3,300); Q.copyFrom(P);}
  //if(key=='4') {P.resetOnCircle(4,400); Q.copyFrom(P);}
  //if(key=='5') {P.resetOnCircle(5,500); Q.copyFrom(P);}
  if(key=='^') track=!track;
  // if(key=='q') Q.copyFrom(P);
  // if(key=='p') P.copyFrom(Q);
  if(key==',') {level=max(level-1,0); f=0;}
  if(key=='.') {level++;f=0;}

  //if(key=='e') {R.copyFrom(P); P.copyFrom(Q); Q.copyFrom(R);}
  // if(key=='d') {P.set_pv_to_pp(); P.deletePicked();}
  if (keyPressed && key=='d') {
      println("pressed p");
    }
  if(key=='i') P.insertClosestProjection(Of); // Inserts new vertex in P that is the closeset projection of O
  //if(key=='W') {P.savePts("data/pts"); Q.savePts("data/pts2");}  // save vertices to pts2
  //if(key=='L') {P.loadPts("data/pts"); Q.loadPts("data/pts2");}   // loads saved model
  if(key=='w') P.savePts("data/pts");   // save vertices to pts
  if(key=='l') P.loadPts("data/pts"); 
  if(key=='a') {animating=!animating; P.setFifo();}// toggle animation
  if(key=='^') showVecs=!showVecs;
  if(key=='#') exit();
  if(key=='=') {}
  
  if(key=='1') {showPCC=true; showTorus=false; showBiarc = false; F.setTo(OriginP);}
  if(key=='2') {showTorus=true; showPCC=false; showBiarc = false; F.setTo(OriginT);}
  if(key=='3') {showBiarc=true; showPCC=false; showTorus = false; F.setTo(OriginB);}
  
  if(key=='+') 
  {
    if (showPCC)
    {
      changeTorusesRopeQuantity(true);
    }
    else if (showTorus)
    {
      TorusDemo.changeRopeQuantity(true);
    }
  }
  if(key=='-')
  {
    if (showPCC)
    {
      changeTorusesRopeQuantity(false);
    }
    else if (showTorus)
    {
      TorusDemo.changeRopeQuantity(false);
    }
  }
  if(key=='m') 
  {
    if (showPCC) changeMainTorusesVisability();
    else if (showTorus) TorusDemo.showMainTorus = !TorusDemo.showMainTorus;
  }
  if(key=='b') {showControlInMainDemo=!showControlInMainDemo;}
  if(key=='n') {showBiarcsInMainDemo=!showBiarcsInMainDemo;}
  
  change=true;   // to save a frame for the movie when user pressed a key 
  }

void mouseWheel(MouseEvent event) 
  {
  dz -= event.getAmount(); 
  change=true;
  }

void mousePressed() 
  {
   if (showPCC)
   {
    if (!keyPressed) picking=true;
    if (!keyPressed) {P.set_pv_to_pp(); println("picked vertex "+P.pp);}
    if (keyPressed && key=='a') {P.addPt(Of);}
    change=true;
   }
   else if (showTorus)
   {
     if (!keyPressed) {TorusDemo.lockCurrentpp(); println("picked vertex "+TorusDemo.pp);}
   }
   else if (showBiarc) {
     biarcPickLock = false;
     println("pressed");
   }
   
  }
  
void mouseMoved() 
  {
    if (keyPressed && key==' ') {rx-=PI*(mouseY-pmouseY)/height; ry+=PI*(mouseX-pmouseX)/width;}
    if (keyPressed && key=='`') dz+=(float)(mouseY-pmouseY); // approach view (same as wheel)
    //change=true;
  }
  
void mouseDragged() 
  {
   
   if (showPCC)
   {
    if (!keyPressed) P.setPickedTo(Of); 
    
  //  if (!keyPressed) {Of.add(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); }
    if (keyPressed && key==CODED && keyCode==SHIFT) {Of.add(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0)));};
    if (keyPressed && key=='h') P.movePicked(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    if (keyPressed && key=='v') P.movePicked(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    if (keyPressed && key=='H') P.moveAll(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    if (keyPressed && key=='V') P.moveAll(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    if (keyPressed && key=='t')  // move focus point on plane
    {
      if(center) F.sub(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
      else F.add(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    }
    if (keyPressed && key=='T')  // move focus point vertically
    {
      if(center) F.sub(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
      else F.add(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    }
    if (keyPressed && key=='p')
    {
      demoTorusRopeTwist += 0.1 * (float)(pmouseY - mouseY);
      changeTorusesRopeTwisting(demoTorus, P, round(demoTorusRopeTwist));
      
    }
    
    change=true;
   }
   else if (showTorus)
   {
      if (keyPressed && key=='t')  // move focus point on plane
      {
        if(center) F.sub(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
        else F.add(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
      }
      if (keyPressed && key=='T')  // move focus point vertically
      {
        if(center) F.sub(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
        else F.add(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
      }
      if (keyPressed && key=='p')
      {
        TorusDemo.curpp = 1;
        TorusDemo.updateControlPoints(0.01 * (float)(pmouseY - mouseY), true);
      }
      if (keyPressed && key=='s')
      {
        TorusDemo.curpp = 0;
        TorusDemo.updateControlPoints(0.01 * (float)(pmouseY - mouseY), true);
      }
     if (!keyPressed) 
     {
       TorusDemo.updateControlPoints(0.01 * (float)(pmouseY - mouseY), false);
     }
   }
   else if (showBiarc)
   { 
      if (keyPressed && key=='t')  // move focus point on plane
      {
        if(center) F.sub(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
        else F.add(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
      }
      if (keyPressed && key=='T')  // move focus point vertically
      {
        if(center) F.sub(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
        else F.add(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
      }
     if (keyPressed && key=='h')  // move focus point horizontally
      {
        biarcPickLock = true;
        if (pick_point == 0 || pick_point == 1) {
            if (pick_point == 0) {
              biarcPoints[0].add(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0)));
              biarcPoints[2].add(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0)));
            } else {
              biarcPoints[1].add(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0)));
              biarcPoints[3].add(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0)));
            }
            Biarc.updateVertices(biarcPoints[0], biarcPoints[1]);
        } else {
            if (pick_point == 2) {
              biarcPoints[2].add(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0)));
              biarcPoints[2] = P(biarcPoints[0], V(arrowLen, U(V(biarcPoints[0], biarcPoints[2]))));
            } else {
              biarcPoints[3].add(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0)));
              biarcPoints[3] = P(biarcPoints[1], V(arrowLen, U(V(biarcPoints[1], biarcPoints[3]))));
            }
            Biarc.updateVectors(U(V(biarcPoints[0], biarcPoints[2])), U(V(biarcPoints[1], biarcPoints[3])));
          }
          
      }
      if (keyPressed && key=='v')  // move focus point vertically
      {
        biarcPickLock = true;
        if (pick_point == 0 || pick_point == 1) {
          if (pick_point == 0) {
            biarcPoints[0].add(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0)));
            biarcPoints[2].add(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0)));
          } else {
            biarcPoints[1].add(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0)));
            biarcPoints[3].add(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0)));
          }
          Biarc.updateVertices(biarcPoints[0], biarcPoints[1]);
        } else {
          if(pick_point == 2) {
            biarcPoints[2].add(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0)));
            biarcPoints[2] = P(biarcPoints[0], V(arrowLen, U(V(biarcPoints[0], biarcPoints[2]))));
          } else {
            biarcPoints[3].add(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0)));
            biarcPoints[3] = P(biarcPoints[1], V(arrowLen, U(V(biarcPoints[1], biarcPoints[3]))));
          }
          Biarc.updateVectors(U(V(biarcPoints[0], biarcPoints[2])), U(V(biarcPoints[1], biarcPoints[3])));
        }
      }
   }
  }  

// **** Header, footer, help text on canvas
void displayHeader()  // Displays title and authors face on screen
    {
      textSize(14);
      if (showPCC) scribeHeader(title1,0);
      else if (showTorus) scribeHeader(title2,0);
      else if (showBiarc) scribeHeader(title3,0);
      scribeHeaderRight(name1, 2); 
      fill(white); image(s1Face, width-s1Face.width/2 - 190, 25, s1Face.width/2,s1Face.height/2); 
      scribeHeaderRight(name2, 1); 
      fill(white); image(s2Face, width-s2Face.width/2 - 100, 25, s2Face.width/2,s2Face.height/2); 
      scribeHeaderRight(name3, 0); 
      fill(white); image(s3Face, width-s3Face.width/2 - 10, 25, s3Face.width/2,s3Face.height/2); 
    }
void displayFooter()  // Displays help text at the bottom
    { 
      noStroke();
      
      if (showPCC)
      {
        scribeFooter(demoSw, 0, blue); 
        scribeFooter(viewpt, 1, blue); 
        scribeFooter(showCtrl, 3, dgreen);
        scribeFooter(ctrlpt, 4, brown); 
        scribeFooter(threadCtrl, 5, red); 
      }
      else if (showTorus)
      {
        scribeFooter(demoSw, 0, blue); 
        scribeFooter(viewpt, 1, blue); 
        scribeFooter(showCtrl2, 3, dgreen);
        scribeFooter(ctrlpt21, 4, dgreen);
        scribeFooter(ctrlpt22, 5, dgreen); 
        scribeFooter(ctrlpt23, 6, dgreen); 
        scribeFooter(threadCtrl2, 7, red); 
      }
      else if (showBiarc)
      {
        scribeFooter(demoSw, 0, blue); 
        scribeFooter(viewpt, 1, blue); 
        scribeFooter(ctrlpt31, 3, dgreen);
        scribeFooter(ctrlpt32, 4, dgreen);
      }

    }

String  title1 = "PCC/Thread Demo", 
        title2 = "Torus Demo",
        title3 = "Biarc Demo",

        name1 = "Zhao Yan", 
        name2 = " Cong Du", 
        name3 = "Hanyu Liu", 

        demoSw = "Demo Switching Control: 1:PCC/Thread Demo, 2:Torus Demo, 3:Biarc Demo",
        viewpt = "Viewpoint Control: space:rotate, `/wheel:closer, t:move horizontally",

        showCtrl = "Show Control: b:show/hide Control Pts, n:show/hide Biarcs, m:showHide Main Torus",
        ctrlpt = "Control Points: click&drag:pick&slide on floor, vh/VH:move/ALL, a:add point",
        threadCtrl = "Thread Control: p&drag:twist threads, +/-:inc/dec thread #",

        ctrlpt21 = "Control Points: drag red/blue points:move control Pt G/P clockwise/counter-clockwise",
        ctrlpt22 = "                          p&drag: move control Pt P to twist the threads",
        ctrlpt23 = "                          s&drag: move control Pt G to twist the main Torus",
        showCtrl2 = "Show Control: m:showHide Main Torus",
        threadCtrl2 = "Thread Control: +/-:inc/dec thread #",

        ctrlpt31 = "vh&drag: change direction of vector if clicked on arrow",
        ctrlpt32 = "                 change location of vector if clicked on arrow base";



        
