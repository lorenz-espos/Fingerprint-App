import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

//classe che permette di usare i sistemi biometrici sul device
class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    //uso try catch per verificare se il device ha dei sistemi di sicurezza biometrica

    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }

  static Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      return <BiometricType>[];
      //BiometricType può essere di tipo face o di tipo fingerprint
    }
  }

  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;
    //uso un try catch per gestire eventuali errori di autentificazione
    try {
      return await _auth.authenticateWithBiometrics(
        localizedReason: 'Scan Fingerprint to Authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      return false;
    }
  }
}
