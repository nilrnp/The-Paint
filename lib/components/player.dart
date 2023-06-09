class Player {
  final int id;
  final String name;
  final String position;
  final String team;
  final double points;
  final double rebounds;
  final double assists;
  final double steals;
  final double blocks;
  final double turnovers;
  final double twoPointersAttempted;
  final double threePointersAttempted;
  final double twoPointersMade;
  final double threePointersMade;
  final double freeThrowsAttempted;
  final double freeThrowsMade;
  final int games;

  Player({
    required this.id,
    required this.name,
    required this.position,
    required this.team,
    required this.points,
    required this.rebounds,
    required this.assists,
    required this.steals,
    required this.blocks,
    required this.turnovers,
    required this.games,
    required this.twoPointersAttempted,
    required this.twoPointersMade,
    required this.threePointersAttempted,
    required this.threePointersMade,
    required this.freeThrowsAttempted,
    required this.freeThrowsMade,
  });
}
