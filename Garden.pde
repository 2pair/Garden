

final int hCells = 50;                    // number of horizontal cells in the field
final int vCells = 30;                    // number of vertical cells in the field
final int maxCellSize = 30;                // the largest size a cell can be
int cellSize;                              // the actual size of the cell, calculated in settings

final int screenWidth = 1680;              // monitor height
final int screenHeight = 1050;             // monitor width
final int screenWaste = 75;                // number of pixels of menu bars we need to avoid

int generation = 0;                        // starting generation
final int grassGens = 7;                   // generations where grass grows
final int flowerGens = 13;                 // generations where flowers grow
final int wiltedGens = 20;                 // generations where flowers will wilt
final float initialGrassGrowth = 0.03;     // percent of terrain seeded with grass
final float randomGrassGrowth = 0.0005;    // chance for random dirt to turn to new grass during grass generations
final float grassRateModifier = 0.9;       // percent of time grass will grow with all neighbors grassy
final float baselineFlowerRate = 0.02;     // chance that flowers will randomly spring from grass. controls inial growth
final float flowerRateModifier = 0.2;      // percent of time flower will grow with all neighbors flowery or grassy
final float wiltRate = 0.002;              // chance that flowers will randomly wilt


Cell[][] cells;

// variables for the last generations of each stage
final int lastGrassGen = grassGens;
final int lastFlowerGen = grassGens+flowerGens;
final int lastWiltedGen = grassGens+flowerGens+wiltedGens;

void settings() {
  // logic to determine the size of our cells so we fit on screen
  cellSize = maxCellSize;
  if ((hCells*cellSize) > screenWidth) {
    cellSize = floor(screenWidth/hCells);
  } 
  if ((vCells*cellSize) > (screenHeight-screenWaste)) {
    cellSize = floor((screenHeight-screenWaste)/vCells);
  }  
  final int hSize = hCells*cellSize;
  final int vSize = vCells*cellSize;
  
  size(hSize, vSize);
}
void setup() {
  background(0);
  
  //create our array of cells and fill them with dirt
  cells = new Cell[hCells][vCells];
  for (int i = 0; i < hCells; i++){
    for (int j = 0; j < vCells; j++) {
      int seed = (int)random(4);
      cells[i][j] = new Cell(i,j,Contents.DIRT);
    }
  }
}

void draw() {
  // draw the state
  for (int i=0; i<hCells; i++){
    for (int j=0; j<vCells; j++) {
      cells[i][j].display();
    }
  }
  
  if ( generation < lastWiltedGen) {
    grow(generation++);
  }
  
  delay(50);
}

// environmental creation
void grow(int g) {
  float seed;
  
  // logic for sodding the grass
  if (g == 0) {
    for (int i=0; i<hCells; i++){
      for (int j=0; j<vCells; j++) {
        seed = random(1);
        if (seed < initialGrassGrowth) {
          cells[i][j].setContents(Contents.GRASS);
        }
      }
    }
  }
  // logic for grass growth
  else if (g <= lastGrassGen) {
    for (int i=0; i<hCells; i++){
      for (int j=0; j<vCells; j++) {
        // random grass generation
        seed = random(1);
        if (seed < randomGrassGrowth && cells[i][j].contents == Contents.DIRT) {
          cells[i][j].setContents(Contents.GRASS);
        }
        
        // generation of grass from neighbors
        int grassyNeighbors = pollNeighbors(i, j, Contents.GRASS);
        float growPercentage = 0;
        seed = random(1);
        growPercentage = ((1f/8f)*grassyNeighbors)*grassRateModifier;
        if (seed <= growPercentage) {
          cells[i][j].setContents(Contents.GRASS);
        }
      }
    }
  }
  // logic for flower growth
  else if (g > lastGrassGen && g <= lastFlowerGen) {
    for (int i=0; i<hCells; i++){
      for (int j=0; j<vCells; j++) {
        int grassyNeighbors = pollNeighbors(i, j, Contents.GRASS);
        int floweryNeighbors = pollNeighbors(i, j, Contents.FLOWER);
        // only grow if we are among friends
        if ((grassyNeighbors+floweryNeighbors) == 8) {
          float growPercentage = 0;
          seed = random(1);
          growPercentage = (((1f/8f)*floweryNeighbors)*flowerRateModifier)+baselineFlowerRate;
          if (seed <= growPercentage) {
            cells[i][j].setContents(Contents.FLOWER);
          }
        }
      }
    }
  }
  // logic for wilting flowers
  if (g > lastFlowerGen && g <= lastWiltedGen ) {
    for (int i=0; i<hCells; i++){
      for (int j=0; j<vCells; j++) {
        if (cells[i][j].contents == Contents.FLOWER) {
          seed = random(1);
          if (seed < wiltRate) {
            cells[i][j].setContents(Contents.WILTED);
          }
        }
      }
    }
  }
}

// for a given cell, see how many of its neighbors contain a given contents and return that number
int pollNeighbors(int hPos, int vPos, Contents c) {
  int matchingNeighbors = 0;
  if (((hPos-1) >= 0) && (vPos-1) >= 0) {
    if (cells[hPos-1][vPos-1].contents == c) {
      matchingNeighbors++;
    }
  }
  if ((vPos-1) >= 0) {
    if (cells[hPos][vPos-1].contents == c) {
      matchingNeighbors++;
    }
  }
  if (((hPos+1) < hCells) && (vPos-1) >= 0) {
    if (cells[hPos+1][vPos-1].contents == c) {
      matchingNeighbors++;
    }
  }
  if ((hPos-1) >= 0) {
    if (cells[hPos-1][vPos].contents == c) {
      matchingNeighbors++;
    }
  }
  if ((hPos+1) < hCells) {
    if (cells[hPos+1][vPos].contents == c) {
      matchingNeighbors++;
    }
  }
  if (((hPos-1) >= 0) && (vPos+1) < vCells) {
    if (cells[hPos-1][vPos+1].contents == c) {
      matchingNeighbors++;
    }
  }
  if ((vPos+1) < vCells) {
    if (cells[hPos][vPos+1].contents == c) {
      matchingNeighbors++;
    }
  }
  if (((hPos+1) < hCells) && (vPos+1) < vCells) {
    if (cells[hPos+1][vPos+1].contents == c) {
      matchingNeighbors++;
    }
  }
  return matchingNeighbors;
}