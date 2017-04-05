
TreeMap<String, Suit> mapSuits;

void loadSuits(String[] arr) {

  mapSuits.put("squat",     new Suit(squat(false)));
  mapSuits.put("pullUp",    new Suit(pullUp(false)));
  mapSuits.put("handstand", new Suit(handstand(false)));
  mapSuits.put("legRaise",  new Suit(legRaise(false)));
  
  for (int n = 0; n < arr.length; ++n) {

    String sShape = arr[n];

    if (mapSuits.containsKey(sShape) == false) {
      RShape shape = RG.loadShape(sShape + ".svg");
      mapSuits.put(sShape, new Suit(shape));
    }
  }
}

void drawSuit(
        PGraphics pg,
        String sName,
        float xCenter,
        float yCenter,
        float nHeight,
        boolean bMakeRed,
        boolean bUpsideDown) {

  Suit suit = mapSuits.get(sName);
  suit.draw(pg, xCenter, yCenter, nHeight, bMakeRed, bUpsideDown);
}

class Suit
{
  Suit(RShape shape) {
    m_shape = shape;
  }
  
  Suit(PGraphics pg){
    m_pgBlack = pg;
    m_pgRed = createGraphics(pg.width, pg.height);
    m_pgRed.beginDraw();
    m_pgRed.image(pg, 0, 0);  
    m_pgRed.loadPixels();

    for (int n = 0; n < m_pgRed.pixels.length; ++n) {
      color c = m_pgRed.pixels[n];
      m_pgRed.pixels[n] = color(255, green(c), blue(c), alpha(c));
    }
    
    m_pgRed.updatePixels();
    m_pgRed.endDraw();
  }

  void draw(
        PGraphics pg,
        float xCenter,
        float yCenter,
        float nHeight,
        boolean bMakeRed,
        boolean bUpsideDown) {

    if (m_shape != null) {
      drawShape(pg, m_shape, xCenter, yCenter, nHeight, bMakeRed, bUpsideDown);
    }
    
    PGraphics pgSuit = bMakeRed ? m_pgRed : m_pgBlack;
    
    if (pgSuit != null) {

      float fudge = 2;
      
      pg.pushMatrix();
      
      if (bUpsideDown) {
        yCenter -= fudge;
      } else {
        yCenter += fudge;
      }
      
      float nWidth = (nHeight / pgSuit.height) * pgSuit.width;
      float factor = 1.6;

      pg.translate(xCenter, yCenter); 

      if (bUpsideDown) {
        pg.rotate(PI);
      }

      pg.translate( -0.5*factor*nWidth, -0.5*factor*nHeight );
      pg.scale(factor * nHeight/ pgSuit.height);

      pg.image(pgSuit, 0, 0);

      pg.popMatrix();
    }
  }

  RShape m_shape;
  PGraphics m_pgBlack;
  PGraphics m_pgRed;
};