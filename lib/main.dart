import 'package:flutter/material.dart';
import 'package:qr_code_scan/generate_qr.dart';
import 'package:qr_code_scan/scan_qr.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/scan': (context) => const ScanQR(),
        '/generate': (context) => const GenerateQR(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const Key _scanButtonKey = Key("ScanButtonMain");
  static const Key _generateButtonKey = Key("GenerateButtonMain");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              key: _scanButtonKey,
              onPressed: (){
                Navigator.of(context).pushNamed('/scan');
              },
              child: const Text('Scan QR',),
            ),
            const SizedBox(height: 40,),
            ElevatedButton(
              key: _generateButtonKey,
              onPressed: (){
                Navigator.of(context).pushNamed('/generate');
              },
              child: const Text('Generate QR',),
            ),
          ],
        ),
      ),
    );
  }
}