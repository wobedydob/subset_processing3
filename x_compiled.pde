/** DECK */
String[] shapes = {"T", "R", "E"}; // T = traingle, R = rectangle, E = ellipse
String[] colors = {"R", "G", "B"}; 
int[] numbers = {1, 2, 3};

String[] deck;
int cardWidth;
int cardHeight;
int gridRows = 3;
int gridCols = 3;

String[] generateDeck(String[] shapes, String[] colors, int[] numbers) {
  
  String[] deck = new String[27];
  int index = 0;

  for (int number : numbers) {
    for (String shape : shapes) {
      for (String cardColor : colors) {
        deck[index++] = number + cardColor + shape;
      }
    }
  }
  
  return deck;
}

String[] shuffleDeck(String[] deck) {
  
  for (int i = deck.length - 1; i > 0; i--) {
    
    // randomize the index
    int randomIndex = int(random(i + 1));
    
    // move cards to random positions
    String card = deck[i];
    deck[i] = deck[randomIndex];
    deck[randomIndex] = card;
  }
  
  return deck;
}

void logDeck(String[] deck) {
    for (String card : deck) {
        println(card);
    }
}

void drawDeck() {

    // calculate amount of cards based on gridRows * gridCols
    for (int i = 0; i < gridRows * gridCols; i++) {
      
    // check if card exists and has not been removed yey
        if (boardCards[i] != null && !boardCards[i].equals("removed")) {
            int x = (i % gridCols) * cardWidth;
            int y = (i / gridCols) * cardHeight;
            drawCard(boardCards[i], x, y, cardWidth, cardHeight, i);
        }
        
    }
    
}
  

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
  noFill();
  stroke(0);
  
  // add red border to selected card
  if (selectedCards.contains(index)) {
    strokeWeight(3);
    stroke(255, 0, 0);
  } else {
    strokeWeight(1);
  }
  
  // draw the border
  rect(x, y, cardWidth, cardHeight);
  
  // reset strokeWeight for the following cards
  strokeWeight(1);
  
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

void drawShape(String shape, String colorCode, int x, int y, int w, int h) {
  
  fill(getColor(colorCode));
  noStroke();

  if (shape.equals("T")) {
    drawTriangle(x, y, w, h);
  } else if (shape.equals("R")) {
    drawRectangle(x, y, w, h);
  } else if (shape.equals("E")) {
    drawEllipse(x, y, w, h);
  }
  
}

color getColor(String colorCode) {
  
  color c;
  switch (colorCode) {
    case "R":
      c = color(255, 0, 0);
      break;
    case "G":
      c = color(0, 255, 0);
      break;
    case "B":
      c = color(0, 0, 255);
      break;
    default:
      c = color(0, 0, 0);
      break;
  }
  
  return c;
}
/** DECK */

/** GAME LOGIC */
ArrayList<Integer> selectedCards = new ArrayList<Integer>();
String[] boardCards = new String[gridRows * gridCols]; // DIT MAG MISSCHIEN NIET
ArrayList<String> remainingDeck = new ArrayList<String>();

void printSelectedCards(ArrayList<Integer> selectedCards) {
  if (selectedCards.isEmpty()) {
    println("[]");
    return;
  }
  
  String result = "[";
  for (Integer index : selectedCards) {
      result += boardCards[index] + ", ";
  }
  result = result.substring(0, result.length() - 2) + "]";
  println(result);
}


int getCardIndexFromMousePosition(int mouseX, int mouseY) {
  
  int column = mouseX / cardWidth;
  int row = mouseY / cardHeight;
  
  if (column >= gridCols || row >= gridRows) {
    return -1; // w
  }
  
  return row * gridCols + column;
}

