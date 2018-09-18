//implemented by Zhao Yan
class SIMILARITY
{
  float lambda;
  float alpha;
  PNT f;
  SIMILARITY(PNT A0, PNT B0, PNT A1, PNT B1) {
    VCT V0 = V(A0, B0);
    VCT V1 = V(A1, B1);
    VCT a1a0 = V(A1, A0);
    this.alpha = angle(V0, V1);
    this.lambda = normOf(V1) / normOf(V0);
    VCT w = V(lambda * cos(alpha) - 1, lambda * sin(alpha));
    float d = pow(lambda * cos(alpha) - 1, 2) + pow(lambda * sin(alpha), 2);
    this.f = P(A0, Scaled(1/d, V(dot(w, a1a0), dot(Rotated(w), a1a0))));
  }
  SIMILARITY(float lambda, float alpha, PNT f) {
    this.lambda = lambda;
    this.alpha = alpha;
    this.f = f;
  }
  PNT Apply(PNT p, float t) {
     return P(f, pow(lambda, t), Rotated(V(f, p), alpha * t));
  }
}
