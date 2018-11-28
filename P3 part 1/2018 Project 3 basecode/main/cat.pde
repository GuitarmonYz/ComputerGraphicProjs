class cat extends character {
    cat (pt initPos, vec initVelocity, vec initAcceleration, float fracFactor) {
        super(initPos, initVelocity, initAcceleration, fracFactor);
    }

    void initPos() {
        if (!posSet) {
            int stop = (int)random(M.adjVoroTable.size());
            int i = 0;
            for (Map.Entry<Integer, Set<Integer>> entry : M.adjVoroTable.entrySet()) {
                if (i == stop) {
                    e1_idx = entry.getKey();
                    e2_idx = entry.getValue().iterator().next();
                    e2 = M.voronoi_vertices[e2_idx];
                    e1 = M.voronoi_vertices[e1_idx];
                    position = P(e1, V(10, U(V(e1,e2))));
                    posSet = true;
                    break;
                }
                i++;
            }
        }
    }

    vec getDragForce() {
        return V(n2(V(0.001, V(d.getPos(), position))), U(V(position, d.getPos())));
    }
}