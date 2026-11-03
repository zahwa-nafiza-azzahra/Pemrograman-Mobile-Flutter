import 'package:belajarflutter/column_widget.dart';
import 'package:belajarflutter/hello_world.dart';
import 'package:belajarflutter/main.dart';
import 'package:belajarflutter/row_widget.dart';
import 'package:belajarflutter/ui/produk_form.dart';
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

  testWidgets('MyApp / ProdukPage ListView test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('List Data Produk'), findsOneWidget);
    expect(find.text('Kulkas'), findsOneWidget);
    expect(find.text('Playstation'), findsOneWidget);
    expect(find.text('Radio'), findsOneWidget);
  });
}
