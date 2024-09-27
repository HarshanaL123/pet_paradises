import 'package:flutter/material.dart';

class CategorySection extends StatelessWidget {
  final Function(String category) onCategoryTap;

  CategorySection({required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore Categories',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCategoryCard(context, 'Dog Supplies', 'images/category_dog.jpg'),
              _buildCategoryCard(context, 'Cat Supplies', 'images/category_cat.jpg'),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCategoryCard(context, 'Bird Supplies', 'images/category_birds.jpg'),
              _buildCategoryCard(context, 'Accessories', 'images/category_accessories.jpg'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String categoryTitle, String imagePath) {
    return GestureDetector(
      onTap: () {
        onCategoryTap(categoryTitle); // Trigger navigation when tapped
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              imagePath,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 120),
            ),
          ),
          SizedBox(height: 20),
          Text(
            categoryTitle,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
