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
          title: const Text('Gastos de Presupuestos'),
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

  const MyPieChart({required this.capital, required this.gasto});

  @override
  Widget build(BuildContext context) {
    double porcentaje = (gasto / capital) * 100;

    return Center(
      child: Stack(
        children: [
          SizedBox(
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
                  'Gastado: ${porcentaje.toStringAsFixed(2)}%',
                style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
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
//Clase Gasto
class Gasto {
  String nombre;
  double monto;
  List<String> tipos;

  Gasto({required this.nombre, required this.monto, required this.tipos});
}

class _SecondViewState extends State<SecondView> {
  final TextEditingController textEditingController = TextEditingController();
  double gasto = 0.0;
  List<Gasto> listaGastos = [];
  bool reiniciar = false;

  void calcularPorcentaje() {
    double cantidad = double.parse(textEditingController.text);
    if (cantidad > widget.capital) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('El gasto no puede superar el presupuesto disponible'),
          width: 200,
          backgroundColor: Colors.indigo,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      setState(() {
        gasto += cantidad; // Suma el nuevo gasto al gasto total
        reiniciar = true;
      });
    }
  }

  void mostrarModalAgregarGasto() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String nuevoNombre = '';
        double nuevaCantidad = 0.0;
        List<String> nuevoTipos = [];

        return AlertDialog(
          title: Text('Agregar Gasto'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    nuevoNombre = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  onChanged: (value) {
                    nuevaCantidad = double.parse(value);
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Cantidad',
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  onChanged: (value) {
                    if (nuevoTipos.contains(value!)) {
                      nuevoTipos.remove(value);
                    } else {
                      nuevoTipos.add(value);
                    }
                  },
                  value: nuevoTipos.isNotEmpty ? nuevoTipos[0] : null, // Agregar esta línea
                  decoration: InputDecoration(
                    labelText: 'Tipo',
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'ahorro',
                      child: Text('Ahorro'),
                    ),
                    DropdownMenuItem(
                      value: 'comida',
                      child: Text('Comida'),
                    ),
                    DropdownMenuItem(
                      value: 'casa',
                      child: Text('Casa'),
                    ),
                    DropdownMenuItem(
                      value: 'ocio',
                      child: Text('Ocio'),
                    ),
                    DropdownMenuItem(
                      value: 'salud',
                      child: Text('Salud'),
                    ),
                    DropdownMenuItem(
                      value: 'gastos',
                      child: Text('Gastos'),
                    ),
                    DropdownMenuItem(
                      value: 'suscripciones',
                      child: Text('Suscripciones'),
                    )
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  Gasto nuevoGasto = Gasto(
                    nombre: nuevoNombre,
                    monto: nuevaCantidad, // Utiliza el campo monto en lugar de cantidad
                    tipos: nuevoTipos,
                  );
                  listaGastos.add(nuevoGasto);
                  gasto = listaGastos.fold(0, (total, gasto) => total + gasto.monto); // Suma los montos de la lista de gastos
                  reiniciar = false;
                });
                Navigator.of(context).pop();
              },
              child: Text('Agregar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double disponible = widget.capital - gasto; // Calcula la cantidad disponible restando el gasto de la capital

    return Scaffold(
      appBar: AppBar(
        title: Text('Control de Presupuesto'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text('Capital: ${widget.capital}'),
                  ),
                  ListTile(
                    title: Text('Disponible: $disponible'),
                  ),
                  ListTile(
                    title: Text('Gasto: $gasto'),
                  ),
                  SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        padding: EdgeInsets.all(16),
                        child: MyPieChart(capital: widget.capital, gasto: gasto),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 40),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(height: 16),
                              Visibility(
                                visible: reiniciar,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      gasto = 0.0;
                                      reiniciar = false;
                                    });
                                  },
                                  child: Text(
                                    "Reiniciar",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      mostrarModalAgregarGasto();
                    },
                    child: Text("Agregar Gasto"),
                  ),
                  SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: listaGastos.length,
                    itemBuilder: (BuildContext context, int index) {
                      Gasto gasto = listaGastos[index];
                      return Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          title: Text(gasto.nombre),
                          subtitle: Text('Cantidad: ${gasto.monto}'),
                          trailing: Text('Tipo: ${gasto.tipos.join(', ')}'),
                        ),
                      );
                    },
                  ),
                ],
              ),
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
