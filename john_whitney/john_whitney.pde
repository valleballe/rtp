float t;

void setup(){
  size(1200, 800);
  background(10);
  frameRate(16);
}

void draw(){
  background(8,26,37,10);
  
  

  strokeWeight(5);
  translate(width/2, height/2);
  
  int max = 31;
  
  for (int i=0; i < max*4; i+=4) {
    stroke(220, 112, 135, 80);
    line(x3(t+i), y3(t+i), x4(t+i), y4(t+i));
    
    stroke(255, 255, 234, 150);
    line(x1(t+i), y1(t+i), x2(t+i), y2(t+i));
  }
  t+= 5;
  
}

float x1(float t) {
  return sin(t/40)*100 * sin(t/80);// * sin(t/99); 
}

float y1(float t) {
  return cos(t/40)*100 ; 
}

float x2(float t) {
  return sin(t/40)*250 + sin(t/30)*50; 
}

float y2(float t) {
  return cos(t/42)*250 + cos(t/30)*50; 
}


float x3(float t) {
  return sin(t/20)*-100 * sin(t/10);// * sin(t/99); 
}

float y3(float t) {
  return cos(t/20)*-100 ; 
}

float x4(float t) {
  return sin(t/35)*250 + sin(t/19)*50; 
}

float y4(float t) {
  return cos(t/52)*250 + cos(t/19)*50; 
}