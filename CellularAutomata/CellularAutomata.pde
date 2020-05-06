class CA {
  int[][] cells;
  int[] ruleset;
  int sideLength;
  int generation;
  CA() {
    sideLength = 10;
    cells = new int[height/sideLength][width/sideLength];
    ruleset = new int[8];
    for (int i = 0; i < 8; i++) {
      ruleset[i] = round(random(1));
    }
    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells[0].length; j++) {
        cells[i][j] = int(random(2));
      }
    }
  }
  
  void generate() {
    int[] nextgen = new int[cells[0].length];
    for (int i = 0; i < cells[0].length; i++) {
      int left = cells[cells.length - 1][(i - 1 + cells[0].length) % cells[0].length];
      int me = cells[cells.length - 1][i];
      int right = cells[cells.length - 1][(i + 1) % cells[0].length];
      nextgen[i] = rules(left, me, right);
    }
    for (int i = 0; i < cells.length - 1; i++) {
      cells[i] = cells[i + 1];
    }
    cells[cells.length - 1] = nextgen;
  }
  
  int rules(int left, int me, int right) {
    String string = "" + left + me + right;
    int ruleindex = Integer.parseInt(string, 2);
    return ruleset[ruleindex];
  }
  
  void drawGen() {
    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells[0].length; j++) {
        if (cells[i][j] == 1) {
          fill(0, 255, 0);
        } else {
          fill(255, 0, 0);
        }
        float outterradius = (cells.length - i - 1)*(sqrt(height*height + width*width)/2)/cells.length;
        float innerradius = (cells.length - i)*(sqrt(height*height + width*width)/2)/cells.length;
        float innertheta = (cells[0].length - j)*TAU/cells[0].length;
        float outtertheta = (cells[0].length - j - 
        1)*TAU/cells[0].length;
        pushMatrix();
        translate(width/2, height/2);
        quad(innerradius*cos(innertheta), innerradius*sin(innertheta), innerradius*cos(outtertheta), innerradius*sin(outtertheta), outterradius*cos(outtertheta), outterradius*sin(outtertheta), outterradius*cos(innertheta), outterradius*sin(innertheta));
        popMatrix();  
    }
    }
  }
  
}
CA ca;

void setup() {
  noStroke();
  size(800, 600);
  ca = new CA();
  frameRate(20);
}

void draw() {
  ca.drawGen();
  ca.generate();
}

void keyPressed() {
  if(key == ' ') {
    for (int i = 0; i < ca.cells.length; i++) {
      for (int j = 0; j < ca.cells[0].length; j++) {
        ca.cells[i][j] = int(random(2));
      }
    }
    for (int i = 0; i < 8; i++) {
      ca.ruleset[i] = round(random(1));
    }
  }
}