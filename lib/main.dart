import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final double gasto;

  MyPieChart({required this.capital, required this.gasto});

  @override
  Widget build(BuildContext context) {
    double porcentaje = (gasto / capital) * 100;

    return Center(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: CircularProgressIndicator(
              value: porcentaje / 100,
              strokeWidth: 10,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '${porcentaje.toStringAsFixed(2)}%',
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//Fin Grafica

class SecondView extends StatefulWidget {
  final double capital;

  SecondView({required this.capital});

  @override
  _SecondViewState createState() => _SecondViewState();
}

class _SecondViewState extends State<SecondView> {
  final TextEditingController textEditingController = TextEditingController();
  double gasto = 0.0;

  void calcularPorcentaje() {
    double monto = double.parse(textEditingController.text);
    if (monto > widget.capital) {
      //Mandar mensaje es como tipo alert
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('El gasto no puede superar el presupuesto disponible'),
            width: 200,
            backgroundColor: Colors.indigo,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      setState(() {
        gasto = monto;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control de Presupuesto'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      title: Text('Capital guardado: ${widget.capital}'),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.4,
                      padding: EdgeInsets.all(16),
                      child: MyPieChart(capital: widget.capital, gasto: gasto),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              child: TextFormField(
                                controller: textEditingController,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  hintText: "Ingrese un valor",
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                calcularPorcentaje();
                              },
                              child: const Text("Enviar"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ] ,
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
      child:  SizedBox(
        width: 300,
        height: 200,
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.all(16.0),
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
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: _saveCapital,
                      child: const Text('Guardar'),
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