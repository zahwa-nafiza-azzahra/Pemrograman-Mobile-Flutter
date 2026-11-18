import 'package:flutter/material.dart';
import 'package:belajarflutter/helpers/user_info.dart';
import 'package:belajarflutter/ui/login_page.dart';
import 'package:belajarflutter/ui/produk_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = const Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );

  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    var token = await UserInfo().getToken();
    if (!mounted) return;
    if (token != null) {
      setState(() {
        page = const ProdukPage();
      });
    } else {
      setState(() {
        page = const LoginPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Kita',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.blue,
      ),
      home: page,
    );
  }
}
