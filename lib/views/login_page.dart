import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:silverspy/components/full_width_button.dart';

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
          title: Text('Silverspy'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/logo-circle.png'),
                        width: 150,
                        height: 150,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Silverspy',
                        style: Theme.of(context).textTheme.headlineLarge,
                      )
                    ],
                  ),
                  SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Gain visibility into your finances',
                        style: Theme.of(context).textTheme.bodyMedium,
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
                        FullWidthButton(
                            label: "Log in",
                            onPressed: () async {
                              await auth.login();
                            }),
                        SizedBox(height: 8),
                        OutlinedButton(
                          style: ElevatedButton.styleFrom(
                              // backgroundColor: Colors.purple,
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
        ));
  }
}
