void drawCard(String card, int x, int y, int cardWidth, int cardHeight, int index) {
  
  int number = card.charAt(0) - '0'; // calculate ascii character and convert to number (1, 2, 3)
  String colorCode = card.substring(1, 2);
  String shape = card.substring(2);

  // calculate size and position inside the card
  int shapeWidth = cardWidth / 2;
  int shapeHeight = cardHeight / (number + 1);
  int shapeY = y + shapeHeight / 2;

  for (int i = 0; i < number; i++) {
    
    // determine current y position of the shape
    int currentY = shapeY + (i * (shapeHeight + 10)); // add padding
    drawShape(shape, colorCode, x + cardWidth / 4, currentY, shapeWidth, shapeHeight);
    
  }

  // add border to the card
  stroke(black);
  noFill();
  
  // add red border to selected card
  if (selectedCards.contains(index)) {
    strokeWeight(3);
    stroke(red);
  } else {
    strokeWeight(1);
  }
  
  // draw the border
  rect(x, y, cardWidth, cardHeight);
  
  // reset strokeWeight for the following cards
  strokeWeight(1);
  
}

/** SHAPE DRAWING FUNCTIONS */
void drawShape(String shape, String colorCode, int x, int y, int w, int h) {
  
  fill(getColor(colorCode));
  noStroke();
  
  switch (shape) {
    case "T":
      drawTriangle(x, y, w, h);
      break;
    case "R":
      drawRectangle(x, y, w, h);
      break;
    case "E":
      drawEllipse(x, y, w, h);
      break;
  }
  
}

void drawTriangle(int x, int y, int w, int h) {
  triangle(x + w/2, y, x, y + h, x + w, y + h);
}

void drawRectangle(int x, int y, int w, int h) {
  rect(x, y, w, h);
}

void drawEllipse(int x, int y, int w, int h) {
  ellipse(x + w/2, y + h/2, w, h);
}

color getColor(String colorCode) {
  
  color c;
  switch (colorCode) {
    case "R":
      c = red;
      break;
    case "G":
      c = green;
      break;
    case "B":
      c = blue;
      break;
    default:
      c = black;
      break;
  }
  
  return c;
}
