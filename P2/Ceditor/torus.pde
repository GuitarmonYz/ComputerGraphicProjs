class torus
{
    int     maxnVtx = 100,
            maxnRope = 4,
            nVtx = 0,
            unv = 0,
            nv = 0,
            nu = 0,
            pp = 0,
            curpp = 0,
            nRope = 1;
    float   e = 0.5,
            R = 0,
            r = 0;

    float   GStartAngle = 0,
            GEndAngle   = 0,
            PStartAngle = 0.25 * TWO_PI,
            PEndAngle   = 0.25 * TWO_PI;
    
    boolean showMainTorus = true;

    pt[][] Vtx = new pt [maxnVtx][maxnVtx];  
    pt[][][] UPathVtx = new pt [maxnRope][maxnVtx][maxnVtx];
    pt O, G, P;
    vec XAxis, TOV, GOV, POV, initialGOV, Y, lastGOV;
    
    
    // Methods in Torus Class
    torus() 
    {
        for (int i=0; i<maxnVtx; i++) 
        {
            for (int j=0; j<maxnVtx; j++)   
            {
                Vtx[i][j] = P();
                for (int k = 0; k < maxnRope; k++)
                {
                    UPathVtx[k][i][j] = P();
                }
            }
        }
    }

    torus(pt O, vec XAxis, vec TOV, vec GOV, vec normalGOV, float e, int nv, int nu, int unv)
    {
        this.O = O;
        this.XAxis = XAxis;
        this.TOV = TOV;
        this.GOV = normalGOV;
        this.POV = V(10, U(GOV));
        this.initialGOV = GOV;
        r = GOV.norm();
        R = TOV.norm();
        this.e = e;
        this.nv = nv;
        this.nu = nu;
        this.unv = unv;
        nVtx = nv * nu;
        
        for (int i=0; i<maxnVtx; i++) 
        {
            for (int j=0; j<maxnVtx; j++)   
            {
                Vtx[i][j] = P();
                for (int k = 0; k < maxnRope; k++)
                {
                    UPathVtx[k][i][j] = P();
                }
            }
        }
        Y = cross(TOV, XAxis).normalize();
        G = P(P(O, TOV), R(GOV, GStartAngle, U(normalGOV), U(TOV)));
        P = P(P(O, TOV), R(GOV, PStartAngle, U(normalGOV), U(TOV)));
        
        calculateVertices();
    }

    void updateTorus(pt O, vec XAxis, vec TOV, vec GOV, vec normalGOV, float e, int nv, int nu, int unv)
    {
        this.O = O;
        this.XAxis = XAxis;
        this.TOV = TOV;
        this.GOV = normalGOV;
        this.initialGOV = GOV;
        this.POV = V(10, U(GOV));
        r = GOV.norm();
        R = TOV.norm();
        this.e = e;
        this.nv = nv;
        this.nu = nu;
        this.unv = unv;
        nVtx = nv * nu;
        Y = cross(TOV, XAxis).normalize();
        G = P(P(O, TOV), R(GOV, GStartAngle, U(normalGOV), U(TOV)));
        P = P(P(O, TOV), R(GOV, PStartAngle, U(normalGOV), U(TOV)));
    }

    void calculateVertices() {
        float GAngleDiff = GEndAngle - GStartAngle;
        // GAngleDiff = PI;
        
        float PAngleDiff = PEndAngle - PStartAngle;
        for (int i=0; i < nu; i++)
        {
            vec curTOV = R(TOV, TWO_PI * e / (nu-1) * i, Y, U(TOV));
            pt curOrigin = P(O, curTOV);
            vec tempGOV = R(initialGOV, TWO_PI * e / (nu-1) * i, Y, U(TOV));
            // arrow(curOrigin, tempGOV, 5);
            for (int j=0; j < nv; j++)
            {  
                vec curGOV = R(tempGOV, GAngleDiff / (nu-1) * (i) + TWO_PI / nv * j, U(GOV), U(curTOV));
                Vtx[i][j] = P(curOrigin, curGOV);
                // line(curOrigin.x, curOrigin.y, curOrigin.z, Vtx[i][j].x, Vtx[i][j].y, Vtx[i][j].z);
            }

            for (int k = 0; k < nRope; k++)
            {
                vec initialPOV = R(R(POV, TWO_PI / nRope * k, U(GOV), U(TOV)), TWO_PI * e / (nu-1) * i, Y, U(TOV));
                pt curPOrigin = P(curOrigin, R(V(curOrigin, R(P, TWO_PI * e / (nu-1) * i, Y, U(TOV), O)), (GAngleDiff + PAngleDiff) / (nu-1) * i + TWO_PI / nRope * k, U(GOV), U(curTOV)));
                for (int j = 0; j < unv; j++)
                {
                    vec curPOV = R(initialPOV, TWO_PI / unv * j, U(GOV), U(curTOV));
                    UPathVtx[k][i][j] = P(curPOrigin, curPOV);
                }
            }

            if (i == nu-1) {
                lastGOV = R(tempGOV, GAngleDiff, U(GOV), U(curTOV));
                // stroke(green);
                // arrow(curOrigin, lastGOV, 5);
                // stroke(yellow);
                // arrow(curOrigin, tempGOV, 5);
            }  

        }


    }

    vec getLastGOV() {
        calculateVertices();
        return lastGOV;
    }
    

    //Rendering Methods
    void drawTorus()
    {
        
        noStroke();
        if (showMainTorus)
        {
            drawIndividialTorus(Vtx, true, 0);
        }

        for (int k = 0; k < nRope; k++)
        {
            drawIndividialTorus(UPathVtx[k], false, 1);
        }

        drawControlPoints();

        // drawSphere(O, 10);
    }

    void drawIndividialTorus(pt[][] curVtx, boolean c, int type)
    {
        int numv = 0;
        if (type == 0) 
        {
            numv = nv; 
        }
        else 
        {
            numv = unv;
        }
        
        if (!c) fill(red);
        for (int i=0; i < nu-1; i++)
        {
            for (int j = 0; j <numv-1; j++)
            {
                if (c)
                {
                    if (j >= 0 && j < numv / 4) fill(cyan);
                    if (j >= numv / 4 && j < numv / 2) fill(yellow);
                    if (j >= numv / 2 && j < numv / 4 * 3) fill(green);
                    if (j >= numv * 3 / 4 && j < numv ) fill(orange);
                }
                beginShape();
                vertex(curVtx[i][j].x, curVtx[i][j].y,  curVtx[i][j].z);
                vertex(curVtx[i][j+1].x, curVtx[i][j+1].y, curVtx[i][j+1].z);
                vertex(curVtx[i+1][j+1].x, curVtx[i+1][j+1].y, curVtx[i+1][j+1].z);
                vertex(curVtx[i+1][j].x, curVtx[i+1][j].y, curVtx[i+1][j].z);
                endShape(CLOSE);
            }
            if (c) fill(orange);
            beginShape();
            vertex(curVtx[i][numv-1].x, curVtx[i][numv-1].y,  curVtx[i][numv-1].z);
            vertex(curVtx[i][0].x, curVtx[i][0].y, curVtx[i][0].z);
            vertex(curVtx[i+1][0].x, curVtx[i+1][0].y, curVtx[i+1][0].z);
            vertex(curVtx[i+1][numv-1].x, curVtx[i+1][numv-1].y, curVtx[i+1][numv-1].z);
            endShape(CLOSE);
        }
    }

    void drawControlPoints()
    {
        if (showMainTorus)
        {
            textSize(32);
            fill(blue);
            drawSphere(G, 8);
            text("G", G.x, G.y, G.z);
        }


        if (nRope != 0)
        {
            fill(brown);
            drawSphere(P, 8);
            text("P", P.x, P.y, P.z);
        }
    }

    void drawSphere(pt pnt, int r)
    {
        pushMatrix();
        translate(pnt.x, pnt.y, pnt.z);
        sphere(r);
        popMatrix();
    }
    void testAngle() {
        GEndAngle+= 5.0 / 360 * TWO_PI;
        calculateVertices();
    }

    void changeGEndAngle(float inc) {
        GEndAngle = inc;
        PStartAngle = 0.25*TWO_PI + inc;
        PEndAngle = 0.25*TWO_PI + inc;
    }
    void changePEndAngle(float inc) {
        PEndAngle -= inc;
    }
    void changeTwistEndAngle(float inc){
        changeGEndAngle(inc);
        changePEndAngle(inc);
        calculateVertices();
        // initialGOV = R(initialGOV, TWO_PI * inc, U(GOV), U(TOV));
    }

    // GUI Control Methods
    void updateControlPoints(float alpha, boolean twist) {
        if (!twist)
        {
            if (curpp == 0)
            {
                GStartAngle += alpha;
                GEndAngle += alpha;
                G = P(P(O, TOV), R(GOV, GStartAngle, U(GOV), U(TOV)));
                initialGOV = R(initialGOV, TWO_PI * alpha, U(GOV), U(TOV));
                P = P(P(O, TOV), R(GOV, (GStartAngle + PStartAngle), U(GOV), U(TOV)));
            }
            else if (curpp == 1)
            {
                PStartAngle += alpha;
                PEndAngle += alpha;
                P = P(P(O, TOV), R(GOV, (GStartAngle + PStartAngle), U(GOV), U(TOV)));
            }
            
        }
        else
        {
            if (curpp == 0)
            {
                GStartAngle += alpha;
                G = P(P(O, TOV), R(GOV, GStartAngle, U(GOV), U(TOV)));
                initialGOV = R(initialGOV, TWO_PI * alpha, U(GOV), U(TOV));
                P = P(P(O, TOV), R(GOV, (GStartAngle + PStartAngle), U(GOV), U(TOV)));
            }
            else if (curpp == 1)
            {
                PStartAngle += alpha;
                P = P(P(O, TOV), R(GOV, (GStartAngle + PStartAngle), U(GOV), U(TOV)));
            }
        }
        calculateVertices();
    }

    void SETppToIDofVertexWithClosestScreenProjectionTo(pt M)  // sets pp to the index of the vertex that projects closest to the mouse 
    {
        if (nRope == 0 && showMainTorus)
        {
            pp = 0;
        }
        else if (d(M,ToScreen(G))<=d(M,ToScreen(P)) && showMainTorus) 
        {
            pp = 0;
        } 
        else if (nRope > 0)
        {
            pp = 1;
        }
    }

    void lockCurrentpp()
    {
        curpp = pp;
    }

    void changeRopeQuantity(boolean addsub)
    {
        if (addsub && nRope < maxnRope)
        {
            nRope++;
        }
        else if (!addsub & nRope > 0)
        {
            nRope--;
        }
    }
 
}

