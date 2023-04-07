import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:the_paint/components/api_constants.dart';
import 'package:the_paint/components/team.dart';
import 'package:the_paint/pages/Teams/players_page.dart';

class TeamsPage extends StatelessWidget {
  Future<List<Team>> _fetchTeams() async {
    final response = await http
        .get(Uri.parse('$API_BASE_URL/scores/json/teams?key=$API_KEY'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      final teams = data
          .map((team) => Team(
                key: team['Key'],
                name: team['Name'],
                city: team['City'],
              ))
          .toList();
      return teams;
    } else {
      throw Exception('Failed to fetch teams');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Team>>(
        future: _fetchTeams(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final teams = snapshot.data!;
            return ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
                return ListTile(
                  title: Text(team.name),
                  subtitle: Text(team.city),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PlayersPage(abbreviation: team.key),
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
