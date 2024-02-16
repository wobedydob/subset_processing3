/** GAME CONFIGURATION */
String gameState = "start"; // options: start, playing, stop

/** START SCREEN VARIABLES **/
int btnWidth = 200;
int btnHeight = 50;

/** DECK VARIABLES */
String[] shapes = {"T", "R", "E"};
String[] colors = {"R", "G", "B"};
int[] numbers = {1, 2, 3};
String[] deck;
int maxAmountOfCards = shapes.length * colors.length * numbers.length;
int cardWidth, cardHeight;
int gridRows = 3, gridCols = 3;

/** GAME VARIABLES */
ArrayList<Integer> selectedCards = new ArrayList<Integer>();
String[] boardCards = new String[gridRows * gridCols];
ArrayList<String> remainingDeck = new ArrayList<String>();
int statusBarHeight = 80, setsFound = 0, remainingCards, setsOnTable;

/** SETUP FUNCTION */
void setup() {
  size(600, 600);
  
  // calculate width and height
  cardWidth = width / gridCols;
  cardHeight = (height - statusBarHeight) / gridRows; // remove height of status bar to place it below
  
  // generate deck
  deck = generateDeck(shapes, colors, numbers);
  deck = shuffleDeck(deck);
  
  remainingCards = deck.length - (gridRows * gridCols);
  
  // set boardCards with the first 9 cards and add the rest to remainingDeck
  for (int i = 0; i < deck.length; i++) {
    if (i < 9) {
      boardCards[i] = deck[i];
    } else {
      remainingDeck.add(deck[i]);
    }
  }
  
   //only draw once
  noLoop();
}


/** DRAW FUNCTION */
void draw() {
  background(white);
  setsOnTable = calculateSetsOnTable(boardCards);
  
    switch(gameState) {
    case "start":
      drawStartupScreen();
      break;
    case "playing":
      drawPlayingScreen();
      break;
    case "stop":
       drawStopScreen(); 
      break;
  }
  
}

/** MOUSE PRESSED FUNCTION */
void mousePressed() {
    
  switch(gameState) {
    case "start":
      handleStartState();
      break;
    case "playing":
      handlePlayingState();
      break;
    case "stop":
       handleStopState(); 
      break;
  }
  
}

void handleStartState() {

  // start button position
  int btnX = (width - btnWidth) / 2;
  int btnY = (height - btnHeight) / 2;
  
  // check if start button is pressed
  if (mouseX >= btnX && mouseX <= btnX + btnWidth && mouseY >= btnY && mouseY <= btnY + btnHeight) {
    gameState = "playing"; // update the game state
    redraw();
  }
  
}

void handlePlayingState() {
  
  int cardIndex = getCardIndexFromMousePosition(mouseX, mouseY);
  
  // check if card is valid and has not been removed yet
  if (cardIndex >= 0 && !boardCards[cardIndex].equals("removed")) {
  
    // check if card has been selected
    if (selectedCards.contains(cardIndex)) {
      selectedCards.remove(Integer.valueOf(cardIndex)); 
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
        setsFound++;
        printSelectedCards(selectedCards);
        replaceCards(selectedCards);
      } else { // when the selection is not a valid set
        println("SET IS INVALID: " + selectedCards);
        printSelectedCards(selectedCards);
      }
    }
     
    redraw();
  }
    
  // determine button position based on statusBarHeight
  int stopBtnX = (width / 2) - (100 / 2);
  int stopBtnY = height - (statusBarHeight / 2);
  
  if (setsOnTable == 0 && mouseX >= stopBtnX && mouseX <= stopBtnX + 100 && mouseY >= stopBtnY && mouseY <= stopBtnY + 30) {
    gameState = "stop"; // update the game state
    redraw();
  }
}

void handleStopState() {

  int btnX = (width - btnWidth) / 2;
  int btnY = height / 2 + 50;
  
  // check if reset button is pressed
  if (mouseX >= btnX && mouseX <= btnX + btnWidth && mouseY >= btnY && mouseY <= btnY + btnHeight) {
    resetGame(); // reset the game
    redraw();
  }
  
}

