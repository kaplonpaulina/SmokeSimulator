
import peasy.*;
import ddf.minim.*;

//menu
int button2D_x, button2D_y;      
int button3D_x, button3D_y;     
int buttonSize = 120;

int buttonDiffPlus_y;      
int buttonDiffMinus_y;

int buttonVisPlus_y;      
int buttonViscMinus_y;   

int buttonTimePlus_y;      
int buttonTimeMinus_y;   

int addingButton_x;
int addingButtonSizeX = 60;
int addingButtonSizeY = 28;


color rectColor, baseColor;
color rectHighlight;

boolean over2D = false;
boolean over3D = false;

boolean overDiffPlus = false;
boolean overDiffMinus = false;
float diffusion = 20;

boolean overVisPlus = false;
boolean overViscMinus = false;
float viscosity = 10.00000021;

boolean overTimePlus = false;
boolean overTimeMinus = false;
float dtime = 0.2;

//1-menu, 2-2D, 3-3D
int screenType = 1;
boolean goToMenu = false;


//smoke

int N ;

int iter ;
int SCALE ;
float t ;

int timer;

PeasyCam camera;

Smoke2D smoke2D;
Smoke3D smoke3D;

PImage hazardSign2D;
PImage hazardBg2D;

PImage hazardSign3D;
PImage hazardBg3D;

PImage smokeBg;

AudioPlayer siren;
Minim minim;



void setup() {
  size(700, 700, P3D);
  
  rectColor = color(0);
  rectHighlight = color(51);
  baseColor = color(102);
  
  button2D_x = int(width/2.5)-buttonSize;
  button2D_y = int(2.4*height/3)-buttonSize/2;
  
  button3D_x = int(width/2.3)+buttonSize;
  button3D_y = int(2.4*height/3)-buttonSize/2;
  
  
  addingButton_x = 470;
  
  buttonDiffPlus_y = 225;        
  buttonDiffMinus_y = 257;

  buttonVisPlus_y = 295;      
  buttonViscMinus_y = 327;   

  buttonTimePlus_y = 365;      
  buttonTimeMinus_y = 397;   
  
  
  hazardSign2D = loadImage("hazard.png");
  hazardBg2D = loadImage("bg1.png");
  
  hazardSign3D = loadImage("bg5.png");
  hazardBg3D = loadImage("bg2.png");
  
  camera = new PeasyCam(this, width / 2, height / 2, 0, (height / 2) / tan(PI / 6));
  camera.setActive(false);
  
  minim = new Minim(this);
  siren = minim.loadFile("SmokeAlarm.mp3");
  
  smokeBg = loadImage("smoke.jpg");
 
}

void draw() {
  
  switch(screenType){
  
    case 1:
      siren.pause();
      drawMenu(); 
      break;
      
    case 2:
      draw2D();
    
     if(goToMenu){
        screenType = 1;
      }
    
    break;
    
    case 3:

      draw3D();
      
      if(goToMenu){
        screenType = 1;
      }
      
      break;
      
  }
  
}

void mousePressed() {
  if (screenType==1 && over2D) {
    println("sim 2d");
    
    goToMenu = false;
    
    N = 175;

    iter = 16;
    SCALE = 4;
    t = 0;
    
    
    smoke2D = new Smoke2D(0.2, 0, 0.00000021);
    camera.setActive(false);
    screenType = 2;
    
    
  }
  else if(screenType==1 && over3D){
    println("sim 3d");
    
    goToMenu = false;
    
    N = 50;
    iter = 16;
    SCALE = 7;
    t = 0;
    
    
    smoke3D = new Smoke3D(0.2, 0, 0.0000001);
      camera.setActive(true);

    camera.setSuppressRollRotationMode();
    camera.setYawRotationMode(); 
    screenType = 3;
    
  }
  else if(screenType==1 && overDiffPlus){
    diffusion = constrain(diffusion+0.001,0,1);
  }
  else if(screenType==1 && overDiffMinus){
    diffusion = constrain(diffusion-0.001,0,1);
  }
  else if(screenType==1 && overVisPlus){
    viscosity = constrain(viscosity+0.001,0,1);
  }
  else if(screenType==1 && overViscMinus){
    viscosity = constrain(viscosity-0.001,0,1);
  }
  else if(screenType==1 && overTimePlus){
    dtime = constrain(dtime+0.100,0,1);
  }
  else if(screenType==1 && overTimeMinus){
    dtime = constrain(dtime-0.100,0,1);
  }

}

void mouseDragged() {
  
  if(screenType == 2){
    smoke2D.addDensity2D(mouseX / SCALE, mouseY / SCALE, 500);
    float amtX = mouseX - pmouseX;
    float amtY = mouseY - pmouseY;
    smoke2D.addVelocity2D(mouseX / SCALE, mouseY / SCALE, amtX, amtY); 
    
  }

}

void keyPressed() {
  
  if (key == 'm' ) {
    
    siren.pause();
    goToMenu = true;
        camera.reset();

    camera.setActive(false);
    //camera.reset();
  } 
}
