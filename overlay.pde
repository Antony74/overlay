//
// Overlay command:
// pdftk overlay.pdf background "BASIC ROUTINE INFOGRAPHIC.pdf" output CombinedFile.pdf
//

import geomerative.*;
import java.util.TreeMap;
import processing.pdf.*;

TreeMap<String, RShape> shapes = new TreeMap<String, RShape>();

String[] arrSuits = {"diamond", "club", "heart", "spade"};
String[] arrRanks = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"};

//                        0,   1,   2,   3,   4,   5,   6,    7,   8,   9,  10,   J,   Q,   K,   A
float[] arrRowHeight = { 87,  86,  87,  90,  87,  93,  89, 86.5,  89,  91,  90,  87,  90,  87,  87};
int[]   arrRowCount  = { 13,  14,  12,  14,  15,  13,  12,    9};
  
void pv_line(PGraphics pg, PVector start, PVector end) {
  pg.line(start.x, start.y, end.x, end.y);
}

void loadShapes(String[] arr) {
  for (int n = 0; n < arr.length; ++n) {
    String sShape = arr[n];
    RShape shape = RG.loadShape(sShape + ".svg");
    shapes.put(sShape, shape);
  }
}

void makeRed(RShape shape, boolean bRed) {

  if (bRed) {
    shape.setStroke(color(255, 0, 0));
    shape.setFill(color(255, 0, 0));
  } else { // Not being able to find any proper cloning functionality is starting to grate!
    shape.setStroke(color(0, 0, 0));
    shape.setFill(color(0, 0, 0));
  }
  
  if (shape.children != null) {
    for (int n = 0; n < shape.children.length; ++n) {
      makeRed(shape.children[n], bRed);
    }
  }
}

void arcVertices(PGraphics pg, float x, float y, float radius, boolean bRight, boolean bBottom) {

  int nCount = 30;
  float start = 0;
  
  if        (!bRight && !bBottom) {
    start = PI;
  } else if (!bRight &&  bBottom) {
    start = PI + HALF_PI;
  } else if ( bRight && !bBottom) {
    start = HALF_PI;
  } else if ( bRight &&  bBottom) {
    start = 0;
  } else {
    println("Logic fail!");
  }

  for (int n = 0; n <= nCount; ++n) {
    
    float angle = map(n, nCount, 0, start, start + HALF_PI);

    pg.vertex( x + radius*cos(angle),
               y + radius*sin(angle) );
  }
}

void drawShape(
        PGraphics pg,
        String sName,
        float xCenter,
        float yCenter,
        float nHeight,
        boolean bMakeRed,
        boolean bUpsideDown) {
  
  RShape shape = shapes.get(sName);

  makeRed(shape, bMakeRed);
  
  RPoint point = shape.getTopLeft();
  RPoint br = shape.getBottomRight();
  float shapeHeight = br.y - point.y;
  point.x = -(point.x + br.x) / 2;
  point.y = -(point.y + br.y) / 2;
  shape.translate(point);
  shape.scale(abs(nHeight/shapeHeight));
  
  if (bUpsideDown) {
    shape.rotate(PI);
  }
  
  point.x = xCenter;
  point.y = yCenter;
  shape.translate(point);
  shape.draw(pg);

  if (bUpsideDown) { // Not being able to find any proper cloning functionality is starting to grate! 
    shape.rotate(PI);
  }
}

void setup() {

  RG.init(this);
  
  shapes = new TreeMap<String, RShape>();
  loadShapes(arrSuits);
  loadShapes(arrRanks);
  println(); // Some space between us and any chatter Geomerative has generated

  // weird correction: The letter "A" for Ace is the only shape that requires this bizare hack   
  RShape sh = shapes.get("A");
  RPath paths[] = sh.children[0].children[0].paths;
  paths[1].translate(-1.3,0);
  // End of weird correction
  
  PGraphics pg = createGraphics(827, 2200, PDF, "overlay.pdf");
  pg.beginDraw();
  drawOverlay(pg);

  // Test squat - FIX ME
  PGraphics squat = squat();
  pg.image(squat, 0, 0, pg.width, pg.height);
  // End of test squat

  pg.endDraw();
  pg.dispose();

  String arrCmd1[] = {
    "pdftk",
    sketchPath() + "\\overlay.pdf",
    "background",
    "\"" + sketchPath() + "\\BASIC ROUTINE INFOGRAPHIC.pdf\"",
    "output",
    sketchPath() + "\\CombinedFile.pdf"
  };
 
  String arrCmd2[] = {
    "cmd",
    "/c",
    sketchPath() + "\\CombinedFile.pdf"
  };

  runProgram(arrCmd1, true); 
  runProgram(arrCmd2, false); 
  
  exit();
}

void runProgram(String cmdArray[], boolean bWait) {

  String sCmd = String.join(" ", cmdArray);
  println(sCmd);

  try {
    Process pr = Runtime.getRuntime().exec(sCmd);
    if (bWait == true) {
      pr.waitFor();
    }
  } catch(Exception e) {
    println(e);
  }
}

