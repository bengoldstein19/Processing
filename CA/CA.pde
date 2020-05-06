class CA {
  int[] cells;
  int[] ruleset;
  int sideLength;
  int generation;
  CA() {
    sideLength = 10;
    cells = new int[width/sideLength];
    ruleset = new int[8];
    for (int i = 0; i < 8; i++) {
      ruleset[i] = round(random(1));
    }
  }
  
  void generate() {
    int[] nextgen = new int[cells.length];
    for (int i = 1; i < cells.length; i++) {
      int left = cells[i - 1];
      int me = cells[i];
      int right = cells[i + 1];
      nextgen[i] = rules(left, me, right);
    }
    cells = nextgen;
    generation++;
  }
  
  int rules(int left, int me, int right) {
    String string = "" + left + me + right;
    int ruleindex = Integer.parseInt(string, 2);
    return ruleset[ruleindex];
  }
  
  void drawGens() {
    for (int i = 0; i < cells.length; i++) {
      if (cells[i] == 1) {
        fill(0);
      } else {
        fill(255);
      }
      rect(i*sideLength, generation*sideLength, sideLength, sideLength);
    }
  }
  
}
CA ca;

void setup() {
  
}

void draw() {
  
}