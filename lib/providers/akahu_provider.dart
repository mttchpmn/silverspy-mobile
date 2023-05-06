import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AkahuCredentials {
  final String akahuId;
  final String accessToken;

  const AkahuCredentials({required this.akahuId, required this.accessToken});
}

class AkahuProvider {
  final String idKey = 'akahuId';
  final String tokenKey = 'akahuToken';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<AkahuCredentials> loadCredentials() async {
    final akahuId = await _storage.read(key: idKey);
    final accessToken = await _storage.read(key: tokenKey);

    return AkahuCredentials(akahuId: akahuId ?? "", accessToken: accessToken ?? "");
  }

  Future<void> saveCredentials(String id, String token) async {
    await _storage.write(key: idKey, value: id);
    await _storage.write(key: tokenKey, value: token);
  }
}
