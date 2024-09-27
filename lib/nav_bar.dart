import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final String activePage; // Track the active page

  Navbar({this.activePage = 'home'}); // Default to 'home'

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation; // Get the device orientation

    return BottomAppBar(
      color: Colors.brown, // Set a background color matching your theme
      shape: CircularNotchedRectangle(), // Rounded edges for a smoother look
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Use spaceAround to prevent overflow
        children: [
          _buildNavItem(context, Icons.home, 'Home', '/home', activePage == 'home', orientation),
          _buildNavItem(context, Icons.shopping_cart, 'Cart', '/cart', activePage == 'cart', orientation),
          _buildNavItem(context, Icons.person, 'Profile', '/profile', activePage == 'profile', orientation),
        ],
      ),
    );
  }

  // Helper method to build each navigation item
  Widget _buildNavItem(BuildContext context, IconData icon, String label, String route, bool isActive, Orientation orientation) {
    return SizedBox(
      height: orientation == Orientation.portrait ? 56.0 : 48.0, // Adjust the height based on orientation
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center items vertically
        children: [
          IconButton(
            icon: Icon(
              icon,
              size: orientation == Orientation.portrait ? 26 : 32, // Larger icon size in landscape
              color: isActive ? Colors.white : Colors.white70, // Active icon color
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, route);
            },
            splashColor: Colors.white24, // Ripple effect color
            tooltip: label, // Tooltip for better accessibility
          ),
        ],
      ),
    );
  }
}
