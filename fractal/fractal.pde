void setup() {
  size(600, 600);
  background(255);
  PVector point1 = new PVector(width/2, height/2);
  frac(point1, 100, 7);
}

void frac(PVector point, float radius, int numSides) {
  if (radius > 20) {
    PShape s = createShape();
    s.beginShape();
    for (int i = 0; i < numSides + 1; i++) {
      s.vertex(point.x + radius*cos(i*TAU/numSides), point.y + radius*sin(i*TAU/numSides));
    }
    s.endShape();
    shape(s, 0, 0);
    radius *= 0.5;
    for (int i = 0; i < numSides + 1; i++) {
      PVector futurepoint = new PVector(point.x + radius*1.5*cos((i + 1/2)*TAU/numSides), point.y + radius*1.5*sin((i + 1/2)*TAU/numSides));
      frac(futurepoint, radius, numSides);
    }
  }
}