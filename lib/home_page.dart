import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:battery_plus/battery_plus.dart';
import 'nav_bar.dart';
import 'services/battery_service.dart';
import 'dog_supplies_page.dart';
import 'cat_supplies_page.dart';
import 'bird_supplies_page.dart';
import 'accessories_page.dart';

class HomePage extends StatefulWidget {
  final Function toggleTheme;
  final bool isAutoDarkMode;
 HomePage({required this.toggleTheme, required this.isAutoDarkMode});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BatteryService _batteryService = BatteryService();
  bool isLandscape = false;
  bool isDarkMode = false;
  int _batteryLevel = 0;
  BatteryState _batteryState = BatteryState.unknown;

  @override
  void initState() {
    super.initState();
    _loadBatteryInfo();
    _setupBatteryStateListener();
  }

  Future<void> _loadBatteryInfo() async {
    final level = await _batteryService.getBatteryLevel();
    setState(() => _batteryLevel = level);
  }

  void _setupBatteryStateListener() {
    _batteryService.getBatteryState().listen((state) {
      setState(() => _batteryState = state);
    });
  }

  @override
  Widget build(BuildContext context) {
    isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pet Paradise',
          style: TextStyle(
            fontSize: isLandscape ? 20 : 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: Colors.white,
              size: isLandscape ? 24 : 28,
            ),
            onPressed: () => widget.toggleTheme(),
          ),
        ],
        backgroundColor: Color(0xFF8B5E3C),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: isLandscape 
                ? _buildHeroSectionLandscape(isDarkMode) 
                : _buildHeroSectionPortrait(isDarkMode),
            ),
            _buildMainContent(context, isLandscape, isDarkMode),
            _buildAboutSection(context, isDarkMode),
            _buildHighlightsSection(context, isDarkMode),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(),
    );
  }

  Widget _buildBatteryStatus() {
    Color batteryColor = Colors.green;
    IconData batteryIcon = Icons.battery_full;

    if (_batteryLevel <= 20) {
      batteryColor = Colors.red;
      batteryIcon = Icons.battery_alert;
    } else if (_batteryLevel <= 50) {
      batteryColor = Colors.orange;
      batteryIcon = Icons.battery_4_bar;
    }

    String batteryStatus = 'Unknown';
    switch (_batteryState) {
      case BatteryState.charging:
        batteryStatus = 'Charging';
        break;
      case BatteryState.discharging:
        batteryStatus = 'Discharging'; 
        break;
      case BatteryState.full:
        batteryStatus = 'Full';
        break;
      default:
        batteryStatus = 'Unknown';
    }

    return FadeInDown(
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  batteryIcon,
                  color: batteryColor,
                  size: 24,
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Battery Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      batteryStatus,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: batteryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$_batteryLevel%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: batteryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSectionPortrait(bool isDarkMode) {
    return Container(
      height: 250,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'images/loginPage_img.jpg',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          Center(
            child: FadeInDown(
              duration: Duration(milliseconds: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pets, size: 60, color: Colors.white),
                  SizedBox(height: 20),
                  Text(
                    'Welcome to Pet Paradise!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSectionLandscape(bool isDarkMode) {
    return Container(
      height: 200,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              child: Image.asset(
                'images/loginPage_img.jpg',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          Center(
            child: FadeInDown(
              duration: Duration(milliseconds: 500),
              child: Text(
                'Welcome to Pet Paradise!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, bool isLandscape, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInUp(
            duration: Duration(milliseconds: 500),
            child: Text(
              'Shop by Category',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildCategoryGrid(context, isLandscape, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context, bool isDarkMode) {
    return FadeInUp(
      duration: Duration(milliseconds: 600),
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              'About Pet Paradise',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 15),
            Text(
              'We are your one-stop destination for all pet needs. With years of experience, we provide high-quality products and exceptional service to ensure your pets receive the best care possible.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                height: 1.5,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoCard('1000+', 'Products', Icons.inventory_2, isDarkMode),
                _buildInfoCard('500+', 'Happy Customers', Icons.people, isDarkMode),
                _buildInfoCard('50+', 'Brands', Icons.verified, isDarkMode),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String subtitle, IconData icon, bool isDarkMode) {
    return Column(
      children: [
        Icon(icon, color: Color(0xFF8B5E3C), size: 30),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildHighlightsSection(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why Choose Us',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 20),
          _buildHighlightCard(
            'Premium Quality',
            'We offer only the best products for your beloved pets',
            Icons.star,
            isDarkMode,
          ),
          _buildHighlightCard(
            'Fast Delivery',
            'Quick and reliable delivery to your doorstep',
            Icons.local_shipping,
            isDarkMode,
          ),
          _buildHighlightCard(
            'Expert Support',
            '24/7 customer support for all your pet care needs',
            Icons.support_agent,
            isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightCard(String title, String description, IconData icon, bool isDarkMode) {
    return FadeInUp(
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF8B5E3C).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Color(0xFF8B5E3C), size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
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

  Widget _buildCategoryGrid(BuildContext context, bool isLandscape, bool isDarkMode) {
    List<Map<String, String>> categories = [
      {'title': 'Dog Supplies', 'icon': 'images/category_dog.jpg'},
      {'title': 'Cat Supplies', 'icon': 'images/category_cat.jpg'},
      {'title': 'Bird Supplies', 'icon': 'images/category_birds.jpg'},
      {'title': 'Accessories', 'icon': 'images/category_accessories.jpg'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isLandscape ? 4 : 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return FadeInUp(
          delay: Duration(milliseconds: index * 100),
          child: GestureDetector(
            onTap: () => _navigateToCategoryPage(context, categories[index]['title']!),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Image.asset(
                      categories[index]['icon']!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        categories[index]['title']!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
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
          MaterialPageRoute(builder: (context) => DogSuppliesPage(toggleTheme: widget.toggleTheme)),
        );
        break;
      case 'Cat Supplies':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CatSuppliesPage(toggleTheme: widget.toggleTheme)),
        );
        break;
      case 'Bird Supplies':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BirdSuppliesPage(toggleTheme: widget.toggleTheme)),
        );
        break;
      case 'Accessories':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AccessoriesPage(toggleTheme: widget.toggleTheme)),
        );
        break;
    }
  }
}