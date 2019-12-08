int getIndex3D(int x, int y, int z) {
        x = constrain(x, 0, N - 1);
        y = constrain(y, 0, N - 1);
        z = constrain(z, 0, N - 1);
        return x + (y * N) + (z * N * N);
    }

class Smoke3D {

    int numberOfParticles;

    int size;
    float dt;
    float diff;
    float visc;

    float[] s;
    float[] density;

    float[] Vx;
    float[] Vy;
    float[] Vz;

    float[] Vx0;
    float[] Vy0;
    float[] Vz0;

    Smoke3D(float dt, float diffusion, float viscosity) {

        this.size = N;
        this.dt = dt;
        this.diff = diffusion;
        this.visc = viscosity;

        this.s = new float[N * N * N];
        this.density = new float[N * N * N];

        this.Vx = new float[N * N * N];
        this.Vy = new float[N * N * N];
        this.Vz = new float[N * N * N];

        this.Vx0 = new float[N * N * N];
        this.Vy0 = new float[N * N * N];
        this.Vz0 = new float[N * N * N];

        this.numberOfParticles = 0;
    }

    void step() {
        float visc = this.visc;
        float diff = this.diff;
        float dt = this.dt;
        float[] Vx = this.Vx;
        float[] Vy = this.Vy;
        float[] Vz = this.Vz;
        float[] Vx0 = this.Vx0;
        float[] Vy0 = this.Vy0;
        float[] Vz0 = this.Vz0;
        float[] s = this.s;
        float[] density = this.density;

        diffuse3D(1, Vx0, Vx, visc, dt);
        diffuse3D(2, Vy0, Vy, visc, dt);
        diffuse3D(3, Vz0, Vz, visc, dt);

        project3D(Vx0, Vy0, Vz0, Vx, Vy);

        advect3D(1, Vx, Vx0, Vx0, Vy0, Vz0, dt);
        advect3D(2, Vy, Vy0, Vx0, Vy0, Vz0, dt);
        advect3D(3, Vz, Vz0, Vx0, Vy0, Vz0, dt);

        project3D(Vx, Vy, Vz, Vx0, Vy0);

        diffuse3D(0, s, density, diff, dt);
        advect3D(0, density, s, Vx, Vy, Vz, dt);
    }

    void addDensity(int x, int y, int z, float amount) {
        int index = getIndex3D(x, y, z);
        this.density[index] += amount;
    }

    void addVelocity(int x, int y, int z, float amountX, float amountY, float amountZ) {
        int index = getIndex3D(x, y, z);
        this.Vx[index] += amountX;
        this.Vy[index] += amountY;
        this.Vz[index] += amountZ;
    }

    void render() {
        int particleCount = 0;

        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                for (int k = 0; k < N; k++) {
                    float x = i * SCALE + width / 4 + 2;
                    float y = j * SCALE + height / 4;
                    float z = k * SCALE - width / 4;
                    float d = this.density[getIndex3D(i, j, k)];


                    //PImage tex = loadImage("texture.png");
                    //translate(x, y, z);
                    //noStroke();
                    //tint(255, d); 
                    //scale(10);
                    //TexturedCube(tex);

                    if (d == 0) {
                        noFill();
                    } else {
                        //tint(255,d);
                        fill(200, d);
                    }

                    particleCount += d;


                    noStroke();
                    //rect(x, y, SCALE, SCALE);
                    pushMatrix();
                    translate(x, y, z);
                    box(SCALE);
                    popMatrix();
                }
            }
        }
        this.numberOfParticles = particleCount;
    }
}
