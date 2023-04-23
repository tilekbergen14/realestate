class Post {
  final String id;
  final String title;
  final String location;
  final int price;
  final String description;
  final String ownerId;
  final String picture;
  final String type;

  Post({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.ownerId,
    required this.description,
    required this.picture,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'location': location,
        'price': price,
        'ownerId': ownerId,
        "picture": picture,
        "type": type,
      };

  static Post fromJson(Map<String, dynamic> json, String docid) {
    return Post(
      id: docid,
      title: json['title'],
      description: json['description'],
      location: json['location'],
      price: json['price'],
      ownerId: json['ownerId'],
      picture: json['picture'],
      type: json['type'],
    );
  }
}
