import 'package:flutter/material.dart';
import 'package:belajarflutter/ui/produk_detail.dart';

class ProdukForm extends StatefulWidget {
  const ProdukForm({Key? key}) : super(key: key);

  @override
  _ProdukFormState createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _kodeProdukController = TextEditingController();
  final _namaProdukController = TextEditingController();
  final _hargaProdukController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Produk'),
      ), // AppBar
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            _textboxKodeProduk(),
            _textboxNamaProduk(),
            _textboxHarga(),
            _tombolSimpan()
          ],
        ), // Column
      ), // Container
    ); // Scaffold
  }

  _textboxKodeProduk() {
    return TextField(
      decoration: const InputDecoration(labelText: "Kode Produk"),
      controller: _kodeProdukController,
    ); // TextField
  }

  _textboxNamaProduk() {
    return TextField(
      decoration: const InputDecoration(labelText: "Nama Produk"),
      controller: _namaProdukController,
    ); // TextField
  }

  _textboxHarga() {
    return TextField(
      decoration: const InputDecoration(labelText: "Harga"),
      controller: _hargaProdukController,
    ); // TextField
  }

  _tombolSimpan() {
    return ElevatedButton(
      onPressed: () {
        String kodeProduk = _kodeProdukController.text;
        String namaProduk = _namaProdukController.text;
        int harga = int.tryParse(_hargaProdukController.text) ?? 0;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProdukDetail(
                  kodeProduk: kodeProduk,
                  namaProduk: namaProduk,
                  hargaProduk: harga,
                ))); // ProdukDetail // MaterialPageRoute
      },
      child: const Text('Simpan'),
    ); // ElevatedButton
  }
}

