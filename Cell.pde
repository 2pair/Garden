// class for cells to draw to screen

class Cell {
  int hLocation;           // horizontal location of cell
  int vLocation;           // vertical location of cell
  Contents contents;       // what the cell contains
  //variables for color
  float strokeH;
  float strokeS;
  float strokeB;
  float fillH;
  float fillS;
  float fillB;
  
  Cell (int h, int v, Contents c) {
    hLocation = h;
    vLocation = v;
    contents = c;
    
    update();
  }
  
  void setContents(Contents c) {
    contents = c;
    update();
  }
  
  // method to update cell contents
  void update() {
    if (contents == Contents.GRASS) {
      strokeH = 0.3;
      strokeS = 1.0;
      strokeB = 0.4;
      
      fillH = 0.35;
      fillS = 0.7;
      fillB = 0.5;
    }
    else if (contents == Contents.DIRT) {
      strokeH = 0.1;
      strokeS = .4;
      strokeB = 0.4;
      
      fillH = 0.08;
      fillS = 0.5;
      fillB = 0.6;
    }
    else if (contents == Contents.FLOWER) {
      int seed = (int)random(4);
      
      switch(seed) {
        case 0:
          strokeH = 0.02;
          fillH = 0.02;
          break;
        case 1:
          strokeH = 0.15;
          fillH = 0.15;
          break;
        case 2:
          strokeH = 0.7;
          fillH = 0.7;
          break;
        case 3:
          strokeH = 0.88;
          fillH = 0.88;
          break;
      }
      
      strokeS = .9;
      strokeB = 0.85;
      
      fillS = 0.7;
      fillB = 0.9;
    }
    else if (contents == Contents.WILTED) {
      strokeH = 0.15;
      strokeS = 0.1;
      strokeB = 0.35;
      
      fillH = 0.15;
      fillS = 0.1;
      fillB = 0.4;
    }
  }
  
  // method to draw the cell to the screen
  void display() {
    colorMode(HSB,1);
    stroke(strokeH, strokeS,strokeB);
    fill(fillH,fillS,fillB);
    rect(hLocation*cellSize,vLocation*cellSize,cellSize,cellSize);
  }
  
}