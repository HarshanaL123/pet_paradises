import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'services/checkout_service.dart';
import 'checkout_success_page.dart';

class CheckoutPage extends StatefulWidget {
  final int total;
  CheckoutPage({required this.total});
  
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _checkoutService = CheckoutService();
  bool _isLoading = false;
  bool _isSaveAddress = false;
  String _selectedPaymentMethod = 'cod';

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  
  // Card Controllers
  final _cardNumberController = TextEditingController();
  final _cardExpiryController = TextEditingController();
  final _cardCVVController = TextEditingController();
  final _cardHolderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        backgroundColor: Color(0xFF8B5E3C),
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFF8B5E3C)))
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildCheckoutHeader(),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildOrderSummary(),
                          SizedBox(height: 20),
                          _buildShippingForm(),
                          SizedBox(height: 20),
                          _buildPaymentSection(),
                          if (_selectedPaymentMethod == 'card') ...[
                            SizedBox(height: 20),
                            _buildCardDetailsForm(),
                          ],
                          SizedBox(height: 20),
                          _buildPaymentButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCheckoutHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF8B5E3C),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Order Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Complete your order',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return FadeInDown(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount:',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  Text(
                    'Rs. ${widget.total}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B5E3C),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShippingForm() {
    return FadeInUp(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shipping Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          _buildFormField(
            controller: _nameController,
            label: 'Full Name',
            icon: Icons.person,
            validator: (value) => 
              value?.isEmpty ?? true ? 'Please enter your name' : null,
          ),
          SizedBox(height: 16),
          _buildFormField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Please enter your email';
              if (!value!.contains('@')) return 'Please enter a valid email';
              return null;
            },
          ),
          SizedBox(height: 16),
          _buildFormField(
            controller: _phoneController,
            label: 'Phone Number',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: (value) => 
              value?.isEmpty ?? true ? 'Please enter your phone number' : null,
          ),
          SizedBox(height: 16),
          _buildFormField(
            controller: _addressController,
            label: 'Delivery Address',
            icon: Icons.location_on,
            maxLines: 3,
            validator: (value) => 
              value?.isEmpty ?? true ? 'Please enter your address' : null,
          ),
          SizedBox(height: 16),
          CheckboxListTile(
            value: _isSaveAddress,
            onChanged: (value) => setState(() => _isSaveAddress = value!),
            title: Text(
              'Save address for future orders',
              style: TextStyle(color: Colors.black),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: Color(0xFF8B5E3C),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return FadeInUp(
      delay: Duration(milliseconds: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                RadioListTile<String>(
                  title: Text(
                    'Cash on Delivery',
                    style: TextStyle(color: Colors.black),
                  ),
                  value: 'cod',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() => _selectedPaymentMethod = value!);
                  },
                  activeColor: Color(0xFF8B5E3C),
                ),
                Divider(height: 1),
                RadioListTile<String>(
                  title: Text(
                    'Card Payment',
                    style: TextStyle(color: Colors.black),
                  ),
                  value: 'card',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() => _selectedPaymentMethod = value!);
                  },
                  activeColor: Color(0xFF8B5E3C),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardDetailsForm() {
    return FadeInUp(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Card Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          _buildFormField(
            controller: _cardHolderController,
            label: 'Card Holder Name',
            icon: Icons.person_outline,
            validator: (value) => 
              _selectedPaymentMethod == 'card' && (value?.isEmpty ?? true) 
                ? 'Please enter card holder name' 
                : null,
          ),
          SizedBox(height: 16),
          _buildFormField(
            controller: _cardNumberController,
            label: 'Card Number',
            icon: Icons.credit_card,
            keyboardType: TextInputType.number,
            validator: (value) => 
              _selectedPaymentMethod == 'card' && (value?.isEmpty ?? true) 
                ? 'Please enter card number' 
                : null,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFormField(
                  controller: _cardExpiryController,
                  label: 'MM/YY',
                  icon: Icons.date_range,
                  validator: (value) => 
                    _selectedPaymentMethod == 'card' && (value?.isEmpty ?? true) 
                      ? 'Required' 
                      : null,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildFormField(
                  controller: _cardCVVController,
                  label: 'CVV',
                  icon: Icons.security,
                  obscureText: true,
                  validator: (value) => 
                    _selectedPaymentMethod == 'card' && (value?.isEmpty ?? true) 
                      ? 'Required' 
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.black),
      obscureText: obscureText,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[700]),
        prefixIcon: Icon(icon, color: Color(0xFF8B5E3C)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF8B5E3C)),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
      validator: validator,
    );
  }

  Widget _buildPaymentButton() {
    return FadeInUp(
      delay: Duration(milliseconds: 400),
      child: Container(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _processPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF8B5E3C),
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2,
          ),
          child: Text(
            'Place Order - Rs. ${widget.total}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final paymentData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'amount': widget.total,
        'payment_method': _selectedPaymentMethod,
        'save_address': _isSaveAddress,
        if (_selectedPaymentMethod == 'card') ...{
          'card_holder': _cardHolderController.text,
          'card_number': _cardNumberController.text,
          'card_expiry': _cardExpiryController.text,
          'card_cvv': _cardCVVController.text,
        },
      };

      final response = await _checkoutService.processPayment(paymentData);
      
      if (response['success'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CheckoutSuccessPage()),
        );
      } else {
        throw Exception(response['message'] ?? 'Payment failed');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pop(context); // Return to cart page
    } finally {
      setState(() => _isLoading = false);
    }
  }
}