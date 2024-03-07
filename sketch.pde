final int screenHeight = 600;
final int screenWidth = 600;

/** SETUP FUNCTION */
void setup() {
  size(screenWidth, screenHeight);
  
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

  
    switch(gameState) {
    case "start":
      drawStartupScreen();
      break;
    case "playing":
      setsOnTable = calculateSetsOnTable(boardCards);
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
      throwError("Invalid game state given '" + gameState + "'", true);
      break;
  }
  
}
