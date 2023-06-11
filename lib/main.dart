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
  final double disponible ;
  final double gasto ;

  const MyPieChart({super.key, required this.disponible, required this.gasto});

  @override
  Widget build(BuildContext context) {
    //double porcentaje = gasto > 0.0 ?  disponible - gasto  : gasto;
    //double porcentaje  =   (disponible * gasto) / 100 ;
    var aux = (gasto / disponible) * 100;
    double porcentaje = aux.clamp(0, 100);

    Color progress(double i) {
      Color color;
      if (i >= 0.0 && i <= 0.25) {
        color = Colors.orange;
      } else if (i > 0.26 && i <= 0.50) {
        color = Colors.yellow;
      } else if (i > 0.51 && i <= 0.75) {
        color = Colors.green;
      } else if (i > 0.76 && i <= 0.99) {
        color = Colors.green;
      } else {
        color = Colors.blue;
      }
      return color;
    }

    return Center(
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CircularProgressIndicator(
              value:  porcentaje.isInfinite ? 0.0 : porcentaje / 100,
              strokeWidth: 10,
              color: progress(porcentaje / 100),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  'Gastado: ${porcentaje.isInfinite ? 0.0 : porcentaje.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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
  const SecondView({required this.capital});

  @override
  _SecondViewState createState() => _SecondViewState();
}
//Clase Gasto
class Gasto {
  String nombre;
  double cantidad;
  List<String> tipos;
  bool estado = false;
  Gasto({required this.nombre, required this.cantidad, required this.tipos, this.estado = false});
}

class _SecondViewState extends State<SecondView> {
  final TextEditingController textEditingController = TextEditingController();
  double gasto = 0.0;
  List<Gasto> listaGastos = [];
  bool reiniciar = false;
  late double saldo = 0.0;
   late double disponible;

  int sumaLista(List<int> lista) {
    int suma = 0;
    for (int i = 0; i < lista.length; i++) {
      suma += lista[i];
    }
    return suma;
  }

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
                      value: 'Ahorrar',
                      child: Row(
                        children: [
                          Icon(
                            Icons.money,
                            color: Colors.green,
                            size: 24.0,
                            semanticLabel: 'Ahorros',
                          ),
                          Text('Ahorrar'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Comida',
                      child: Row(
                        children: [
                          Icon(
                            Icons.food_bank,
                            color: Colors.orange,
                            size: 24.0,
                            semanticLabel: 'Cualquier tipo de Comida',
                          ),
                          Text('Comida'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Casa',
                      child: Row(
                        children: [
                          Icon(
                            Icons.home,
                            color: Colors.blue,
                            size: 24.0,
                            semanticLabel: 'Cualquier tipo de gasto en casa',
                          ),
                          Text('Casa'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Entretenimiento',
                      child: Row(
                        children: [
                          Icon(
                            Icons.sports_esports,
                            color: Colors.black,
                            size: 24.0,
                            semanticLabel: 'Cualquier tipo de Entretenimiento',
                          ),
                          Text('Entretenimiento'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Salud',
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_hospital,
                            color: Colors.red,
                            size: 24.0,
                            semanticLabel: 'Cualquier gasto en salud',
                          ),
                          Text('Salud'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Gastos',
                      child: Row(
                        children: [
                          Icon(
                            Icons.money,
                            color: Colors.green,
                            size: 24.0,
                            semanticLabel: 'Cualquier tipo de Gasto',
                          ),
                          Text('Gastos'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Suscripciones',
                      child: Row(
                        children: [
                        Icon(
                        Icons.subscriptions,
                        color: Colors.pink,
                        size: 24.0,
                        semanticLabel: 'Cualquier tipo de Suscripciones',
                      ),
                          Text('Suscripciones'),
                        ],
                      ),
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
                      width: 280,
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
                  setGastos(nuevoNombre, nuevaCantidad, nuevoTipos);
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

  void setGastos(String arg1, double arg2, List<String> arg3){
    setState(() {
      listaGastos.add(Gasto(
        nombre: arg1,
        cantidad: arg2,
        tipos: arg3,
        estado: disponible <= 0,
      ));
    });
  }

  Icon? iconos(String i){

    if(i == 'Ahorrar'){
      return const Icon(
        Icons.money,
        color: Colors.green,
        size: 35.0,
        semanticLabel: 'Ahorros',
      );}
    if(i == 'Comida'){
      return const Icon(
        Icons.food_bank,
        color: Colors.orange,
        size: 35.0,
        semanticLabel: 'Cualquier tipo de Comida',
      );}
    if(i == 'Casa'){
      return const Icon(
        Icons.home,
        color: Colors.blue,
        size: 35.0,
        semanticLabel: 'Cualquier tipo de gasto en casa',
      );}
    if(i == 'Entretenimiento'){
      return const Icon(
        Icons.sports_esports,
        color: Colors.black,
        size: 35.0,
        semanticLabel: 'Cualquier tipo de Entretenimiento',
      );}
    if(i == 'Salud'){
      return const Icon(
        Icons.local_hospital,
        color: Colors.red,
        size: 35.0,
        semanticLabel: 'Cualquier gasto en salud',
      );}
    if(i == 'Gastos'){
      return const Icon(
        Icons.money,
        color: Colors.green,
        size: 35.0,
        semanticLabel: 'Cualquier tipo de Gasto',
      );}
    if(i == 'Suscripciones'){
      return const Icon(
        Icons.subscriptions,
        color: Colors.pink,
        size: 35.0,
        semanticLabel: 'Cualquier tipo de Suscripciones',
      );}
    return const Icon(
      Icons.payments,
      color: Colors.green,
      size: 35.0,
      semanticLabel: 'Cualquier tipo de Gasto',
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalGastado = sumaLista(listaGastos.map((e) => e.cantidad.toInt()).toList()).toDouble();
    disponible = widget.capital - totalGastado;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Control de Presupuesto'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.diamond_outlined, color: Colors.yellow, size: 30.0),
                    title: Text('Capital:  ${widget.capital} ', style: const TextStyle(fontSize: 20)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.money_off, color: Colors.green, size: 30.0),
                    title: Text('Gasto:  $totalGastado ', style: const TextStyle(fontSize: 20)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.payments, color: Colors.green, size: 30.0),
                    title: Text('Disponible:  $disponible ', style: const TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        padding: const EdgeInsets.all(16),
                        child: MyPieChart(disponible: widget.capital, gasto: totalGastado),
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: listaGastos.length,
                        itemBuilder: (BuildContext context, int index) {
                          Gasto gasto = listaGastos[index];
                          return Container(
                            margin: const EdgeInsets.all(1.0),
                            foregroundDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: !gasto.estado ? Colors.greenAccent : Colors.red,
                                width: 1.0,
                              ),
                            ),
                            //color: !gasto.estado ? Colors.greenAccent : Colors.red, // Establece el color de fondo deseado aquí
                            child:  ListTile(
                              title: Text(gasto.nombre),
                              subtitle: Text('Cantidad: ${gasto.cantidad}'),
                              trailing: Text('Tipo: ${gasto.tipos.join(', ')}'),
                              leading: iconos(gasto.tipos.join(', ')),
                            ),
                          )
                          ;
                        },
                      ),
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
