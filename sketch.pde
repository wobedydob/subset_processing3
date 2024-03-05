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
