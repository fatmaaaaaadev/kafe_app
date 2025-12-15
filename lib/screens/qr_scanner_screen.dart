import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGeneratorScreen extends StatefulWidget {
  const QRGeneratorScreen({super.key});

  @override
  State<QRGeneratorScreen> createState() => _QRGeneratorScreenState();
}

class _QRGeneratorScreenState extends State<QRGeneratorScreen> {
  final TextEditingController _masaController = TextEditingController(
    text: '1',
  );
  String qrData = 'https://yourdomain.com/masa/1'; // Varsayılan URL

  @override
  void initState() {
    super.initState();
    _updateQrData();
  }

  void _updateQrData() {
    final masaNo = _masaController.text.trim();
    if (masaNo.isNotEmpty) {
      setState(() {
        // BURAYI KENDİ DOMAIN'İN İLE DEĞİŞTİR!
        // Örnek: Firebase Hosting kullanıyorsan: https://proje-adi.web.app/masa/1
        // Veya kendi domain: https://restoranadi.com/masa/1
        qrData = 'https://kafee-ff1fb.web.app/masa/$masaNo';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Masa QR Kod Üretici'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Masa numarası girişi
            TextField(
              controller: _masaController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Masa Numarası',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.table_bar),
              ),
              onChanged: (value) => _updateQrData(),
            ),
            const SizedBox(height: 40),

            // QR Kod gösterimi
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(77),
                    spreadRadius: 5,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 320,
                gapless: false,
              ),
            ),
            const SizedBox(height: 30),

            // QR içeriği metin
            SelectableText(
              qrData,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Bu QR kodu yazdırıp masalara yapıştırın.\nMüşteri tarayınca doğrudan o masanın menüsüne yönlenecek.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Kaydet/Yazdır butonu (şimdilik bilgi)
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'QR kod üretildi! Yazdırıp masalara yapıştırın.',
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.print),
              label: const Text('QR Kodunu Yazdır / Kaydet'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _masaController.dispose();
    super.dispose();
  }
}
