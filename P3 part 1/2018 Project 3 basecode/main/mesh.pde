import java.util.Queue;
import java.util.Deque;
import java.util.LinkedList;
import java.util.Set;
import java.util.HashSet;
import java.util.Map;
import java.util.HashMap;
import java.util.Arrays;
// TRIANGLE MESH
class MESH {
    // VERTICES
    int nv=0, maxnv = 1000;  
    pt[] G = new pt [maxnv];                        
    // TRIANGLES 
    int nt = 0, maxnt = maxnv*2;                           
    boolean[] isInterior = new boolean[maxnv];                                      
    // CORNERS 
    int c=0;    // current corner                                                              
    int nc = 0; 
    int[] V = new int [3*maxnt];   
    int[] O = new int [3*maxnt];  
    // additional data structure needed to bulge Triangularization
    Set<edge> bulged_edges = new HashSet();
    Set<triangle> added_triangles = new HashSet();
    Queue<Integer> queue = new LinkedList();
    // Data Structures for edgebreaker
    int[] gN = new int [3*maxnt];
    int[] gP = new int [3*maxnt];
    boolean[] vertices_visited = new boolean[maxnv];
    boolean[] g_visited = new boolean[3*maxnt];
    // Data structures for cat catching dogs
    pt[] voronoi_vertices = new pt[maxnt];
    Map<Integer, Set<Integer>> adjVoroTable = new HashMap();
    // current corner that can be edited with keys
  MESH() {for (int i=0; i<maxnv; i++) G[i]=new pt();};
  void reset() {nv=0; nt=0; nc=0;}                                                  // removes all vertices and triangles
  void loadVertices(pt[] P, int n) {nv=0; for (int i=0; i<n; i++) addVertex(P[i]);}
  void writeVerticesTo(pts P) {for (int i=0; i<nv; i++) P.G[i].setTo(G[i]);}
  void addVertex(pt P) { G[nv++].setTo(P); }                                             // adds a vertex to vertex table G
  void addTriangle(int i, int j, int k) {V[nc++]=i; V[nc++]=j; V[nc++]=k; nt=nc/3; }     // adds triangle (i,j,k) to V table

  // CORNER OPERATORS
  int t (int c) {int r=int(c/3); return(r);}                   // triangle of corner c
  int n (int c) {int r=3*int(c/3)+(c+1)%3; return(r);}         // next corner
  int p (int c) {int r=3*int(c/3)+(c+2)%3; return(r);}         // previous corner
  pt g (int c) {return G[V[c]];}                             // shortcut to get the point where the vertex v(c) of corner c is located

  boolean nb(int c) {return(O[c]!=c);};  // not a border corner
  boolean bord(int c) {return(O[c]==c);};  // not a border corner

  pt cg(int c) {return P(0.6,g(c),0.2,g(p(c)),0.2,g(n(c)));}   // computes offset location of point at corner c

  // Edgebreaker Operations
  int gv (int c) {return v(n(c));};
  int gn (int c) {return p(c);};
  int gp (int c) {return n(c);};
  int go (int c) {return p(o(n(c)));};
  int gP (int c) {return gP[c];};
  int gN (int c) {return gN[c];};

  // CORNER ACTIONS CURRENT CORNER c
  void next() {c=n(c);}
  void previous() {c=p(c);}
  void opposite() {c=o(c);}
  void left() {c=l(c);}
  void right() {c=r(c);}
  void swing() {c=s(c);} 
  void unswing() {c=u(c);} 
  void printCorner() {println("c = "+c);}
  
  

  // DISPLAY
  void showCurrentCorner(float r) { if(bord(c)) fill(red); else fill(dgreen); show(cg(c),r); };   // renders corner c as small ball
  void showEdge(int c) {beam( g(p(c)),g(n(c)),rt ); };  // draws edge of t(c) opposite to corner c
  void showVertices(float r) // shows all vertices green inside, red outside
    {
    for (int v=0; v<nv; v++) 
      {
      if(isInterior[v]) fill(green); else fill(red);
      show(G[v],r);
      }
    }                          
  void showInteriorVertices(float r) {for (int v=0; v<nv; v++) if(isInterior[v]) show(G[v],r); }                          // shows all vertices as dots
  void showTriangles() { for (int c=0; c<nc; c+=3) show(g(c), g(c+1), g(c+2)); }         // draws all triangles (edges, or filled
  void showEdges() {for (int i=0; i<nc; i++) showEdge(i); };         // draws all edges of mesh twice

