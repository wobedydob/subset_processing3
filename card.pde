void drawCard(String card, int x, int y, int cardWidth, int cardHeight, int index) {
  
  if(!cardExists(card)) {
    throwError("Invalid value for card given '" + card + "'", true);
  }
  
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
    default:
      throwError("Invalid value for card shape given '" + shape + "'", true);
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

boolean cardExists(String card) {
  if (card == null || card.length() != 3) {
    return false; // Ongeldige kaartformat
  }

  // Extract eigenschappen van de kaart
  String number = card.substring(0, 1);
  int intNumber = 0;
  
  try {
    intNumber = Integer.parseInt(number);
  } catch (NumberFormatException e) {
    println(e);
    throwError("'number' is not an integer '" + number + "'", false);
  }
  
  
  String colorCode = card.substring(1, 2);
  String shape = card.substring(2, 3);

  boolean numberExists = numberExists(intNumber);
  boolean colorExists = colorExists(colorCode);
  boolean shapeExists = shapeExists( shape);
  
  if(!numberExists && !colorExists && !shapeExists) {
    return false;
  }

  return true;
}

boolean numberExists(int number) 
{
  boolean numberExists = false;
  for (int num : numbers) {
    if (num == number) {
      numberExists = true;
      break;
    }
  }
  return numberExists;
}


boolean colorExists(String colorCode) 
{
  boolean colorExists = false;
  for (String c : colors) {
    if (c.equals(colorCode)) {
      colorExists = true;
      break;
    }
  }
  return colorExists;
}

boolean shapeExists(String shapeCode) 
{
  boolean shapeExists = false;
  for (String shape : shapes) {
    if (shape.equals(shapeCode)) {
      shapeExists = true;
      break;
    }
  }
  return shapeExists;
}
