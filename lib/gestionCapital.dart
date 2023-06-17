//Estado del widget
import 'package:flutter/material.dart';

import 'gastos.dart';
import 'myPieChart.dart';

class SecondView extends StatefulWidget {
  final double capital;

  const SecondView({super.key, required this.capital});

  @override
  _SecondViewState createState() => _SecondViewState();
}

//Segunda vista
class _SecondViewState extends State<SecondView> {
  final TextEditingController textEditingController = TextEditingController();
  double gasto = 0.0;
  List<Gasto> listaGastos = [];
  bool reiniciar = false;
  late double saldo = 0.0;
  late double disponible;
  String tipo = '';

  int sumaLista(List<int> lista) {
    int suma = 0;
    for (int i = 0; i < lista.length; i++) {
      suma += lista[i];
    }
    return suma;
  }

  void calcularPorcentaje() {
    double monto = double.parse(textEditingController.text);
    if (monto > disponible) {
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
            child: SizedBox(
              width: 450,
              height: 300,
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
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                        nuevoTipos.clear();
                        nuevoTipos.add(value!);
                      }
                    },
                    value: nuevoTipos.isNotEmpty ? nuevoTipos[0] : null,
                    // Agregar esta línea
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
                              semanticLabel:
                              'Cualquier tipo de Entretenimiento',
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
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                if (nuevoNombre.isEmpty ||
                    nuevaCantidad == 0.0 ||
                    nuevoTipos.isEmpty) {
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

  void setGastos(String arg1, double arg2, List<String> arg3) {
    setState(() {
      listaGastos.add(Gasto(
        nombre: arg1,
        cantidad: arg2,
        tipos: arg3,
        estado: disponible <= arg2,
      ));
    });
  }

  Icon? iconos(String i) {
    if (i == 'Ahorrar') {
      return const Icon(
        Icons.money,
        color: Colors.green,
        size: 35.0,
        semanticLabel: 'Ahorros',
      );
    }
    if (i == 'Comida') {
      return const Icon(
        Icons.food_bank,
        color: Colors.orange,
        size: 35.0,
        semanticLabel: 'Cualquier tipo de Comida',
      );
    }
    if (i == 'Casa') {
      return const Icon(
        Icons.home,
        color: Colors.blue,
        size: 35.0,
        semanticLabel: 'Cualquier tipo de gasto en casa',
      );
    }
    if (i == 'Entretenimiento') {
      return const Icon(
        Icons.sports_esports,
        color: Colors.black,
        size: 35.0,
        semanticLabel: 'Cualquier tipo de Entretenimiento',
      );
    }
    if (i == 'Salud') {
      return const Icon(
        Icons.local_hospital,
        color: Colors.red,
        size: 35.0,
        semanticLabel: 'Cualquier gasto en salud',
      );
    }
    if (i == 'Gastos') {
      return const Icon(
        Icons.money,
        color: Colors.green,
        size: 35.0,
        semanticLabel: 'Cualquier tipo de Gasto',
      );
    }
    if (i == 'Suscripciones') {
      return const Icon(
        Icons.subscriptions,
        color: Colors.pink,
        size: 35.0,
        semanticLabel: 'Cualquier tipo de Suscripciones',
      );
    }
    return const Icon(
      Icons.payments,
      color: Colors.green,
      size: 35.0,
      semanticLabel: 'Cualquier tipo de Gasto',
    );
  }

  StatelessWidget? lista(String i, Gasto gasto) {
    var tipos = gasto.tipos.join(', ');

    if (i == tipos) {
      return ListTile(
        title: Text(gasto.nombre),
        subtitle: Text('Cantidad: ${gasto.cantidad}'),
        trailing: Text('Tipo: ${gasto.tipos.join(', ')}'),
        leading: iconos(gasto.tipos.join(', ')),
      );
    }

    if (i == 'Todos') {
      return ListTile(
        title: Text(gasto.nombre),
        subtitle: Text('Cantidad: ${gasto.cantidad}'),
        trailing: Text('Tipo: ${gasto.tipos.join(', ')}'),
        leading: iconos(gasto.tipos.join(', ')),
      );
    }
    if (i == '') {
      return ListTile(
        title: Text(gasto.nombre),
        subtitle: Text('Cantidad: ${gasto.cantidad}'),
        trailing: Text('Tipo: ${gasto.tipos.join(', ')}'),
        leading: iconos(gasto.tipos.join(', ')),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double totalGastado =
    sumaLista(listaGastos.map((e) => e.cantidad.toInt()).toList())
        .toDouble();
    disponible = widget.capital - totalGastado;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Control de Presupuesto'),
      ),
      body: SafeArea(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              fit: FlexFit.loose,
              flex: 1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ListTile(
                      minVerticalPadding: 0,
                      contentPadding: const EdgeInsets.all(1),
                      leading: const Icon(Icons.diamond_outlined, color: Colors.yellow, size: 30.0),
                      title: Text(
                        'Capital: ${widget.capital.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      minVerticalPadding: 0,
                      contentPadding: const EdgeInsets.all(1),
                      leading: const Icon(Icons.money_off, color: Colors.green, size: 30.0),
                      title: Text(
                        'Gasto: ${totalGastado.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      minVerticalPadding: 0,
                      contentPadding: const EdgeInsets.all(1),
                      leading: const Icon(Icons.payments, color: Colors.green, size: 30.0),
                      title: Text(
                        'Disponible: ${disponible.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
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
            DropdownButtonFormField<String>(
              onChanged: (value) {
                setState(() {
                  tipo = value!;
                });
              },
              value: 'Todos',
              decoration: const InputDecoration(
                labelText: 'Filtra por tipo de gasto',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Todos',
                  child: Row(
                    children: [
                      Icon(
                        Icons.align_horizontal_left,
                        color: Colors.cyan,
                        size: 24.0,
                        semanticLabel: 'Todos',
                      ),
                      Text('Todos'),
                    ],
                  ),
                ),
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: listaGastos.isEmpty
                    ? const Center(
                  child: Text(
                    "No hay Gastos",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                    : ListView.builder(
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
                      child: lista(tipo, gasto),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}