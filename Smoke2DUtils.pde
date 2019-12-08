
void diffuse2D(int b, float[] x, float[] x0, float diff, float dt) {
    float a = dt * diff * (N - 2) * (N - 2);
    lin_solve2D(b, x, x0, a, 1 + 6 * a);
}

void lin_solve2D(int b, float[] x, float[] x0, float a, float c) {
    float cRecip = 1.0 / c;
    for (int k = 0; k < iter; k++) {
        for (int j = 1; j < N - 1; j++) {
            for (int i = 1; i < N - 1; i++) {
                x[getIndex2D(i, j)] =
                        (x0[getIndex2D(i, j)]
                                + a * (x[getIndex2D(i + 1, j)]
                                + x[getIndex2D(i - 1, j)]
                                + x[getIndex2D(i, j + 1)]
                                + x[getIndex2D(i, j - 1)]
                        )) * cRecip;
            }
        }

        set_bnd2D(b, x);
    }
}

void project2D(float[] velocX, float[] velocY, float[] p, float[] div) {
    for (int j = 1; j < N - 1; j++) {
        for (int i = 1; i < N - 1; i++) {
            div[getIndex2D(i, j)] = -0.5f * (
                    velocX[getIndex2D(i + 1, j)]
                            - velocX[getIndex2D(i - 1, j)]
                            + velocY[getIndex2D(i, j + 1)]
                            - velocY[getIndex2D(i, j - 1)]
            ) / N;
            p[getIndex2D(i, j)] = 0;
        }
    }

    set_bnd2D(0, div);
    set_bnd2D(0, p);
    lin_solve2D(0, p, div, 1, 6);

    for (int j = 1; j < N - 1; j++) {
        for (int i = 1; i < N - 1; i++) {
            velocX[getIndex2D(i, j)] -= 0.5f * (p[getIndex2D(i + 1, j)]
                    - p[getIndex2D(i - 1, j)]) * N;
            velocY[getIndex2D(i, j)] -= 0.5f * (p[getIndex2D(i, j + 1)]
                    - p[getIndex2D(i, j - 1)]) * N;
        }
    }
    set_bnd2D(1, velocX);
    set_bnd2D(2, velocY);
}


void advect2D(int b, float[] d, float[] d0, float[] velocX, float[] velocY, float dt) {
    float i0, i1, j0, j1;

    float dtx = dt * (N - 2);
    float dty = dt * (N - 2);

    float s0, s1, t0, t1;
    float tmp1, tmp2, x, y;

    float Nfloat = N;
    float ifloat, jfloat;
    int i, j;

    for (j = 1, jfloat = 1; j < N - 1; j++, jfloat++) {
        for (i = 1, ifloat = 1; i < N - 1; i++, ifloat++) {
            tmp1 = dtx * velocX[getIndex2D(i, j)];
            tmp2 = dty * velocY[getIndex2D(i, j)];
            x = ifloat - tmp1;
            y = jfloat - tmp2;

            if (x < 0.5f) x = 0.5f;
            if (x > Nfloat + 0.5f) x = Nfloat + 0.5f;
            i0 = floor(x);
            i1 = i0 + 1.0f;
            if (y < 0.5f) y = 0.5f;
            if (y > Nfloat + 0.5f) y = Nfloat + 0.5f;
            j0 = floor(y);
            j1 = j0 + 1.0f;

            s1 = x - i0;
            s0 = 1.0f - s1;
            t1 = y - j0;
            t0 = 1.0f - t1;

            int i0i = int(i0);
            int i1i = int(i1);
            int j0i = int(j0);
            int j1i = int(j1);

            d[getIndex2D(i, j)] =
                    s0 * (t0 * d0[getIndex2D(i0i, j0i)] + t1 * d0[getIndex2D(i0i, j1i)]) +
                            s1 * (t0 * d0[getIndex2D(i1i, j0i)] + t1 * d0[getIndex2D(i1i, j1i)]);
        }
    }

    set_bnd2D(b, d);
}


void set_bnd2D(int b, float[] x) {
    for (int i = 1; i < N - 1; i++) {
        x[getIndex2D(i, 0)] = b == 2 ? -x[getIndex2D(i, 1)] : x[getIndex2D(i, 1)];
        x[getIndex2D(i, N - 1)] = b == 2 ? -x[getIndex2D(i, N - 2)] : x[getIndex2D(i, N - 2)];
    }
    for (int j = 1; j < N - 1; j++) {
        x[getIndex2D(0, j)] = b == 1 ? -x[getIndex2D(1, j)] : x[getIndex2D(1, j)];
        x[getIndex2D(N - 1, j)] = b == 1 ? -x[getIndex2D(N - 2, j)] : x[getIndex2D(N - 2, j)];
    }

    x[getIndex2D(0, 0)] = 0.5f * (x[getIndex2D(1, 0)] + x[getIndex2D(0, 1)]);
    x[getIndex2D(0, N - 1)] = 0.5f * (x[getIndex2D(1, N - 1)] + x[getIndex2D(0, N - 2)]);
    x[getIndex2D(N - 1, 0)] = 0.5f * (x[getIndex2D(N - 2, 0)] + x[getIndex2D(N - 1, 1)]);
    x[getIndex2D(N - 1, N - 1)] = 0.5f * (x[getIndex2D(N - 2, N - 1)] + x[getIndex2D(N - 1, N - 2)]);
}
