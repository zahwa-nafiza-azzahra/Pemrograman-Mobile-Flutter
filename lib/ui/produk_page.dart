import 'package:flutter/material.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({Key? key}) : super(key: key);

  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Data Produk'),
      ), // AppBar
      body: ListView(
        children: const [
          Card(
            child: ListTile(
              title: Text('Kulkas'),
              subtitle: Text('30000'),
            ), // ListTile
          ), // Card
          Card(
            child: ListTile(
              title: Text('Playstation'),
              subtitle: Text('30000'),
            ), // ListTile
          ), // Card
          Card(
            child: ListTile(
              title: Text('Radio'),
              subtitle: Text('30000'),
            ), // ListTile
          ) // Card
        ],
      ), // ListView
    ); // Scaffold
  }
}

