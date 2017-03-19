//
// Overlay command:
// pdftk overlay.pdf background "BASIC ROUTINE INFOGRAPHIC.pdf" output CombinedFile.pdf
//

import geomerative.*;
import java.util.TreeMap;
import processing.pdf.*;

TreeMap<String, RShape> shapes = new TreeMap<String, RShape>();

String[] arrSuits = {"club", "diamond", "heart", "spade"};
String[] arrRanks = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"};

float[] arrRowHeight = {87, 86, 87, 87, 87, 94, 87, 87, 91, 91, 91, 87, 87, 87, 87};
int[]   arrRowCount  = {13, 14, 12, 14, 15, 13, 12,  9};
  
void loadShapes(String[] arr) {
  for (int n = 0; n < arr.length; ++n) {
    String sShape = arr[n];
    RShape shape = RG.loadShape(sShape + ".svg");
    shapes.put(sShape, shape);
  }
}

void drawShape(PGraphics pg, String sName, float xCenter, float yCenter, float nHeight) {
  RShape shape = shapes.get(sName).toShape();
  RPoint point = shape.getTopLeft();
  RPoint br = shape.getBottomRight();
  float shapeHeight = br.y - point.y;
  point.x = -(point.x + br.x) / 2;
  point.y = -(point.y + br.y) / 2;
  shape.translate(point);
  shape.scale(abs(nHeight/shapeHeight));
  
  point.x = xCenter;
  point.y = yCenter;
  shape.translate(point);
  shape.draw(pg);
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

  float x = 34;
  float nWidth  = 96.4;
  
  pg.noFill();
  pg.stroke(255,0,0);

  for (int nCol = 0; nCol < arrRowCount.length; ++nCol) {
    float y = 386;
    int nRowCount = arrRowCount[nCol];
    for (int nRow = 0; nRow < nRowCount; ++nRow) {

      float nHeight = arrRowHeight[nRow];
      pg.rect(x, y, nWidth, nHeight);

      String sRank = arrRanks[nRow - nRowCount + arrRanks.length];

      drawShape(pg, sRank, x + 15, y + 10, 10);
      
      y = y + nHeight;
    }
    x = x + nWidth;
  }

}