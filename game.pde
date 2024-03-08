/** GAME CONFIGURATION */
String gameState = "start"; // options: start, playing, stop

/** START SCREEN VARIABLES **/
int btnWidth = 200;
int btnHeight = 50;

/** GAME VARIABLES */
int selectedSetSize = 3;
ArrayList<Integer> selectedCards = new ArrayList<Integer>();
String[] boardCards = new String[gridRows * gridCols];
ArrayList<String> remainingDeck = new ArrayList<String>();
int statusBarHeight = 80; 
int setsFound = 0; 
int remainingCards;
int setsOnTable;

void initializeGame() {  
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
    } else if (selectedCards.size() < selectedSetSize) { // check if there have not yet been 3 cards selected
      selectedCards.add(cardIndex);
      println("ADDED CARD: " + boardCards[cardIndex]);
    }
    
    println("SELECTED CARD INDEXES: " + selectedCards);
    println("SELECTED CARDS:");
    printSelectedCards(selectedCards);
    
    // check if 3 cards have been selected
    if (selectedCards.size() == selectedSetSize) {
      
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

void handleErrorState() {

  int btnX = (width - btnWidth) / 2;
  int btnY = height / 2 + 50;
  
  // check if exit button is pressed
  if (mouseX >= btnX && mouseX <= btnX + btnWidth && mouseY >= btnY && mouseY <= btnY + btnHeight) {
    exit();
  }
  
}

/** GAME LOGIC FUNCTIONS */
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

void throwError(String errorMessage, boolean exit) 
{
  gameState = "ERROR";
  println("[ERROR] " + errorMessage);
  
  if(exit) {
    exit();
  }
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
  for (int i = 0; i < boardCards.length - 2; i++) { // first card
    
    for (int j = i + 1; j < boardCards.length - 1; j++) { // second card
      
      for (int k = j + 1; k < boardCards.length; k++) { // third card
        
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
