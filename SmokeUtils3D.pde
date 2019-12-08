void diffuse3D(int b, float[] x, float[] x0, float diff, float dt) {
    float a = dt * diff * (N - 2) * (N - 2);
    lin_solve3D(b, x, x0, a, 1 + 6 * a);
}

void lin_solve3D(int b, float[] x, float[] x0, float a, float c) {
    float cRecip = 1.0 / c;
    for (int k = 0; k < iter; k++) {
        for (int m = 1; m < N - 1; m++) {
            for (int j = 1; j < N - 1; j++) {
                for (int i = 1; i < N - 1; i++) {
                    x[getIndex3D(i, j, m)] =
                            (x0[getIndex3D(i, j, m)] + a * (x[getIndex3D(i + 1, j, m)]
                                    + x[getIndex3D(i - 1, j, m)]
                                    + x[getIndex3D(i, j + 1, m)]
                                    + x[getIndex3D(i, j - 1, m)]
                                    + x[getIndex3D(i, j, m + 1)]
                                    + x[getIndex3D(i, j, m - 1)]
                            )) * cRecip;
                }
            }
        }
        set_bnd3D(b, x);
    }
}

void project3D(float[] velocX, float[] velocY, float[] velocZ, float[] p, float[] div) {
    for (int k = 1; k < N - 1; k++) {
        for (int j = 1; j < N - 1; j++) {
            for (int i = 1; i < N - 1; i++) {
                div[getIndex3D(i, j, k)] = -0.5f * (
                        velocX[getIndex3D(i + 1, j, k)]
                                - velocX[getIndex3D(i - 1, j, k)]
                                + velocY[getIndex3D(i, j + 1, k)]
                                - velocY[getIndex3D(i, j - 1, k)]
                                + velocZ[getIndex3D(i, j, k + 1)]
                                - velocZ[getIndex3D(i, j, k - 1)] ) / N;
                p[getIndex3D(i, j, k)] = 0;
            }
        }
    }
    set_bnd3D(0, div);
    set_bnd3D(0, p);
    lin_solve3D(0, p, div, 1, 6);

    for (int k = 1; k < N - 1; k++) {
        for (int j = 1; j < N - 1; j++) {
            for (int i = 1; i < N - 1; i++) {
                velocX[getIndex3D(i, j, k)] -= 0.5f * (p[getIndex3D(i + 1, j, k)] - p[getIndex3D(i - 1, j, k)]) * N;
                velocY[getIndex3D(i, j, k)] -= 0.5f * (p[getIndex3D(i, j + 1, k)] - p[getIndex3D(i, j - 1, k)]) * N;
                velocZ[getIndex3D(i, j, k)] -= 0.5f * (p[getIndex3D(i, j, k + 1)] - p[getIndex3D(i, j, k - 1)]) * N;
            }
        }
    }
    set_bnd3D(1, velocX);
    set_bnd3D(2, velocY);
    set_bnd3D(3, velocZ);
}


void advect3D(int b, float[] d, float[] d0, float[] velocX, float[] velocY, float[] velocZ, float dt) {
    float i0, i1, j0, j1, k0, k1;

    float dtx = dt * (N - 2);
    float dty = dt * (N - 2);
    float dtz = dt * (N - 2);

    float s0, s1, t0, t1, u0, u1;
    float tmp1, tmp2, tmp3, x, y, z;

    float Nfloat = N;
    float ifloat, jfloat, kfloat;
    int i, j, k;
    for (k = 1, kfloat = 1; k < N - 1; k++, kfloat++) {
        for (j = 1, jfloat = 1; j < N - 1; j++, jfloat++) {
            for (i = 1, ifloat = 1; i < N - 1; i++, ifloat++) {
                tmp1 = dtx * velocX[getIndex3D(i, j, k)];
                tmp2 = dty * velocY[getIndex3D(i, j, k)];
                tmp3 = dtz * velocZ[getIndex3D(i, j, k)];
                x = ifloat - tmp1;
                y = jfloat - tmp2;
                z = kfloat - tmp3;

                if (x < 0.5f) x = 0.5f;
                if (x > Nfloat + 0.5f) x = Nfloat + 0.5f;
                i0 = floor(x);
                i1 = i0 + 1.0f;
                if (y < 0.5f) y = 0.5f;
                if (y > Nfloat + 0.5f) y = Nfloat + 0.5f;
                j0 = floor(y);
                j1 = j0 + 1.0f;
                if (z < 0.5f) z = 0.5f;
                if (z > Nfloat + 0.5f) z = Nfloat + 0.5f;
                k0 = floor(z);
                k1 = k0 + 1.0f;

                s1 = x - i0;
                s0 = 1.0f - s1;
                t1 = y - j0;
                t0 = 1.0f - t1;
                u1 = z - k0;
                u0 = 1.0f - u1;

                int i0i = int(i0);
                int i1i = int(i1);
                int j0i = int(j0);
                int j1i = int(j1);
                int k0i = int(k0);
                int k1i = int(k1);

                d[getIndex3D(i, j, k)] =
                        s0 * (t0 * (u0 * d0[getIndex3D(i0i, j0i, k0i)]
                                + u1 * d0[getIndex3D(i0i, j0i, k1i)])
                                + (t1 * (u0 * d0[getIndex3D(i0i, j1i, k0i)]
                                + u1 * d0[getIndex3D(i0i, j1i, k1i)])))
                                + s1 * (t0 * (u0 * d0[getIndex3D(i1i, j0i, k0i)]
                                + u1 * d0[getIndex3D(i1i, j0i, k1i)])
                                + (t1 * (u0 * d0[getIndex3D(i1i, j1i, k0i)]
                                + u1 * d0[getIndex3D(i1i, j1i, k1i)])));
            }
        }
    }

    set_bnd3D(b, d);
}


