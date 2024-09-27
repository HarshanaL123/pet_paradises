import 'package:flutter/material.dart';
import 'footer.dart';
import 'nav_bar.dart';
import 'product_detail_page.dart';

class CatSuppliesPage extends StatelessWidget {
  final Function toggleTheme;

  CatSuppliesPage({required this.toggleTheme});

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
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white  // White text in dark mode
                  : Colors.black  // Black text in light mode
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.wb_sunny  // Sun icon in dark mode
                  : Icons.nightlight_round,  // Moon icon in light mode
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white  // White icon in dark mode
                  : Colors.black,  // Black icon in light mode
            ),
            onPressed: () {
              toggleTheme(); // Toggles theme
            },
          ),
        ],
        backgroundColor: Color(0xFF8B5E3C), // Primary theme color
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Cat Food', context),
                  SizedBox(height: 10),
                  isLandscape
                      ? _buildGridProductList(context, 'food', screenWidth)
                      : _buildHorizontalProductList(context, 'food'), // Cat Food product list
                  SizedBox(height: 30),
                  _buildSectionTitle('Cat Medicine', context),
                  SizedBox(height: 10),
                  isLandscape
                      ? _buildGridProductList(context, 'medicine', screenWidth)
                      : _buildHorizontalProductList(context, 'medicine'), // Cat Medicine product list
                ],
              ),
            ),
            Divider(thickness: 2),
            Footer(), // Footer Widget
          ],
        ),
      ),
      bottomNavigationBar: Navbar(), // Navigation Bar Widget
    );
  }

  // Method to Build Section Titles with Enhanced Styles
  Widget _buildSectionTitle(String title, BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white  // White text in dark mode
            : Color(0xFF8B5E3C), // Using the primary theme color in light mode
      ),
    );
  }

  // Horizontal scrolling Cat product list for portrait mode
  Widget _buildHorizontalProductList(BuildContext context, String category) {
    List<Map<String, dynamic>> products = _getProducts(category);
    return Container(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          return _buildEnhancedProductCard(
            products[index]['image'],
            products[index]['name'],
            products[index]['price'],
            context,
          );
        },
      ),
    );
  }

  // Grid-based product list for landscape mode with dynamic width adjustment
  Widget _buildGridProductList(BuildContext context, String category, double screenWidth) {
    List<Map<String, dynamic>> products = _getProducts(category);

    // Calculate card width to prevent overflow
    double cardWidth = screenWidth / 3.5; // Divide by 3.5 to leave space for padding/margins

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Show 3 items per row in landscape mode
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: cardWidth / 300, // Adjust based on the card width
      ),
      itemBuilder: (context, index) {
        return _buildEnhancedProductCard(
          products[index]['image'],
          products[index]['name'],
          products[index]['price'],
          context,
        );
      },
    );
  }

  // Product Data
  List<Map<String, dynamic>> _getProducts(String category) {
    if (category == 'food') {
      return [
        {'image': 'images/cat_food_1.jpg', 'name': 'Kitten Chaton', 'price': 800},
        {'image': 'images/cat_food_2.jpg', 'name': 'Hills Diet', 'price': 1100},
        {'image': 'images/cat_food_3.jpg', 'name': 'Pro Plan C', 'price': 1600},
        {'image': 'images/cat_food_4.jpg', 'name': 'Wellness CORE', 'price': 1200},
      ];
    } else {
      return [
        {'image': 'images/cat_medicine_1.jpg', 'name': 'Drontal', 'price': 700},
        {'image': 'images/cat_medicine_2.jpg', 'name': 'Zylkene', 'price': 950},
        {'image': 'images/cat_medicine_3.jpg', 'name': 'L-Lysine', 'price': 1200},
        {'image': 'images/cat_medicine_4.jpg', 'name': 'Check-up kit', 'price': 1350},
      ];
    }
  }

  // Enhanced Product Card Widget for all products
  Widget _buildEnhancedProductCard(String imagePath, String title, int price, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              imagePath: imagePath,
              productName: title,
              price: price,
              description: 'Premium product for your cat\'s health and well-being.',
            ),
          ),
        );
      },
      child: Container(
        width: 195,
        margin: EdgeInsets.only(right: 18),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Color(0xFF303030)  // Darker background for dark mode
              : Color(0xFFF9F9F9),  // Light background for light mode
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
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              child: AspectRatio(
                aspectRatio: 1, // Makes the image square for consistency
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 120),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white  // White text in dark mode
                          : Colors.black,  // Black text in light mode
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
                        fontSize: 16,
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
