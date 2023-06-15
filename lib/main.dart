import 'package:flutter/material.dart';
import 'package:gastosfinancieros/router/router.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

// llamamos a nuestro router
final GoRouter _router = router();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Money Manager',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      // configuramos nuestro router para la app
      routerConfig: _router,
    );
  }
}