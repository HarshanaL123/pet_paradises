import 'package:flutter/material.dart';
import 'nav_bar.dart';
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
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pet Paradise',
          style: TextStyle(
            fontSize: isLandscape ? 20 : 24,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              size: isLandscape ? 24 : 28,
            ),
            onPressed: () {
              toggleTheme();
            },
          ),
        ],
        backgroundColor: Color(0xFF8B5E3C),
        toolbarHeight: isLandscape ? 50 : 56,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            isLandscape ? _buildHeroSectionLandscape(isDarkMode) : _buildHeroSectionPortrait(isDarkMode),
            SizedBox(height: 20),

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
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    textAlign: isLandscape ? TextAlign.left : TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  _buildCategoryGrid(context, isLandscape, isDarkMode),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(),
    );
  }

  Widget _buildHeroSectionPortrait(bool isDarkMode) {
    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/loginPage_img.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        color: Colors.black.withOpacity(0.5),
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

  Widget _buildHeroSectionLandscape(bool isDarkMode) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/loginPage_img.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        color: Colors.black.withOpacity(0.5),
        child: Text(
          'Welcome to Pet Paradise!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

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
        crossAxisCount: isLandscape ? 3 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: isLandscape ? 1 : 0.8,
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
            shadowColor: Colors.black.withOpacity(0.4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    categories[index]['icon']!,
                    height: 90,
                    width: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  categories[index]['title']!,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