public void drawToruses(biarc[] biarcs, torus[] toruses, pts P_)
{
    int vertexQuantity = P_.nv;
    vec currGOV = V(100, U(biarcs[0].axises[0]));
    //Calculate angle difference

    for (int i = 0; i < vertexQuantity; i++)
    {
        pt[] Os = biarcs[i].centrics;
        vec[] Xaxies = biarcs[i].axises;
        vec[] TOVs = biarcs[i].tovs;
        float[] Es = biarcs[i].angles;
        toruses[2*i].GEndAngle = 0;
        toruses[2*i+1].GEndAngle = 0;
        // toruses[2*i].drawSphere(Os[0], 20);
        // V(100, U(Xaxies[0]))
        
        toruses[2*i].updateTorus(Os[0], Xaxies[0], TOVs[0], currGOV, V(100, U(Xaxies[0])), Es[0], demoTorusnv, demoTorusnu, demoTorusunv);
        currGOV = toruses[2*i].getLastGOV();
        
        
        toruses[2*i+1].updateTorus(Os[1], Xaxies[1], TOVs[1], currGOV, V(100, U(Xaxies[1])), Es[1], demoTorusnv, demoTorusnu, demoTorusunv);
        currGOV = toruses[2*i+1].getLastGOV();
        
    }

    // stroke(red);
    // arrow(P(biarcs[0].centrics[0], biarcs[0].tovs[0]), V(100, U(biarcs[0].axises[0])), 7);
    float diffAngle = angle(V(100, U(biarcs[0].axises[0])), currGOV);
    if (d(cross(currGOV, V(100, U(biarcs[0].axises[0]))), U(V(P_.G[P_.nv-1], P_.G[1]))) < 0){
        println(">= 0");
        diffAngle *= -1;
    }

    println("a:" + diffAngle / TWO_PI * 360);
    currGOV = V(100, U(biarcs[0].axises[0]));
    if (abs(diffAngle) > 0.01)
    {
        for (int i = 0; i < vertexQuantity; i++) 
        {
            pt[] Os = biarcs[i].centrics;
            vec[] Xaxies = biarcs[i].axises;
            vec[] TOVs = biarcs[i].tovs;
            float[] Es = biarcs[i].angles;
            toruses[2*i].changeGEndAngle(diffAngle / (vertexQuantity * 2));
            toruses[2*i].updateTorus(Os[0], Xaxies[0], TOVs[0], currGOV, V(100, U(Xaxies[0])), Es[0], demoTorusnv, demoTorusnu, demoTorusunv);
            currGOV = toruses[2*i].getLastGOV();
            toruses[2*i+1].changeGEndAngle(diffAngle / (vertexQuantity * 2));
            toruses[2*i+1].updateTorus(Os[1], Xaxies[1], TOVs[1], currGOV, V(100, U(Xaxies[1])), Es[1], demoTorusnv, demoTorusnu, demoTorusunv);
            currGOV = toruses[2*i+1].getLastGOV();
            
        }
    }
   
    diffAngle = angle(V(100, U(biarcs[0].axises[0])), currGOV) / TWO_PI * 360;

    println("b: " + diffAngle);

    //Rendering Toruses
    for (int i = 0; i < vertexQuantity; i++)
    {
        toruses[2*i].drawTorus();
        toruses[2*i+1].drawTorus();
    }
}

