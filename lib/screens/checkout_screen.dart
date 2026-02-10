import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  // Burası çok önemli! Sepeti dışarıdan alacağımızı buraya tanımladık.
  final List<Map<String, dynamic>> basket;

  const CheckoutScreen({super.key, required this.basket});

  @override
  Widget build(BuildContext context) {
    // Sepetteki toplam fiyatı hesaplayalım
    double total = basket.fold(0, (sum, item) => sum + (item['price'] ?? 0));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hesap Özeti'),
        backgroundColor: Colors.orange,
      ),
      body: basket.isEmpty
          ? const Center(child: Text('Sepetiniz boş!'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: basket.length,
                    itemBuilder: (context, index) {
                      final item = basket[index];
                      return ListTile(
                        leading: const Icon(Icons.coffee),
                        title: Text(item['name'] ?? 'Ürün'),
                        subtitle: Text('${item['price']} TL'),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Toplam Tutar: ${total.toStringAsFixed(2)} TL',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
    );
  }
}