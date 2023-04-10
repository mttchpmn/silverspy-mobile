import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:silverspy/providers/auth_provider.dart';
import 'package:silverspy/views/login_page.dart';
import 'package:silverspy/views/transactions_overview_page.dart';

import 'dashboard_page.dart';
import 'transactions_page.dart';
// import 'payments_page.dart';
import 'payments_overview_page.dart';
import 'settings_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const TransactionsOverviewPage(),
    // const TransactionListPage(),
    const PaymentsOverviewPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthProvider>(context);
    var isLoggedIn = auth.isAuthenticated();

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return !isLoggedIn
            ? const LoginPage()
            : Scaffold(
                body: _pages[_currentIndex],
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  unselectedItemColor: Colors.black54,
                  selectedItemColor: Colors.deepPurple,
                  items: [
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.dashboard),
                      label: "Home",
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.payment),
                      label: "Transactions",
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.money),
                      label: "Payments",
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: "Settings",
                    ),
                  ],
                ),
              );
      },
    );
  }
}