  void triangulate()      // performs Delaunay triangulation using a quartic algorithm
   {
     c=0;                   // to reset current corner
     for (int i = 0; i < nv; i++) {
       for (int j = i+1; j < nv; j++) {
         for (int k = j+1; k < nv; k++) {
            pt center = CircumCenter(G[i], G[j], G[k]);
            float r = norm(V(G[i], center));
            boolean isTri = true;
            for (int l = 0; l < nv; l++) {
              if (l != i && l != j && l!= k) {
                if (norm(V(G[l], center)) < r ) {
                  isTri = false;
                }
              }
            }
            if (isTri) {
              if (cw(V(0,0,1), V(G[i], G[j]), V(G[i], G[k]))) {
                addTriangle(i, j, k);
              } else {
                addTriangle(i, k, j);
              }
            }
         }
       }
     }
   }
  void triangulateWithBulging()
  {
    c=0;
    bulged_edges.clear();
    added_triangles.clear();
    // find a starting border edge
    int init_p1 = -1;
    float min_x = Float.MAX_VALUE;
    for (int i = 0; i < nv; i++) {
      if (G[i].x < min_x) {
        init_p1 = i;
        min_x = G[i].x;
      }
    }
    int init_p2 = 0;
    for (int i = 1; i < nv; i++) {
      if (init_p2 != init_p1 && dot(cross(V(G[init_p1], G[i]), V(G[init_p1], G[init_p2])), V(0,0,1)) < 0) {
        init_p2 = i;
      }
    }
    // bfs bulging
    queue.add(init_p1);
    queue.add(init_p2);
    while (!queue.isEmpty()) {
      int v1 = queue.poll();
      int v2 = queue.poll();
      Integer vo = queue.poll();
      float minBulge = Float.MAX_VALUE;
      int v3 = -1;
      if (bulged_edges.contains(E(v1, v2)) || bulged_edges.contains(E(v2, v1))) continue;
      bulged_edges.add(E(v1, v2));
      for (int i = 0; i < nv; i++) {
        if (vo != null && dot(cross(V(G[v1], G[v2]), V(G[v1], G[vo])), cross(V(G[v1], G[v2]), V(G[v1], G[i]))) > 0) continue;
        pt center = CircumCenter(G[v1], G[v2], G[i]);
        float bulge = 0;
        float e = dot(V(center, G[v1]), U(V(center, P(G[v1], G[v2]))));
        if (dot(cross(V(G[v1], G[v2]), V(G[v1], center)), cross(V(G[v1], G[v2]), V(G[v1], G[i]))) > 0) {
          bulge = norm(V(G[v1], center)) + e;
        } else {
          bulge = norm(V(G[v1], center)) - e;
        }
        if (bulge < minBulge) {
          minBulge = bulge;
          v3 = i;
        }
      }
      if (v3 != -1) {
        queue.add(v1);
        queue.add(v3);
        queue.add(v2);
        queue.add(v2);
        queue.add(v3);
        queue.add(v1);
        if (cw(V(0,0,1), V(G[v1], G[v2]), V(G[v1], G[v3]))) {
          if (!added_triangles.contains(Tri(v1, v2, v3)) && !added_triangles.contains(Tri(v2, v3, v1)) && !added_triangles.contains(Tri(v3, v1, v2))) {
            addTriangle(v1, v2, v3);
            added_triangles.add(Tri(v1, v2, v3));
          }
        } else {
          if (!added_triangles.contains(Tri(v1, v3, v2)) && !added_triangles.contains(Tri(v2, v1, v3)) && !added_triangles.contains(Tri(v3, v2, v1))) {
            addTriangle(v1, v3, v2);
            added_triangles.add(Tri(v1, v3, v2));
          }
        }
      }
    }
  }  

  void computeO() // **02 implement it 
    {     
      for (int i = 0; i < nc; i++) {
        boolean found = false;
        for (int j = 0; j < nc; j++) {
          if (V[n(i)] == V[p(j)] && V[p(i)] == V[n(j)]) {
            O[i] = j;
            found = true;
            break;
          }
        }
        if (!found) O[i] = i;
      }
    } 

  void initEdgebreaker()
  {
    Arrays.fill(vertices_visited, false);
    Arrays.fill(g_visited, false);
    Arrays.fill(gN, -1);
    Arrays.fill(gP, -1);
    for (int i = 0; i < nc; i++) {
      if (o(i) == i) {
        for (int j = 0; j  < nc; j++) {
          if (o(j) == j) {
            if (v(n(i)) == v(p(j))) {
              gN[p(i)] = p(j);
              gP[p(j)] = p(i);
              vertices_visited[v(n(i))] = true;
              g_visited[p(i)] = true;
            }
          }
        }
      }
    }
  }

