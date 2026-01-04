class Todelist {
  final int? id;
  final String title;
  final String description;
  final String createdAt;


  Todelist({this.id, required this.title, required this.description ,required this.createdAt});

  Map<String, dynamic> Todemap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt,
      
    };
  }

  factory Todelist.fromMap(Map<String, dynamic> map) {
    return Todelist(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      createdAt: map['createdAt'],
      
    );
  }
}