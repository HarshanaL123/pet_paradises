import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'nav_bar.dart';
import 'product_detail_page.dart';

class DogSuppliesPage extends StatefulWidget {
  final Function toggleTheme;

  DogSuppliesPage({required this.toggleTheme});

  @override
  _DogSuppliesPageState createState() => _DogSuppliesPageState();
}

class _DogSuppliesPageState extends State<DogSuppliesPage> {
  final String apiUrl = 'https://petsup.online/api/products';

  Future<List<dynamic>> fetchDogProducts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> allProducts = jsonResponse['data'];
        return allProducts
            .where((product) => product['category'] == 'dog')
            .toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      throw Exception('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dog Supplies'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.nightlight_round),
            onPressed: () {
              widget.toggleTheme();
            },
          ),
        ],
        backgroundColor: const Color(0xFF8B5E3C),
        toolbarHeight: 50,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchDogProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No dog supplies found.'));
          }

          final List<dynamic> dogProducts = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildSectionTitle('Explore Our Products', context),
                ),
                isLandscape
                    ? _buildGridProductList(context, dogProducts, screenWidth)
                    : _buildHorizontalProductList(context, dogProducts),
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
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
      ),
    );
  }

  Widget _buildHorizontalProductList(
      BuildContext context, List<dynamic> products) {
    return SizedBox(
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

  Widget _buildGridProductList(
      BuildContext context, List<dynamic> products, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 195 / 320,
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

  Widget _buildEnhancedProductCard(String imageUrl, String title, int price,
      String description, BuildContext context) {
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
        height: 220,
        margin: const EdgeInsets.only(right: 18, bottom: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF303030)
              : const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Container(
                width: 195,
                height: 95,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 120),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: 117,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.brown,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Rs. $price',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
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
