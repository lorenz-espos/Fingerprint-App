import 'package:fingerprint_app/api/local_auth_api.dart';
import 'package:fingerprint_app/main.dart';
import 'package:fingerprint_app/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class FingerprintPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(
                Icons.fingerprint_rounded,
              ),
              Text(MyApp.title),
              Icon(
                Icons.fingerprint_rounded,
              ),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // buildAvailability(context), //serve solo come check dei metodi disponibili sul device
                SizedBox(height: 24),
                buildAuthenticate(context), //bottone per l'autentificazione
              ],
            ),
          ),
        ),
      );

  Widget buildAvailability(BuildContext context) => buildButton(
        //verifica dei sistemi biometrici disponibili nel device
        text: 'Check Availability',
        icon: Icons.event_available,
        onClicked: () async {
          final isAvailable = await LocalAuthApi.hasBiometrics();
          final biometrics = await LocalAuthApi.getBiometrics();

          final hasFingerprint = biometrics.contains(BiometricType.fingerprint);

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Availability'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildText('Biometrics', isAvailable),
                  buildText('Fingerprint', hasFingerprint),
                ],
              ),
            ),
          );
        },
      );

  Widget buildText(String text, bool checked) => Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            checked
                ? Icon(Icons.check, color: Colors.green, size: 24)
                : Icon(Icons.close, color: Colors.red, size: 24),
            const SizedBox(width: 12),
            Text(text, style: TextStyle(fontSize: 24)),
          ],
        ),
      );

  Widget buildAuthenticate(BuildContext context) => buildButton(
        //bottone per l'autentificazione
        text: 'Authenticate',
        icon: Icons.fingerprint,
        onClicked: () async {
          final isAuthenticated = await LocalAuthApi.authenticate();

          if (isAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) =>
                      HomePage()), //mi porta alla hompage dopo il login
            );
          }
        },
      );

  Widget buildButton({
    @required String text,
    @required IconData icon,
    @required VoidCallback onClicked,
  }) =>
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(100),
        ),
        icon: Icon(icon, size: 56),
        label: Text(
          text,
          style: TextStyle(fontSize: 30),
        ),
        onPressed: onClicked,
      );
}
