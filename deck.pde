/** DECK VARIABLES */
String[] shapes = {"T", "R", "E"};
String[] colors = {"R", "G", "B"};
int[] numbers = {1, 2, 3};
String[] deck;
int maxAmountOfCards = shapes.length * colors.length * numbers.length;
int cardWidth, cardHeight;
int gridRows = 3, gridCols = 3;

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
