/** SETUP FUNCTION */
void setup() {
  size(600, 600);
  
  if (testing) {
    initializeTesting();
  } else {
    initializeGame();
  }

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
    default:
      throwError("Invalid game state given '" + gameState + "'", true);
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
    default:
      handleErrorState();
      break;
  }
  
}
