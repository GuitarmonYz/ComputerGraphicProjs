class torus
{
    int     maxnVtx = 100,
            maxnRope = 10,
            nVtx = 0,
            unv = 0,
            nv = 0,
            nu = 0,
            pp = 0,
            curpp = 0,
            nRope = 4,
            torusIdx = 0;
            
    float   e = 0.5,
            R = 0,
            r = 0,
            ropeTwistOffset = 0;

    float   GStartAngle = 0,
            GEndAngle   = 0,
            PStartAngle = 0.25 * TWO_PI,
            PEndAngle   = 0.25 * TWO_PI;
    
    boolean showMainTorus = true;
    boolean showFirstControlTorus = true;

    color[] threadColors = {green, red, blue, yellow, cyan, magenta, grey, green, brown, metal};

    pt[][] Vtx = new pt [maxnVtx][maxnVtx];  
    pt[][][] UPathVtx = new pt [maxnRope][maxnVtx][maxnVtx];
    pt O, G, P;
    vec XAxis, TOV, GOV, POV, initialGOV, Y;
    
    
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
        this.initialGOV = V(50, U(GOV));
        this.POV = V(10, U(GOV));
        r = GOV.norm();
        R = TOV.norm();
        this.e = e;
        if (nv > maxnVtx) this.nv = maxnVtx; else this.nv = nv;
        if (nv > maxnVtx) this.nu = maxnVtx; else this.nu = nu;
        if (nv > maxnVtx) this.unv = maxnVtx; else this.unv = unv;
        nVtx = this.nv * this.nu;
        
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
        G = P(P(O, TOV), R(initialGOV, GStartAngle, U(normalGOV), U(TOV)));
        P = P(P(O, TOV), R(initialGOV, PStartAngle, U(normalGOV), U(TOV)));
        
        calculateVertices();
    }

    void updateTorus(pt O, vec XAxis, vec TOV, vec GOV, vec normalGOV, float e, int nv, int nu, int unv, int nRope, boolean mainTVis)
    {
        this.O = O;
        this.XAxis = XAxis;
        this.TOV = TOV;
        this.GOV = normalGOV;
        this.initialGOV = V(20, U(GOV));
        this.POV = V(5, U(GOV));
        r = GOV.norm();
        R = TOV.norm();
        this.e = e;
        this.showMainTorus = mainTVis;
        if (nv > maxnVtx) this.nv = maxnVtx; else this.nv = nv;
        if (nv > maxnVtx) this.nu = maxnVtx; else this.nu = nu;
        if (nv > maxnVtx) this.unv = maxnVtx; else this.unv = unv;
        this.nRope = nRope;
        nVtx = this.nv * this.nu;
        Y = cross(TOV, XAxis).normalize();
        G = P(P(O, TOV), R(GOV, GStartAngle, U(normalGOV), U(TOV)));
        P = P(P(O, TOV), R(GOV, PStartAngle, U(normalGOV), U(TOV)));
    }

    void calculateVertices() {
        float GAngleDiff = GEndAngle - GStartAngle;
        float PAngleDiff = PEndAngle - PStartAngle;
        
        for (int i=0; i < nu; i++)
        {
            vec curTOV = R(TOV, TWO_PI * e / (nu-1) * i, Y, U(TOV));
            pt curOrigin = P(O, curTOV);
            vec tempGOV = R(initialGOV, TWO_PI * e / (nu-1) * i, Y, U(TOV));
            for (int j=0; j < nv; j++)
            {  
                vec curGOV = R(tempGOV, GAngleDiff / (nu-1) * (i) + TWO_PI / nv * j, U(GOV), U(curTOV));
                Vtx[i][j] = P(curOrigin, curGOV);
            }

            for (int k = 0; k < nRope; k++)
            {
                vec initialPOV = R(R(POV, TWO_PI / nRope * k , U(GOV), U(TOV)), TWO_PI * e / (nu-1) * i, Y, U(TOV));
                pt curPOrigin = P(curOrigin, R(V(curOrigin, R(P, TWO_PI * e / (nu-1) * i, Y, U(TOV), O)), (GAngleDiff + PAngleDiff) / (nu-1) * i + torusIdx * ropeTwistOffset + TWO_PI / nRope * k, U(GOV), U(curTOV)));
                for (int j = 0; j < unv; j++)
                {
                    vec curPOV = R(initialPOV, TWO_PI / unv * j, U(GOV), U(curTOV));
                    UPathVtx[k][i][j] = P(curPOrigin, curPOV);
                }
            }
        }
    }



    vec getLastGOV() {
        float GAngleDiff = GEndAngle - GStartAngle;
        vec curTOV = R(TOV, TWO_PI * e, Y, U(TOV));
        vec tempGOV = R(initialGOV, TWO_PI * e, Y, U(TOV));
        vec lastGOV = R(tempGOV, GAngleDiff, U(GOV), U(curTOV));
        return lastGOV;
    }
    

    //Rendering Methods
    void drawTorus()
    {
        
        noStroke();
        if (showMainTorus)
        {
            drawIndividialTorus(Vtx, true);
        }

        for (int k = 0; k < nRope; k++)
        {
            fill(threadColors[k]);
            drawIndividialTorus(UPathVtx[k], false);
        }

        drawFirstControlTorus(Vtx);
    }

    void drawIndividialTorus(pt[][] curVtx, boolean c)
    {
        int numv = 0;
        if (c) numv = nv; 
        else numv = unv;
        
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

    void drawFirstControlTorus(pt[][] curVtx)
    {
        if (showMainTorus && showFirstControlTorus)
        {
            stroke(black);
            strokeWeight(5);
            noFill();
            beginShape();
            for (int i = 0; i < nv; i++)
            {
                vertex(curVtx[0][i].x, curVtx[0][i].y, curVtx[0][i].z);
            }
            vertex(curVtx[0][0].x, curVtx[0][0].y, curVtx[0][0].z);
            endShape(CLOSE);
            noStroke();
        }
    }

    void drawControlPoints(int r)
    {
        if (showMainTorus)
        {
            textSize(32);
            fill(blue);
            drawSphere(G, r);
            text("G", G.x, G.y, G.z);
        }


        if (nRope != 0)
        {
            fill(green);
            drawSphere(P, r);
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

    void changeGEndAngle(float inc) 
    {
        GEndAngle = inc;

    }

    void changeRopeTwisting(float offset) 
    {
        ropeTwistOffset = offset;
        PStartAngle = 0.25*TWO_PI ;
        PEndAngle = 0.25*TWO_PI + ropeTwistOffset;
    }

    // GUI Control Methods
    void updateControlPoints(float alpha, boolean twist) {
        if (!twist)
        {
            if (curpp == 0)
            {
                GStartAngle += alpha;
                GEndAngle += alpha;
                G = P(P(O, TOV), R(V(50, U(GOV)), GStartAngle, U(GOV), U(TOV)));
                P = P(P(O, TOV), R(V(50, U(GOV)), (GStartAngle + PStartAngle), U(GOV), U(TOV)));
                initialGOV = R(V(50, U(GOV)), GStartAngle, U(GOV), U(TOV));
                
            }
            else if (curpp == 1)
            {
                PStartAngle += alpha;
                PEndAngle += alpha;
                P = P(P(O, TOV), R(V(50, U(GOV)), (GStartAngle + PStartAngle), U(GOV), U(TOV)));
            }
            
        }
        else
        {
            if (curpp == 0)
            {
                GStartAngle += alpha;
                G = P(P(O, TOV), R(V(50, U(GOV)), GStartAngle, U(GOV), U(TOV)));
                P = P(P(O, TOV), R(V(50, U(GOV)), (GStartAngle + PStartAngle), U(GOV), U(TOV)));
                initialGOV = R(V(50, U(GOV)), GStartAngle, U(GOV), U(TOV));
                
            }
            else if (curpp == 1)
            {
                PStartAngle += alpha;
                P = P(P(O, TOV), R(V(50, U(GOV)), (GStartAngle + PStartAngle), U(GOV), U(TOV)));
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
        calculateVertices();
    }
 
}

public void initToruses(biarc[] biarcs, torus[] toruses, pts P_)
{
    int vertexQuantity = P_.nv;
    vec currGOV = V(20, U(biarcs[0].axises[0]));
    //Calculate angle difference

    for (int i = 0; i < vertexQuantity; i++)
    {
        pt[] Os = biarcs[i].centrics;
        vec[] Xaxies = biarcs[i].axises;
        vec[] TOVs = biarcs[i].tovs;
        float[] Es = biarcs[i].angles;
        toruses[2*i].GEndAngle = 0;
        toruses[2*i+1].GEndAngle = 0;
        
        toruses[2*i].torusIdx = 2*i;
        toruses[2*i].updateTorus(Os[0], Xaxies[0], TOVs[0], currGOV, V(20, U(Xaxies[0])), Es[0], demoTorusnv, demoTorusnu, demoTorusunv, demoTorusnRope, demoTorusMainTorusVisibility);
        toruses[2*i].calculateVertices();
        currGOV = toruses[2*i].getLastGOV();
        toruses[2*i+1].torusIdx = 2*i+1;
        toruses[2*i+1].updateTorus(Os[1], Xaxies[1], TOVs[1], currGOV, V(20, U(Xaxies[1])), Es[1], demoTorusnv, demoTorusnu, demoTorusunv, demoTorusnRope, demoTorusMainTorusVisibility);
        toruses[2*i+1].calculateVertices();
        currGOV = toruses[2*i+1].getLastGOV();
    }

    for (int i = 0; i < vertexQuantity; i++)
    {
        toruses[2*i].drawTorus();
        toruses[2*i+1].drawTorus();
    }
}

public void updateToruses(biarc[] biarcs, torus[] toruses, pts P_)
{
    int vertexQuantity = P_.nv;
    vec currGOV = V(20, U(biarcs[0].axises[0]));
    //Calculate angle difference
    changeTorusesRopeTwisting(toruses, P,  round(demoTorusRopeTwist));
    for (int i = 0; i < vertexQuantity; i++)
    {
        pt[] Os = biarcs[i].centrics;
        vec[] Xaxies = biarcs[i].axises;
        vec[] TOVs = biarcs[i].tovs;
        float[] Es = biarcs[i].angles;
        toruses[2*i].GEndAngle = 0;
        toruses[2*i+1].GEndAngle = 0;
        
        toruses[2*i].torusIdx = 2*i;
        toruses[2*i].updateTorus(Os[0], Xaxies[0], TOVs[0], currGOV, V(20, U(Xaxies[0])), Es[0], demoTorusnv, demoTorusnu, demoTorusunv, demoTorusnRope, demoTorusMainTorusVisibility);
        toruses[2*i].calculateVertices();
        currGOV = toruses[2*i].getLastGOV();
        toruses[2*i+1].torusIdx = 2*i+1;
        toruses[2*i+1].updateTorus(Os[1], Xaxies[1], TOVs[1], currGOV, V(20, U(Xaxies[1])), Es[1], demoTorusnv, demoTorusnu, demoTorusunv, demoTorusnRope, demoTorusMainTorusVisibility);
        toruses[2*i+1].calculateVertices();
        currGOV = toruses[2*i+1].getLastGOV();
        
    }

    float diffAngle = angle(V(100, U(biarcs[0].axises[0])), currGOV);
    if (d(cross(currGOV, V(100, U(biarcs[0].axises[0]))), U(V(P_.G[P_.nv-1], P_.G[1]))) < 0){
        diffAngle *= -1;
    }

    currGOV = V(20, U(biarcs[0].axises[0]));
    if (abs(diffAngle) > 0.01)
    {
        for (int i = 0; i < vertexQuantity; i++) 
        {
            pt[] Os = biarcs[i].centrics;
            vec[] Xaxies = biarcs[i].axises;
            vec[] TOVs = biarcs[i].tovs;
            float[] Es = biarcs[i].angles;
            toruses[2*i].changeGEndAngle(diffAngle / (vertexQuantity * 2));
            toruses[2*i].updateTorus(Os[0], Xaxies[0], TOVs[0], currGOV, V(20, U(Xaxies[0])), Es[0], demoTorusnv, demoTorusnu, demoTorusunv, demoTorusnRope, demoTorusMainTorusVisibility);
            toruses[2*i].calculateVertices();
            currGOV = toruses[2*i].getLastGOV();
            toruses[2*i+1].changeGEndAngle(diffAngle / (vertexQuantity * 2));
            toruses[2*i+1].updateTorus(Os[1], Xaxies[1], TOVs[1], currGOV, V(20, U(Xaxies[1])), Es[1], demoTorusnv, demoTorusnu, demoTorusunv, demoTorusnRope, demoTorusMainTorusVisibility);
            toruses[2*i+1].calculateVertices();
            currGOV = toruses[2*i+1].getLastGOV();
        }
    }
}

public void drawToruses(torus[] toruses, pts P_)
{
    int nT = P_.nv*2;
    toruses[0].showFirstControlTorus = true;
    toruses[0].drawTorus();
    toruses[0].drawControlPoints(12);
    for (int i = 1; i < nT; i++) 
    {
        toruses[i].showFirstControlTorus = false;
        toruses[i].drawTorus();
    }

}

public void changeTorusesRopeQuantity(boolean addsub)
{
    if (addsub && demoTorusnRope < demoTorusnMaxRope)
    {
        demoTorusnRope++;
    }
    else if (!addsub & demoTorusnRope > 0)
    {
        demoTorusnRope--;
    }
}

public void changeTorusesRopeTwisting(torus[] toruses, pts P_, int offset)
{
    float ang = (float)offset * TWO_PI / demoTorusnRope;
    int nT = P_.nv*2;
    for (int i = 0; i < nT; i++) 
    {
        toruses[i].changeRopeTwisting(ang / nT);
    }
    
}

public void changeMainTorusesVisability()
{
    demoTorusMainTorusVisibility = !demoTorusMainTorusVisibility;
}
