class dog extends character {

    dog (pt initPos, vec initVelocity, vec initAcceleration, float fracFactor) {
        super(initPos, initVelocity, initAcceleration, fracFactor);
    }

    vec getDragForce() {
        return V(n2(V(0.001, V(Of, position))), U(V(position, Of)));
    }
}