  void labelEdgebreaker()
  {
    Deque<Integer> stack = new LinkedList();
    int start = -1;

    for (int i = 0; i < nc; i++) {
      if (gN[i] != -1) {
        start = i;
        break;
      } 
    }
    stack.offerLast(start);
    while (!stack.isEmpty()) {
      int cur = stack.pollLast();
      if (!vertices_visited[gv(cur)]) {
        //case C
        vertices_visited[gv(cur)] = true;
        g_visited[cur] = false;
        g_visited[go(gp(cur))] = true;
        g_visited[go(gn(cur))] = true;

        gN[go(gn(cur))] = gN[cur];
        gP[gN[cur]] = go(gn(cur));
        gP[go(gp(cur))] = gP[cur];
        gN[gP[cur]] = go(gp(cur));
        gN[go(gp(cur))] = go(gn(cur));
        gP[go(gn(cur))] = go(gp(cur));
        stack.offerLast(go(gn(cur)));
        fill(yellow);
        // println("C");
      } else {
        if (gp(cur) == gP(cur)) {
          if (gn(cur) == gN(cur)) {
            //case E
            g_visited[cur] = false;
            g_visited[gn(cur)] = false;
            g_visited[gp(cur)] = false;
            fill(red);
            // println("E");
          } else {
            //case L
            g_visited[cur] = false;
            g_visited[gP(cur)] = false;
            g_visited[go(gn(cur))] = true;

            gN[gP(gP(cur))] = go(gn(cur));
            gP[go(gn(cur))] = gP(gP(cur));
            gN[go(gn(cur))] = gN(cur);
            gP[gn(cur)] = go(gn(cur));
            stack.offerLast(go(gn(cur)));

            fill(brown);
            // println("L");
          }
        } else {
          if (gn(cur) == gN(cur)) {
            // case R
            g_visited[cur] = false;
            g_visited[gN(cur)] = false;
            g_visited[go(gp(cur))] = true;
            gP[gN(gN(cur))] = go(gp(cur));
            gN[go(gp(cur))] = gN(gN(cur));
            gP[go(gp(cur))] = gP(cur);
            gN[gP(cur)] = go(gp(cur));
            stack.offerLast(go(gp(cur)));

            fill(blue);
            // println("R");
          } else {
            // case S
            g_visited[cur] = false;
            g_visited[go(gp(cur))] = true;
            g_visited[go(gn(cur))] = true;

            int b = gn(cur);
            while (!g_visited[b]) {
              b = gp(go(b));
            }
            gN[gP(cur)] = go(gp(cur));
            gP[go(gp(cur))] = gP(cur);
            gN[go(gp(cur))] = gN(b);
            gP[gN(b)] = go(gp(cur));
            gN[b] = go(gn(cur));
            gP[go(gn(cur))] = b;
            gN[go(gn(cur))] = gN(cur);
            gP[gN(cur)] = go(gn(cur));
            stack.offerLast(go(gp(cur)));
            stack.offerLast(go(gn(cur)));

            fill(green);
            // println("S");
          }
        }
      }
      show(g(cur), g(p(cur)), g(n(cur)));
    }
  }

  int countBorders() {
    int count = 0;
    for (int i = 0; i < nc; i++) {
      if (o(i) == i) {
        count++;
      }
    }
    return count;
  }
    
  void showBorderEdges()  // draws all border edges of mesh
    {
      for (int i = 0; i < nc; i++) {
        if (O[i] == i){
          showEdge(i);
        }
      }
    }         

  void showNonBorderEdges() // draws all non-border edges of mesh
    {
      for (int i = 0; i < nc; i++) {
        if (O[i] != i) {
          showEdge(i);
        }
      }
    }        
    
  void classifyVertices() 
    { 
      for (int i = 0; i < nv; i++) {
        isInterior[i] = true;
      }
      for (int i = 0; i < nc; i++) {
        if (O[i] == i) {
          isInterior[V[n(i)]] = false;
          isInterior[V[p(i)]] = false;
        }
      }
    }  
    
  void smoothenInterior() 
    { // even interior vertiex locations
      pt[] Gn = new pt[nv];
      int[] count = new int[nv];
      for (int i = 0; i < nv; i++) {
        Gn[i] = P(0,0,0);
      }
      for (int i = 0; i < nc; i++) {
        if (isInterior[v(i)]) {
          Gn[v(i)].add(g(n(i)));
          Gn[v(i)].add(g(p(i)));
          count[v(i)]+=2;
        }
      }
      for (int i = 0; i < nv; i++) {
        if (isInterior[i]) {
          Gn[i].div(count[i]);
        }
      }
      for (int v=0; v<nv; v++) if(isInterior[v]) G[v].translateTowards(.1,Gn[v]);
    }

  int v (int c) {return V[c];}                                // vertex of c
  int o (int c) {return O[c];}                                // opposite corner
  int l (int c) {return O[n(c)];}                             // left
  int s (int c) {return n(O[n(c)]);}                             // swing
  int u (int c) {return p(O[p(c)]);}                             // unswing
  int r (int c) {return O[p(c)];}                             // right

