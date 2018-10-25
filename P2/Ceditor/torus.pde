class torus
{
    int     maxnVtx = 1000,
            maxnRope = 10,
            nVtx = 0,
            unv = 0,
            nv = 0,
            nu = 0,
            pp = 0,
            curpp = 0,
            nRope = 6;
    float   e = 0.5,
            R = 0,
            r = 0;

    float   GStartAngle = 0,
            GEndAngle   = 0,
            PStartAngle = 0.25,
            PEndAngle   = 0.25;
    
    boolean showMainTorus = true;

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
            }
        }
    }

    torus(pt O, vec XAxis, vec TOV, vec GOV, float e, int nv, int nu, int unv)
    {
        this.O = O;
        this.XAxis = XAxis;
        this.TOV = TOV;
        this.GOV = GOV;
        this.POV = V(0.1, GOV);
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
        G = P(P(O, TOV), R(GOV, TWO_PI * GStartAngle, U(GOV), U(TOV)));
        P = P(P(O, TOV), R(GOV, TWO_PI * PStartAngle, U(GOV), U(TOV)));
        
        calculateVertices();
    }

    void calculateVertices() {
        float GAngleDiff = GStartAngle - GEndAngle;
        float PAngleDiff = PStartAngle - PEndAngle;
        for (int i=0; i < nu; i++)
        {
            vec curTOV = R(TOV, TWO_PI * e / (nu-1) * i, U(TOV), Y);
            pt curOrigin = P(O, curTOV);
            for (int j=0; j < nv; j++)
            {  
                vec tempGOV = R(initialGOV, TWO_PI * e / (nu-1) * i, U(TOV), Y);
                vec curGOV = R(tempGOV, TWO_PI * GAngleDiff / (nu-1) * (nu - i - 1) + TWO_PI / nv * j, U(GOV), U(curTOV));
                Vtx[i][j] = P(curOrigin, curGOV);
            }

            for (int k = 0; k < nRope; k++)
            {
                vec initialPOV = R(R(POV, TWO_PI / nRope * k, U(POV), U(TOV)), TWO_PI * e / (nu-1) * i, U(TOV), Y);
                pt curPOrigin = P(curOrigin, R(V(curOrigin, R(P, TWO_PI * e / (nu-1) * i, U(TOV), U(Y), O)), TWO_PI * (-GAngleDiff - PAngleDiff) / (nu-1) * i + TWO_PI / nRope * k, U(GOV), U(curTOV)));
                for (int j = 0; j < unv; j++)
                {
                    vec curPOV = R(initialPOV, TWO_PI / unv * j, U(GOV), U(curTOV));
                    UPathVtx[k][i][j] = P(curPOrigin, curPOV);
                }
            }
        }
    }

    //Rendering Methods
    void drawTorus()
    {
        calculateVertices();
        
        if (showMainTorus)
        {
            drawIndividialTorus(Vtx, true, 0);
        }

        for (int k = 0; k < nRope; k++)
        {
            drawIndividialTorus(UPathVtx[k], false, 1);
        }

        drawControlPoints();
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


    // GUI Control Methods
    void updateControlPoints(float alpha, boolean twist) {
        if (!twist)
        {
            if (curpp == 0)
            {
                GStartAngle += alpha * 0.01;
                GEndAngle += alpha * 0.01;
                G = P(P(O, TOV), R(GOV, TWO_PI * GStartAngle, U(GOV), U(TOV)));
                initialGOV = R(initialGOV, TWO_PI * alpha * 0.01, U(GOV), U(TOV));
                P = P(P(O, TOV), R(GOV, TWO_PI * (GStartAngle + PStartAngle), U(GOV), U(TOV)));
            }
            else if (curpp == 1)
            {
                PStartAngle += alpha * 0.01;
                PEndAngle += alpha * 0.01;
                P = P(P(O, TOV), R(GOV, TWO_PI * (GStartAngle + PStartAngle), U(GOV), U(TOV)));
            }
            
        }
        else
        {
            if (curpp == 0)
            {
                GStartAngle += alpha * 0.01;
                G = P(P(O, TOV), R(GOV, TWO_PI * GStartAngle, U(GOV), U(TOV)));
                P = P(P(O, TOV), R(GOV, TWO_PI * (GStartAngle + PStartAngle), U(GOV), U(TOV)));
            }
            else if (curpp == 1)
            {
                PStartAngle += alpha * 0.01;
                P = P(P(O, TOV), R(GOV, TWO_PI * (GStartAngle + PStartAngle), U(GOV), U(TOV)));
            }
        }
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
