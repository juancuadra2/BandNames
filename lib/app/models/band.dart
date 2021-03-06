class Band {

  String id;
  String name;
  int votes;

  Band({
    this.id,
    this.name,
    this.votes
  });

  //Regresa una nueva instancia de la clase
  factory Band.fromMap(Map<String, dynamic> obj) => Band(
    id     : obj.containsKey('id') ? obj['id']     : 'no-id',
    name   : obj.containsKey('id') ? obj['name']   : 'no-name',
    votes  : obj.containsKey('id') ? obj['votes']  : 'no-votes',
  );

}