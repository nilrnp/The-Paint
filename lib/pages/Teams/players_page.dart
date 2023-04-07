import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:the_paint/components/api_constants.dart';
import 'package:the_paint/components/player.dart';
import 'package:the_paint/pages/Teams/player_stats_page.dart';

class PlayersPage extends StatelessWidget {
  final String abbreviation;

  const PlayersPage({required this.abbreviation});

  Future<List<Player>> _fetchPlayers() async {
    final response = await http.get(Uri.parse(
        '$API_BASE_URL/stats/json/PlayerSeasonStatsByTeam/2022/$abbreviation?key=$API_KEY'));
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
                fgPercentage: player['FieldGoalsPercentage'],
                threePtPercentage: player['ThreePointersPercentage'],
                games: player['Games'],
              ))
          .toList();
      return players;
    } else {
      throw Exception('Failed to fetch players');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Player>>(
        future: _fetchPlayers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final players = snapshot.data!;
            return ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return ListTile(
                  title: Text('${player.name}'),
                  subtitle: Text(player.position),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayerStatsPage(player: player),
                        ));
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
