import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(CardMatchingGame());
}

class CardMatchingGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> emojis = ['🍎', '🍌', '🍇', '🍉', '🍒', '🍓', '🥝', '🍍'];
  List<String> gameBoard = [];
  List<bool> flipped = [];
  List<int> selectedCards = [];

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    List<String> shuffledEmojis = List.from(emojis)..addAll(emojis);
    shuffledEmojis.shuffle(Random());
    gameBoard = shuffledEmojis;
    flipped = List.generate(gameBoard.length, (index) => false);
    selectedCards.clear();
  }

  void _flipCard(int index) {
    if (flipped[index] || selectedCards.length == 2) return;
    
    setState(() {
      flipped[index] = true;
      selectedCards.add(index);
    });

    if (selectedCards.length == 2) {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          if (gameBoard[selectedCards[0]] != gameBoard[selectedCards[1]]) {
            flipped[selectedCards[0]] = false;
            flipped[selectedCards[1]] = false;
          }
          selectedCards.clear();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Card Matching Game")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: gameBoard.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _flipCard(index),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    flipped[index] ? gameBoard[index] : "?",
                    style: TextStyle(fontSize: 32, color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}