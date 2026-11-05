import 'package:belajarflutter/column_widget.dart';
import 'package:belajarflutter/hello_world.dart';
import 'package:belajarflutter/main.dart';
import 'package:belajarflutter/row_widget.dart';
import 'package:belajarflutter/ui/produk_form.dart';
import 'package:belajarflutter/ui/produk_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  testWidgets('ProdukForm and ProdukDetail navigation test',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProdukForm()));
    expect(find.text('Form Produk'), findsOneWidget);

    await tester.enterText(
        find.widgetWithText(TextField, 'Kode Produk'), 'A001');
    await tester.enterText(
        find.widgetWithText(TextField, 'Nama Produk'), 'Kulkas');
    await tester.enterText(find.widgetWithText(TextField, 'Harga'), '30000');

    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Detail Produk'), findsOneWidget);
    expect(find.text('Kode Produk : A001'), findsOneWidget);
    expect(find.text('Nama Produk : Kulkas'), findsOneWidget);
    expect(find.text('Harga Produk : 30000'), findsOneWidget);
  });

  testWidgets('ProdukPage ListView test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProdukPage()));
    expect(find.text('List Data Produk'), findsOneWidget);
    expect(find.text('Kulkas'), findsOneWidget);
    expect(find.text('Playstation'), findsOneWidget);
    expect(find.text('Radio'), findsOneWidget);
  });

  testWidgets('LoginPage, LocalStorage, HomePage, Sidemenu, and AboutPage test',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const MyApp());
    expect(find.text('Login'), findsWidgets);

    // Enter admin credentials
    await tester.enterText(
        find.widgetWithText(TextField, 'Masukkan Username'), 'admin');
    await tester.enterText(
        find.widgetWithText(TextField, 'Masukkan Password'), 'admin');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // Expect success dialog
    expect(find.text('Anda Berhasil Login'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Expect HomePage with saved username from SharedPreferences
    expect(find.text('Home Page'), findsOneWidget);
    expect(find.text('Ini adalah halaman User admin'), findsOneWidget);

    // Open Drawer (Sidemenu) and navigate to AboutPage
    final ScaffoldState state = tester.firstState(find.byType(Scaffold));
    state.openDrawer();
    await tester.pumpAndSettle();

    expect(find.text('Sidemenu'), findsOneWidget);
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    expect(find.text('About Page'), findsOneWidget);
    expect(find.text('Ini adalah halaman About'), findsOneWidget);
  });
}
