import 'dart:convert';

import 'package:belajarflutter/column_widget.dart';
import 'package:belajarflutter/hello_world.dart';
import 'package:belajarflutter/helpers/api_url.dart';
import 'package:belajarflutter/helpers/app_exception.dart';
import 'package:belajarflutter/helpers/user_info.dart';
import 'package:belajarflutter/main.dart';
import 'package:belajarflutter/model/login.dart';
import 'package:belajarflutter/model/produk.dart';
import 'package:belajarflutter/model/registrasi.dart';
import 'package:belajarflutter/row_widget.dart';
import 'package:belajarflutter/ui/login_page.dart' as ui_login;
import 'package:belajarflutter/ui/produk_detail.dart';
import 'package:belajarflutter/ui/produk_form.dart';
import 'package:belajarflutter/ui/produk_page.dart';
import 'package:belajarflutter/ui/registrasi_page.dart';
import 'package:belajarflutter/widget/success_dialog.dart';
import 'package:belajarflutter/widget/warning_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
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

  test('Model JSON parsing test (Login, Registrasi, Produk)', () {
    final login = Login.fromJson({
      'code': 200,
      'status': true,
      'data': {
        'token': 'abc123token',
        'user': {'id': '1', 'email': 'admin@admin.com'}
      }
    });
    expect(login.code, 200);
    expect(login.token, 'abc123token');
    expect(login.userID, 1);
    expect(login.userEmail, 'admin@admin.com');

    final failedLogin = Login.fromJson({
      'code': 400,
      'status': false,
      'data': 'Email tidak ditemukan',
    });
    expect(failedLogin.code, 400);
    expect(failedLogin.status, false);
    expect(failedLogin.token, isNull);

    final reg = Registrasi.fromJson({
      'code': 200,
      'status': true,
      'data': 'Registrasi Berhasil',
    });
    expect(reg.data, 'Registrasi Berhasil');

    final produk = Produk.fromJson({
      'id': '1',
      'kode_produk': 'A001',
      'nama_produk': 'Kamera',
      'harga': '5000000',
    });
    expect(produk.id, 1);
    expect(produk.kodeProduk, 'A001');
    expect(produk.namaProduk, 'Kamera');
    expect(produk.hargaProduk, 5000000);
  });

  test('UserInfo, ApiUrl, and AppException helper tests', () async {
    SharedPreferences.setMockInitialValues({});
    final userInfo = UserInfo();
    await userInfo.setToken('tok-123');
    await userInfo.setUserID(42);
    expect(await userInfo.getToken(), 'tok-123');
    expect(await userInfo.getUserID(), 42);
    await userInfo.logout();
    expect(await userInfo.getToken(), isNull);
    expect(await userInfo.getUserID(), isNull);

    expect(ApiUrl.registrasi, 'http://10.0.2.2/toko-api/public/registrasi');
    expect(ApiUrl.login, 'http://10.0.2.2/toko-api/public/login');
    expect(ApiUrl.listProduk, 'http://10.0.2.2/toko-api/public/produk');
    expect(ApiUrl.createProduk, 'http://10.0.2.2/toko-api/public/produk');
    expect(ApiUrl.updateProduk(5), 'http://10.0.2.2/toko-api/public/produk/5/update');
    expect(ApiUrl.showProduk(5), 'http://10.0.2.2/toko-api/public/produk/5');
    expect(ApiUrl.deleteProduk(5), 'http://10.0.2.2/toko-api/public/produk/5');

    expect(FetchDataException('timeout').toString(),
        'Error During Communication: timeout');
    expect(BadRequestException('bad').toString(), 'Invalid Request: bad');
    expect(UnauthorisedException('401').toString(), 'Unauthorised: 401');
    expect(UnprocessableEntityException('422').toString(),
        'Unprocessable Entity: 422');
    expect(InvalidInputException('bad input').toString(),
        'Invalid Input: bad input');
  });

  testWidgets('MyApp opens LoginPage when not logged in',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(ui_login.LoginPage), findsOneWidget);
    expect(find.text('Registrasi'), findsOneWidget);
  });

  testWidgets('Modul 5 Registrasi, Login, and Logout end-to-end flow test',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    final mockClient = MockClient((request) async {
      if (request.url.path.endsWith('/registrasi')) {
        return http.Response(
          jsonEncode({
            'code': 200,
            'status': true,
            'data': 'Registrasi Berhasil',
          }),
          200,
        );
      }
      if (request.url.path.endsWith('/login')) {
        if (request.bodyFields['password'] == 'salah') {
          return http.Response(
            jsonEncode({
              'code': 400,
              'status': false,
              'data': 'Password tidak valid',
            }),
            200,
          );
        }
        return http.Response(
          jsonEncode({
            'code': 200,
            'status': true,
            'data': {
              'token': 'mock_token_xyz',
              'user': {'id': '1', 'email': 'admin@admin.com'}
            }
          }),
          200,
        );
      }
      if (request.url.path.endsWith('/produk') && request.method == 'GET') {
        return http.Response(
          jsonEncode({
            'code': 200,
            'status': true,
            'data': [
              {
                'id': '1',
                'kode_produk': 'A001',
                'nama_produk': 'Kulkas Polytron',
                'harga': '2000000',
              },
            ],
          }),
          200,
        );
      }
      return http.Response('Not Found', 404);
    });

    await http.runWithClient(() async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to RegistrasiPage and submit
      await tester.tap(find.text('Registrasi'));
      await tester.pumpAndSettle();
      expect(find.byType(RegistrasiPage), findsOneWidget);

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Nama'), 'Administrator');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'admin@admin.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'admin123');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Konfirmasi Password'),
          'admin123');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Registrasi'));
      await tester.pumpAndSettle();

      expect(find.byType(SuccessDialog), findsOneWidget);
      expect(find.text('Registrasi berhasil, silahkan login'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Back at LoginPage; test wrong password -> WarningDialog
      expect(find.byType(ui_login.LoginPage), findsOneWidget);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'admin@admin.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'salah');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      expect(find.byType(WarningDialog), findsOneWidget);
      expect(find.text('Login gagal, silahkan coba lagi'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Test valid password -> ProdukPage with API data
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'admin123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      expect(find.byType(ProdukPage), findsOneWidget);
      expect(find.text('Kulkas Polytron'), findsOneWidget);
      expect(await UserInfo().getToken(), 'mock_token_xyz');
      expect(await UserInfo().getUserID(), 1);

      // Test Drawer Logout
      final ScaffoldState scaffoldState =
          tester.firstState(find.byType(Scaffold));
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();

      expect(find.byType(ui_login.LoginPage), findsOneWidget);
      expect(await UserInfo().getToken(), isNull);
    }, () => mockClient);
  });

  testWidgets('Modul 5 CRUD Produk (List, Create, Update, Delete) flow test',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'token': 'mock_token', 'userID': 1});

    final List<Map<String, dynamic>> db = [
      {
        'id': '1',
        'kode_produk': 'A001',
        'nama_produk': 'Kulkas Polytron',
        'harga': '2000000',
      },
    ];

    final mockClient = MockClient((request) async {
      if (request.url.path.endsWith('/produk') && request.method == 'GET') {
        return http.Response(
          jsonEncode({'code': 200, 'status': true, 'data': db}),
          200,
        );
      }
      if (request.url.path.endsWith('/produk') && request.method == 'POST') {
        final newItem = {
          'id': '2',
          'kode_produk': request.bodyFields['kode_produk'],
          'nama_produk': request.bodyFields['nama_produk'],
          'harga': request.bodyFields['harga'],
        };
        db.add(newItem);
        return http.Response(
          jsonEncode({'code': 200, 'status': true, 'data': newItem}),
          200,
        );
      }
      if (request.url.path.endsWith('/produk/2/update') &&
          request.method == 'POST') {
        final idx = db.indexWhere((e) => e['id'] == '2');
        if (idx != -1) {
          db[idx] = {
            'id': '2',
            'kode_produk': request.bodyFields['kode_produk'],
            'nama_produk': request.bodyFields['nama_produk'],
            'harga': request.bodyFields['harga'],
          };
        }
        return http.Response(
          jsonEncode({'code': 200, 'status': true, 'data': db[idx]}),
          200,
        );
      }
      if (request.url.path.endsWith('/produk/2') && request.method == 'DELETE') {
        db.removeWhere((e) => e['id'] == '2');
        return http.Response(
          jsonEncode({'code': 200, 'status': true, 'data': true}),
          200,
        );
      }
      return http.Response('Not Found', 404);
    });

    await http.runWithClient(() async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(ProdukPage), findsOneWidget);
      expect(find.text('Kulkas Polytron'), findsOneWidget);

      // Create Produk
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.byType(ProdukForm), findsOneWidget);
      expect(find.text('TAMBAH PRODUK'), findsOneWidget);

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Kode Produk'), 'A002');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Nama Produk'), 'AC Panasonic');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Harga'), '3000000');

      await tester.tap(find.text('SIMPAN'));
      await tester.pumpAndSettle();

      expect(find.byType(ProdukPage), findsOneWidget);
      expect(find.text('AC Panasonic'), findsOneWidget);

      // Detail & Update Produk
      await tester.tap(find.text('AC Panasonic'));
      await tester.pumpAndSettle();
      expect(find.byType(ProdukDetail), findsOneWidget);
      expect(find.text('Kode : A002'), findsOneWidget);

      await tester.tap(find.text('EDIT'));
      await tester.pumpAndSettle();
      expect(find.text('UBAH PRODUK'), findsOneWidget);

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Nama Produk'), 'AC Sharp');
      await tester.tap(find.text('UBAH'));
      await tester.pumpAndSettle();

      expect(find.byType(ProdukPage), findsOneWidget);
      expect(find.text('AC Sharp'), findsOneWidget);

      // Detail & Delete Produk
      await tester.tap(find.text('AC Sharp'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('DELETE'));
      await tester.pumpAndSettle();

      expect(find.text('Yakin ingin menghapus data ini?'), findsOneWidget);
      await tester.tap(find.text('Ya'));
      await tester.pumpAndSettle();

      expect(find.byType(ProdukPage), findsOneWidget);
      expect(find.text('AC Sharp'), findsNothing);
    }, () => mockClient);
  });
}
