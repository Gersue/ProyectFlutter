import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Presupuesto',
      debugShowCheckedModeBanner: false, //Propiedad para quitar el banner del debug
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Gastos de Presupuestos'),
        ),
        body: Center(
          child: CapitalInputWidget(),
        ),
      ),
    );
  }
}

class CapitalInputWidget extends StatefulWidget {
  @override
  _CapitalInputWidgetState createState() => _CapitalInputWidgetState();
}

//Grafica
class MyPieChart extends StatelessWidget {
  final double capital;

  MyPieChart({required this.capital});

  @override
  Widget build(BuildContext context) {
    double a = capital;

    return Stack(
      children: [
        PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(title: 'A', color: Colors.blue),
            ],
          ),
          swapAnimationDuration: Duration(milliseconds: 150),
          swapAnimationCurve: Curves.linear,
        ),
        Center(
          child: Text(
            '\$$capital',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
//Fin Grafica

class SecondView extends StatelessWidget {
  final double capital;

  SecondView({required this.capital});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control de Presupuesto'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('Capital guardado: $capital'),
                ),
                SizedBox(height: 16),
                Container(
                  width: 200,
                  height: 200,
                  padding: EdgeInsets.all(16),
                  child: MyPieChart(capital: capital),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CapitalInputWidgetState extends State<CapitalInputWidget> {
  final TextEditingController _controller = TextEditingController();
  //Presencia ? con valores nullable
  double? _capital;
  //Ademas, este se utilizara para mandar mensajes de error cuando sea negativo o letras
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //Observemos en el TextField porque ahi es donde manejamos el error y hacemos el llamado a _saveCapital cuando presione el botton
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 200,
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Presupuesto',
                      errorText: _errorText,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    ),
                    controller: _controller,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      setState(() {
                        try {
                          _capital = double.parse(value);
                          if (_capital! < 0) {
                            _errorText = 'El capital debe ser positivo';
                          } else {
                            _errorText = null;
                          }
                        } catch (e) {
                          _errorText = 'Ingrese un número válido';
                        }
                      });
                    },
                    onSubmitted: (value) {
                      if (_capital != null && _capital! >= 0) {
                        _saveCapital();
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: _saveCapital,
                      child: Text('Guardar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//Si no es nulo o mayor o igual a 0 mandamos a llamas la segunda vista  con Navigator push
  void _saveCapital() {
    if (_capital != null && _capital! >= 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondView(capital: _capital!)),
      );
    }
  }

}