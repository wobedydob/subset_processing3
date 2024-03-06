boolean testing = true;

void initializeTesting() {

    println("---TESTING BEGINS HERE---");
    //testGenerateDeck();
    //testShuffleDeck();
    //testIsValidSet();
    testGameStateManagement();
    println("---TESTING ENDS HERE---");
    exit();
}

void testGenerateDeck() {
  
  println("~testGenerateDeck()");
  
  String[] testDeck = generateDeck(shapes, colors, numbers);
  
  if (testDeck.length != 27) {
    throwError("Invalid deck.length given '" + testDeck.length + "'", false);
    return;
  }
  
  // check for duplicates
  for (int i = 0; i < testDeck.length; i++) {
    for (int j = i + 1; j < testDeck.length; j++) {
      if (testDeck[i].equals(testDeck[j])) {
        throwError("Duplicate card found in deck '" + testDeck[i] + "'", false);
        return;
      }
    }
  }
  
  println("[SUCCESS] Deck was successfully generated with " + testDeck.length + " cards");
}

void testShuffleDeck() {
  
  println("~testShuffleDeck()");

  String[] testDeck = generateDeck(shapes, colors, numbers);
  String[] originalDeck = testDeck.clone();
  
  testDeck = shuffleDeck(testDeck);
  
  // check if the shuffled deck has the same length as the original
  if (testDeck.length != originalDeck.length) {
    throwError("Shuffled deck length does not match original deck length '" +  testDeck.length + "'", false);
    return;
  }
  
  // check for duplicates
  for (int i = 0; i < testDeck.length; i++) {
    for (int j = i + 1; j < testDeck.length; j++) {
      if (testDeck[i].equals(testDeck[j])) {
        throwError("Duplicate card found in shuffled deck '" + testDeck[i] + "'", false);
        return;
      }
    }
  }
  
  // check if the order of the deck has changed
  boolean isOrderChanged = false;
  for (int i = 0; i < testDeck.length; i++) {
    if (!testDeck[i].equals(originalDeck[i])) {
      isOrderChanged = true;
      break;
    }
  }
  
  if (!isOrderChanged) {
    throwError("Deck order has not changed after shuffling", false);
    return;
  }
  
  println("[SUCCESS] Deck was successfully shuffled with " + testDeck.length + " cards, and the order was changed.");
}

void testIsValidSet() {
  
  println("~testIsValidSet()");
  
  // valid set array with different properties
  ArrayList<Integer> validSetDiff = new ArrayList<Integer>(); 
  validSetDiff.add(0); validSetDiff.add(1); validSetDiff.add(2);

  // valid set array with all same properties
  ArrayList<Integer> validSetSame = new ArrayList<Integer>();
  validSetSame.add(3); validSetSame.add(4); validSetSame.add(5);

  // invalid set
  ArrayList<Integer> invalidSet = new ArrayList<Integer>();
  invalidSet.add(8); invalidSet.add(7); invalidSet.add(8);

  String[] testDeck = generateDeck(shapes, colors, numbers);

  // check if validSetDiff is a valid set in testDeck
  if (isValidSet(validSetDiff, testDeck)) {
    println("[SUCCESS] 'validSetDiff' is a valid set found in 'testDeck'.");
  } else {
   throwError("'isValidSet' failed using 'validSetDiff' and 'testDeck'.", false);
  }

  // check if validSetSame is a valid set in testDeck
  if (isValidSet(validSetSame, testDeck)) {
    println("[SUCCESS] 'validSetSame' is a valid set found in 'testDeck'.");
  } else {
   throwError("'isValidSet' failed using 'validSetSame' and 'testDeck'.", false);
  }
  
  // check if invalidSet is a valid set in testDeck
  if (isValidSet(invalidSet, testDeck)) {
    println("[SUCCESS] 'invalidSet' is a valid set found in 'testDeck'.");
  } else {
    throwError("'isValidSet' failed using 'invalidSet' and 'testDeck'.", false);
  }
  
  return;
}

void testGameState(String gameState) {

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
      throwError("Invalid game state given '" + gameState + "'", false);
      break;
  }
  
  

  if (!gameState.equals("playing")) {
    println("[ERROR] handleStartState did not transition to 'playing'. Current gameState: " + gameState);
  } else {
    println("[SUCCESS] handleStartState correctly transitioned to 'playing'.");
  }

  handleStopState();
  if (!gameState.equals("start")) {
    println("[ERROR] handleStopState did not reset to 'start'. Current gameState: " + gameState);
  } else {
    println("[SUCCESS] handleStopState correctly reset to 'start'.");
  }

  // Zorg ervoor dat je de spelstaat en eventuele andere relevante variabelen reset naar hun oorspronkelijke waarden na de tests, indien nodig
}
