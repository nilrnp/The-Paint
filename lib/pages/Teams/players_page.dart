import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:the_paint/components/api_constants.dart';
import 'package:the_paint/components/player.dart';
import 'package:the_paint/pages/Teams/player_stats_page.dart';
import 'package:the_paint/pages/Teams/teams_page.dart';
import '../Profile/profile_page.dart';
import '../Registering/login_page.dart';
import '../Search/search_page.dart';

class PlayersPage extends StatefulWidget {
  final String abbreviation;

  const PlayersPage({Key? key, required this.abbreviation}) : super(key: key);

  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  Future<List<Player>> _fetchPlayers() async {
    final response = await http.get(Uri.parse(
        '$API_BASE_URL/stats/json/PlayerSeasonStatsByTeam/2023/${widget.abbreviation}?key=$API_KEY'));
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
      body: FutureBuilder<List<Player>>(
        future: _fetchPlayers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final players = snapshot.data!;
            return ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text('${player.name}'),
                      subtitle: Text(player.position),
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
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
