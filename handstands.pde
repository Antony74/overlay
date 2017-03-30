
PGraphics handstand(boolean bShowPoints) {

  int headHeight = 90;
  
  PGraphics pg = createGraphics(240, 350 + headHeight);
  pg.beginDraw();
  pg.rectMode(CENTER);
  pg.translate(-180, 80 - headHeight);

  stroke(0);

  float f = -15;

  PVector head       = new PVector(300, 360);
  PVector neck       = new PVector(300, 360);
  PVector pelvis     = new PVector(300, 201 + f);
  PVector leftHip    = new PVector(310, 201 + f);
  PVector rightHip   = new PVector(290, 201 + f);
  PVector leftKnee   = new PVector(340, 120 + f);
  PVector rightKnee  = new PVector(260, 120 + f);
  PVector leftFoot   = new PVector(340,  60 + f);
  PVector rightFoot  = new PVector(260,  60 + f);

  PVector shoulder   = new PVector(300, 250);
  PVector leftElbow  = new PVector(390, 350);
  PVector rightElbow = new PVector(210, 350);
  PVector leftHand   = new PVector(370, 420);
  PVector rightHand  = new PVector(230, 420);

  pg.strokeWeight(50);

  pv_line(pg, neck, pelvis);

  pg.strokeWeight(50);

  pv_line(pg, leftHip,  leftKnee);
  pv_line(pg, rightHip, rightKnee);

  pv_line(pg, leftFoot,  leftKnee);
  pv_line(pg, rightFoot, rightKnee);

  pg.strokeWeight(40);

  pv_line(pg, shoulder,  leftElbow);
  pv_line(pg, shoulder,  rightElbow);
  pv_line(pg, leftHand,  leftElbow);
  pv_line(pg, rightHand, rightElbow);

  pg.fill(0);
  pg.strokeWeight(1);
  pg.ellipse(head.x, head.y, headHeight, headHeight);

   if (bShowPoints) {
    pg.stroke(255, 0, 0);
    pv_point(pg, head);
    pv_point(pg, neck);
    pv_point(pg, pelvis);
    pv_point(pg, leftHip);
    pv_point(pg, rightHip);
    pv_point(pg, leftKnee);
    pv_point(pg, rightKnee);
    pv_point(pg, leftFoot);
    pv_point(pg, rightFoot);

    pv_point(pg, shoulder);
    pv_point(pg, leftElbow);
    pv_point(pg, rightElbow);
    pv_point(pg, leftHand);
    pv_point(pg, rightHand);
  }

  pg.endDraw();

  return pg;
}