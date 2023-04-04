import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Credentials? _credentials;

  late Auth0 auth0;

  @override
  void initState() {
    super.initState();
    auth0 = Auth0('silverspy.au.auth0.com', 's2DGlsupQOkcdhtm2KQqMdUVYIaLtcjN');
  }

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Column(
          children: [
            Center(
                child: ElevatedButton(
                    onPressed: () async {
                      await auth.login();
                    },
                    child: const Text("Log in"))),
          ],
        ));
  }
}
