import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:the_paint/components/api_constants.dart';
import 'package:the_paint/components/team.dart';
import 'package:the_paint/pages/Teams/players_page.dart';
import '../Registering/login_page.dart';

class TeamsPage extends StatefulWidget {
  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
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
      body: FutureBuilder<List<Team>>(
        future: _fetchTeams(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final teams = snapshot.data!;
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text(team.city),
                      subtitle: Text(team.name),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PlayersPage(abbreviation: team.key),
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
