class KochLine {
  PVector start;
  PVector end;
  KochLine(PVector a, PVector b) {
    start = a.copy();
    end = b.copy();
  }
  
  void display() {
    line(start.x, start.y, end.x, end.y);
  }
}

void generate() {
    ArrayList next = new ArrayList<KochLine>();
    for (KochLine l : lines) {
      PVector perpOffset = new PVector(PVector.sub(l.end, l.start).y, -PVector.sub(l.end, l.start).x);
      perpOffset.normalize().mult(PVector.sub(l.end, l.start).mag()*sqrt(3)/-6);
      PVector futurepoint = PVector.add(PVector.add(l.start, l.end).div(2), perpOffset);
      next.add(new KochLine(l.start, PVector.add(l.end, PVector.mult(l.start, 2)).div(3)));
      next.add(new KochLine(PVector.add(l.end, PVector.mult(l.start, 2)).div(3), futurepoint));
      next.add(new KochLine(futurepoint, PVector.add(l.start, PVector.mult(l.end, 2)).div(3)));
      next.add(new KochLine(PVector.add(l.start, PVector.mult(l.end, 2)).div(3), l.end));
    }
    lines = next;
  }

ArrayList<KochLine> lines;
float zoom;
float xoffset;
float yoffset;

void setup() {
  size(600, 400);
  resetting = false;
  zoom = 0;
  yoffset = 0;
  xoffset = 0;
  lines = new ArrayList<KochLine>();
  float radius = 150;
  PVector point1 = new PVector(width/2, height/2 - radius);
  PVector point2 = new PVector(width/2 - radius*sqrt(3)/2, height/2 + radius/2);
  PVector point3 = new PVector(width/2 + radius*sqrt(3)/2, height/2 + radius/2);
  lines.add(new KochLine(point1, point2));
  lines.add(new KochLine(point2, point3));
  lines.add(new KochLine(point3, point1));
  doStuff();
}

boolean resetting;

void doStuff() {
  background(255);
  pushMatrix();
  translate(width/2,height/2);
  scale(1 + zoom);
  strokeWeight(1/(1 + zoom));
  translate(-width/2 + xoffset,-height/2 + yoffset);
  for(KochLine l : lines) {
    l.display();
  }
  popMatrix();
}

void draw() {
  if (resetting) {
    if (zoom > 0.1) {
      zoom = zoom*2 / 3;
    } else {
      if (abs(xoffset) > 2) {
        xoffset = xoffset*4 / 5;
      }
      if (abs(yoffset) > 2) {
        yoffset = yoffset*4 / 5;
      }
    }
    if (!(zoom > 0.1 || abs(xoffset) > 2 || abs(yoffset) > 2)) {
      zoom = 0;
      xoffset = 0;
      yoffset = 0;
      resetting = false;
    }
    doStuff();
  }
}

void keyPressed() {
  if (key == 'i') {
    zoom = (zoom + 1) * 2 - 1;
  } else if (key =='o') {
    zoom = (zoom + 1)/ 2 - 1;
  } else if (key == 'a') {
    xoffset = xoffset - 10/(zoom + 1);
  } else if (key == 'd') {
    xoffset = xoffset + 10/(zoom + 1);
  } else if (key == 'w') {
    yoffset = yoffset - 10/(zoom + 1);
  } else if (key == 's') {
    yoffset = yoffset + 10/(zoom + 1);
  } else if (key == 'r') {
    resetting = true;
  } else if (key == ' ') {
    generate();
  } else if (key == 'k') {
    resetting = false;
  zoom = 0;
  yoffset = 0;
  xoffset = 0;
  lines = new ArrayList<KochLine>();
  float radius = 150;
  PVector point1 = new PVector(width/2, height/2 - radius);
  PVector point2 = new PVector(width/2 - radius*sqrt(3)/2, height/2 + radius/2);
  PVector point3 = new PVector(width/2 + radius*sqrt(3)/2, height/2 + radius/2);
  lines.add(new KochLine(point1, point2));
  lines.add(new KochLine(point2, point3));
  lines.add(new KochLine(point3, point1));
  }
  doStuff();
}