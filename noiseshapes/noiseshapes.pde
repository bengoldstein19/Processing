void setup() {
  size(1200, 800);
  background(255);
  fill(0);
  stroke(0,0,255);
  background(255);
  rectangle(200, 200, 500, 500, 0.05, 0.01);
  //circle(600,400,200,150,0.3,2.0);
}

void draw() {
    stroke(0,0,255);
    //circle(600,400,200,150,0.3,2.0); good values
}

void rectangle(int topleftx, int toplefty, int sqwidth, int sqheight, float noiseamp, float noisiness) {
  int maxxnoise = ceil(noiseamp*sqwidth);
  int maxynoise = ceil(noiseamp*sqheight);
  int[] topedgeys = new int[sqwidth + 2*maxxnoise];
  int[] bottomedgeys = new int[sqwidth + 2*maxxnoise];
  int[] leftedgexs = new int[sqheight + 2*maxynoise];
  int[] rightedgexs = new int[sqheight + 2*maxynoise];
  int topnoiseoffset = floor(random(10000));
  int bottomnoiseoffset = floor(random(10000));
  for (int i = 0; i < sqwidth + 2*maxxnoise; i++) {
    topedgeys[i] = floor(float(toplefty) - noiseamp*sqheight*noise(noisiness*i + topnoiseoffset));
    bottomedgeys[i] = ceil(float(toplefty + sqheight) + noiseamp*sqheight*noise(noisiness*i + bottomnoiseoffset));
  }
  int leftnoiseoffset = floor(random(10000));
  int rightnoiseoffset = floor(random(10000));
  for (int i = 0; i < sqheight + 2*maxynoise; i++) {
    leftedgexs[i] = floor(float(topleftx) - noiseamp*sqwidth*noise(noisiness*i + leftnoiseoffset));
    rightedgexs[i] = ceil(float(topleftx + sqwidth) + noiseamp*sqwidth*noise(noisiness*i + rightnoiseoffset));
    print(rightedgexs[i]);
    print("////");
}
  for (int i = topleftx - maxxnoise; i < topleftx + sqwidth + maxxnoise; i++) {
    print(topleftx - maxxnoise);
    print(topleftx + sqwidth + maxxnoise);
    int xindex = i + maxxnoise - topleftx;
    for (int j = toplefty - maxynoise; j < toplefty + sqheight + maxynoise; j++) {
      int yindex = i + maxynoise - toplefty;
      if (((i < rightedgexs[yindex]) && (i > leftedgexs[yindex])) && ((j > topedgeys[xindex]) && (j < bottomedgeys[xindex]))) {
        point(i,j);
      }
    }
  }
}

void circle(int centerx, int centery, int outerrad, int innerrad, float noiseamp, float noisiness) {
  if (noiseamp > 1) {
    print("noiseamp > 1");
    return;
  }
  if (outerrad < innerrad) {
    print("outerrad < innerrad");
    return;
  }
  boolean solid = false;
  if (innerrad == 0) {
    solid = true;
  }
  float noiseinneroffset = random(10000);
  float noiseouteroffset = random(10000);
  int thickness = outerrad - innerrad;
  float maxnoise = noiseamp*thickness;
  for (int i = centerx - outerrad - ceil(maxnoise); i < centerx + outerrad + maxnoise; i++) {
    for (int j = centery - outerrad - ceil(maxnoise); j < centery + outerrad + maxnoise; j++) {
      float x = i - centerx;
      float y = j - centery;
      float theta;
      if (x == 0) {
        theta = 0;
      } else {
        theta = atan(y/x);
        if (x < 0) {
          theta = theta + PI;
        }
        if (theta < 0) {
          theta = theta + 2*PI;
        }
      }
      float squared = x*x + y*y;
      int innerradmin = floor((innerrad - maxnoise*noise(-noisiness*abs(PI-theta) + noiseinneroffset))*(innerrad - maxnoise*noise(-noisiness*abs(PI-theta) + noiseinneroffset)));
      if (solid) {
        innerradmin = 0;
      }
      int outerradmax = floor((outerrad + maxnoise*noise(-noisiness*abs(PI-theta) + noiseouteroffset))*(outerrad + maxnoise*noise(-noisiness*abs(PI-theta) + noiseouteroffset)));
      if ((squared >= innerradmin) && (squared < outerradmax)) {
        point(i,j);
      }
    }
  }
}