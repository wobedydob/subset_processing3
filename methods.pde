///** DECK GENERATION */
//String[] generateDeck(String[] shapes, String[] colors, int[] numbers) {
//  String[] deck = new String[27];
//  int index = 0;

//  for (int number : numbers) {
//    for (String shape : shapes) {
//      for (String cardColor : colors) {
//        deck[index++] = number + cardColor + shape;
//      }
//    }
//  }
  
//  return deck;
//}

//String[] shuffleDeck(String[] deck) {
//  for (int i = deck.length - 1; i > 0; i--) {
//    int index = int(random(i + 1)); // Kies een willekeurig index van 0 tot i
//    // Wissel de huidige kaart met de kaart op de willekeurig gekozen index
//    String temp = deck[i];
//    deck[i] = deck[index];
//    deck[index] = temp;
//  }
//  return deck;
//}

//void logDeck(String[] deck) {
//    for (String card : deck) {
//        println(card);
//    }
//}

//void drawDeck() {
//  // calculate amount of cards based on gridRows * gridCols
//  for (int i = 0; i < gridRows * gridCols; i++) {
//    int x = (i % gridCols) * cardWidth;
//    int y = (i / gridCols) * cardHeight;
//    drawCard(deck[i], x, y, cardWidth, cardHeight);
//  }
//}

//void drawCard(String card, int x, int y, int cardWidth, int cardHeight) {
//  int number = card.charAt(0) - '0'; // Zet het karakter om in een getal (1, 2, of 3)
//  String colorCode = card.substring(1, 2); // Neem de kleurcode (R, G, of B)
//  String shape = card.substring(2); // Neem de vormcode (T, R, of E)

//  // Bepaal de afmetingen en positie voor de vormen binnen de kaart
//  int shapeWidth = cardWidth / 2;
//  int shapeHeight = cardHeight / (number + 1);
//  int shapeY = y + shapeHeight / 2;

//  for (int i = 0; i < number; i++) {
//    // Bepaal de y-positie van de huidige vorm, gelijkmatig verdeeld over de kaart
//    int currentY = shapeY + (i * (shapeHeight + 10)); // Voeg een kleine ruimte toe tussen de vormen

//    // Teken de vorm met de juiste kleur
//    drawShape(shape, colorCode, x + cardWidth / 4, currentY, shapeWidth, shapeHeight);
//  }

//  // Teken een rand rond de kaart als je wilt
//  noFill();
//  stroke(0);
//  rect(x, y, cardWidth, cardHeight);
//}

//void drawTriangle(int x, int y, int w, int h) {
//  triangle(x + w/2, y, x, y + h, x + w, y + h);
//}

//void drawRectangle(int x, int y, int w, int h) {
//  rect(x, y, w, h);
//}

//void drawEllipse(int x, int y, int w, int h) {
//  ellipse(x + w/2, y + h/2, w, h);
//}

//void drawShape(String shape, String colorCode, int x, int y, int w, int h) {
//  fill(getColor(colorCode)); // Set the fill color using the getColor function
//  noStroke(); // If you don't want a border around shapes, otherwise remove this line

//  if (shape.equals("T")) {
//    drawTriangle(x, y, w, h);
//  } else if (shape.equals("R")) {
//    drawRectangle(x, y, w, h);
//  } else if (shape.equals("E")) {
//    drawEllipse(x, y, w, h);
//  }
//}

//color getColor(String colorCode) {
//  color c;
//  switch (colorCode) {
//    case "R":
//      c = color(255, 0, 0); // Red
//      break;
//    case "G":
//      c = color(0, 255, 0); // Green
//      break;
//    case "B":
//      c = color(0, 0, 255); // Blue
//      break;
//    default:
//      c = color(0, 0, 0); // Default to black if an unrecognized color code is passed
//      break;
//  }
//  return c;
//}
///** DECK GENERATION */

///** GAME LOGIC */
///** GAME LOGIC */
