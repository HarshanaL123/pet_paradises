class CartItem {
  final String id;
  final String productName;
  final String imagePath;
  final int price;
  int quantity;

  CartItem({
    required this.id,
    required this.productName,
    required this.imagePath,
    required this.price,
    this.quantity = 1,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final product = json['product'];
    return CartItem(
      id: json['id'],
      productName: product['name'],
      imagePath: 'https://petsup.online/img/${product['image']}',
      price: int.parse(product['price']),
      quantity: int.parse(json['quantity'].toString()),
    );
  }
}