void set_bnd3D(int b, float[] x) {
    for (int j = 1; j < N - 1; j++) {
        for (int i = 1; i < N - 1; i++) {
            x[getIndex3D(i, j, 0)]     = b == 3 ? -x[getIndex3D(i, j, 1)] : x[getIndex3D(i, j, 1)];
            x[getIndex3D(i, j, N - 1)] = b == 3 ? -x[getIndex3D(i, j, N - 2)] : x[getIndex3D(i, j, N - 2)];
        }
    }
    for (int k = 1; k < N - 1; k++) {
        for (int i = 1; i < N - 1; i++) {
            x[getIndex3D(i, 0, k)]     = b == 2 ? -x[getIndex3D(i, 1, k)] : x[getIndex3D(i, 1, k)];
            x[getIndex3D(i, N - 1, k)] = b == 2 ? -x[getIndex3D(i, N - 2, k)] : x[getIndex3D(i, N - 2, k)];
        }
    }
    for (int k = 1; k < N - 1; k++) {
        for (int j = 1; j < N - 1; j++) {
            x[getIndex3D(0, j, k)]     = b == 1 ? -x[getIndex3D(1, j, k)] : x[getIndex3D(1, j, k)];
            x[getIndex3D(N - 1, j, k)] = b == 1 ? -x[getIndex3D(N - 2, j, k)] : x[getIndex3D(N - 2, j, k)];
        }
    }

    x[getIndex3D(0, 0, 0)]             = 0.5f * (x[getIndex3D(1, 0, 0)] + x[getIndex3D(0, 1, 0)] + x[getIndex3D(0, 0, 1)]);
    x[getIndex3D(0, N - 1, 0)]         = 0.5f * (x[getIndex3D(1, N - 1, 0)] + x[getIndex3D(0, N - 2, 0)] + x[getIndex3D(0, N - 1, 1)]);
    x[getIndex3D(0, 0, N - 1)]         = 0.5f * (x[getIndex3D(1, 0, N - 1)] + x[getIndex3D(0, 1, N - 1)] + x[getIndex3D(0, 0, N)]);
    x[getIndex3D(0, N - 1, N - 1)]     = 0.5f * (x[getIndex3D(1, N - 1, N - 1)] + x[getIndex3D(0, N - 2, N - 1)] + x[getIndex3D(0, N - 1, N - 2)]);
    x[getIndex3D(N - 1, 0, 0)]         = 0.5f * (x[getIndex3D(N - 2, 0, 0)] + x[getIndex3D(N - 1, 1, 0)] + x[getIndex3D(N - 1, 0, 1)]);
    x[getIndex3D(N - 1, N - 1, 0)]     = 0.5f * (x[getIndex3D(N - 2, N - 1, 0)] + x[getIndex3D(N - 1, N - 2, 0)] + x[getIndex3D(N - 1, N - 1, 1)]);
    x[getIndex3D(N - 1, 0, N - 1)]     = 0.5f * (x[getIndex3D(N - 2, 0, N - 1)] + x[getIndex3D(N - 1, 1, N - 1)] + x[getIndex3D(N - 1, 0, N - 2)]);
    x[getIndex3D(N - 1, N - 1, N - 1)] = 0.5f * (x[getIndex3D(N - 2, N - 1, N - 1)] + x[getIndex3D(N - 1, N - 2, N - 1)] + x[getIndex3D(N - 1, N - 1, N - 2)]);
}
