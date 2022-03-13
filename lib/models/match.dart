class Match {
  String id;
  String matchId;
  String matchTime;
  int perKill;
  int entryFee;
  String type;
  String map;
  int totalSlots;
  String matchStatus;
  List users;

  Match(
      {required this.id,
      required this.matchId,
      required this.matchTime,
      required this.perKill,
      required this.entryFee,
      required this.type,
      required this.map,
      required this.totalSlots,
      required this.matchStatus,
      required this.users});
}
