class Landscape {

  int scl;
  int w, h;
  int rows, cols;
  float zoff = 0.0;
  float[][] z;

  Landscape(int scl_, int w_, int h_) {
    scl = scl_;
    w = w_;
    h = h_;
    cols = w/scl;
    rows = h/scl;
    z = new float[cols][rows];
  }


  void calculate() {
    float xoff = 0;
    for (int i = 0; i < cols; i++) { 
      float yoff = 0;
      for (int j = 0; j < rows; j++) {
        z[i][j] = map(noise(xoff, yoff,zoff), 0, 1, -120, 120);
        yoff += 0.1;
      }
      xoff += 0.1;
    }
    zoff+=0.01;
  }

  void render() {
    for (int x = 0; x < z.length-1; x++) {
      beginShape(QUAD_STRIP);
      for (int y = 0; y < z[x].length; y++) {
        stroke(0);
        float currentElevation = z[x][y];
        float currentShade = map(currentElevation, -120, 120, 0, 255);
        fill(currentShade*(x + 100)/175 + 50*noise(coloroffset), currentShade*(y + 100)/175 + 50*noise(coloroffset + 100000), currentShade/175 + 50*noise(coloroffset + 1000));
        float xCoordinate = x*scl-w/2;
        float yCoordinate = y*scl-h/2;
        vertex(xCoordinate, yCoordinate, z[x][y]);
        vertex(xCoordinate + scl, yCoordinate, z[x+1][y]);
      }
      endShape();
    }
  }
}

Landscape land;    
float theta = 0.0;
float coloroffset = 0.0;

void setup() {

  size(800,800,P3D);
  land = new Landscape(5,800,800);
}

void draw() {

  background(255);
  translate(width/2,height/2+20,-160);
  rotateX(PI/3);
  rotateZ(theta);
  land.calculate();
  land.render();
  
  coloroffset += 0.1;
  theta += 0.0025;
}