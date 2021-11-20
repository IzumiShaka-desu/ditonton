import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

abstract class SecureClient {
  static Future<Client> getSecureClient() async {
    HttpClient client = HttpClient(context: await globalContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    return IOClient(client);
  }

  static Future<SecurityContext> get globalContext async {
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    try {
      final sslCert =
          await rootBundle.load('packages/core/certificates/certificate.pem');
      securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    } catch (e) {
      debugPrint(e.toString() + " ')}");
    }
    return securityContext;
  }
}
