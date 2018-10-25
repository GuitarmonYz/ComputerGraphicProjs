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
  if(key=='m') {method=(method+1)%5;}
  if(key=='[') {showControl=!showControl;}
  if(key==']') {showQuads=!showQuads;}
  if(key=='{') {showCurve=!showCurve;}
  if(key=='\\') {showKeys=!showKeys;}
  if(key=='}') {showPath=!showPath;}
  if(key=='|') {showCorrectedKeys=!showCorrectedKeys;}
  if(key=='=') {showTube=!showTube;}
  if(key=='3') {P.resetOnCircle(3,300); Q.copyFrom(P);}
  if(key=='4') {P.resetOnCircle(4,400); Q.copyFrom(P);}
  if(key=='5') {P.resetOnCircle(5,500); Q.copyFrom(P);}
  if(key=='^') track=!track;
  if(key=='q') Q.copyFrom(P);
  if(key=='p') P.copyFrom(Q);
  if(key==',') {level=max(level-1,0); f=0;}
  if(key=='.') {level++;f=0;}

  //if(key=='e') {R.copyFrom(P); P.copyFrom(Q); Q.copyFrom(R);}
  if(key=='d') {P.set_pv_to_pp(); P.deletePicked();}
  if(key=='i') P.insertClosestProjection(Of); // Inserts new vertex in P that is the closeset projection of O
  if(key=='W') {P.savePts("data/pts"); Q.savePts("data/pts2");}  // save vertices to pts2
  if(key=='L') {P.loadPts("data/pts"); Q.loadPts("data/pts2");}   // loads saved model
  if(key=='w') P.savePts("data/pts");   // save vertices to pts
  if(key=='l') P.loadPts("data/pts"); 
  if(key=='a') {animating=!animating; P.setFifo();}// toggle animation
  if(key=='^') showVecs=!showVecs;
  if(key=='#') exit();
  if(key=='=') {}
  
  if(key=='e') {showEditorDemo=!showEditorDemo; showTorus=false; F.setTo(Of);}
  if(key=='d') {showTorus=!showTorus; showEditorDemo=false; showBiarc = false; F.setTo(Origin);}
  if(key=='b') {showBiarc=!showBiarc; showEditorDemo=false; showTorus = false; F.setTo(Origin);}
  change=true;   // to save a frame for the movie when user pressed a key 
  }

void mouseWheel(MouseEvent event) 
  {
  dz -= event.getAmount(); 
  change=true;
  }

void mousePressed() 
  {
   if (!showTorus)
   {
    //if (!keyPressed) picking=true;
    if (!keyPressed) {P.set_pv_to_pp(); println("picked vertex "+P.pp);}
    if(keyPressed && key=='a') {P.addPt(Of);}
  //  if(keyPressed && (key=='f' || key=='s' || key=='b' || key=='c')) {P.addPt(Of,key);}
  
   // if (!keyPressed) P.setPicked();
    change=true;
   }
   else
   {
     if (!keyPressed) {TorusDemo.lockCurrentpp(); println("picked vertex "+TorusDemo.pp);}
   }
   
  }
  
void mouseMoved() 
  {
  //if (!keyPressed) 
  if (keyPressed && key==' ') {rx-=PI*(mouseY-pmouseY)/height; ry+=PI*(mouseX-pmouseX)/width;}
  if (keyPressed && key=='`') dz+=(float)(mouseY-pmouseY); // approach view (same as wheel)
  change=true;
  }
  
void mouseDragged() 
  {
   if (showEditorDemo)
   {
    if (!keyPressed) P.setPickedTo(Of); 
    
  //  if (!keyPressed) {Of.add(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); }
    if (keyPressed && key==CODED && keyCode==SHIFT) {Of.add(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0)));};
    if (keyPressed && key=='x') P.movePicked(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    if (keyPressed && key=='z') P.movePicked(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    if (keyPressed && key=='X') P.moveAll(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    if (keyPressed && key=='Z') P.moveAll(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
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
      if (keyPressed && key=='p')  // move focus point vertically
      {
        TorusDemo.curpp = 1;
        TorusDemo.updateControlPoints((float)(pmouseY - mouseY), true);
      }
      if (keyPressed && key=='s')  // move focus point vertically
      {
        TorusDemo.curpp = 0;
        TorusDemo.updateControlPoints((float)(pmouseY - mouseY), true);
      }
     if (!keyPressed) 
     {
       TorusDemo.updateControlPoints((float)(pmouseY - mouseY), false);
     }
   }
   else if (showBiarc)
   {
     //int pick_point = 0;
     //float dist = Integer.MAX_VALUE;
     //for (int i = 0; i < biarcPoints.length;i++) {
     // int cur_dist = norm(V(P(mouseX, mouseY, 0), ToScreen(biarcPoints[i])));
     // if (cur_dist < dist) {
     //   pick_point = i;
     //   dist = cur_dist;
     // }
     //}
     //if (pick_point == 0 || pick_point == 1) {
     //  biarcPoints[0] = ;
     //  biarcPoints[1] = ;
     //  Biarc.updateVertices();
     //  Biarc.updateVectors();
     //} {
     //  biarcPoints[2] = ;
     //  biarcPoints[3] = ;
     //  Biarc.updateVectors();
     //}
     //if (keyPressed && key=='p')  // move focus point vertically
     // {
        
     //   TorusDemo.updateControlPoints((float)(pmouseY - mouseY), true);
     // }
     // if (keyPressed && key=='s')  // move focus point vertically
     // {
     //   TorusDemo.curpp = 0;
     //   TorusDemo.updateControlPoints((float)(pmouseY - mouseY), true);
     // }
   }
  }  

// **** Header, footer, help text on canvas
void displayHeader()  // Displays title and authors face on screen
    {
    scribeHeader(title,0); scribeHeaderRight(name); 
    fill(white); image(myFace, width-myFace.width/2,25,myFace.width/2,myFace.height/2); 
    }
void displayFooter()  // Displays help text at the bottom
    {
    scribeFooter(guide,1); 
    scribeFooter(menu,0); 
    }

String title ="3D curve editor", name ="Jarek Rossignac",
       menu="?:help, !:picture, ~:(start/stop)capture, space:rotate, `/wheel:closer, t/T:target, a:anim, #:quit",
       guide="click&drag:pick&slide on floor, xz/XZ:move/ALL, e:exchange, q/p:copy, l/L:load, w/W:write, m:subdivide method"; // user's guide
