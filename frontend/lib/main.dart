import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 🔴 SCREENS
import 'screens/auth_screen.dart';
import 'screens/report_need_screen.dart';
import 'screens/needs_dashboard_screen.dart';
import 'screens/volunteer_match_screen.dart';
import 'screens/my_needs_screen.dart';

void main() {
  runApp(const VolunteerApp());
}

class VolunteerApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const VolunteerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Volunteer Coordination',
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}

//
// 🔴 AUTH GATE
//

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _loading = true;
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (!mounted) return;

    setState(() {
      _loggedIn = token != null && token.isNotEmpty;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return _loggedIn ? const MainShell() : const AuthScreen();
  }
}

//
// 🔴 MAIN APP (TABS)
//

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final List<Widget> _screens = const [
    NeedsDashboardScreen(),
    VolunteerMatchScreen(),
    ReportNeedScreen(),
    MyNeedsScreen(),
  ];

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');

    VolunteerApp.navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthGate()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Coordination'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') _logout();
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(
              icon: Icon(Icons.search), label: 'Match'),
          NavigationDestination(
              icon: Icon(Icons.add), label: 'Report'),
          NavigationDestination(
              icon: Icon(Icons.person), label: 'My Needs'),
        ],
      ),
    );
  }
}
