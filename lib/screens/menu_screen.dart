import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Map<String, dynamic>> sepet = [];
  double toplamTutar = 0.0;

  // Sepete ekleme ve isimleri birleştirme mantığı
  void sepeteEkle(String ad, double fiyat) {
    setState(() {
      sepet.add({'name': ad, 'price': fiyat});
      toplamTutar += fiyat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kafe Menüsü'),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Hata!'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;
          Map<String, List<QueryDocumentSnapshot>> gruplanmis = {};

          for (var doc in data.docs) {
            final urunVerisi = doc.data() as Map<String, dynamic>;
            String kategori = urunVerisi.containsKey('m_category') ? urunVerisi['m_category'] : 'Diğer';
            if (!gruplanmis.containsKey(kategori)) gruplanmis[kategori] = [];
            gruplanmis[kategori]!.add(doc);
          }

          return ListView.builder(
            itemCount: gruplanmis.keys.length,
            itemBuilder: (context, index) {
              String kategori = gruplanmis.keys.elementAt(index);
              var urunler = gruplanmis[kategori]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    color: Colors.orange.withOpacity(0.1),
                    child: Text(kategori.toUpperCase(), 
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
                  ),
                  ...urunler.map((urunDoc) {
                    var product = urunDoc.data() as Map<String, dynamic>;
                    double fiyat = double.tryParse(product['price'].toString()) ?? 0.0;
                    
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          (product['imageURL'] ?? '').toString().trim(), // Resim linkini temizle
                          width: 60, height: 60, fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) => const Icon(Icons.fastfood, size: 40),
                        ),
                      ),
                      title: Text(product['name'] ?? 'İsimsiz Ürün'),
                      subtitle: Text("$fiyat TL"),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.orange),
                        onPressed: () => sepeteEkle(product['name'] ?? 'Ürün', fiyat),
                      ),
                    );
                  }).toList(),
                ],
              );
            },
          );
        },
      ),
      // --- SEPETTE ÜRÜN İSİMLERİNİ GÖSTEREN ÇUBUK ---
    bottomNavigationBar: Container(
        padding: const EdgeInsets.all(15),
        color: Colors.orange,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (sepet.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "Sepettekiler: ${sepet.map((e) => e['name']).join(', ')}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${sepet.length} Ürün",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Toplam: ${toplamTutar.toStringAsFixed(2)} TL",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ); // Scaffold'un sonu
  } // build metodunun sonu
} // class'ın sonu