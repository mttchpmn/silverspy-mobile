import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:silverspy/components/atoms/full_width_button.dart';

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
        // appBar: AppBar(
        //   title: Text('Silverspy'),
        // ),
        body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(0.8, 1),
          colors: <Color>[
            Color(0xFFEF476F),
            Color(0xFF6F2DBD),
          ],
          // Gradient from https://learnui.design/tools/gradient-generator.html
          tileMode: TileMode.mirror,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Image(
                        image: AssetImage('assets/logo-gold.png'),
                        width: 175,
                        height: 175,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Silverspy',
                      // style: Theme.of(context).textTheme.headlineLarge,
                      style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Gain visibility into your finances',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      // style: Theme.of(context).textTheme.bodyMedium,
                    )
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF1B1B1E),
                            minimumSize: const Size.fromHeight(50)),
                        onPressed: () async {
                          await auth.login();
                        },
                        child: Text("Sign in"),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              width: 1.0,
                              color: Colors.white,
                              style: BorderStyle.solid,
                            ),
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(50)),
                        onPressed: () async {
                          await auth.login();
                        },
                        child: Text("Sign up"),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
