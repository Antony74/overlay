
PGraphics legRaise(boolean bShowPoints) {

  int headHeight = 90;
  
  PGraphics pg = createGraphics(330, 280 + headHeight);
  pg.beginDraw();
  pg.rectMode(CENTER);
  pg.translate(-120, 150 - headHeight);

  PVector armStart = new PVector(375, 135);
  PVector elbow    = armStart;
  PVector hand     = new PVector(350,   0);
  PVector pelvis   = new PVector(344, 231);
  PVector knee     = new PVector(260, 210);
  PVector ankle    = new PVector(190, 215);
  PVector toe      = new PVector(ankle.x, ankle.y - 30);
  
  pg.stroke(0);
  pg.strokeWeight(60);

  pv_line(pg, armStart, elbow);
  pv_line(pg, elbow,    hand);

  pg.strokeWeight(70);

  pv_line(pg, armStart, pelvis);
  pv_line(pg, pelvis,   knee);
  pv_line(pg, knee,     ankle);

  pg.strokeWeight(50);
  pg.translate(-10, 0);
  pv_line(pg, ankle, toe);

  pg.fill(0);
  pg.strokeWeight(1);
  pg.ellipse(380, 60, headHeight, headHeight);

  if (bShowPoints) {
    pg.stroke(255, 0, 0);
    pv_point(pg, armStart);
    pv_point(pg, elbow);
    pv_point(pg, hand);
    pv_point(pg, pelvis);
    pv_point(pg, knee);
    pv_point(pg, ankle);
    pv_point(pg, toe);
  }

  pg.endDraw();

  return pg;
}