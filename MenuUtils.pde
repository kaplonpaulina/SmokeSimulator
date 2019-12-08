boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

void drawButton(int x, int y, int size, String label, boolean mouseOver){
   if (mouseOver) {
    fill(rectHighlight);
    }
    else {
      fill(rectColor);
    }
  stroke(255);
  rect(x, y, size, size);
  
  textSize(32);
  textAlign(CENTER);
  fill(255);
  text(label, x+size/2, y+size/1.6); 
}


void drawButton(int x, int y, int sizeX, int sizeY, String label, boolean mouseOver){
   if (mouseOver) {
    fill(rectHighlight);
    }
    else {
      fill(rectColor);
    }
  stroke(255);
  rect(x, y, sizeX, sizeY);
  
  textSize(16);
  textAlign(CENTER);
  fill(255);
  text(label, x+sizeX/2, y+sizeY/1.6); 
}

void update() {
if ( overRect(button2D_x, button2D_y, buttonSize, buttonSize) ) {
    over2D = true;
    over3D = false;
  }
  else if(overRect(button3D_x, button3D_y, buttonSize, buttonSize)) {
    over3D = true;
    over2D = false;
  }
  else if(overRect(addingButton_x, buttonDiffPlus_y, addingButtonSizeX, addingButtonSizeY)){
    overDiffPlus = true;
    overDiffMinus = false;
    overVisPlus = false;
    overViscMinus = false;
    overTimePlus = false;
    overTimeMinus = false;
  }
  else if(overRect(addingButton_x, buttonDiffMinus_y, addingButtonSizeX, addingButtonSizeY)){
    overDiffPlus = false;
    overDiffMinus = true;
    overVisPlus = false;
    overViscMinus = false;
    overTimePlus = false;
    overTimeMinus = false;
  }
  else if(overRect(addingButton_x, buttonVisPlus_y, addingButtonSizeX, addingButtonSizeY)){
    overDiffPlus = false;
    overDiffMinus = false;
    overVisPlus = true;
    overViscMinus = false;
    overTimePlus = false;
    overTimeMinus = false;
  }
  else if(overRect(addingButton_x, buttonViscMinus_y, addingButtonSizeX, addingButtonSizeY)){
    overDiffPlus = false;
    overDiffMinus = false;
    overVisPlus = false;
    overViscMinus = true;
    overTimePlus = false;
    overTimeMinus = false;
  }
  else if(overRect(addingButton_x, buttonTimePlus_y, addingButtonSizeX, addingButtonSizeY)){
    overDiffPlus = false;
    overDiffMinus = false;
    overVisPlus = false;
    overViscMinus = false;
    overTimePlus = true;
    overTimeMinus = false;
  }
  else if(overRect(addingButton_x, buttonTimeMinus_y, addingButtonSizeX, addingButtonSizeY)){
    overDiffPlus = false;
    overDiffMinus = false;
    overVisPlus = false;
    overViscMinus = false;
    overTimePlus = false;
    overTimeMinus = true;
  }
  else {
    overDiffPlus = false;
    overDiffMinus = false;
    overVisPlus = false;
    overViscMinus = false;
    overTimePlus = false;
    overTimeMinus = false;
    over2D = false;
    over3D = false;
  
  }
  
}

void drawMenu(){
  update();
      background(baseColor);
      imageMode(CENTER);
      image(smokeBg, height/2, width/2);
            
      textSize(60);
      fill(255);
      textAlign(CENTER);
      text("SMOKE SIMULATION", width/2, 150);
      
      textAlign(LEFT);
      textSize(40);
      text("DIFFUSION:", 160, 270);
      
      fill(0);
      rect(400, 225, 60, 60);
      fill(255);
      textAlign(CENTER);
      textSize(15);
      text(diffusion, 427, 260);
      drawButton(470, 225, 60, 28, "+", overDiffPlus);  
      drawButton(470, 257, 60, 28, "-", overDiffMinus);  

      
      fill(255);
      textAlign(LEFT);
      textSize(40);
      text("VISCOSITY:", 160, 340);
      
      fill(0);
      rect(400, 295, 60, 60);
      fill(255);
      textAlign(CENTER);
      textSize(15);
      text(viscosity, 427, 330);
      drawButton(470, 295, 60, 28, "+", overVisPlus);  
      drawButton(470, 327, 60, 28, "-", overViscMinus);  
      
      fill(255);
      textAlign(LEFT);
      textSize(40);
      text("DT:", 160, 410);
      
      fill(0);
      rect(400, 365, 60, 60);
      fill(255);
      textAlign(CENTER);
      textSize(15);
      text(dtime, 427, 400);
      drawButton(470, 365, 60, 28, "+", overTimePlus);  
      drawButton(470, 397, 60, 28, "-", overTimeMinus);
      
      fill(255);
    
    
      drawButton(button2D_x, button2D_y, buttonSize, "2D", over2D);  
      drawButton(button3D_x, button3D_y, buttonSize, "3D", over3D);
}

