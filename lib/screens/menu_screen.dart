import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kafe_app/screens/checkout_screen.dart';
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // 🛒 1. Adım: Sepet listemizi burada tanımlıyoruz
  List<Map<String, dynamic>> basket = []; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kafe Menü'),
        backgroundColor: Colors.orange,
       actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context)=> CheckoutScreen(items: basket),
              ),
            );
          },
        ),
       ],
      
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Hata oluştu!'));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: const Icon(Icons.coffee),
                title: Text(data['name'] ?? 'Ürün'),
                subtitle: Text('${data['price']} TL'),
                // 🎯 2. Adım: İşte o "Sepete Ekle" butonu burada
                trailing: IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                  onPressed: () {
                    // 👇 Burası sihirli dokunuş
                    setState(() {
                      basket.add(data); // Ürünü listeye ekle
                    });
                    
                    // 👇 Ekranda "Sepete eklendi" yazısını çıkaran kod
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${data['name']} sepete eklendi!'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}