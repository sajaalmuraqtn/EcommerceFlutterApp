class Product {
  final int? id;
  final String title;
  final String subTitle;
  final String description;
  final String image;
  final int price;
  final String category;
  bool isLiked;

  Product({
    this.id,
    required this.title,
    required this.subTitle,
    required this.description,
    required this.image,
    required this.price,
    required this.category,
    this.isLiked = false,
  });

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"],
        title: json["title"] ?? '',
        subTitle: json["subTitle"] ?? '',
        description: json["description"] ?? '',
        image: json["image"] ?? '',
        price: (json["price"] ?? 0).toInt(),
        category: json["category"] ?? '',
        isLiked: (json["isLiked"] ?? 0) == 1,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "subTitle": subTitle,
        "description": description,
        "image": image,
        "price": price,
        "category": category,
      };
}
