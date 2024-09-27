import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Pet Paradise\nWe are committed to offering high-quality pet products with convenience and care.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.brown[700], // Adds a branded color
            ),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildSocialIcon(Icons.facebook, Colors.blue, () {
                // Facebook action
              }),
              SizedBox(width: 20),
              _buildSocialIcon(Icons.camera_alt, Colors.pink, () {
                // Instagram action
              }),
              SizedBox(width: 20),
              _buildSocialIcon(Icons.ondemand_video, Colors.red, () {
                // YouTube action
              }),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                // Navigate to About Us Page
              },
              child: Text('About Us'),
              style: TextButton.styleFrom(foregroundColor: Colors.brown),
            ),
            Text(" | "), // Divider between the two links
            TextButton(
              onPressed: () {
                // Navigate to Contact Us Page
              },
              child: Text('Contact Us'),
              style: TextButton.styleFrom(foregroundColor: Colors.brown),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '© 2024 Pet Paradise. All rights reserved.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color, Function onPressed) {
    return IconButton(
      icon: Icon(icon),
      color: color,
      iconSize: 32, // Makes icons larger for better visibility
      onPressed: () {
        onPressed();
      },
    );
  }
}