boolean isValidSet(ArrayList<Integer> selectedCards, String[] deck) {
  
  // make sure there are 3 cards selected
  if (selectedCards.size() != 3) {
    return false;
  }

// THIS MIGHT BE MOVED TO A SEPARATE FUNCTION VVVV

  // extract card properties
  int[][] properties = new int[3][3]; // [card][property (0=number, 1=color, 2=shape)]
  for (int i = 0; i < 3; i++) {
    String card = deck[selectedCards.get(i)];
    properties[i][0] = card.charAt(0) - '0'; // number
    properties[i][1] = card.charAt(1); // color
    properties[i][2] = card.charAt(2); // shape
  }

// THIS MIGHT BE MOVED TO A SEPARATE FUNCTION ^^^^

  // compare properties
  for (int property = 0; property < 3; property++) {
    boolean allSame = true;
    boolean allDifferent = true;
    
    for (int i = 0; i < 2; i++) {
      for (int j = i + 1; j < 3; j++) {
        if (properties[i][property] != properties[j][property]) {
          allSame = false;
        } else {
          allDifferent = false;
        }
      }
    }

    if (!allSame && !allDifferent) {
      return false;
    }
  }

  return true;
}

void replaceCards(ArrayList<Integer> selectedCards) {
    for (int index : selectedCards) {
        if (!remainingDeck.isEmpty()) {
            boardCards[index] = remainingDeck.remove(0); // remove new card from deck
        } else {
            boardCards[index] = "removed"; // mark card as removed
        }
    }
    selectedCards.clear();
    redraw();
}

// Globale variabelen
int foundSetsCount = 0;
int remainingDeckSize = 0;
int setsOnTable = 0;

void drawStatusBar() {
  fill(200); // Grijs voor de informatiebalk
  noStroke();
  rect(0, height - 50, width, 50); // Teken de balk onderaan

  fill(0); // Zwart voor de tekst
  textSize(16);
  textAlign(LEFT, CENTER);
  text("Sets gevonden: " + foundSetsCount, 10, height - 25);
  
  textAlign(CENTER, CENTER);
  text("Gedekte kaarten: " + remainingDeckSize + " - Sets op tafel: " + setsOnTable, width / 2, height - 25);
}
/** GAME LOGIC */

/** SKETCHING */
void setup() {
  size(600, 600);
  
  // calculate width and height
  cardWidth = width / gridCols;
  cardHeight = height / gridRows;
  
  // generate deck
  deck = generateDeck(shapes, colors, numbers);
  deck = shuffleDeck(deck);
  
  //logDeck(deck);
  
    // set boardCards with the first 9 cards and add the rest to remainingDeck
    for (int i = 0; i < deck.length; i++) {
        if (i < 9) {
            boardCards[i] = deck[i];
        } else {
            remainingDeck.add(deck[i]);
        }
    }
  
  // only draw once
  noLoop();
}

void draw() {
  background(255);
  drawDeck();
  drawStatusBar();
}

void mousePressed() {
  
    int cardIndex = getCardIndexFromMousePosition(mouseX, mouseY);

    // check if card is valid and has not been removed yet
    if (cardIndex >= 0 && !boardCards[cardIndex].equals("removed")) {
      
        // check if card has been selected
        if (selectedCards.contains(cardIndex)) {
            selectedCards.remove(Integer.valueOf(cardIndex)); // Verwijder op basis van object om juiste verwijdering te garanderen
            println("REMOVED CARD: " + boardCards[cardIndex]);
            
        } else if (selectedCards.size() < 3) { // check if there have not yet been 3 cards selected
            selectedCards.add(cardIndex);
            println("ADDED CARD: " + boardCards[cardIndex]);
        }

        println("SELECTED CARD INDEXES: " + selectedCards);
        
        println("SELECTED CARDS:");
        printSelectedCards(selectedCards);

        // check if 3 cards have been selected
        if (selectedCards.size() == 3) {
          
            // check if the selected cards are valid as a set
            if (isValidSet(selectedCards, boardCards)) {
                println("FOUND A SET: ");
                printSelectedCards(selectedCards);
                replaceCards(selectedCards);
            } else { // when the selection is not a valid set
                println("SET IS INVALID: " + selectedCards);
                printSelectedCards(selectedCards);
            }
        }
 
        redraw();
    }
}
/** SKETCHING */

/** TODO */
// move status bar below grid
// make counters in status bar work
// make starting screen
// make ending screen
