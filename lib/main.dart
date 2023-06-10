import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Presupuesto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Gastos de Presupuestos'),
        ),
        body: const CapitalInputWidget(),
      ),
    );
  }
}

class CapitalInputWidget extends StatefulWidget {
  const CapitalInputWidget({Key? key}) : super(key: key);

  @override
  _CapitalInputWidgetState createState() => _CapitalInputWidgetState();
}

class _CapitalInputWidgetState extends State<CapitalInputWidget> {
  late TextEditingController _controller;
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
          margin: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Presupuesto',
                      errorText: _errorText,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                    ),
                    controller: _controller,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                style: const TextStyle(
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
          title: const Text('Agregar Gasto'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    nuevoNombre = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (value) {
                    nuevaCantidad = double.parse(value);
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  onChanged: (value) {
                    if (nuevoTipos.contains(value!)) {
                      nuevoTipos.remove(value);
                    } else {
                      nuevoTipos.add(value);
                    }
                  },
                  value: nuevoTipos.isNotEmpty ? nuevoTipos[0] : null, // Agregar esta línea
                  decoration: const InputDecoration(
                    labelText: 'Tipo',
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: 'ahorro',
                      child: Text('Ahorro'),
                    ),
                    const DropdownMenuItem(
                      value: 'comida',
                      child: Text('Comida'),
                    ),
                    const DropdownMenuItem(
                      value: 'casa',
                      child: Text('Casa'),
                    ),
                    const DropdownMenuItem(
                      value: 'ocio',
                      child: Text('Ocio'),
                    ),
                    const DropdownMenuItem(
                      value: 'salud',
                      child: Text('Salud'),
                    ),
                    const DropdownMenuItem(
                      value: 'gastos',
                      child: Text('Gastos'),
                    ),
                    const DropdownMenuItem(
                      value: 'suscripciones',
                      child: const Text('Suscripciones'),
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
              child: const Text('Agregar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
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
        title: const Text('Control de Presupuesto'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
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
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        padding: const EdgeInsets.all(16),
                        child: MyPieChart(capital: widget.capital, gasto: gasto),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(height: 16),
                              Visibility(
                                visible: reiniciar,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      gasto = 0.0;
                                      reiniciar = false;
                                    });
                                  },
                                  child: const Text(
                                    "Reiniciar",
                                    style: const TextStyle(
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
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (disponible == 0 || disponible < 0) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Alerta'),
                              content: const Text('Ya no puedes agregar más gastos.'),
                              actions: [
                                ElevatedButton(
                                  child: const Text('Reiniciar'),
                                  onPressed: () {
                                    Navigator.popUntil(context, ModalRoute.withName('/')); // Vuelve a la primera vista
                                    setState(() {
                                      gasto = 0.0; // Reinicia el gasto
                                      listaGastos.clear(); // Borra los gastos ingresados
                                    });
                                  },
                                ),

                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        mostrarModalAgregarGasto();
                      }
                    },
                    child: const Text('Agregar Gasto'),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: listaGastos.length,
                    itemBuilder: (BuildContext context, int index) {
                      Gasto gasto = listaGastos[index];
                      return Container(
                        margin: const EdgeInsets.all(8.0),
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