public void updateAngle(biarc[] biarcs, torus[] toruses, pts P_)
{
    int vertexQuantity = P_.nv;
    vec currGOV = V(100, U(biarcs[0].axises[0]));

    for (int i = 0; i < vertexQuantity; i++)
    {
        pt[] Os = biarcs[i].centrics;
        vec[] Xaxies = biarcs[i].axises;
        vec[] TOVs = biarcs[i].tovs;
        float[] Es = biarcs[i].angles;
        toruses[2*i].GEndAngle = 0;
        toruses[2*i+1].GEndAngle = 0;
        // toruses[2*i].drawSphere(Os[0], 20);
        
        toruses[2*i].updateTorus(Os[0], Xaxies[0], TOVs[0], currGOV, V(100, U(Xaxies[0])), Es[0], demoTorusnv, demoTorusnu, demoTorusunv);
        currGOV = toruses[2*i].getLastGOV();
        

        
        toruses[2*i+1].updateTorus(Os[1], Xaxies[1], TOVs[1], currGOV, V(100, U(Xaxies[1])), Es[1], demoTorusnv, demoTorusnu, demoTorusunv);
        currGOV = toruses[2*i+1].getLastGOV();
    }

    // stroke(red);
    // arrow(P(biarcs[0].centrics[0], biarcs[0].tovs[0]), V(100, U(biarcs[0].axises[0])), 7);
    float diffAngle = angle(V(100, U(biarcs[0].axises[0])), currGOV);
    if (d(cross(currGOV, V(100, U(biarcs[0].axises[0]))), U(V(P_.G[P_.nv-1], P_.G[1]))) < 0){
        println(">= 0");
        diffAngle *= -1;
    }
    println("a_test:" + diffAngle / TWO_PI * 360);
    currGOV = V(100, U(biarcs[0].axises[0]));
    if (abs(diffAngle) > 0.01)
    {
        for (int i = 0; i < vertexQuantity; i++) 
        {
            pt[] Os = biarcs[i].centrics;
            vec[] Xaxies = biarcs[i].axises;
            vec[] TOVs = biarcs[i].tovs;
            float[] Es = biarcs[i].angles;
            // toruses[2*i].changeGEndAngle(diffAngle / (vertexQuantity * 2));
            // toruses[2*i].updateTorus(Os[0], Xaxies[0], TOVs[0], currGOV, V(100, U(Xaxies[0])), Es[0], demoTorusnv, demoTorusnu, demoTorusunv);
            currGOV = toruses[2*i].getLastGOV();
            // toruses[2*i+1].changeGEndAngle(diffAngle / (vertexQuantity * 2));
            if (2 * i + 1 != vertexQuantity*2-1) {
                // toruses[2*i+1].updateTorus(Os[1], Xaxies[1], TOVs[1], currGOV, V(100, U(Xaxies[1])), Es[1], demoTorusnv, demoTorusnu, demoTorusunv);
                currGOV = toruses[2*i+1].getLastGOV();
            }
            
        }
        // twistCnt += 1;
        pt[] Os = biarcs[vertexQuantity-1].centrics;
        vec[] Xaxies = biarcs[vertexQuantity-1].axises;
        vec[] TOVs = biarcs[vertexQuantity-1].tovs;
        float[] Es = biarcs[vertexQuantity-1].angles;
        println(diffAngle);
        toruses[vertexQuantity*2-1].changeGEndAngle(diffAngle);
        toruses[vertexQuantity*2-1].updateTorus(Os[1], Xaxies[1], TOVs[1], currGOV, V(100, U(Xaxies[1])), Es[1], demoTorusnv, demoTorusnu, demoTorusunv);
        currGOV = toruses[2*vertexQuantity-1].getLastGOV();
        // println(toruses[vertexQuantity*2-1].GEndAngle - toruses[vertexQuantity*2-1].GStartAngle);
    }
    else
    { 
        println("initialTwist: " + initialDiff);
        println("twistCnt: " + twistCnt);
    };
    diffAngle = angle(V(100, U(biarcs[0].axises[0])), currGOV) / TWO_PI * 360;
    // if (vertexQuantity == 3 ) diffAngle = 0;

    println("b_test: " + diffAngle);

    //Rendering Toruses
    // for (int i = 0; i < vertexQuantity; i++)
    // {
    //     toruses[2*i].drawTorus();
    //     toruses[2*i+1].drawTorus();
    // }
}
//torus(pt O, vec XAxis, vec TOV, vec GOV, float e, int nv, int nu, int unv)
