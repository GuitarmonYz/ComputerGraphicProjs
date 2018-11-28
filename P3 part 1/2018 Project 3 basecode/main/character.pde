abstract class character {
    pt position;
    vec velocity;
    vec acceleration;
    float fracFactor;
    pt e1;
    pt e2;
    int e1_idx;
    int e2_idx;
    boolean posSet = false;

    character (pt initPos, vec initVelocity, vec initAcceleration, float fracFactor) {
        position = initPos;
        velocity = V(initVelocity);
        acceleration = V(initAcceleration);
        this.fracFactor = fracFactor;
    }

    void initPos() {
        if (!posSet) {
            Map.Entry<Integer,Set<Integer>> entry = M.adjVoroTable.entrySet().iterator().next();
            e1_idx = entry.getKey();
            e2_idx = entry.getValue().iterator().next();
            e2 = M.voronoi_vertices[e2_idx];
            e1 = M.voronoi_vertices[e1_idx];
            position = P(e1, V(10, U(V(e1,e2))));
            posSet = true;
        }
    }

    void updateAcc() {
        vec dragForce = getDragForce();
        if (norm(velocity) > 0.01 || norm(velocity) < -0.01) {
            vec frac = V(-fracFactor, U(velocity));
            acceleration = A(dragForce, frac);
        } else {
            acceleration = dragForce;
        }
        // println("updateAcc");
    }

    void projectAcc() {
        vec edge = V(e1, e2);
        float magnitude = abs(d(U(edge), acceleration));
        if (d(edge, acceleration) < 0) {
            acceleration = V(-magnitude, U(edge));
        } else {
            acceleration = V(magnitude, U(edge));
        }
        // println(magnitude);
    }

    void updateVelocity() {
        velocity.add(acceleration);
    }

    void move() {
        // println("d2e1: "+d(position, e1));
        // println("d2e2: "+d(position, e2));
        // println("velocity: "+n(velocity));
        if (n(velocity) - d(position, e1) > 0 && d(velocity, V(position, e1)) > 0) {
            float residual = n(velocity) - d(position, e1);
            // print("residual in e1: ");
            // println(residual);
            e2_idx = checkDirection(e1_idx);
            e2 = M.voronoi_vertices[e2_idx];
            velocity = V(norm(velocity), U(e1,e2));
            position = P(e1, V(residual, U(e1, e2)));
        } else if (n(velocity) - d(position, e2) > 0 && d(velocity, V(position, e2)) > 0) {
            float residual = n(velocity) - d(position, e2);
            // print("residual in e2: ");
            // println(residual);
            e1_idx = checkDirection(e2_idx);
            e1 = M.voronoi_vertices[e1_idx];
            velocity = V(norm(velocity), U(e2, e1));
            position = P(e2, V(residual, U(e2, e1)));
        } else {
            // println("velocity: ");
            position.add(velocity);
        }
    }

    int checkDirection(int endPoint) {
        vec dragForce = getDragForce();
        Set<Integer> candidates = M.adjVoroTable.get(endPoint);
        float min_angle = 10;
        int res = -1;
        // println("size: "+candidates.size());
        for (Integer neighbor_idx : candidates) {
            pt neighbor = M.voronoi_vertices[neighbor_idx];
            vec cur_candidate = V(M.voronoi_vertices[endPoint], neighbor);
            float cur_angle = angle(U(dragForce), U(cur_candidate));
            if (cur_angle < min_angle) {
                min_angle = cur_angle;
                res = neighbor_idx;
            }
        }
        // show(res, 12);
        return res;
    }

    abstract vec getDragForce ();

    pt getPos() {
        return position;
    }
}
