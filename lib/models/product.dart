class Product {
  final String id;
  final String name;
  final String image;
  final String category;
  final String description;
  final double price;
  int qty; 

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.description,
    required this.price,
    this.qty = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    String imageUrl = json['image_url'] ?? '';

    // Check if it's a Base64 data URI
    bool isDataUri = imageUrl.startsWith('data:');

    // If it's NOT a data URI and NOT an absolute URL, then it might be a relative path
    if (imageUrl.isNotEmpty && !isDataUri && !imageUrl.startsWith('http')) {
       if (imageUrl.startsWith('/')) {
           imageUrl = 'https://kazokuweb-production.up.railway.app$imageUrl';
       } else {
           imageUrl = 'https://kazokuweb-production.up.railway.app/$imageUrl';
       }
    }

    return Product(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      image: imageUrl,
      category: json['category'] != null ? json['category']['name'] : '',
    );
  }
}
