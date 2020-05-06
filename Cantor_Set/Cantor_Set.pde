ArrayList<CantorLine> lines;

void setup() {
  size(600, 800);
  background(255);
  lines = new ArrayList<CantorLine>();
  lines.add(new CantorLine(0, 0, width, height));
  for (CantorLine l : lines) {
    l.display();
  }
}

void draw() {
}

void generate() {
  background(255);
  ArrayList<CantorLine> next = new ArrayList<CantorLine>();
  for (CantorLine l: lines) {
    next.add(new CantorLine(l.startx, l.starty, (l.endx  + 2*l.startx)/3, (l.endy  + 2*l.starty)/3));
    next.add(new CantorLine((l.startx + l.endx*2)/3, (l.starty + l.endy*2)/3, l.endx, l.endy));
  }
  lines = next;
  for (CantorLine l : next) {
    l.display();
  }
}

class CantorLine {
  float startx, starty, endx, endy;
  CantorLine(float startx_, float starty_, float endx_, float endy_) {
    startx = startx_;
    starty = starty_;
    endx = endx_;
    endy = endy_;
  }
  void display() {
    line(startx, starty, endx, endy);
  }
}

void keyPressed() {
  generate();
}