void drawOverlay(PGraphics pg) {

  float xBase = 34;
  float yBase = 386;
  
  float x = xBase;
  float nWidth  = 96.4;
  
  float nTotalWidth = 96.4 * arrRowCount.length;
  float nTotalHeight = 0;

  for (int nRow = 0; nRow < arrRowHeight.length; ++nRow) {
    nTotalHeight += arrRowHeight[nRow];
  }
  
  for (int nCol = 0; nCol < arrRowCount.length; ++nCol) {
    
    float y = yBase;
    String sSuit = arrSuits[nCol % arrSuits.length];
    int nRowCount = arrRowCount[nCol];

    boolean bMakeRed = false;
    if (sSuit.equals("heart") || sSuit.equals("diamond")) {
      bMakeRed = true;
    }

    for (int nRow = 0; nRow < nRowCount; ++nRow) {

      float nHeight = arrRowHeight[nRow];

      int nRad = 5;
      int nGap = nRad + 2;

      // Draw a green card table
      
      pg.noStroke();
      pg.fill(0, 200, 0);

      pg.beginShape();
      pg.vertex(x - 1, y - 1);
      arcVertices(pg, x + nGap,          y + nGap,           nRad, false, false);
      arcVertices(pg, x + nGap,          y + nHeight - nGap, nRad, true,  false);
      arcVertices(pg, x + nWidth - nGap, y + nHeight - nGap, nRad, true,  true );
      arcVertices(pg, x + nWidth - nGap, y + nGap,           nRad, false, true );
      arcVertices(pg, x + nGap,          y + nGap,           nRad, false, false);
      pg.vertex(x - 1,        y - 1          );
      pg.vertex(x + nWidth+1, y - 1          );
      pg.vertex(x + nWidth+1, y + nHeight + 1);
      pg.vertex(x - 1,        y + nHeight + 1);
      pg.endShape(CLOSE);

      // Make the playing cards more white so they look more like playing cards
      pg.fill(240);

      int nThickness = 3;
      int nDepth = 62;

      pg.beginShape();
      arcVertices(pg, x + nGap,          y + nGap,           nRad, false, false);
      pg.vertex(x + 2,    y + nDepth);
      pg.vertex(x + nGap + nThickness, y + nDepth);
      pg.vertex(x + nGap + nThickness, y + 2);
      pg.endShape(CLOSE);

      pg.beginShape();
      arcVertices(pg, x + nWidth - nGap, y + nGap,           nRad, false, true );
      pg.vertex(x + nWidth - nGap - nThickness, y + 2);
      pg.vertex(x + nWidth - nGap - nThickness, y + nDepth);
      pg.vertex(x + nWidth - 2,    y + nDepth);
      pg.endShape(CLOSE);

      // Draw the outline of each playing card with the characteristic curved corners
      
      pg.noFill();
      pg.stroke(0);
      pg.strokeWeight(1.5);
      
      pg.beginShape();
      arcVertices(pg, x + nGap,          y + nGap,           nRad, false, false);
      arcVertices(pg, x + nGap,          y + nHeight - nGap, nRad, true,  false);
      arcVertices(pg, x + nWidth - nGap, y + nHeight - nGap, nRad, true,  true );
      arcVertices(pg, x + nWidth - nGap, y + nGap,           nRad, false, true );
      pg.endShape(CLOSE);

      // Draw rank and suit onto card
      String sRank = arrRanks[nRow - nRowCount + arrRanks.length];

      drawShape(pg, sRank, x + 7, y + 12, 10, bMakeRed, false);
      drawShape(pg, sSuit, x + 7, y + 24, 10, bMakeRed, false);
      
      // And draw it upsidedown too
      
      drawShape(pg, sRank, x + nWidth - 7, y + nDepth -  8, 10, bMakeRed, true);
      drawShape(pg, sSuit, x + nWidth - 7, y + nDepth - 20, 10, bMakeRed, true);

      // Next
      y = y + nHeight;
    }

    // Fill in empty space with card table green

    pg.noStroke();
    pg.fill(0, 200, 0);

    for (int nRow = nRowCount; nRow < arrRowHeight.length; ++nRow) {
      
      float nHeight = arrRowHeight[nRow];

      pg.rect(x - 1, y - 1, nWidth + 2, nHeight + 2);

      // Next
      y = y + nHeight;
    }

    x = x + nWidth;
  }

  // Draw a little more card table around the edges

  pg.noFill();
  pg.stroke(0, 200, 0);
  pg.strokeWeight(4);
  pg.rect(xBase - 2, yBase - 2, nTotalWidth + 4, nTotalHeight + 4);

  pg.stroke(0);
  pg.strokeWeight(1);
  pg.rect(xBase - 4, yBase - 4, nTotalWidth + 8, nTotalHeight + 8);
}