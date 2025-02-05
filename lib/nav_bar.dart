import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:animate_do/animate_do.dart';
import 'services/battery_service.dart';

class Navbar extends StatefulWidget {
  final String activePage;
  Navbar({this.activePage = 'home'});

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  final BatteryService _batteryService = BatteryService();
  int _batteryLevel = 0;
  BatteryState _batteryState = BatteryState.unknown;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBatteryInfo();
    _setupBatteryStateListener();
  }

  Future<void> _loadBatteryInfo() async {
    try {
      final level = await _batteryService.getBatteryLevel();
      if (mounted) {
        setState(() {
          _batteryLevel = level;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading battery info: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _setupBatteryStateListener() {
    _batteryService.getBatteryState().listen(
      (state) {
        if (mounted) {
          setState(() => _batteryState = state);
        }
      },
      onError: (e) => print('Error in battery state listener: $e'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildBatteryStatus(isDarkMode, isSmallScreen),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF8B5E3C),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 8 : 16,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(child: _buildNavItem('Home', Icons.home_rounded, '/home')),
                  Expanded(child: _buildNavItem('Cart', Icons.shopping_cart_rounded, '/cart')),
                  Expanded(child: _buildNavItem('Profile', Icons.person_rounded, '/profile')),
                  Expanded(child: _buildNavItem('Contact', Icons.support_agent_rounded, '/contactus')),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBatteryStatus(bool isDarkMode, bool isSmallScreen) {
    if (_isLoading) {
      return SizedBox(height: 30);
    }

    Color batteryColor = Colors.green;
    IconData batteryIcon = Icons.battery_full;
    String status = '';

    if (_batteryLevel <= 20) {
      batteryColor = Colors.red;
      batteryIcon = Icons.battery_alert;
      status = 'Low';
    } else if (_batteryLevel <= 50) {
      batteryColor = Colors.orange;
      batteryIcon = Icons.battery_4_bar;
      status = 'Medium';
    } else {
      status = 'Good';
    }

    if (_batteryState == BatteryState.charging) {
      status = 'Charging';
    }

    return FadeInDown(
      duration: Duration(milliseconds: 500),
      child: Container(
        color: Color(0xFF8B5E3C),
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 8 : 16,
          vertical: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              batteryIcon,
              size: isSmallScreen ? 14 : 16,
              color: batteryColor,
            ),
            SizedBox(width: 4),
            Text(
              '$_batteryLevel%',
              style: TextStyle(
                fontSize: isSmallScreen ? 10 : 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 4),
            Text(
              '• $status',
              style: TextStyle(
                fontSize: isSmallScreen ? 10 : 12,
                color: Colors.white70,
              ),
            ),
            if (_batteryState == BatteryState.charging)
              Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.bolt,
                  size: isSmallScreen ? 14 : 16,
                  color: Colors.yellow,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String label, IconData icon, String route) {
    final bool isActive = widget.activePage == label.toLowerCase();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.pushReplacementNamed(context, route),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 24,
                color: isActive ? Colors.white : Colors.white70,
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isActive ? Colors.white : Colors.white70,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}