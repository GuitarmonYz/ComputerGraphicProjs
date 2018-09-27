//get the centroid of each quad
float getGradient(PNT p1, PNT p2) {
    return (p1.y - p2.y) / (p1.x - p2.x);
}
float calculateYAxisIntersect(PNT p, float m) {
    return  p.y - (m * p.x);
}
PNT[] getCentroid(PNT[] points) {
    PNT[] centroids_quad = new PNT[4];
    for (int i = 0; i < 4; i++) {
        centroids_quad[i] = new PNT(0, 0);
        PNT[] centroids_Tri = new PNT[4];
        for (int j = 0; j < 4; j++) {
            centroids_Tri[j] = new PNT(0,0);
            centroids_Tri[j].x = (points[(i*4+j)%4].x + points[(i*4+1+j)%4].x + points[(i*4+2+j)%4].x)/3.0;
            centroids_Tri[j].y = (points[(i*4+j)%4].y + points[(i*4+1+j)%4].y + points[(i*4+2+j)%4].y)/3.0;
        }
        float m1 = getGradient(centroids_Tri[0], centroids_Tri[2]);
        float m2 = getGradient(centroids_Tri[1], centroids_Tri[3]);
        float b1 = calculateYAxisIntersect(centroids_Tri[0], m1);
        float b2 = calculateYAxisIntersect(centroids_Tri[1], m2);
        centroids_quad[i].x = (b2 - b1) / float(m1 - m2);
        centroids_quad[i].y = (m1 * x) + b1;
    }
    return centroids_quad;    
}

PNT[]
