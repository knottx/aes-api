import 'package:aes/app/utils/aeseverywhere.dart';
import 'package:server_nano/server_nano.dart';

void main() {
  final server = Server();
  server.use(Helmet());
  server.use(Cors());

  server.post(
    '/encrypt',
    (req, res) async {
      String? encrypted;

      final payload = await req.payload().onError((error, stackTrace) => null);
      final text = payload?['text'];
      final passphrase = payload?['passphrase'];

      if (text != null && passphrase != null) {
        encrypted = Aes256.encrypt(text, passphrase);
      }

      return res.sendJson(
        {
          'encrypted': encrypted,
        },
      );
    },
  );

  server.post(
    '/decrypt',
    (req, res) async {
      String? decrypted;

      final payload = await req.payload().onError((error, stackTrace) => null);
      final encoded = payload?['encoded'];
      final passphrase = payload?['passphrase'];

      if (encoded != null && passphrase != null) {
        decrypted = Aes256.decrypt(encoded, passphrase);
      }

      return res.sendJson(
        {
          'decrypted': decrypted,
        },
      );
    },
  );

  server.listen(port: 3000);
}
