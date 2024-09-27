import 'package:flutter/material.dart';
import 'footer.dart';
import 'nav_bar.dart';
import 'product_detail_page.dart';

class BirdSuppliesPage extends StatelessWidget {
  final Function toggleTheme;

  BirdSuppliesPage({required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bird Supplies',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.nightlight_round),
            onPressed: () {
              toggleTheme();
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
                  _buildSectionTitle('Bird Food', context),
                  SizedBox(height: 10),
                  isLandscape
                      ? _buildGridProductList(context, 'food', screenWidth)
                      : _buildHorizontalProductList(context, 'food', screenHeight), // Bird Food product list
                  SizedBox(height: 20),
                  _buildSectionTitle('Bird Medicine', context),
                  SizedBox(height: 10),
                  isLandscape
                      ? _buildGridProductList(context, 'medicine', screenWidth)
                      : _buildHorizontalProductList(context, 'medicine', screenHeight), // Bird Medicine product list
                ],
              ),
            ),
            Divider(),
            SizedBox(height: 10),
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
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white  // White text for dark mode
            : Colors.black,  // Black text for light mode
      ),
    );
  }

  // Horizontal scrolling Bird Food product list for portrait mode
  Widget _buildHorizontalProductList(BuildContext context, String category, double screenHeight) {
    List<Map<String, dynamic>> products = _getProducts(category);

    // Adjust the height dynamically to prevent overflow
    double containerHeight = screenHeight * 0.35; // Adjust based on screen size

    return Container(
      height: containerHeight, // Adjusted height to fit better
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
    double cardWidth = screenWidth / 3.2; // Adjusted for spacing in landscape mode

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Show 3 items per row in landscape mode
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: cardWidth / 270, // Adjusted for better fit in landscape
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
        {'image': 'images/bird_food_1.jpg', 'name': 'Tropical Fruit Mix', 'price': 3500},
        {'image': 'images/bird_food_2.jpg', 'name': 'Parakeet Food', 'price': 5400},
        {'image': 'images/bird_food_3.jpg', 'name': 'Canary Seed', 'price': 6000},
        {'image': 'images/bird_food_4.jpg', 'name': 'Cockatiel Mix', 'price': 1500},
      ];
    } else {
      return [
        {'image': 'images/bird_medicine_1.jpg', 'name': 'Avian Vet', 'price': 1200},
        {'image': 'images/bird_medicine_2.jpg', 'name': 'Beak and Nail Trimmer', 'price': 1500},
        {'image': 'images/bird_medicine_3.jpg', 'name': 'Feather Care Spray', 'price': 800},
        {'image': 'images/bird_medicine_4.jpg', 'name': 'VetRx for Birds', 'price': 1300},
      ];
    }
  }

  // Enhanced Product Card Widget for all products
  Widget _buildEnhancedProductCard(String imagePath, String title, int price, BuildContext context) {
    return Container(
      width: 160, // Reduced the width to fit within constraints
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
              aspectRatio: 1, // Ensures the image has equal width and height
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover, // Cover to prevent overflow
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
                    fontSize: 16, // Reduced font size to fit smaller card width
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white  // White text for dark mode
                        : Colors.black,  // Black text for light mode
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
    );
  }
}
