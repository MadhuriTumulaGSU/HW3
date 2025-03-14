import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

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
  int score = 0;
  int timeElapsed = 0;
  Timer? timer;

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
    score = 0;
    timeElapsed = 0;
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        timeElapsed++;
      });
    });
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
            score -= 5;
          } else {
            score += 10;
          }
          selectedCards.clear();
        });
        _checkWinCondition();
      });
    }
  }

  void _checkWinCondition() {
    if (flipped.every((isFlipped) => isFlipped)) {
      timer?.cancel();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("You Win!"),
          content: Text("Time: $timeElapsed seconds\nScore: $score"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _initializeGame();
                });
              },
              child: Text("Restart"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Card Matching Game")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Time: $timeElapsed s", style: TextStyle(fontSize: 18)),
                Text("Score: $score", style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          Expanded(
            child: Padding(
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
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}