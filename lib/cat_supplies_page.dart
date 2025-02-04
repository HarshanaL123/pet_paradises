import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'nav_bar.dart';
import 'product_detail_page.dart';

class CatSuppliesPage extends StatefulWidget {
  final Function toggleTheme;

  CatSuppliesPage({required this.toggleTheme});

  @override
  _CatSuppliesPageState createState() => _CatSuppliesPageState();
}

class _CatSuppliesPageState extends State<CatSuppliesPage> {
  final String apiUrl = 'https://petsup.online/api/products';

  Future<List<dynamic>> fetchCatProducts() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> allProducts = jsonResponse['data'];
      return allProducts.where((product) => product['category'] == 'cat').toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cat Supplies',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.nightlight_round,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
            ),
            onPressed: () {
              widget.toggleTheme();
            },
          ),
        ],
        backgroundColor: Color(0xFF8B5E3C),
        toolbarHeight: 50,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchCatProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No cat supplies found.'));
          }

          final List<dynamic> catProducts = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildSectionTitle('Explore Our Products', context),
                ),
                isLandscape
                    ? _buildGridProductList(context, catProducts, screenWidth)
                    : _buildHorizontalProductList(context, catProducts),
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
      height: 280, // Adjusted height
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
    double cardWidth = 160; // Adjusted width
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
          childAspectRatio: cardWidth / 260, // Adjusted aspect ratio
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

  Widget _buildEnhancedProductCard(
      String imageUrl, String title, int price, String description, BuildContext context) {
    const double cardWidth = 160; // Adjusted width
    const double cardHeight = 260; // Adjusted height
    const double imageHeight = 140; // Adjusted image height

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
        width: cardWidth,
        height: cardHeight,
        margin: EdgeInsets.only(right: 16, bottom: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? Color(0xFF303030) : Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(15),
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
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Container(
                width: cardWidth,
                height: imageHeight,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 100),
                ),
              ),
            ),
            SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Container(
                height: cardHeight - imageHeight - 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 6),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.brown,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Rs. $price',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
