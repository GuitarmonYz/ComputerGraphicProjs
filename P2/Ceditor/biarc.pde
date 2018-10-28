class biarc {
    pt A;
    pt D;
    vec U;
    vec V;
    pt B;
    pt C;
    float d;
    public pt[] centrics;
    public float[] radius;
    public vec[] axises;
    public vec[] tovs;
    public float[] angles;
    float d_angle = TWO_PI / 36;

    public biarc () {
        centrics = new pt[2];
        radius = new float[2];
        axises = new vec[2];
        tovs = new vec[2];
        angles = new float[2];
    }

    public biarc (pt A, pt D, vec U, vec V) {
        this.A = A;
        this.D = D;
        this.U = U;
        this.V = V;
        centrics = new pt[2];
        radius = new float[2];
        axises = new vec[2];
        tovs = new vec[2];
        angles = new float[2];
        calculateD();
    }

    public void updateBiarc(pt A, pt D, vec U, vec V)
    {
        this.A = A;
        this.D = D;
        this.U = U;
        this.V = V;
        
        calculateD();
        getCentrics();
        vec bo1 = V(B, centrics[0]);
        
        vec bh = V(0.5,V(B,C));
        vec o1h = M(bh, bo1);
        radius[0] = n(o1h);
        axises[0] = cross(o1h, bh);
        tovs[0] = V(centrics[0], A);
        float angle_ha = angle(o1h, V(centrics[0], A));
        angles[0] = angle_ha / TWO_PI;
        
        vec co = V(C, centrics[1]);
        vec ch = V(d, U(V(C,B)));
        vec o2h = M(ch, co);
        radius[1] = n(o2h);
        axises[1] = cross(ch, o2h);
        tovs[1] = o2h;
        float angle_hd = angle(o2h, V(centrics[1], D));
        angles[1] = angle_hd / TWO_PI;
    }

    public void updateVectors(vec U, vec V) {
        this.U = U;
        this.V = V;
    }

    public void updateVertices(pt A, pt D) {
        this.A = A;
        this.D = D;
    }

    public void drawBiarc() {
        calculateD();
        getCentrics();
        vec bo1 = V(B, centrics[0]);
        
        vec bh = V(0.5,V(B,C));
        vec o1h = M(bh, bo1);
        radius[0] = n(o1h);
        axises[0] = cross(o1h, bh);
        tovs[0] = V(centrics[0], A);
        float angle_ha = angle(o1h, V(centrics[0], A));
        angles[0] = angle_ha / TWO_PI;
        
        vec co = V(C, centrics[1]);
        vec ch = V(d, U(V(C,B)));
        vec o2h = M(ch, co);
        radius[1] = n(o2h);
        axises[1] = cross(ch, o2h);
        tovs[1] = o2h;
        float angle_hd = angle(o2h, V(centrics[1], D));
        angles[1] = angle_hd / TWO_PI;

        vec bc = V(B, C);
        pt h = P(centrics[0], o1h);
        fill(yellow);
        drawSphere(h, 10);

        stroke(red);
        strokeWeight(5);
        noFill();
        beginShape();
        for (float i = 0; i < angle_ha; i+=d_angle) {
            pt a = R(A, i, U(o1h), U(bc), centrics[0]);
            vertex(a.x, a.y, a.z);
        }
        pt last = R(h, 0, U(o2h), U(bc), centrics[1]);
        vertex(last.x, last.y, last.z);
        endShape();

        stroke(green);
        beginShape();
        for (float i = 0; i < angle_hd; i+=d_angle) {
            pt a = R(h, i, U(o2h), U(bc), centrics[1]);
            vertex(a.x, a.y, a.z);
        }
        vertex(D.x, D.y, D.z);
        endShape();

    }

    public int updateNearestPoint(){
        if (!biarcPickLock) {
            float dist = Integer.MAX_VALUE;
            for (int i = 0; i < biarcPoints.length;i++) {
                pt M = Mouse();
                float cur_dist = d(M,ToScreen(biarcPoints[i]));
                if (cur_dist < dist) {
                    pick_point = i;
                    dist = cur_dist;
                }
            }
        }
       return pick_point;
    }

    private void calculateD() {
        float a = n2(A(U,V)) - 4;
        float b = -2 * d(V(A,D), A(U,V));
        float c = n2(V(A,D));
        this.d = (-b + sqrt(b*b - 4*a*c)) / (2 * a);
        if (this.d < 0) this.d = (-b - sqrt(b*b - 4*a*c)) / (2 * a);
    }
    private void getCentrics() {
        B = P(A, V(d, U));
        C = P(D, V(-d, V));
        vec bc = V(B, C);
        vec ba = V(B, A);
        float norm_o1b = d / cos(angle(ba, bc) / 2);
        vec bo1 = V(norm_o1b, U(A(ba, 0.5, bc)));
        this.centrics[0] = P(B, bo1);
        
        vec cb = V(C, B);
        vec cd = V(C, D);
        float norm_o2c = d / cos(angle(cd, cb) / 2);
        vec co2 = V(norm_o2c, U(A(cd, V(0.5, cb))));
        this.centrics[1] = P(C, co2);
    }

    void drawSphere(pt pnt, int r)
    {
        pushMatrix();
        translate(pnt.x, pnt.y, pnt.z);
        sphere(r);
        popMatrix();
    }
}



public vec[] getTangents(pts P_) {
    vec[] tangents = new vec[P_.nv];
    pt[] vertices = P_.G;
    for (int i = 1; i < P_.nv-1; i++) {
        tangents[i] = U(V(vertices[i-1], vertices[i+1]));
    }
    tangents[0] = U(V(vertices[P_.nv-1], vertices[1]));
    tangents[P_.nv-1] = U(V(vertices[P_.nv-2], vertices[0]));
    return tangents;
}

public void drawBiarcs(biarc[] biarcs, pts P_) {
    vec[] tangents = getTangents(P_);
    pt[] vertices = P_.G;
    for (int i = 0; i < P_.nv-1; i++) {
        biarcs[i].updateBiarc(vertices[i], vertices[i+1], tangents[i], tangents[i+1]);
        if (showBiarcsInMainDemo) biarcs[i].drawBiarc();
    }
    biarcs[P_.nv-1].updateBiarc(vertices[P_.nv-1], vertices[0], tangents[P_.nv-1], tangents[0]);
    if (showBiarcsInMainDemo) biarcs[P_.nv-1].drawBiarc();
}
