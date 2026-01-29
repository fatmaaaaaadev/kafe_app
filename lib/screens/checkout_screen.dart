import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const CheckoutScreen({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    // Toplam fiyatı hesaplıyoruz
    double total = items.fold(0, (sum, item) => sum + (item['price'] ?? 0));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hesap Özeti'),
        backgroundColor: Colors.orange,
      ),
      body: items.isEmpty
          ? const Center(child: Text('Sepetiniz boş!'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.flatware),
                        title: Text(items[index]['name'] ?? 'Ürün'),
                        trailing: Text('${items[index]['price']} TL'),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.orange.shade100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('TOPLAM TUTAR:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('${total.toStringAsFixed(2)} TL', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}