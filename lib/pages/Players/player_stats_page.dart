import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_paint/components/player.dart';
import '../../components/api_constants.dart';
import '../Registering/login_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PlayerStatsPage extends StatefulWidget {
  final int playerId;

  const PlayerStatsPage({super.key, required this.playerId});

  @override
  State<PlayerStatsPage> createState() => _PlayerStatsPageState();
}

class _PlayerStatsPageState extends State<PlayerStatsPage> {
  Future<List<Player>> _fetchPlayers() async {
    final response = await http.get(Uri.parse(
        '$API_BASE_URL/stats/json/PlayerSeasonStats/2023?key=$API_KEY'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      final players = data
          .map((player) => Player(
                id: player['PlayerID'],
                name: player['Name'],
                position: player['Position'],
                team: player['Team'],
                points: player['Points'],
                rebounds: player['Rebounds'],
                assists: player['Assists'],
                steals: player['Steals'],
                blocks: player['BlockedShots'],
                turnovers: player['Turnovers'],
                twoPointersAttempted: player['TwoPointersAttempted'],
                twoPointersMade: player['TwoPointersMade'],
                threePointersAttempted: player['ThreePointersAttempted'],
                threePointersMade: player['ThreePointersMade'],
                games: player['Games'],
                freeThrowsAttempted: player['FreeThrowsAttempted'],
                freeThrowsMade: player['FreeThrowsMade'],
              ))
          .toList();
      return players;
    } else {
      throw Exception('Failed to fetch players');
    }
  }

  Future<Player> getPlayerById(int id) async {
    List<Player> players = (await _fetchPlayers());
    for (Player player in players) {
      if (player.id == id) {
        return player;
      }
    }
    return Player(
        id: 0,
        name: '',
        position: 'position',
        team: 'team',
        points: 0,
        rebounds: 0,
        assists: 0,
        steals: 0,
        blocks: 0,
        turnovers: 0,
        twoPointersAttempted: 0,
        twoPointersMade: 0,
        threePointersAttempted: 0,
        threePointersMade: 0,
        games: 0,
        freeThrowsAttempted: 0,
        freeThrowsMade: 0);
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const LoginPage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('The Paint'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(
              builder: (context) => LoginPage(),
            )),
            icon: const Icon(Icons.logout),
          )
        ],
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<Player>(
        future: getPlayerById(widget.playerId),
        builder: (BuildContext context, AsyncSnapshot<Player> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return Center(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${snapshot.data!.name}\n2022-2023 Season Stats',
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DataTable(
                          headingRowColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white),
                          dataRowColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white),
                          columnSpacing: 70,
                          columns: const [
                            DataColumn(
                                label: Text(
                              'Category',
                              style: TextStyle(color: Colors.black),
                            )),
                            DataColumn(
                                label: Text(
                              'Stats',
                              style: TextStyle(color: Colors.black),
                            )),
                          ],
                          rows: [
                            DataRow(cells: [
                              const DataCell(Text(
                                'Points',
                                style: TextStyle(color: Colors.black),
                              )),
                              DataCell(Text(
                                (snapshot.data!.points / 82).toStringAsFixed(1),
                                style: const TextStyle(color: Colors.black),
                              )),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text(
                                'Rebounds',
                                style: TextStyle(color: Colors.black),
                              )),
                              DataCell(Text(
                                (snapshot.data!.rebounds / 82)
                                    .toStringAsFixed(1),
                                style: const TextStyle(color: Colors.black),
                              )),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text(
                                'Assists',
                                style: TextStyle(color: Colors.black),
                              )),
                              DataCell(Text(
                                (snapshot.data!.assists / 82)
                                    .toStringAsFixed(1),
                                style: const TextStyle(color: Colors.black),
                              )),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text(
                                'Steals',
                                style: TextStyle(color: Colors.black),
                              )),
                              DataCell(Text(
                                (snapshot.data!.steals / 82).toStringAsFixed(1),
                                style: const TextStyle(color: Colors.black),
                              )),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text(
                                'Blocks',
                                style: TextStyle(color: Colors.black),
                              )),
                              DataCell(Text(
                                (snapshot.data!.blocks / 82).toStringAsFixed(1),
                                style: const TextStyle(color: Colors.black),
                              )),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text(
                                'Turnovers',
                                style: TextStyle(color: Colors.black),
                              )),
                              DataCell(Text(
                                (snapshot.data!.turnovers /
                                        snapshot.data!.games)
                                    .toStringAsFixed(1),
                                style: const TextStyle(color: Colors.black),
                              )),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text(
                                'FG Percentage',
                                style: TextStyle(color: Colors.black),
                              )),
                              DataCell(Text(
                                (snapshot.data!.twoPointersMade /
                                        snapshot.data!.twoPointersAttempted *
                                        100)
                                    .toStringAsFixed(1),
                                style: const TextStyle(color: Colors.black),
                              )),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text(
                                '3PT FG Percentage',
                                style: TextStyle(color: Colors.black),
                              )),
                              DataCell(Text(
                                (snapshot.data!.threePointersMade /
                                        snapshot.data!.threePointersAttempted *
                                        100)
                                    .toStringAsFixed(1),
                                style: const TextStyle(color: Colors.black),
                              )),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text(
                                'Free Throw Percentage',
                                style: TextStyle(color: Colors.black),
                              )),
                              DataCell(Text(
                                (snapshot.data!.freeThrowsMade /
                                        snapshot.data!.freeThrowsAttempted *
                                        100)
                                    .toStringAsFixed(1),
                                style: const TextStyle(color: Colors.black),
                              )),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: Text('Player not found.'),
            );
          }
        },
      ),
    );
  }
}
