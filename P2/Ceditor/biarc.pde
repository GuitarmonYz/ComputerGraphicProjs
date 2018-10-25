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
    //int maxNvx = 1000;
    //pt[] firstArc;
    //pt[] secondArc;
    float d_angle = TWO_PI / 36;
    public biarc (pt A, pt D, vec U, vec V) {
        this.A = A;
        this.D = D;
        this.U = U;
        this.V = V;
        //firstArc = new pt[maxNvx];
        //secondArc = new pt[maxNvx];
        //for (int i = 0; i < maxNvx; i++) {
        //    firstArc[i] = P();
        //}
        centrics = new pt[2];
        radius = new float[2];
        axises = new vec[2];
        tovs = new vec[2];
        calculateD();
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
        
        vec co = V(C, centrics[1]);
        vec ch = V(d, U(V(C,B)));
        vec o2h = M(ch, co);
        radius[1] = n(o2h);
        axises[1] = cross(o2h, ch);
        tovs[1] = o2h;
        float angle_hd = angle(o2h, V(centrics[1], D));
        
        vec bc = V(B, C);
        pt h = P(centrics[0], o1h);
        stroke(black);
        noFill();
        beginShape();
        for (float i = 0; i < angle_ha; i+=d_angle) {
            pt a = R(A, i, U(o1h), U(bc), centrics[0]);
            vertex(a.x, a.y, a.z);
        }
        for (float i = 0; i < angle_hd; i+=d_angle) {
            pt a = R(h, i, U(o2h), U(bc), centrics[1]);
            vertex(a.x, a.y, a.z);
        }
        endShape();
        //fill(red);
        //drawSphere(centrics[0]);
        //drawSphere(centrics[1]);
        //fill(green);
        //drawSphere(A);
        //drawSphere(D);
        //fill(yellow);
        //drawSphere(B);
        //drawSphere(C);
        //fill(blue);
        //drawSphere(P(centrics[0], o1h));
        //drawSphere(P(centrics[1], o2h));
        
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
}