  void showOpposites()
  {
    boolean[] visited = new boolean[nc];
    for (int i = 0; i < nc; i++) {
      if (!visited[i]) {
        pt midPoint = P(g(n(i)), g(p(i)));
        drawParabolaInHat(g(i), midPoint, g(o(i)), 5);
        visited[i] = true;
        visited[o(i)] = true;
      }
    }
  }

  void showVoronoiEdges() // draws Voronoi edges on the boundary of Voroni cells of interior vertices
    { 
      boolean[] visited = new boolean[nv];
      boolean[] visited_tri = new boolean[nt];
      adjVoroTable.clear();
      for (int i = 0; i < nc; i++) {
        if (!visited_tri[t(i)] && isInterior[v(i)]) {
          voronoi_vertices[t(i)] = triCircumcenter(i);
          visited_tri[t(i)] = true;
        }
      }

      for (int i = 0; i < nc; i++) {
        if (!visited[v(i)] && isInterior[v(i)]) {
          visited[v(i)] = true;
          // pt c_1 = triCircumcenter(i);
          pt c_1 = voronoi_vertices[t(i)];
          int s = s(i);
          int pre = i;
          while (s != i) {
            // pt c_2 = triCircumcenter(s);
            pt c_2 = voronoi_vertices[t(s)];
            show(c_1, c_2);
            // filling Voronoi adjTable
            if (adjVoroTable.get(t(pre)) != null) {
              adjVoroTable.get(t(pre)).add(t(s));
            } else {
              Set<Integer> tmp_set = new HashSet();
              tmp_set.add(t(s));
              adjVoroTable.put(t(pre), tmp_set);
            }
            if (adjVoroTable.get(t(s)) != null) {
              adjVoroTable.get(t(s)).add(t(pre));
            } else {
              Set<Integer> tmp_set = new HashSet();
              tmp_set.add(t(pre));
              adjVoroTable.put(t(s), tmp_set);
            }
            c_1 = c_2;
            pre = s;
            s = s(s);
          }
          pt c_2 = voronoi_vertices[t(i)];
          show(c_1, c_2);
          if (adjVoroTable.get(t(pre)) != null) {
            adjVoroTable.get(t(pre)).add(t(s));
          } else {
            Set<Integer> tmp_set = new HashSet();
            tmp_set.add(t(s));
            adjVoroTable.put(t(pre), tmp_set);
          }
          if (adjVoroTable.get(t(s)) != null) {
            adjVoroTable.get(t(s)).add(t(pre));
          } else {
            Set<Integer> tmp_set = new HashSet();
            tmp_set.add(t(pre));
            adjVoroTable.put(t(s), tmp_set);
          }
        }
      }
    }               

  void showArcs() // draws arcs of quadratic B-spline of Voronoi boundary loops of interior vertices
    { 
      for (int i = 0; i < nc; i++) {
        if (isInterior[v(i)]) {
          pt[] tmpArray = new pt[3];
          pt c_i = triCircumcenter(i);
          pt c_u = triCircumcenter(u(i));
          pt c_s = triCircumcenter(s(i));
          tmpArray[0] = c_u;
          tmpArray[1] = c_i;
          tmpArray[2] = c_s;
          drawBspline(tmpArray, 4);
          int s = s(i);
          while (s != i) {
            c_i = triCircumcenter(s);
            c_u = triCircumcenter(u(s));
            c_s = triCircumcenter(s(s));
            tmpArray[0] = c_u;
            tmpArray[1] = c_i;
            tmpArray[2] = c_s;
            drawBspline(tmpArray, 4);
            s = s(s);
          }
        }
      }
    }               // draws arcs in triangles

  void drawVoronoiFaceOfInteriorVertices() {
    float dv = 1. / (nv - 1);
    for (int i = 0; i < nv; i++) {
      if (isInterior[i]) {
        fill(dv * 255 * i, dv * 255 * (nv - i), 200);
        drawVoronoiFaceOfInteriorVertex(i);
      }
    }
  }

  int cornerIndexFromVertexIndex(int v) {
    for (int i = 0; i < nc; i++) {
      if (v(i) == v) return i;
    }
    return -1;
  }

  void drawVoronoiFaceOfInteriorVertex(int v) {
    int c_start = cornerIndexFromVertexIndex(v);
    beginShape();
    pt c_1 = triCircumcenter(c_start);
    vertex(c_1);
    int s = s(c_start);
    while (s != c_start) {
      pt c_2 = triCircumcenter(s);
      vertex(c_2);
      c_1 = c_2;
      s = s(s);
    }
    endShape(CLOSE);
  }

 
  pt triCenter(int c) {return P(g(c),g(n(c)),g(p(c))); }  // returns center of mass of triangle of corner c
  pt triCircumcenter(int c) {return CircumCenter(g(c),g(n(c)),g(p(c))); }  // returns circumcenter of triangle of corner c


  } // end of MESH
