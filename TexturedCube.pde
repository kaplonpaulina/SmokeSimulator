void TexturedCube(PImage tex, int size) {
    beginShape(QUADS);
    texture(tex);
    noFill();

    // +Z "front" face
    vertex(-size, -size, size, 0, 0);
    vertex(size, -size, size, size, 0);
    vertex(size, size, size, size, size);
    vertex(-size, size, size, 0, size);

    // -Z "back" face
    vertex(size, -size, -size, 0, 0);
    vertex(-size, -size, -size, size, 0);
    vertex(-size, size, -size, size, size);
    vertex(size, size, -size, 0, size);

    // +Y "bottom" face
    vertex(-size, size, size, 0, 0);
    vertex(size, size, size, size, 0);
    vertex(size, size, -size, size, size);
    vertex(-size, size, -size, 0, size);

    // -Y "top" face
    vertex(-size, -size, -size, 0, 0);
    vertex(size, -size, -size, size, 0);
    vertex(size, -size, size, size, size);
    vertex(-size, -size, size, 0, size);

    // +X "right" face
    vertex(size, -size, size, 0, 0);
    vertex(size, -size, -size, size, 0);
    vertex(size, size, -size, size, size);
    vertex(size, size, size, 0, size);

    // -X "left" face
    vertex(-size, -size, -size, 0, 0);
    vertex(-size, -size, size, size, 0);
    vertex(-size, size, size, size, size);
    vertex(-size, size, -size, 0, size);

    endShape();
}
