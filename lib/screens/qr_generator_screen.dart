// lib/screens/qr_generator_screen.dart

import 'package:flutter/material.dart';
// Kendi sabitlerinizi ve fonksiyonlarınızı import ediyoruz
import '../data/table_data.dart'; 
import '../utils/url_generator.dart';
// Arkadaşınızın eklediği QR kod paketini import ediyoruz
import 'package:qr_flutter/qr_flutter.dart'; 

class QRGeneratorScreen extends StatelessWidget {
  const QRGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Kod Üreticisi'),
        backgroundColor: Colors.blueGrey, // AppBar'a renk ekleyelim
      ),
      body: ListView.builder(
        // TABLE_IDS listesindeki her eleman için bir satır oluştur
        itemCount: TABLE_IDS.length,
        itemBuilder: (context, index) {
          // Listenin o anki elemanını (masa ID'sini) al
          final tableId = TABLE_IDS[index];
          // Fonksiyonunuzu kullanarak QR kodunun verisini (URL'yi) oluştur
          final qrData = generateTableUrl(tableId);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            elevation: 4,
            child: ListTile(
              leading: QrImageView(
                data: qrData, // QR kodunun içindeki veri
                version: QrVersions.auto,
                size: 60.0, // Küçük bir QR kodu boyutu
                // QR kodu üretilemezse gösterilecek widget
                errorStateBuilder: (cxt, err) {
                  return const Center(child: Icon(Icons.error, color: Colors.red));
                },
              ),
              title: Text(
                'Masa: $tableId',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Link: ${qrData.substring(0, 30)}...', // URL'nin sadece bir kısmını gösterelim
                style: const TextStyle(color: Colors.grey),
              ),
              // Sağ tarafta basit bir ikon
              trailing: const Icon(Icons.qr_code_2_sharp),
            ),
          );
        },
      ),
    );
  }
}