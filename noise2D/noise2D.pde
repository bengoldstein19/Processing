float incrementx = 0.01;
float incrementy = 0.01;
int xrand = int(random(10000));
int yrand = int(random(10000));

void setup() {
  size(640,360);
  background(255);
}

void draw() {
  float[] color1 = {255,128,0};
  float[] color2 = {51,255,255};
  float noisenum = 0.0;
  background(0);
  
  loadPixels();
  float xoff = 0.0;
  for (int x = 0; x < width; x++) {
    xoff += incrementx;
    float yoff = 0.0;
    for (int y = 0; y < height; y++) {
      yoff += incrementy;
      
      float bright = noise(xoff + xrand,yoff + yrand, noisenum);
      
      pixels[x+y*width] = color(bright*color1[0]+(1-bright)*color2[0],bright*color1[1]+(1-bright)*color2[1],bright*color1[2]+(1-bright)*color2[2]);
    }
  }
  updatePixels();
  noisenum += 10;
}