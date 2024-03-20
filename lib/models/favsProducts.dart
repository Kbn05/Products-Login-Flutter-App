class FavProducts {
  final String id;
  final String name;
  final String image;
  final String owner;
  final String rating;

  FavProducts(
      {required this.id,
      required this.name,
      required this.image,
      required this.rating,
      required this.owner});

  factory FavProducts.fromJson(Map<String, dynamic> json) {
    return FavProducts(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      owner: json['description'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'owner': owner,
      'rating': rating,
    };
  }
}
