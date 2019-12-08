int getIndex2D(int x, int y) {
  x = constrain(x, 0, N-1);
  y = constrain(y, 0, N-1);
  return x + (y * N);
}

class Smoke2D {
  
  int numberOfParticles;
  
  int size;
  float dt;
  float diff;
  float visc;

  float[] s;
  float[] density;

  float[] Vx;
  float[] Vy;

  float[] Vx0;
  float[] Vy0;

  Smoke2D(float dt, float diffusion, float viscosity) {

    this.size = N;
    this.dt = dt;
    this.diff = diffusion;
    this.visc = viscosity;

    this.s = new float[N*N];
    this.density = new float[N*N];

    this.Vx = new float[N*N];
    this.Vy = new float[N*N];

    this.Vx0 = new float[N*N];
    this.Vy0 = new float[N*N];
    
    this.numberOfParticles = 0;
  }

  void step2D() {
    float visc     = this.visc;
    float diff     = this.diff;
    float dt       = this.dt;
    float[] Vx      = this.Vx;
    float[] Vy      = this.Vy;
    float[] Vx0     = this.Vx0;
    float[] Vy0     = this.Vy0;
    float[] s       = this.s;
    float[] density = this.density;

    diffuse2D(1, Vx0, Vx, visc, dt);
    diffuse2D(2, Vy0, Vy, visc, dt);

    project2D(Vx0, Vy0, Vx, Vy);

    advect2D(1, Vx, Vx0, Vx0, Vy0, dt);
    advect2D(2, Vy, Vy0, Vx0, Vy0, dt);

    project2D(Vx, Vy, Vx0, Vy0);

    diffuse2D(0, s, density, diff, dt);
    advect2D(0, density, s, Vx, Vy, dt);
  }

  void addDensity2D(int x, int y, float amount) {
    int index = getIndex2D(x, y);
    this.density[index] += amount;
  }

  void addVelocity2D(int x, int y, float amountX, float amountY) {
    int index = getIndex2D(x, y);
    this.Vx[index] += amountX;
    this.Vy[index] += amountY;
  }

  void render2D() {
    colorMode(HSB, 255);
    
    int particleCount = 0;
    
    for (int i = 0; i < N; i++) {
      for (int j = 0; j < N; j++) {
        float x = i * SCALE;
        float y = j * SCALE;
        float d = this.density[getIndex2D(i, j)];
        fill((d + 50) % 255,0,d);
        particleCount +=d;
        noStroke();
        rect(x, y, SCALE, SCALE);
      }
    }
    this.numberOfParticles = particleCount;
  }
}
