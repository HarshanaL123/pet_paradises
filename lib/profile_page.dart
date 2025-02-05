import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'nav_bar.dart';
import 'services/profile_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService _profileService = ProfileService();
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic> _userData = {};

  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _nameController.addListener(_onNameChanged);
  }

    @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    setState(() {
      _userData['name'] = _nameController.text;
    });
  }

  Future<void> _loadProfile() async {
    try {
      setState(() => _isLoading = true);
      final userData = await _profileService.getProfile();
      setState(() {
        _userData = userData;
        _nameController.text = userData['name'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showEditProfileDialog() {
    // Store original values in case of cancellation
    final originalName = _nameController.text;
    final originalEmail = _emailController.text;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profile'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Name is required' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Email is required';
                  if (!value!.contains('@')) return 'Enter valid email';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Restore original values on cancel
              _nameController.text = originalName;
              _emailController.text = originalEmail;
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  await _profileService.updateProfile(
                    _nameController.text,
                    _emailController.text,
                  );
                  Navigator.pop(context);
                  // Update UI immediately
                  setState(() {
                    _userData['name'] = _nameController.text;
                    _userData['email'] = _emailController.text;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Profile updated successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF8B5E3C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Password'),
        content: Form(
          key: _passwordFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => 
                  value?.isEmpty ?? true ? 'Current password is required' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'New password is required';
                  if (value!.length < 6) return 'Password must be at least 6 characters';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_passwordFormKey.currentState!.validate()) {
                try {
                  await _profileService.changePassword(
                    _currentPasswordController.text,
                    _newPasswordController.text,
                  );
                  Navigator.pop(context);
                  _currentPasswordController.clear();
                  _newPasswordController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password changed successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF8B5E3C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Change Password'),
          ),
        ],
      ),
    );
  }

@override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF8B5E3C)),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xFF8B5E3C), Color(0xFFD2B48C)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 60),
                    FadeInDown(
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, size: 60, color: Color(0xFF8B5E3C)),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    FadeInUp(
                      delay: Duration(milliseconds: 300),
                      child: Text(
                        _userData['name'] ?? 'User',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    FadeInUp(
                      delay: Duration(milliseconds: 400),
                      child: Text(
                        _userData['email'] ?? 'email@example.com',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildProfileStats(),
                _buildSettingsSection(),
                _buildLogoutButton(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Navbar(activePage: 'profile'),
    );
  }

  Widget _buildProfileStats() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: FadeInUp(
        delay: Duration(milliseconds: 500),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // children: [
          //   _buildStatCard('Orders', '0', Icons.shopping_bag),
          //   _buildStatCard('Reviews', '0', Icons.star),
          //   _buildStatCard('Points', '0', Icons.card_giftcard),
          // ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      width: 100,
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Color(0xFF8B5E3C), size: 28),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B5E3C),
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: FadeInUp(
        delay: Duration(milliseconds: 600),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSettingsTile(
                Icons.edit,
                'Edit Profile',
                'Update your personal information',
                _showEditProfileDialog,
              ),
              Divider(height: 1),
              _buildSettingsTile(
                Icons.lock,
                'Change Password',
                'Keep your account secure',
                _showChangePasswordDialog,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFF8B5E3C).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Color(0xFF8B5E3C)),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton() {
    return FadeInUp(
      delay: Duration(milliseconds: 700),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ElevatedButton.icon(
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          icon: Icon(Icons.logout),
          label: Text('Logout'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 2,
          ),
        ),
      ),
    );
  }
}