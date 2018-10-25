//implemented by Cong Du
void  LERPquads(PNT A, PNT B, PNT C, PNT D, PNT[] Point, float time)
{
  int i = floor(time / (1.0/3.0)) + 1;
  i = (i > 3) ? 3 : i;
  
  float scaled_time = (time - (i - 1) * 1.0 / 3.0) * 3;
  A.setTo(LERP(Point[(i - 1) * 4], scaled_time,Point[i * 4]));
  B.setTo(LERP(Point[(i - 1) * 4 + 1], scaled_time, Point[i * 4 + 1]));
  C.setTo(LERP(Point[(i - 1) * 4 + 2], scaled_time, Point[i * 4 + 2]));
  D.setTo(LERP(Point[(i - 1) * 4 + 3], scaled_time, Point[i * 4 + 3]));
}

// implemented by Cong Du & Zhao Yan
void NevillQuads(PNT A, PNT B, PNT C, PNT D, PNT[] point, PNT[] centroid, PNT[] primes, float time)
{
  int i = floor(time / (1.0/3.0)) + 1;
  i = (i > 3) ? 3 : i;
  
  float scaled_time = (time - (i - 1) * 1.0 / 3.0) * 3;
  
  // compute current centroid
  PNT centroidt = Neville(0, centroid[0], 0.333, centroid[1], 0.6666, centroid[2], 1.0, centroid[3], time);
  
  VCT at = (LPM(V( centroid[i - 1], point[(i - 1) * 4]), scaled_time ,V(centroid[i], primes[i * 4 + 2])));
  //drawEdge(E(centroid[i - 1],point[(i - 1) * 4]));
  //drawEdge(E(centroid[i], primes[i * 4]));
  VCT residual_a_t = V(primes[i*4 + 2], point[i*4]);
  //println(normOf(residual_a_t));
  residual_a_t = Scaled(scaled_time, residual_a_t);
  //println(normOf(residual_a_t));
  A.setTo(P(P(centroidt, at), residual_a_t));
  //A.setTo(P(centroidt, at));
  
  VCT bt = (LPM(V(centroid[i - 1], point[(i - 1) * 4 + 1]), scaled_time ,V(centroid[i], primes[i * 4 + 3])));
  VCT residual_b_t = V(primes[i * 4 + 3], point[i * 4 + 1]);
  residual_b_t = Scaled(scaled_time, residual_b_t);
  B.setTo(P(P(centroidt, bt), residual_b_t));
  //B.setTo(P(centroidt, bt));
  
  VCT ct = (LPM(V(centroid[i - 1], point[(i - 1) * 4 + 2]), scaled_time ,V(centroid[i], primes[i * 4])));
  VCT residual_c_t = V(primes[i * 4], point[i * 4 + 2]);
  residual_c_t = Scaled(scaled_time, residual_c_t);
  C.setTo(P(P(centroidt, ct), residual_c_t));
  //C.setTo(P(centroidt, ct));
  
  VCT dt = (LPM(V(centroid[i - 1], point[(i - 1) * 4 + 3]), scaled_time ,V(centroid[i], primes[i * 4 + 1])));
  VCT residual_d_t = V(primes[i * 4 + 1], point[i * 4 + 3]);
  residual_d_t = Scaled(scaled_time, residual_d_t);
  D.setTo(P(P(centroidt, dt), residual_d_t));
  //D.setTo(P(centroidt, dt));
  
}


//implemented by Cong Du
void LPMquads(PNT A, PNT B, PNT C, PNT D, PNT[] Point, float time)
{
    int i = floor(time / (1.0/3.0)) + 1;
    i = (i > 3) ? 3 : i;
    
    float scaled_time = (time - (i - 1) * 1.0 / 3.0) * 3;
    
    SIMILARITY s_1 = new SIMILARITY(Point[(i - 1) * 4], Point[(i - 1) * 4 + 1], Point[i * 4], Point[1 + i * 4]);
    SIMILARITY s_2 = new SIMILARITY(Point[(i - 1) * 4 + 3], Point[(i - 1) * 4 + 2], Point[3 + i * 4], Point[2 + i * 4]);
    PNT At_1 = s_1.Apply(Point[(i - 1) * 4 + 0], scaled_time);
    PNT Bt_1 = s_1.Apply(Point[(i - 1) * 4 + 1], scaled_time);
    PNT Ct_1 = s_2.Apply(Point[(i - 1) * 4 + 2], scaled_time);
    PNT Dt_1 = s_2.Apply(Point[(i - 1) * 4 + 3], scaled_time);
    SIMILARITY s_3 = new SIMILARITY(Point[(i - 1) * 4 + 1], Point[(i - 1) * 4 + 2], Point[1 + i * 4], Point[2 + i * 4]);
    SIMILARITY s_4 = new SIMILARITY(Point[(i - 1) * 4], Point[(i - 1) * 4 + 3], Point[i * 4], Point[3 + i * 4]);
    PNT At_2 = s_4.Apply(Point[(i - 1) * 4 + 0], scaled_time);
    PNT Dt_2 = s_4.Apply(Point[(i - 1) * 4 + 3], scaled_time);
    PNT Bt_2 = s_3.Apply(Point[(i - 1) * 4 + 1], scaled_time);
    PNT Ct_2 = s_3.Apply(Point[(i - 1) * 4 + 2], scaled_time);
    A.setTo(P((At_1.x + At_2.x)/2.0, (At_1.y + At_2.y)/2.0));
    B.setTo(P((Bt_1.x + Bt_2.x)/2.0, (Bt_1.y + Bt_2.y)/2.0));
    C.setTo(P((Ct_1.x + Ct_2.x)/2.0, (Ct_1.y + Ct_2.y)/2.0));
    D.setTo(P((Dt_1.x + Dt_2.x)/2.0, (Dt_1.y + Dt_2.y)/2.0));
}
// Implemented by Zhao Yan
PNT SQUINTmap(PNT A, PNT B, PNT C, PNT D, float u, float v)
{
  SIMILARITY s_u = new SIMILARITY(A, D, B, C);
  SIMILARITY s_v = new SIMILARITY(A, B, D, C);
  return P(s_u.f, pow(s_u.lambda, u) * pow(s_v.lambda, v), Rotated(V(s_u.f, A), u * s_u.alpha + v * s_v.alpha));
}
