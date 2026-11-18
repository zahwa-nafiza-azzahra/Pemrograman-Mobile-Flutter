class Produk {
  int? id;
  String? kodeProduk;
  String? namaProduk;
  int? hargaProduk;

  Produk({this.id, this.kodeProduk, this.namaProduk, this.hargaProduk});

  factory Produk.fromJson(Map<String, dynamic> obj) {
    return Produk(
      id: obj['id'] is int
          ? obj['id'] as int?
          : int.tryParse(obj['id'].toString()),
      kodeProduk: obj['kode_produk']?.toString(),
      namaProduk: obj['nama_produk']?.toString(),
      hargaProduk: obj['harga'] is int
          ? obj['harga'] as int?
          : int.tryParse(obj['harga'].toString()),
    );
  }
}
