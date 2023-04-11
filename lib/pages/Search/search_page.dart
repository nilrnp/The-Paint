import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../components/api_constants.dart';
import '../../components/player.dart';
import '../Registering/login_page.dart';
import '../Teams/player_stats_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<Player> _players = [];

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
              ))
          .toList();
      return players;
    } else {
      throw Exception('Failed to fetch players');
    }
  }

  Future<void> _searchPlayers() async {
    final players = await _fetchPlayers();
    final searchText = _searchController.text.toLowerCase();
    final filteredPlayers = players
        .where((player) => player.name.toLowerCase().contains(searchText))
        .toList();
    setState(() {
      _players = filteredPlayers;
    });
  }

  //sign user out method
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
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          )
        ],
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search players',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchPlayers,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _players.length,
              itemBuilder: (context, index) {
                final player = _players[index];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text(player.name),
                      subtitle: Text(player.team),
                      trailing: Text('${player.position}'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayerStatsPage(
                                playerId: player.id,
                              ),
                            ));
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
