
TreeMap<String, Suit> mapSuits;

void loadSuits(String[] arr) {

  mapSuits.put("squat", new Suit(squat()));
  
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
    m_pg = pg;
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
    
    if (m_pg != null) {
      float nWidth = (nHeight / m_pg.height) * m_pg.width;
      pg.image(m_pg, xCenter - nWidth, yCenter - nHeight, nWidth*2, nHeight*2);
    }
  }

  RShape m_shape;
  PGraphics m_pg;
};