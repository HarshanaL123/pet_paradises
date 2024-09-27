import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  final String imagePath;
  final String productName;
  final int price;
  final String description;

  ProductDetailPage({
    required this.imagePath,
    required this.productName,
    required this.price,
    required this.description,
  });

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1; // Initial quantity

  @override
  Widget build(BuildContext context) {
    // Get the orientation
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName),
        centerTitle: true,
        backgroundColor: Color(0xFF8B5E3C), // Main theme color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with rounded corners and shadow
              Center(
                child: Container(
                  height: orientation == Orientation.portrait ? 250 : 200, // Adjust height based on orientation
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      widget.imagePath,
                      fit: BoxFit.contain, // Ensures image fits within the container
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 150),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Product Title
              Text(
                widget.productName,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B5E3C), // Main theme color
                ),
              ),
              SizedBox(height: 10),

              // Price with larger font and emphasis
              Text(
                'Rs. ${widget.price}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              SizedBox(height: 10),

              // Divider to separate product details
              Divider(color: Color(0xFF8B5E3C).withOpacity(0.5), thickness: 1),

              // Product Description
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B5E3C), // Main theme color
                ),
              ),
              SizedBox(height: 8),
              Text(
                widget.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade800,
                  height: 1.5,
                ),
              ),

              SizedBox(height: 30),

              // Quantity Selector with plus/minus buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (quantity > 1) quantity--;
                      });
                    },
                    icon: Icon(Icons.remove, size: 24),
                    color: Color(0xFF8B5E3C),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      quantity.toString(),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                    icon: Icon(Icons.add, size: 24),
                    color: Color(0xFF8B5E3C),
                  ),
                ],
              ),

              SizedBox(height: 30),

              // Add to Cart Button with enhanced styling
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Add to cart logic
                  },
                  icon: Icon(Icons.shopping_cart, size: 20, color: Colors.white),
                  label: Text(
                    'Add to Cart',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Reduced padding
                    backgroundColor: Color(0xFF8B5E3C), // Main theme color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Slightly smaller radius for balance
                    ),
                    shadowColor: Colors.black26, // Subtle shadow for the button
                    elevation: 5, // Enhanced shadow effect
                  ),
                ),
              ),

              SizedBox(height: 20), // Reduced space after button
            ],
          ),
        ),
      ),
    );
  }
}