/** DECK FUNCTIONS */
String[] generateDeck(String[] shapes, String[] colors, int[] numbers) {
  
  String[] deck = new String[maxAmountOfCards];
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

/** GAME LOGIC FUNCTIONS */
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

  // extract card properties
  int[][] properties = new int[3][3]; // [card][property (0=number, 1=color, 2=shape)]
  for (int i = 0; i < 3; i++) {
    String card = deck[selectedCards.get(i)];
    properties[i][0] = card.charAt(0) - '0'; // number
    properties[i][1] = card.charAt(1); // color
    properties[i][2] = card.charAt(2); // shape
  }

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

int calculateSetsOnTable(String[] boardCards) {
  int setsCount = 0;
  for (int i = 0; i < boardCards.length - 2; i++) {
    for (int j = i + 1; j < boardCards.length - 1; j++) {
      for (int k = j + 1; k < boardCards.length; k++) {
        ArrayList<Integer> selectedCards = new ArrayList<Integer>();
        if (!boardCards[i].equals("removed") && !boardCards[j].equals("removed") && !boardCards[k].equals("removed")) {
          selectedCards.add(i);
          selectedCards.add(j);
          selectedCards.add(k);
          if (isValidSet(selectedCards, boardCards)) {
            setsCount++;
          }
        }
      }
    }
  }
  return setsCount;
}

void replaceCards(ArrayList<Integer> selectedCards) {
    for (int index : selectedCards) {
        if (!remainingDeck.isEmpty()) {
            boardCards[index] = remainingDeck.remove(0); // remove new card from deck
            remainingCards--;
        } else {
            boardCards[index] = "removed"; // mark card as removed
        }
    }
    selectedCards.clear();
    redraw();
}

void drawStatusBar() {
  
  // bar background
  fill(grey);
  noStroke();
  rect(0, height - statusBarHeight, width, statusBarHeight);

  // bar text
  fill(black);
  textSize(16);
  
  // setsFound
  textAlign(LEFT, CENTER);
  text("Sets gevonden: " + setsFound, 10, height - (statusBarHeight - 25));
  
  // remainingCards
  textAlign(CENTER, CENTER);
  text("Gedekte kaarten: " + remainingCards, width / 2, height - (statusBarHeight - 25));

  // setsOnTable
  textAlign(RIGHT, CENTER);
  text("Sets op tafel: " + setsOnTable, width - 25 / 1, height - (statusBarHeight - 25));
  
  // check if no sets can be made
  if (setsOnTable == 0) {
    
    // stop button
    fill(red); // red background
    int stopBtnX = (width / 2) - (100 / 2);
    int stopBtnY = height - (statusBarHeight / 2);
    rect(stopBtnX, stopBtnY, 100, 30, 5);
    
    // stop button text
    fill(white); // white
    textSize(14);
    textAlign(CENTER, CENTER);
    text("Stop", stopBtnX + 50, stopBtnY + 15);
    
  }
  
}

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

/** GAME STATE FUNCTIONS */
void drawStartupScreen() {
  background(black);
  fill(white); // text
  
  // head title
  textSize(32);
  textAlign(CENTER, CENTER); 
  text("SubSet", width / 2, height / 3);
  
  // without these "duplicated" variables the start button gets destroyed...
  int btnX = (width - btnWidth) / 2;
  int btnY = (height - btnHeight) / 2;
  
  // button
  fill(red); // background
  rect(btnX, btnY, btnWidth, btnHeight, 10);
  
  // button text
  fill(white);
  textSize(20);
  text("Start", width / 2, btnY + btnHeight / 2);
}

void drawPlayingScreen() {
  drawDeck();
  drawStatusBar();
}

void drawStopScreen() {
  background(black);
  fill(white); // text
  textSize(32);
  textAlign(CENTER, CENTER);
  
  // scoreboard
  text("Spel Gestopt", width / 2, height / 2 - 50);
  text("Sets gevonden: " + setsFound, width / 2, height / 2);

  // reset button
  int btnX = (width - btnWidth) / 2;
  int btnY = height / 2 + 50;
  fill(red);
  rect(btnX, btnY, btnWidth, btnHeight, 10);

  // button text
  fill(white);
  textSize(20);
  text("Terug naar Start", width / 2, btnY + btnHeight / 2);
}

void resetGame() {
  setsFound = 0; // reset the setsFound attribute
  selectedCards.clear(); // clear selectedCards
  remainingDeck.clear(); // clear remainingDeck

  // regenerate deck
  deck = generateDeck(shapes, colors, numbers);
  deck = shuffleDeck(deck);

  // reset boardCards and remainingDeck
  for (int i = 0; i < deck.length; i++) {
      if (i < gridRows * gridCols) {
          boardCards[i] = deck[i];
      } else {
          remainingDeck.add(deck[i]);
      }
  }

  remainingCards = deck.length - (gridRows * gridCols); // reset remainingCards
  setsOnTable = calculateSetsOnTable(boardCards); // reset setsOnTable
  
  gameState = "start"; // reset the game
}
