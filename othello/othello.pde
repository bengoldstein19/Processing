Board board;
Player player1;
Player player2;

void setup() {
  size(600, 600);
  background(255);
  board = new Board(8);
  player1 = new Player(1, true);
  player2 = new Player(2, false);
  board.render();
}

void draw() {
  if (!board.game_done) {
    board.render();
    player1.display_mouse();
    player2.display_mouse();
  }
}

class Player {
  int id;
  boolean my_turn;
  
  Player(int id_, boolean my_turn_) {
    id = id_;
    my_turn = my_turn_;
  }
  
  void display_mouse() {
    if (my_turn) {
      int box_i = mouseY * board.size / height;
      int box_j = mouseX * board.size / width;
      if (board.board_array[box_i][box_j] == 0) {
        if (id == 1) {
          fill(255, 0, 0);
        } else {
          fill(0, 255, 0);
        }
        ellipse(width * (2 * box_j + 1) / (2 * board.size), height * (2 * box_i + 1) / (2 * board.size), width / board.size, height / board.size);
      }   
    }
  }
  
  void attempt_move() {
    if (my_turn) {
      int box_i = mouseY * board.size / height;
      int box_j = mouseX * board.size / width;
      if (board.is_valid(box_i, box_j, id)) {
        print("VALID MOVE");
        board.update(box_i, box_j, id);
      }
    }
  }
}

class Board {
  int num_moves;
  int board_array[][];
  int size;
  boolean game_done;
  
