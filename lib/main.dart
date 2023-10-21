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

class Treasure {
  String emoji;
  String name;
  int value;

  Treasure(this.emoji, this.name, this.value);
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
  Treasure latestTreasure = Treasure('📦', 'Common Box', 10);
  bool hasWon = false;
  bool hasNavigationMaps = false;
  bool hasAdvancedTools = false;
  bool hasTreasureLore = false;

  final List<Treasure> treasures = [
    Treasure('📦', 'Common Box', 10),
    Treasure('🔮', 'Magical Orb', 50),
    Treasure('💎', 'Rare Gem', 250),
    Treasure('👑', 'Royal Crown', 1000),
    Treasure('🏺', 'Ancient Vase', 5000),
  ];

  // Track each type of treasure collected
  Map<String, int> treasureCount = {};

  void discoverTreasure() {
    var randomTreasure = treasures[(DateTime.now().millisecondsSinceEpoch % treasures.length)];
    setState(() {
      gold += randomTreasure.value;
      latestTreasure = randomTreasure;
      treasureCount[randomTreasure.name] = (treasureCount[randomTreasure.name] ?? 0) + 1;
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
        latestTreasure = treasures[1];
        checkWinCondition();
      });
    }
  }

  void startAutoCollectForShip() async {
    while (ships > 0 && !hasWon) {
      await Future.delayed(Duration(seconds: 10));
      setState(() {
        gold += 100 * ships;
        latestTreasure = treasures[2];
        checkWinCondition();
      });
    }
  }

  void buyNavigationMaps() {
    if (gold >= 200 && !hasNavigationMaps) {
      setState(() {
        gold -= 200;
        hasNavigationMaps = true;
      });
    }
  }

  void buyAdvancedTools() {
    if (gold >= 100 && !hasAdvancedTools) {
      setState(() {
        gold -= 100;
        hasAdvancedTools = true;
      });
      // Update the hunter collection rate in the startAutoCollectForHunter method accordingly
    }
  }

  void buyTreasureLore() {
    if (gold >= 300 && !hasTreasureLore) {
      setState(() {
        gold -= 300;
        hasTreasureLore = true;
      });
      // Modify the discoverTreasure method to increase the chance for rarer treasures
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
            ElevatedButton(
              onPressed: buyNavigationMaps,
              child: Text('Buy Navigation Maps (200 Gold)'),
              style: ElevatedButton.styleFrom(
                primary: hasNavigationMaps ? Colors.grey : Colors.blue,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: buyAdvancedTools,
              child: Text('Buy Advanced Tools (100 Gold)'),
              style: ElevatedButton.styleFrom(
                primary: hasAdvancedTools ? Colors.grey : Colors.green,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: buyTreasureLore,
              child: Text('Buy Treasure Lore (300 Gold)'),
              style: ElevatedButton.styleFrom(
                primary: hasTreasureLore ? Colors.grey : Colors.amber,
                onPrimary: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Latest Treasure: ${latestTreasure?.emoji ?? ""} (${latestTreasure?.name ?? ""})',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: treasureCount.keys.length,
                itemBuilder: (context, index) {
                  var key = treasureCount.keys.elementAt(index);
                  return ListTile(
                    title: Text('$key: ${treasureCount[key]}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
