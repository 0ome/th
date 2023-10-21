import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Legacy of the Lost Relics',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TreasureHuntHome(),
    );
  }
}

class TreasureHuntHome extends StatefulWidget {
  @override
  _TreasureHuntHomeState createState() => _TreasureHuntHomeState();
}

class _TreasureHuntHomeState extends State<TreasureHuntHome> {
  final int winCondition = 5000000;
  int gold = 0;
  int hunters = 0;
  int ships = 0;
  String treasure = '📦';
  bool hasWon = false;

  final List<String> treasures = [
    '📦',
    '🔮',
    '💎',
    '👑',
  ];

  void discoverTreasure() {
    setState(() {
      gold += 10;
      treasure = treasures[0];
      checkWinCondition();
    });
  }

  void hireHunter() {
    if (gold >= 50) {
      setState(() {
        gold -= 50;
        hunters += 1;
      });
      startAutoCollectForHunter();
    }
  }

  void buyShip() {
    if (gold >= 500) {
      setState(() {
        gold -= 500;
        ships += 1;
      });
      startAutoCollectForShip();
    }
  }

  void startAutoCollectForHunter() async {
    while (hunters > 0 && !hasWon) {
      await Future.delayed(Duration(seconds: 5));
      setState(() {
        gold += 5 * hunters;
        treasure = treasures[1];
        checkWinCondition();
      });
    }
  }

  void startAutoCollectForShip() async {
    while (ships > 0 && !hasWon) {
      await Future.delayed(Duration(seconds: 10));
      setState(() {
        gold += 100 * ships;
        treasure = treasures[2];
        checkWinCondition();
      });
    }
  }

  void checkWinCondition() {
    if (gold >= winCondition && !hasWon) {
      setState(() {
        hasWon = true;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Congratulations!'),
            content: Text('You have collected 5 million gold and won the game!'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Legacy of the Lost Relics'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LinearProgressIndicator(
              value: gold / winCondition.toDouble(),
            ),
            SizedBox(height: 20),
            Text(
              'Gold: $gold / $winCondition',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              'Hunters: $hunters',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              'Ships: $ships',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: discoverTreasure,
              child: Text('Discover Treasure!'),
              style: ElevatedButton.styleFrom(
                primary: Colors.amber,
                onPrimary: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: hireHunter,
              child: Text('Hire Hunter (50 Gold)'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: buyShip,
              child: Text('Buy Ship (500 Gold)'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Latest Treasure: $treasure',
              style: TextStyle(fontSize: 36),
            ),
          ],
        ),
      ),
    );
  }
}
