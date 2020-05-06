int[] pointxs = new int[150];
int[] pointys = new int[150];
int[] pointreds = new int[150];
int[] pointgreens = new int[150];
int[] pointblues = new int[150];
float eqlength = 200;
float springconstant = 0.0005;
float g = 10.3;
float ballmass = 1;
float b = 0.005;
float ballx = 600;
float bally = 400;
float ballvelx = 0;
float ballvely = 0;
float ballaccx = 0;
float ballaccy = 0;

void setup() {
  size(1200, 800);
  background(255);
  init();
}

void draw() {
  background(255);
  updateball();
  if (mousePressed) {
    ballx = mouseX;
    bally = mouseY;
    ballvelx = 0;
    ballvely = 0;
    ballaccx = 0;
    ballaccy = 0;
  }
  drawelements();
}

void mouseDragged() {
  ballx = mouseX;
  bally = mouseY;
  ballvelx = 0;
  ballvely = 0;
  ballaccx = 0;
  ballaccy = 0;
}

void init() {
  for (int i = 0; i < 150; i++) {
    float theta = random(2000*PI)/1000;
    pointxs[i] = 600 + floor(random(300, 450)*cos(theta));
    pointys[i] = 300 + floor(random(200, 300)*sin(theta));
    pointreds[i] = floor(random(0, 255));
    pointgreens[i] = floor(random(0, 255));
    pointblues[i] = floor(random(0, 255));
  }
}

void drawelements() {
  for (int i = 0; i < 150; i++) {
    float len = sqrt((pointxs[i] - ballx)*(pointxs[i] - ballx) + (pointys[i] - bally)*(pointys[i] - bally));
    float coloroffset = sqrt(sqrt(len/eqlength));
    stroke(pointreds[i], pointgreens[i], pointblues[i]);
    fill(pointreds[i], pointgreens[i], pointblues[i]);
    ellipse(pointxs[i], pointys[i], 20, 20);
    stroke(coloroffset*pointreds[i], coloroffset*pointgreens[i], coloroffset*pointblues[i]);
    strokeWeight(10);
    line(ballx, bally, pointxs[i], pointys[i]);
  }
  stroke(0, 255, 0);
  fill(255, 0, 255);
  ellipse(ballx, bally, 50, 50);
}

void updateball() {
  float fnetx = 0;
  float fnety = 0;
  for (int i = 0; i < 150; i++) {
    float localfnetx = 0;
    float localfnety = 0;
    float springlength = sqrt((ballx - pointxs[i])*(ballx - pointxs[i]) + (bally - pointys[i])*(bally - pointys[i]));
    float unitx = (pointxs[i] - ballx)/springlength;
    float unity = (pointys[i] - bally)/springlength;
    localfnetx = -springconstant*(eqlength - springlength)*unitx;
    localfnety = -springconstant*(eqlength - springlength)*unity;
    fnetx = fnetx + localfnetx;
    fnety = fnety + localfnety;
  }
  ballaccx = fnetx/ballmass - b*ballvelx;
  ballaccy = fnety/ballmass + g - b*ballvely;
  ballvelx = ballvelx + ballaccx;
  ballvely = ballvely + ballaccy;
  ballx = ballx + ballvelx;
  bally = bally + ballvely;
}