import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Presupuesto',
      debugShowCheckedModeBanner: false, //Propiedad para quitar el banner del debug
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
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

  const MyPieChart({super.key, required this.capital, required this.gasto});

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
              value: porcentaje.isNegative  ? porcentaje / 100 : porcentaje,
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
  double cantidad;
  List<String> tipos;

  Gasto({required this.nombre, required this.cantidad, required this.tipos});
}

class _SecondViewState extends State<SecondView> {
  final TextEditingController textEditingController = TextEditingController();
  double gasto = 0.0;
  List<Gasto> listaGastos = [];
  bool reiniciar = false;

  void calcularPorcentaje() {
    double monto = double.parse(textEditingController.text);
    if (monto > widget.capital) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('El gasto no puede superar el presupuesto disponible'),
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
                      nuevoTipos.add(value!);
                    }
                  },
                  value: nuevoTipos.isNotEmpty ? nuevoTipos[0] : null, // Agregar esta línea
                  decoration: const InputDecoration(
                    labelText: 'Tipo',
                  ),
                  items: const [
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
                if (nuevoNombre.isEmpty || nuevaCantidad == 0.0 || nuevoTipos.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Todos los campos son obligatorios'),
                      width: 200,
                      backgroundColor: Colors.red,
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

                  Navigator.of(context).pop();
                } else {
                  setState(() {
                    listaGastos.add(Gasto(nombre: nuevoNombre, cantidad: nuevaCantidad, tipos: nuevoTipos));
                  });
                  Navigator.of(context).pop();
                }
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Control de Presupuesto'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.money),
                  title: Text('Capital:  ${widget.capital} ', style: const TextStyle(fontSize: 20)),
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
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    mostrarModalAgregarGasto();
                  },
                  child: const Text("Agregar Gasto"),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: listaGastos.length,
                    itemBuilder: (BuildContext context, int index) {
                      Gasto gasto = listaGastos[index];
                      return Container(
                        color: Colors.greenAccent, // Establece el color de fondo deseado aquí
                        child: ListTile(
                          title: Text(gasto.nombre),
                          subtitle: Text('Cantidad: ${gasto.cantidad}'),
                          trailing: Text('Tipo: ${gasto.tipos.join(', ')}'),
                        ),
                      )
                      ;
                    },
                  ),
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
      child: SizedBox(
        width: 300,
        height: 200,
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.all(1.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.attach_money,
                    color: Colors.green, // Puedes establecer el color del icono aquí
                    size: 30, // Puedes ajustar el tamaño del icono aquí
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Presupuesto',
                      errorText: _errorText,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                    padding: const EdgeInsets.all(30.0),
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
