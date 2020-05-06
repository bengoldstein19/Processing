class Cell {

  float x, y;
  float w;

  float state;
  float previous;

  Cell(float x_, float y_, float w_) {
    x = x_;
    y = y_;
    w = w_;
    
    state = floor(random(6))/5;
    previous = state;
  }
  
  void savePrevious() {
    previous = state; 
  }

  void newState(float s) {
    state = s;
  }

  void display() {
    fill(state*255);
    stroke(0);
    rect(x, y, w, w);
  }
}


class GOL {

  int w = 8;
  int columns, rows;

  Cell[][] board;


  GOL() {
    columns = width/w;
    rows = height/w;
    board = new Cell[columns][rows];
    init();
  }

  void init() {
    for (int i = 0; i < columns; i++) {
      for (int j = 0; j < rows; j++) {
        board[i][j] = new Cell(i*w, j*w, w);
      }
    }
  }

  void generate() {
     for ( int i = 0; i < columns;i++) {
      for ( int j = 0; j < rows;j++) {
        board[i][j].savePrevious();
      }
    }
    
    for (int x = 0; x < columns; x++) {
      for (int y = 0; y < rows; y++) {

        int neighbors = 0;
        for (int i = -1; i <= 1; i++) {
          for (int j = -1; j <= 1; j++) {
            neighbors += board[(x+i+columns)%columns][(y+j+rows)%rows].previous;
          }
        }

        neighbors -= board[x][y].previous;

        if      ((board[x][y].state > 0.1) && (neighbors <  2)) {
          if (random(1) > 0.4) {
            board[x][y].newState(board[x][y].state - 0.1);
          }
        }
        else if ((board[x][y].state > 0.1) && (neighbors >  3)) {
          if (random(1) > 0.2) {
            board[x][y].newState(board[x][y].state - 0.1);
          }
        }
        else if (board[x][y].state > 0 && board[x][y].state < 1) {
          board[x][y].newState(board[x][y].state + 0.1);
        }
        else if ((board[x][y].state == 0) && (neighbors == 3)) {
          board[x][y].newState(1);
        }
      }
    }
  }

  void display() {
    for ( int i = 0; i < columns;i++) {
      for ( int j = 0; j < rows;j++) {
        board[i][j].display();
      }
    }
  }
}


boolean spacePressed;
GOL gol;

void setup() {
  size(600, 800);
  frameRate(10);
  gol = new GOL();
  spacePressed = false;
}

void draw() {
  background(255);
  if (!spacePressed) {
    gol.generate();
  }
  gol.display();
}

void keyPressed() {
  if (key == ' ') {
    spacePressed = !spacePressed;
  } else if (key == 'r') {
    gol.init();
  } else if (key == 'd') {
    for (int i = 0; i < gol.columns; i++) {
      for (int j = 0; j < gol.rows; j++) {
        gol.board[i][j].state = 0;
      }
    }
  } else if (key == 'a') {
    for (int i = 0; i < gol.columns; i++) {
      for (int j = 0; j < gol.rows; j++) {
        gol.board[i][j].state = 1;
      }
    }
  }
}

void mousePressed() {
  if (spacePressed) {
    int col = floor(mouseX*gol.columns/width);
    int row = floor(mouseY*gol.rows/height);
    gol.board[col][row].state = ((gol.board[col][row].state*10 + 2) % 11)/10;
  }
}