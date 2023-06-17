import 'package:flutter/material.dart';

import 'ingresarCapital.dart';

void main() {
  runApp(const MyApp());
}
//Clase principal
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capital Inicial',
      debugShowCheckedModeBanner: false,
      //Propiedad para quitar el banner del debug
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Money Manager'),
        ),
        body: const Center(
          child: CapitalInputWidget(),
        ),
      ),
    );
  }
}



