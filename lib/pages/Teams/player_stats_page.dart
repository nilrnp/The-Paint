import 'package:flutter/material.dart';
import 'package:the_paint/components/player.dart';

class PlayerStatsPage extends StatelessWidget {
  final Player player;

  const PlayerStatsPage({required this.player});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${player.name}\n2022-2023 Season Stats',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            DataTable(
              columns: const [
                DataColumn(label: Text('Category')),
                DataColumn(label: Text('Stats')),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('Points')),
                  DataCell(Text((player.points / player.games).toString())),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Rebounds')),
                  DataCell(Text((player.rebounds / player.games).toString())),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Assists')),
                  DataCell(Text((player.assists / player.games).toString())),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Steals')),
                  DataCell(Text((player.steals / player.games).toString())),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Blocks')),
                  DataCell(Text((player.blocks / player.games).toString())),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Turnovers')),
                  DataCell(Text((player.turnovers / player.games).toString())),
                ]),
                DataRow(cells: [
                  const DataCell(Text('FG Percentage')),
                  DataCell(
                      Text((player.fgPercentage / player.games).toString())),
                ]),
                DataRow(cells: [
                  const DataCell(Text('3PT FG Percentage')),
                  DataCell(Text(
                      (player.threePtPercentage / player.games).toString())),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
