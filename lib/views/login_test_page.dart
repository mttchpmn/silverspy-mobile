import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';

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
    // ...
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Column(
          children: [
            Text(_credentials?.accessToken ?? "No accessToken"),
            Center(
                child: _credentials == null
                    ? ElevatedButton(
                        onPressed: () async {
                          final credentials = await auth0
                              .webAuthentication(scheme: "demo")
                              .login();

                          setState(() {
                            _credentials = credentials;
                          });
                        },
                        child: const Text("Log in"))
                    : ElevatedButton(
                        onPressed: () async {
                          await auth0
                              .webAuthentication(scheme: "demo")
                              .logout();

                          setState(() {
                            _credentials = null;
                          });
                        },
                        child: const Text("Log out"))),
          ],
        ));
  }
}
