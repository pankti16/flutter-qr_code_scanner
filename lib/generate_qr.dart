import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQR extends StatefulWidget {
  const GenerateQR({super.key});

  @override
  State<GenerateQR> createState() => _GenerateQRState();
}

class _GenerateQRState extends State<GenerateQR> {
  late TextEditingController _inputController;
  String enteredText = "";

   @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate QR'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (enteredText.isNotEmpty)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10,),
                    QrImageView(data: enteredText, size: 200,),
                    const SizedBox(height: 30,),
                  ],
                ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30,),
                child: TextField(
                  controller: _inputController,
                  decoration: const InputDecoration(
                    labelText: "Enter text",
                    hintText: "Enter text",
                  ),
                  onSubmitted: (String value) async {
                    setState(() {
                      enteredText = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}