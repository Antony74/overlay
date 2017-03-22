
PGraphics squat() {
  
  PGraphics pg = createGraphics(220, 350);
  pg.beginDraw();
  pg.rectMode(CENTER);

  stroke(0);

  PVector armStart = new PVector(287, 150);
  PVector hand     = new PVector(375, 150);
  PVector pelvis   = new PVector(249, 261);
  PVector knee     = new PVector(334, 261);
  PVector ankle    = new PVector(277, 366);
  PVector toe      = new PVector(310, 366);

  pg.strokeWeight(35);

  pv_line(pg, armStart, hand);
  pv_line(pg, armStart, pelvis);
  pv_line(pg, pelvis, knee);
  pv_line(pg, knee, ankle);
  pv_line(pg, ankle, toe);

  pg.fill(0);
  pg.strokeWeight(1);
  pg.ellipse(293, 93, 50, 50);

  pg.endDraw();
  return pg;
}