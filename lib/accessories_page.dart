import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'nav_bar.dart';
import 'product_detail_page.dart';

class AccessoriesPage extends StatefulWidget {
  final Function toggleTheme;

  AccessoriesPage({required this.toggleTheme});

  @override
  _AccessoriesPageState createState() => _AccessoriesPageState();
}

class _AccessoriesPageState extends State<AccessoriesPage> {
  final String apiUrl = 'https://petsup.online/api/products';

  Future<List<dynamic>> fetchAccessories() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> allProducts = jsonResponse['data'];

      return allProducts.where((product) => product['category'] == 'accessories').toList();
    } else {
      throw Exception('Failed to load accessories');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Accessories'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.nightlight_round),
            onPressed: () {
              widget.toggleTheme();
            },
          ),
        ],
        backgroundColor: Color(0xFF8B5E3C),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchAccessories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No accessories found.'));
          }

          final List<dynamic> accessories = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildSectionTitle('Explore Accessories', context),
                ),
                isLandscape
                    ? _buildGridProductList(context, accessories, screenWidth)
                    : _buildHorizontalProductList(context, accessories),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Navbar(),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildHorizontalProductList(BuildContext context, List<dynamic> products) {
    return Container(
      height: 320,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildEnhancedProductCard(
            product['image_url'],
            product['name'],
            int.parse(product['price']),
            product['description'],
            context,
          );
        },
      ),
    );
  }

  Widget _buildGridProductList(BuildContext context, List<dynamic> products, double screenWidth) {
    double cardWidth = 195;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: cardWidth / 320,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildEnhancedProductCard(
            product['image_url'],
            product['name'],
            int.parse(product['price']),
            product['description'],
            context,
          );
        },
      ),
    );
  }

  Widget _buildEnhancedProductCard(String imageUrl, String title, int price, String description, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              imagePath: imageUrl,
              productName: title,
              price: price,
              description: description,
            ),
          ),
        );
      },
      child: Container(
        width: 195,
        margin: EdgeInsets.only(right: 18),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? Color(0xFF303030) : Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 120),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.brown,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Rs. $price',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
