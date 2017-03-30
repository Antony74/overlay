
void pv_point(PGraphics pg, PVector pv) {
  pg.pushStyle();
  pg.rectMode(RADIUS);
  pg.rect(pv.x, pv.y, 5, 5);
  pg.popStyle();
}

PGraphics pullUp() {

  int headHeight = 90;
  
  PGraphics pg = createGraphics(220, 330 + headHeight);
  pg.beginDraw();
  pg.rectMode(CENTER);
  pg.translate(-220, 80 - headHeight);

  PVector armStart = new PVector(375, 135);
  PVector elbow    = new PVector(280, 150);
  PVector hand     = new PVector(elbow.x, 100);
  PVector pelvis   = new PVector(344, 231);
  PVector knee     = new PVector(300, 290);
  PVector ankle    = new PVector(310, 360);
  PVector toe      = new PVector(ankle.x - 33, ankle.y + 22);
  
  pg.stroke(0);
  pg.strokeWeight(60);

  pv_line(pg, armStart, elbow);
  pv_line(pg, elbow,    hand);

  pg.strokeWeight(70);

  pv_line(pg, armStart, pelvis);
  pv_line(pg, pelvis,   knee);
  pv_line(pg, knee,     ankle);

  pg.strokeWeight(50);
  pg.translate(0,10);
  pv_line(pg, ankle, toe);

  pg.fill(0);
  pg.strokeWeight(1);
  pg.ellipse(370, 60, headHeight, headHeight);

  pg.stroke(255, 0, 0);

  // Diagnostics
  pv_point(pg, armStart);
  pv_point(pg, elbow);
  pv_point(pg, hand);
  pv_point(pg, pelvis);
  pv_point(pg, knee);
  pv_point(pg, ankle);
  pv_point(pg, toe);
  // End of diagnostics

  pg.endDraw();

  return pg;
}