//get the centroid of each quad
float getGradient(PNT p1, PNT p2) {
    return (p1.y - p2.y) / (p1.x - p2.x);
}
//get intersection with y axis
float calculateYAxisIntersect(PNT p, float m) {
    return  p.y - (m * p.x);
}
//implememted by Zhao Yan
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
        centroids_quad[i].x = (b2 - b1) / (m1 - m2);
        centroids_quad[i].y = (m1 * centroids_quad[i].x) + b1;
    }
    return centroids_quad;    
}
//implemented by Cong Du
PNT[] getPrimes(PNT[] points, PNT[] centroid) {
  PNT[] primes = new PNT[16];
  for(int i = 0; i < 3; i++) {
    //VCT move = V(centroid[i+1], centroid[i]);
    float scale = sqrt(normOf(V(points[(i+1)*4], points[(i+1)*4+2])) * normOf(V(points[(i+1)*4+1], points[(i+1)*4+3]))) / sqrt(normOf(V(points[i*4], points[i*4+2])) * normOf(V(points[i*4+1], points[i*4+3])));
    // rotate is in rad
    float rotate = angle(V(centroid[i+1], points[(i+1)*4]), V(centroid[i], points[i*4])) + angle(V(centroid[i+1], points[(i+1)*4 + 1]), V(centroid[i], points[i*4 + 1])) + 
    angle(V(centroid[i+1], points[(i+1)*4 + 2]), V(centroid[i], points[i * 4 + 2])) + angle(V(centroid[i+1], points[(i + 1) * 4 + 3]), V(centroid[i], points[i * 4 + 3]));
    rotate = rotate/4;
    
    for(int j = 0; j < 4; j++) {
      VCT Vnew = V(points[i * 4 + j], centroid[i]);
      Vnew = Rotated(Vnew, rotate);
      Vnew = Scaled(scale, Vnew);
      primes[(i + 1) * 4 + j] = P(centroid[i + 1], Vnew);
    }
  }
  return primes;
}