void draw2D(){
   background(0);
    int xAxis2D = int(0.5 * width / SCALE);
    int yAxis2D = int(0.5 * height / SCALE);
    for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
            smoke2D.addDensity2D(xAxis2D + i, yAxis2D + j, random(50, 150));
        }
    }
    for (int i = 0; i < 2; i++) {
        float angle = noise(t) - TWO_PI / 3;
        PVector v = PVector.fromAngle(angle);
        v.mult(0.2);
        t += 0.01;
        smoke2D.addVelocity2D(xAxis2D, yAxis2D, v.x, v.y);
    }

    smoke2D.step2D();
    smoke2D.render2D();
    if (smoke2D.numberOfParticles >= 4000000) {

        if (!siren.isPlaying()) {
            siren.loop();
        }

        image(hazardBg2D, width / 2, height / 2);

        if (millis() - timer >= 1000) {

            imageMode(CENTER);
            rotate(camera.getRotations()[2]);
            image(hazardSign2D, camera.getLookAt()[0], camera.getLookAt()[1]);
            if (millis() - timer >= 2000) {

                timer = millis();
            }
        }
        float zPoz = camera.getRotations()[2];
        if (zPoz <= -0.05) {
            camera.rotateZ(random(0.01));
        } else if (zPoz >= 0.05) {
            camera.rotateZ(random(-0.01, 0));
        } else {
            camera.rotateZ(random(-0.01, 0.01));
        }

    }
    
   
    textAlign(LEFT);
    textSize(20);
    fill(114, 242, 144);
    text("\"m\" to return to menu screen", 20, height-10-20);
}


void draw3D(){
   background(0);

    int xAxis3D = int(0.5 * (width / 2) / SCALE);
    int yAxis3D = int(0.5 * (height / 2) / SCALE);
    int zAxis3D = int(0.5 * (width / 2) / SCALE);
    for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
            for (int k = -1; k <= 1; k++) {
                smoke3D.addDensity(xAxis3D + i, yAxis3D + j, zAxis3D + k, random(50, 150));
            }
        }
    }
    for (int i = 0; i < 2; i++) {
        float angle = noise(t) - TWO_PI / 3;
        PVector v = PVector.fromAngle(angle);
        float a = constrain(0.2 * height, 0.2, 1);
        v.mult(a);
        t += 0.01;
        smoke3D.addVelocity(xAxis3D, yAxis3D, zAxis3D, v.x, v.y, v.z);
    }


    smoke3D.step();
    smoke3D.render();

    translate(width / 2, height / 2, 0);
    if (smoke3D.numberOfParticles >= 1500000) {
        if (!siren.isPlaying()) {
            siren.loop();
        }
        TexturedCube(hazardBg3D, 180);
        if (millis() - timer >= 1000) {
            TexturedCube(hazardSign3D, 180);
            if (millis() - timer >= 2000) {
                timer = millis();
            }
        }

    } else {
        pushMatrix();
        stroke(255);
        noFill();
        box(N * SCALE);
        popMatrix();
    }
    
    textAlign(LEFT);
    textSize(20);
    fill(114, 242, 144);
    text("\"m\" to return to menu screen", camera.getLookAt()[0]-2.35*width/3,camera.getLookAt()[1]-height/4.5,camera.getLookAt()[2]+height/3);
    
    textAlign(LEFT);
    rotateY(PI/2);
    textSize(20);
    fill(114, 242, 144);
    text("\"m\" to return to menu screen", camera.getLookAt()[0]-2.35*width/3,camera.getLookAt()[1]-height/4.5,camera.getLookAt()[2]+height/3);
    
    textAlign(LEFT);
    rotateY(PI/2);
    textSize(20);
    fill(114, 242, 144);
    text("\"m\" to return to menu screen", camera.getLookAt()[0]-2.35*width/3,camera.getLookAt()[1]-height/4.5,camera.getLookAt()[2]+height/3);
    
    textAlign(LEFT);
    rotateY(PI/2);
    textSize(20);
    fill(114, 242, 144);
    text("\"m\" to return to menu screen", camera.getLookAt()[0]-2.35*width/3,camera.getLookAt()[1]-height/4.5,camera.getLookAt()[2]+height/3);
}
