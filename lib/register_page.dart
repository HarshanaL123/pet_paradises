import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool _obscureText = true;

  void _register() {
    if (!_formKey.currentState!.validate()) return;

    // Navigate to login page
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF8B5E3C), Color(0xFFD2B48C)],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),

                    FadeInDown(
                      child: Column(
                        children: [
                          Icon(
                            Icons.pets,
                            size: 60,
                            color: Colors.white,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Create Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Join our pet paradise community',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 40),

                    FadeInUp(
                      child: Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: firstNameController,
                                style: TextStyle(color: Colors.black87),
                                validator: (value) => 
                                  value!.isEmpty ? 'Please enter first name' : null,
                                decoration: _inputDecoration(
                                  'First Name',
                                  Icons.person_outline,
                                ),
                              ),
                              SizedBox(height: 20),

                              TextFormField(
                                controller: lastNameController,
                                style: TextStyle(color: Colors.black87),
                                validator: (value) => 
                                  value!.isEmpty ? 'Please enter last name' : null,
                                decoration: _inputDecoration(
                                  'Last Name',
                                  Icons.person_outline,
                                ),
                              ),
                              SizedBox(height: 20),

                              TextFormField(
                                controller: emailController,
                                style: TextStyle(color: Colors.black87),
                                validator: (value) => !value!.contains('@') 
                                  ? 'Please enter valid email' : null,
                                decoration: _inputDecoration(
                                  'Email',
                                  Icons.email_outlined,
                                ),
                              ),
                              SizedBox(height: 20),

                              TextFormField(
                                controller: passwordController,
                                style: TextStyle(color: Colors.black87),
                                obscureText: _obscureText,
                                validator: (value) => value!.length < 6
                                  ? 'Password must be at least 6 characters' : null,
                                decoration: _inputDecoration(
                                  'Password',
                                  Icons.lock_outline,
                                ).copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureText 
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                      color: Color(0xFF8B5E3C),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),

                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                onPressed: () {
                                Navigator.pushReplacementNamed(context, '/');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF8B5E3C),
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text(
                                    'REGISTER',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    FadeInUp(
                      delay: Duration(milliseconds: 300),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(color: Colors.white70),
                            children: [
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[700]),
      prefixIcon: Icon(icon, color: Color(0xFF8B5E3C)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.grey[100],
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Color(0xFF8B5E3C)),
      ),
    );
  }
}