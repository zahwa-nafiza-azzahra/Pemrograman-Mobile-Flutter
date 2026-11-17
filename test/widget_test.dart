import 'package:belajarflutter/column_widget.dart';
import 'package:belajarflutter/hello_world.dart';
import 'package:belajarflutter/main.dart';
import 'package:belajarflutter/model/login.dart';
import 'package:belajarflutter/model/produk.dart';
import 'package:belajarflutter/model/registrasi.dart';
import 'package:belajarflutter/row_widget.dart';
import 'package:belajarflutter/ui/login_page.dart' as ui_login;
import 'package:belajarflutter/ui/produk_form.dart';
import 'package:belajarflutter/ui/produk_page.dart';
import 'package:belajarflutter/ui/registrasi_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HelloWorld widget test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HelloWorld()));
    expect(find.text('Belajar Flutter'), findsOneWidget);
    expect(find.text('Hello World'), findsOneWidget);
  });

  testWidgets('ColumnWidget test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ColumnWidget()));
    expect(find.text('Widget Column'), findsOneWidget);
    expect(find.text('Kolom 1'), findsOneWidget);
    expect(find.text('Kolom 2'), findsOneWidget);
    expect(find.text('Kolom 3'), findsOneWidget);
    expect(find.text('Kolom 4'), findsOneWidget);
  });

  testWidgets('RowWidget test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RowWidget()));
    expect(find.text('Widget Row'), findsOneWidget);
    expect(find.text('Row 1'), findsOneWidget);
    expect(find.text('Row 2'), findsOneWidget);
    expect(find.text('Row 3'), findsOneWidget);
    expect(find.text('Row 4'), findsOneWidget);
  });

  test('Model JSON parsing test (Login, Registrasi, Produk)', () {
    final login = Login.fromJson({
      'code': 200,
      'status': true,
      'data': {
        'token': 'abc123token',
        'user': {'id': 1, 'email': 'admin@admin.com'}
      }
    });
    expect(login.code, 200);
    expect(login.token, 'abc123token');
    expect(login.userEmail, 'admin@admin.com');

    final reg = Registrasi.fromJson({
      'code': 200,
      'status': true,
      'data': 'Registrasi Berhasil',
    });
    expect(reg.data, 'Registrasi Berhasil');

    final produk = Produk.fromJson({
      'id': 1,
      'kode_produk': 'A001',
      'nama_produk': 'Kamera',
      'harga': 5000000,
    });
    expect(produk.kodeProduk, 'A001');
    expect(produk.namaProduk, 'Kamera');
    expect(produk.hargaProduk, 5000000);
  });

  testWidgets('Modul 4 LoginPage and RegistrasiPage navigation test',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ui_login.LoginPage()));
    expect(find.text('Login'), findsWidgets);
    expect(find.text('Registrasi'), findsOneWidget);

    await tester.tap(find.text('Registrasi'));
    await tester.pumpAndSettle();

    expect(find.byType(RegistrasiPage), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Nama'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Konfirmasi Password'),
        findsOneWidget);
  });

  testWidgets(
      'Modul 4 ProdukPage, ProdukDetail, and ProdukForm (Tambah & Ubah) test',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('List Produk'), findsOneWidget);
    expect(find.text('Kamera'), findsOneWidget);
    expect(find.text('Kulkas'), findsOneWidget);
    expect(find.text('Mesin Cuci'), findsOneWidget);

    // Tap '+' icon to open Tambah Produk form
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('TAMBAH PRODUK'), findsOneWidget);
    expect(find.text('SIMPAN'), findsOneWidget);

    // Go back to ProdukPage
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Tap 'Kamera' item to open ProdukDetail
    await tester.tap(find.text('Kamera'));
    await tester.pumpAndSettle();
    expect(find.text('Detail Produk'), findsOneWidget);
    expect(find.text('Kode : A001'), findsOneWidget);
    expect(find.text('Nama : Kamera'), findsOneWidget);
    expect(find.text('Harga : Rp. 5000000'), findsOneWidget);

    // Tap 'EDIT' button to open Ubah Produk form
    await tester.tap(find.text('EDIT'));
    await tester.pumpAndSettle();
    expect(find.text('UBAH PRODUK'), findsOneWidget);
    expect(find.text('UBAH'), findsOneWidget);
    expect(find.byType(ProdukForm), findsOneWidget);
  });
}
