import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final String _scheme = "demo";
  bool _isAuthenticated = false;
  late Auth0 auth;

  AuthProvider() {
    var domain = 'silverspy.au.auth0.com';
    var clientId = 's2DGlsupQOkcdhtm2KQqMdUVYIaLtcjN';

    auth = Auth0(domain, clientId);
    _checkIsAuthenticated();
  }

  Future<Credentials> getCredentials() async {
    return await auth.credentialsManager.credentials();
  }

  Future<void> login() async {
    await auth.webAuthentication(scheme: _scheme).login();

    await _checkIsAuthenticated();
  }

  void logout() async {
    await auth.webAuthentication(scheme: _scheme).logout();

    await _checkIsAuthenticated();
  }

  bool isAuthenticated() {
    return _isAuthenticated;
  }

  Future<void> _checkIsAuthenticated() async {
    _isAuthenticated = await auth.credentialsManager.hasValidCredentials();
    notifyListeners();
  }
}
