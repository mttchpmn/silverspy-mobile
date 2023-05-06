import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:silverspy/providers/akahu_provider.dart';

class AkahuAuthWidget extends StatefulWidget {
  const AkahuAuthWidget({Key? key}) : super(key: key);

  @override
  _AkahuAuthWidgetState createState() => _AkahuAuthWidgetState();
}

class _AkahuAuthWidgetState extends State<AkahuAuthWidget> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _accessTokenController = TextEditingController();

  final AkahuProvider _akahuProvider = AkahuProvider();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    var credentials = await _akahuProvider.loadCredentials();

    setState(() {
      _idController.text = credentials.akahuId;
      _accessTokenController.text = credentials.accessToken;
    });
  }

  Future<void> _saveCredentials() async {
    await _akahuProvider.saveCredentials(_idController.text, _accessTokenController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _idController,
            decoration: InputDecoration(
              labelText: 'Akahu ID',
            ),
            obscureText: !_isEditing,
            enabled: _isEditing,
          ),
          TextFormField(
            controller: _accessTokenController,
            decoration: InputDecoration(
              labelText: 'Akahu Access Token',
            ),
            obscureText: !_isEditing,
            enabled: _isEditing,
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });

              if (!_isEditing) {
                _saveCredentials();
              }
            },
            child: Text(_isEditing ? 'Save' : 'Edit'),
          ),
        ],
      ),
    );
  }
}
