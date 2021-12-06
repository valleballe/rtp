import processing.video.*;

boolean start = true;

Capture video;
PImage prev;
PImage canvas;
PImage[] savedImgs;
PImage[] masks;
color[] colors;

float threshold = 10;

float motionX = 0;
float motionY = 0;

float lerpX = 0;
float lerpY = 0;

int count = 0;

void setup() {
  size(640, 480);
  String[] cameras = Capture.list();
  video = new Capture(this, cameras[1]);
  video.start();
  
  colors = new color[8];
  colors[0] = color(1,0,0,255);
  colors[1] = color(104,128,202,255);
  colors[2] = color(134, 52,139,255);
  colors[3] = color(244,141,110,255);
  colors[4] = color( 37, 17, 80,255);
  colors[5] = color( 30, 56, 57,255);
  colors[6] = color( 69,139,137,255);
  
  
  savedImgs = new PImage[0];
  masks = new PImage[0];
  
  prev = createImage(640, 480, RGB);
  canvas = createImage(width, height, RGB);
  
}


void mousePressed() {
  if (start){
    prev.copy(video, 0, 0, video.width, video.height, 0, 0, prev.width, prev.height);
    prev.updatePixels();
    start = false;
  }
  else{
    PImage saved = createImage(640, 480, RGB);
    saved.copy(canvas, 0, 0, canvas.width, canvas.height, 0, 0, prev.width, prev.height);
    saved.updatePixels();
    savedImgs = (PImage[]) append(savedImgs, saved);
    
    PImage mask = saved;
    if (masks.length > 0){
      println("asd");
      mask = invertColor(saved, masks.length);
      mask = maskBlack(mask);
      masks = (PImage[]) append(masks, mask);
    }
    else {
      println("dsa");
      masks = (PImage[]) append(masks, mask);
      masks[0] = maskBlack(masks[0]);
      masks[0] = invertColor(masks[0], 0);
      
      savedImgs[0].mask(masks[0]);  
      savedImgs[0] = changeColor(savedImgs[0], 0);
    }
    //image(masks[masks.length-1],0,0);
    
    println("saved img");
  }
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
 
  video.loadPixels();
  prev.loadPixels();

  threshold = map(mouseX, 0, width, 0, 100);
  //threshold = 50;

  canvas.loadPixels();
  //begin loop for every image
  background(151,217,230,255);
  getPixelDist(video);
  canvas.updatePixels();
  canvas.mask(canvas);

  
  for (int i = 0; i < savedImgs.length; i++){
    
    if (i != 0){
      masks[i] = maskColor(masks[i]);
      savedImgs[i].mask(masks[i]);
      PImage img = changeColor(savedImgs[i], i);
      image(img, 0,0);
    }
    
    
    //image(masks[i],0,0);
    
    
    
    image(canvas, 0,0);
    image(masks[0], 0,0);
  }
  
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

void getPixelDist(PImage img){
  // Begin loop to walk through every pixel
  for (int x = 0; x < img.width; x++ ) {
    for (int y = 0; y < img.height; y++ ) {
      int loc = x + y * img.width;
      // What is current color
      color currentColor = img.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      color prevColor = prev.pixels[loc];
      float r2 = red(prevColor);
      float g2 = green(prevColor);
      float b2 = blue(prevColor);

      float d = distSq(r1, g1, b1, r2, g2, b2); 

      if (d > threshold*threshold) {
        canvas.pixels[loc] = colors[savedImgs.length%colors.length];//color(151,217,230,255);
      } else {
        canvas.pixels[loc] = color(0,0,0,255);
      }
    }
  }
}

PImage changeColor(PImage img, int col_n){
  img.loadPixels();
  // Begin loop to walk through every pixel
  for (int x = 0; x < img.width; x++ ) {
    for (int y = 0; y < img.height; y++ ) {
      int loc = x + y * img.width;
      // What is current color
      color currentColor = img.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      
      color newColor = colors[col_n%colors.length];
      float r2 = red(newColor);
      float g2 = green(newColor);
      float b2 = blue(newColor);
      
      if (img.pixels[loc] == color(255,255,255)){
        img.pixels[loc] = color(r2,g2,b2,255);//;
      }
      
    }
  }
  img.updatePixels();
  return img;
}

PImage invertColor(PImage img, int n){
  img.loadPixels();
  // Begin loop to walk through every pixel
  for (int x = 0; x < img.width; x++ ) {
    for (int y = 0; y < img.height; y++ ) {
      int loc = x + y * img.width;
      
      // only invert first mask
      if (masks.length < 1 ||n==0){
        color currentColor = img.pixels[loc];
        float r = red(currentColor);
        float g = green(currentColor);
        float b = blue(currentColor);
        img.pixels[loc] = color(255-r, 255-g,255-b);
      }
    }
  }
  img.updatePixels();
  return img;
}

PImage maskColor(PImage img){
  img.loadPixels();
  // Begin loop to walk through every pixel
  for (int x = 0; x < img.width; x++ ) {
    for (int y = 0; y < img.height; y++ ) {
      int loc = x + y * img.width;
      
      if (red(img.pixels[loc]) != 0){
        img.pixels[loc] = color(255,255,255);
      }
    }
  }
  img.updatePixels();
  return img;
}

PImage maskBlack(PImage img){
  img.loadPixels();
  // Begin loop to walk through every pixel
  for (int x = 0; x < img.width; x++ ) {
    for (int y = 0; y < img.height; y++ ) {
      int loc = x + y * img.width;
      
      if (red(img.pixels[loc]) != 0){
        img.pixels[loc] = color(255,255,255);
      }
    }
  }
  img.updatePixels();
  return img;
}