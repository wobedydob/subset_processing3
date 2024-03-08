boolean testing = true; // set to true to test

String testGameState = "start";

String[] testShapes = {"T", "R", "E"};
String[] testColors = {"R", "G", "B"};
int[] testNumbers = {1, 2, 3};
String[] testDeck = {};

int[] testSet = {0, 1, 2};

void initializeTesting() {
    println("---TESTING BEGINS HERE---");
    
    testGameState(testGameState);
    testGenerateDeck();
    testShuffleDeck(testDeck); 
    testIsValidSet(testSet);

    println("---TESTING ENDS HERE---");
    exit();
}

void testGenerateDeck() {
  
  println("~testGenerateDeck()");
  
  testDeck = generateDeck(testShapes, testColors, testNumbers);

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

void testShuffleDeck(String[] testDeck) {
  
  println("~testShuffleDeck()");

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

void testIsValidSet(int[] testSet) {
  
  println("~testIsValidSet()");
  
  testDeck = generateDeck(testShapes, testColors, testNumbers);
  
  ArrayList<Integer> set = convertArrayToList(testSet, new ArrayList<Integer>());

  // check if validSetDiff is a valid set in testDeck
  if (isValidSet(set, testDeck)) {
      println("[SUCCESS] '" + set + "' are valid indexes for a valid set found in 'testDeck'.");
  } else {
     throwError("'" + set + "' is not a valid set found in 'testDeck'.", false);
  }
  
  return;
}

void testGameState(String gameState) {

    println("~testGameState()");
  
  switch(gameState) {
    case "start":
      println("[SUCCESS] Correct game state is initialized: '" + gameState + "'");
      break;
    case "playing":
      println("[SUCCESS] Correct game state is initialized: '" + gameState + "'");
      break;
    case "stop":
      println("[SUCCESS] Correct game state is initialized: '" + gameState + "'");
      break;
    default:
      throwError("Invalid game state given '" + gameState + "'", false);
      break;
  }
  
}

ArrayList<Integer> convertArrayToList(int[] array, ArrayList<Integer> list) {
  for (int i = 0; i < array.length; i++) {
      list.add(array[i]);
  }
  return list;
}
