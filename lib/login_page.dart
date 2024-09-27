import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final Function toggleTheme;

  LoginPage({required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        backgroundColor: Color(0xFF8B5E3C), // Main theme color
        actions: [
          IconButton(
            icon: Icon(Icons.nightlight_round),
            onPressed: () {
              toggleTheme();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity, // Ensure the container takes full width
            height: MediaQuery.of(context).size.height, // Ensure container takes full height
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: Theme.of(context).brightness == Brightness.light
                    ? [Color(0xFFD2B48C), Color(0xFF8B5E3C)]
                    : [Color(0xFF8B5E3C), Color(0xFF5B3B2A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(26.0),
                child: Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: isLandscape ? _buildLandscapeLayout(context) : _buildPortraitLayout(context),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Portrait Layout
  Widget _buildPortraitLayout(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(),
        SizedBox(height: 20),
        _buildEmailField(),
        SizedBox(height: 16),
        _buildPasswordField(),
        SizedBox(height: 20),
        _buildLoginButton(context),
        SizedBox(height: 10),
        _buildRegisterLink(context),  // The registration link
      ],
    );
  }

  // Landscape Layout
  Widget _buildLandscapeLayout(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height, // Ensure full height in landscape
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildEmailField(),
                SizedBox(height: 16),
                _buildPasswordField(),
                SizedBox(height: 20),
                _buildLoginButton(context),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pets, size: 100, color: Color(0xFF8B5E3C)),
                SizedBox(height: 20),
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B5E3C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Common Widgets
  Widget _buildHeader() {
    return Text(
      'Welcome Back!',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color(0xFF8B5E3C),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: Icon(Icons.email),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: Icon(Icons.lock),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.brown,
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/home');
      },
      child: Text(
        'Login',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildRegisterLink(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/register');  // Navigates to RegisterPage when clicked
      },
      child: Text(
        'Don\'t have an account? Register',
        style: TextStyle(fontSize: 16, color: Color(0xFF8B5E3C)),
      ),
    );
  }
}