  Board(int size_) {
    size = size_;
    game_done = false;
    num_moves = 0;
    board_array = new int[size][size];
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        board_array[i][j] = 0;
      }
    }
  }
  
  boolean valid_moves_remain(int id) {
    if (num_moves < 4) {
      return true;
    }
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (this.is_valid(i, j, id)) {
          return true;
        }
      }
    }
    return false;
  }
  
  void update(int index_i, int index_j, int id) {
    board_array[index_i][index_j] = id;
    if (index_i != size - 1) {
      if (board_array[index_i + 1][index_j] == id % 2 + 1) {
        for(int i = 2; index_i + i < size; i++) {
          if (board_array[index_i + i][index_j] == id) {
            for(int j = 1; j < i; j++) {
              board_array[index_i + j][index_j] = id;
            }
            break;
          }
        }
      }
      if (index_j != 0) {
        if (board_array[index_i + 1][index_j - 1] == id % 2 + 1) {
          for(int i = 2; index_i + i < size && index_j - i >= 0; i++) {
            if (board_array[index_i + i][index_j - i] == id) {
              for(int j = 1; j < i; j++) {
                board_array[index_i + j][index_j - j] = id;
              }
              break;
            }
          }
        }
      }
      if (index_j != size - 1) {
        if (board_array[index_i + 1][index_j + 1] == id % 2 + 1) {
          for(int i = 2; index_i + i < size && index_j + i < size; i++) {
            if (board_array[index_i + i][index_j + i] == id) {
              for(int j = 1; j < i; j++) {
                board_array[index_i + j][index_j + j] = id;
              }
              break;
            }
          }
        }
      }
    }
    if (index_i != 0) {
      if (board_array[index_i - 1][index_j] == id % 2 + 1) {
        for(int i = 2; index_i - i >= 0; i++) {
          if (board_array[index_i - i][index_j] == id) {
            for(int j = 1; j < i; j++) {
              board_array[index_i - j][index_j] = id;
            }
            break;
          }
        }
      }
      if (index_j != 0) {
        if (board_array[index_i - 1][index_j - 1] == id % 2 + 1) {
          for(int i = 2; index_i - i >= 0 && index_j - i >= 0; i++) {
            if (board_array[index_i - i][index_j - i] == id) {
              for(int j = 1; j < i; j++) {
                board_array[index_i - j][index_j- j] = id;
              }
              break;
            }
          }
        }
      }
      if (index_j != size - 1) {
        if (board_array[index_i - 1][index_j + 1] == id % 2 + 1) {
          for(int i = 2; index_i - i >= 0 && index_j + i < size; i++) {
            if (board_array[index_i - i][index_j + i] == id) {
              for(int j = 1; j < i; j++) {
                board_array[index_i - j][index_j + j] = id;
              }
              break;
            }
          }
        }
      }
    }
    if (index_j != size - 1) {
       if (board_array[index_i][index_j + 1] == id % 2 + 1) {
         for(int i = 2; index_j + i < size; i++) {
           if (board_array[index_i][index_j + i] == id) {
             for(int j = 1; j < i; j++) {
               board_array[index_i][index_j + j] = id;
             }
             break;
           }
         }
       }
    }
    if (index_j != 0) {
       if (board_array[index_i][index_j - 1] == id % 2 + 1) {
         for(int i = 2; index_j - i >= 0; i++) {
           if (board_array[index_i][index_j - i] == id) {
             for(int j = 1; j < i; j++) {
               board_array[index_i][index_j - j] = id;
             }
             break;
           }
         }
       }
    }
    num_moves++;
    if (id == 1) {
      if (this.valid_moves_remain(2)) {
        player1.my_turn = false;
        player2.my_turn = true;
      } else if (!this.valid_moves_remain(2)) {
         game_done = true;
      }
    } else {
      if (this.valid_moves_remain(1)) {
        player1.my_turn = true;
        player2.my_turn = false;
      } else if (!valid_moves_remain(2)) {
         game_done = true;
      }
    }
    if (game_done) {
      int num_green = 0;
      int num_red = 0;
      for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
          if (board_array[i][j] == 1) {
            num_red++;
          } else if (board.board_array[i][j] == 2) {
            num_green++;
          }
        }
      }
      textSize(32);
      fill(255);
      textAlign(CENTER);
      if (num_red > num_green) {
        background(255, 0, 0);
        text("RED WINS", width/2, height/2);
      } else if (num_green > num_red) {
        background(0, 255, 0);
        text("GREEN WINS", width/2, height/2);
      } else {
        background(0, 0, 255);
        text("IT'S A TIE", width/2, height/2);
      }
    }
  }
  
  boolean is_valid(int index_i, int index_j, int id) {
    if (board_array[index_i][index_j] != 0) {
      return false;
    }
    if (num_moves < 4) {
      return ((index_i == 3 || index_i == 4) && (index_j == 3 || index_j == 4));
    }
    if (index_i != size - 1) {
      if (board_array[index_i + 1][index_j] == id % 2 + 1) {
        for(int i = 2; index_i + i < size; i++) {
          if (board_array[index_i + i][index_j] == id) {
            return true;
          }
        }
      }
      if (index_j != 0) {
        if (board_array[index_i + 1][index_j - 1] == id % 2 + 1) {
          for(int i = 2; index_i + i < size && index_j - i >= 0; i++) {
            if (board_array[index_i + i][index_j - i] == id) {
              return true;
            }
          }
        }
      }
      if (index_j != size - 1) {
        if (board_array[index_i + 1][index_j + 1] == id % 2 + 1) {
          for(int i = 2; index_i + i < size && index_j + i < size; i++) {
            if (board_array[index_i + i][index_j + i] == id) {
              return true;
            }
          }
        }
      }
    }
    if (index_i != 0) {
      if (board_array[index_i - 1][index_j] == id % 2 + 1) {
        for(int i = 2; index_i - i >= 0; i++) {
          if (board_array[index_i - i][index_j] == id) {
            return true;
          }
        }
      }
      if (index_j != 0) {
        if (board_array[index_i - 1][index_j - 1] == id % 2 + 1) {
          for(int i = 2; index_i - i >= 0 && index_j - i >= 0; i++) {
            if (board_array[index_i - i][index_j - i] == id) {
              return true;
            }
          }
        }
      }
      if (index_j != size - 1) {
        if (board_array[index_i - 1][index_j + 1] == id % 2 + 1) {
          for(int i = 2; index_i - i >= 0 && index_j + i < size; i++) {
            if (board_array[index_i - i][index_j + i] == id) {
              return true;
            }
          }
        }
      }
    }
    if (index_j != size - 1) {
       if (board_array[index_i][index_j + 1] == id % 2 + 1) {
         for(int i = 2; index_j + i < size; i++) {
           if (board_array[index_i][index_j + i] == id) {
             return true;
           }
         }
       }
    }
    if (index_j != 0) {
       if (board_array[index_i][index_j - 1] == id % 2 + 1) {
         for(int i = 2; index_j - i >= 0; i++) {
           if (board_array[index_i][index_j - i] == id) {
             return true;
           }
         }
       }
    }
    return false;
  }
  
  void render() {
    background(255);
    for (int i = 0; i < size + 1; i++) {
      stroke(0);
      line(i*width / size, 0, i * width / size, height);
      line(0, i* height / size, width, i * height / size);
    }
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (board_array[i][j] == 1) {
          noStroke();
          fill(255, 0, 0);
          ellipse(width * (2 * j + 1) / (2 * size), height * (2 * i + 1) / (2 * size), width / size, height / size);
        }
        else if (board_array[i][j] == 2) {
          noStroke();
          fill(0, 255, 0);
          ellipse(width * (2 * j + 1) / (2 * size), height * (2 * i + 1) / (2 * size), width / size, height / size);
        }
      }
    }
  }
}

void mousePressed() {
  int box_i = mouseY * board.size / height;
  int box_j = mouseX * board.size / width;
  if (board.board_array[box_i][box_j] == 0) {
    player1.attempt_move();
    player2.attempt_move();
  }
}