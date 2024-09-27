import 'package:flutter/material.dart';
import 'nav_bar.dart';
import 'footer.dart';
import 'dog_supplies_page.dart';
import 'cat_supplies_page.dart';
import 'bird_supplies_page.dart';
import 'accessories_page.dart';

class HomePage extends StatelessWidget {
  final Function toggleTheme;

  HomePage({required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    // Get the current brightness (light or dark mode)
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pet Paradise',
          style: TextStyle(
            fontSize: isLandscape ? 20 : 24, // Adjust font size based on orientation
            color: isDarkMode ? Colors.white : Colors.black, // Adjust color based on mode
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              size: isLandscape ? 24 : 28, // Adjust icon size based on orientation
            ),
            onPressed: () {
              toggleTheme(); // Toggle dark mode
            },
          ),
        ],
        backgroundColor: Color(0xFF8B5E3C),
        toolbarHeight: isLandscape ? 50 : 56, // Reduce height of the AppBar in landscape
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero image or promotional banner
            isLandscape ? _buildHeroSectionLandscape(isDarkMode) : _buildHeroSectionPortrait(isDarkMode),
            SizedBox(height: 20),

            // Category section with improved design
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: isLandscape ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                children: [
                  Text(
                    'Shop by Category',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: isDarkMode ? Colors.white : Colors.black, // Adjust color based on mode
                    ),
                    textAlign: isLandscape ? TextAlign.left : TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  _buildCategoryGrid(context, isLandscape, isDarkMode),
                ],
              ),
            ),
            SizedBox(height: 20),

            Divider(),
            Footer(),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(), // Bottom nav bar
    );
  }

  // Hero section or promotional banner for portrait mode
  Widget _buildHeroSectionPortrait(bool isDarkMode) {
    return Container(
      width: double.infinity,
      height: 220,  // Slightly larger in portrait
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/loginPage_img.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        color: Colors.black.withOpacity(0.4),
        child: Text(
          'Welcome to Pet Paradise!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Hero section or promotional banner for landscape mode
  Widget _buildHeroSectionLandscape(bool isDarkMode) {
    return Container(
      width: double.infinity,
      height: 180,  // Slightly smaller in landscape
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/loginPage_img.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        color: Colors.black.withOpacity(0.4),
        child: Text(
          'Welcome to Pet Paradise!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,  // Slightly smaller in landscape
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Category grid with dynamic layout for portrait and landscape
  Widget _buildCategoryGrid(BuildContext context, bool isLandscape, bool isDarkMode) {
    List<Map<String, String>> categories = [
      {'title': 'Dog Supplies', 'icon': 'images/category_dog.jpg'},
      {'title': 'Cat Supplies', 'icon': 'images/category_cat.jpg'},
      {'title': 'Bird Supplies', 'icon': 'images/category_birds.jpg'},
      {'title': 'Accessories', 'icon': 'images/category_accessories.jpg'},
    ];

    return GridView.builder(
      itemCount: categories.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isLandscape ? 3 : 2,  // Adjusted for orientation
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: isLandscape ? 1 : 0.8,  // Adjust for more square in landscape
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _navigateToCategoryPage(context, categories[index]['title']!);
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(categories[index]['icon']!, height: 80), // Icon image
                SizedBox(height: 10),
                Text(
                  categories[index]['title']!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black, // Adjust color based on mode
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Navigation to the respective category pages
  void _navigateToCategoryPage(BuildContext context, String category) {
    switch (category) {
      case 'Dog Supplies':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DogSuppliesPage(toggleTheme: toggleTheme)),
        );
        break;
      case 'Cat Supplies':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CatSuppliesPage(toggleTheme: toggleTheme)),
        );
        break;
      case 'Bird Supplies':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BirdSuppliesPage(toggleTheme: toggleTheme)),
        );
        break;
      case 'Accessories':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AccessoriesPage(toggleTheme: toggleTheme)),
        );
        break;
    }
  }
}
