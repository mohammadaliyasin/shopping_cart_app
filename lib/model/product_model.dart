class Product {
  final int id;
  final String title;
  final String image;
  final double price;
  final double discount;

  Product({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.discount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      image: json['thumbnail'],
      price: json['price'].toDouble(),
      discount: json['discountPercentage'].toDouble(),
    );
  }

  double get discountedPrice => price - (price * discount / 100);
}
