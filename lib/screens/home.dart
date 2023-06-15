import 'package:flutter/material.dart';

import '../providers/expense.dart';
import '../widgets/my_pie_chart.dart';

//Estado del widget
class Home extends StatefulWidget {
  final double capital;

  const Home({super.key, required this.capital});

  @override
  State<Home> createState() => _HomeState();
}

//Segunda vista
class _HomeState extends State<Home> {
  final TextEditingController textEditingController = TextEditingController();
  double gasto = 0.0;
  List<Expense> listaGastos = [];
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
          content:
          const Text('El gasto no puede superar el presupuesto disponible'),
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
        TextEditingController nombreController = TextEditingController();
        TextEditingController cantidadController = TextEditingController();
        nombreController.text = nuevoNombre;
        cantidadController.text = nuevaCantidad.toString();
        return OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            bool isPortrait = orientation == Orientation.portrait;
            return AlertDialog(
              title: isPortrait ? const Text('Agregar Gasto') : null,
              content: SingleChildScrollView(
                reverse: false,
                child: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isPortrait) const SizedBox(height: 16),
                      TextField(
                        controller: nombreController,
                        onChanged: (value) {
                          nuevoNombre = value;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: cantidadController,
                        onChanged: (value) {
                          nuevaCantidad = double.parse(value);
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Cantidad',
                        ),
                      ),
                      const SizedBox(height: 10),
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
                        decoration: const InputDecoration(
                          labelText: 'Tipo',
                          isDense: true,
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
                                  semanticLabel:
                                  'Cualquier tipo de gasto en casa',
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
                                  semanticLabel:
                                  'Cualquier tipo de Suscripciones',
                                ),
                                Text('Suscripciones'),
                              ],
                            ),
                          )
                        ],
                        isExpanded: true,
                        selectedItemBuilder: (BuildContext context) {
                          return nuevoTipos.map<Widget>((String value) {
                            return Text(value);
                          }).toList();
                        },
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
                          content:
                          const Text('Todos los campos son obligatorios'),
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
      },
    );
  }

  void setGastos(String arg1, double arg2, List<String> arg3) {
    setState(() {
      listaGastos.add(Expense(
        name: arg1,
        amount: arg2,
        types: arg3,
        state: disponible <= 0,
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

  StatelessWidget? lista(String i, Expense gasto) {
    var tipos = gasto.types.join(', ');

    if (i == tipos) {
      return ListTile(
        title: Text(gasto.name),
        subtitle: Text('Cantidad: ${gasto.amount}'),
        trailing: Text('Tipo: ${gasto.types.join(', ')}'),
        leading: iconos(gasto.types.join(', ')),
      );
    }

    if (i == 'Todos') {
      return ListTile(
        title: Text(gasto.name),
        subtitle: Text('Cantidad: ${gasto.amount}'),
        trailing: Text('Tipo: ${gasto.types.join(', ')}'),
        leading: iconos(gasto.types.join(', ')),
      );
    }
    if (i == '') {
      return ListTile(
        title: Text(gasto.name),
        subtitle: Text('Cantidad: ${gasto.amount}'),
        trailing: Text('Tipo: ${gasto.types.join(', ')}'),
        leading: iconos(gasto.types.join(', ')),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double totalGastado =
    sumaLista(listaGastos.map((e) => e.amount.toInt()).toList())
        .toDouble();
    disponible = widget.capital - totalGastado;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Control de Presupuesto'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final bool isHorizontal =
                      constraints.maxWidth > constraints.maxHeight;

                  if (isHorizontal) {
                    // Vista horizontal
                    return Column(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                                  children: [
                                    ListTile(
                                      minVerticalPadding: 0,
                                      contentPadding: const EdgeInsets.all(1),
                                      leading: const Icon(
                                          Icons.diamond_outlined,
                                          color: Colors.yellow,
                                          size: 30.0),
                                      title: Text('Capital: ${widget.capital}',
                                          style: const TextStyle(fontSize: 20)),
                                    ),
                                    ListTile(
                                      minVerticalPadding: 0,
                                      contentPadding: const EdgeInsets.all(1),
                                      leading: const Icon(Icons.money_off,
                                          color: Colors.green, size: 30.0),
                                      title: Text('Gasto: $totalGastado',
                                          style: const TextStyle(fontSize: 20)),
                                    ),
                                    ListTile(
                                      minVerticalPadding: 0,
                                      contentPadding: const EdgeInsets.all(1),
                                      leading: const Icon(Icons.payments,
                                          color: Colors.green, size: 30.0),
                                      title: Text('Disponible: $disponible',
                                          style: const TextStyle(fontSize: 20)),
                                    ),
                                  ],
                                ),
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 200,
                                    height: 200,
                                    padding: const EdgeInsets.all(16),
                                    child: MyPieChart(
                                        disponible: widget.capital,
                                        gasto: totalGastado),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 40, bottom: 40),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
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
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                mostrarModalAgregarGasto();
                              },
                              child: const Text("Agregar Gasto"),
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 320.0),
                              child: DropdownButtonFormField<String>(
                                onChanged: (value) {
                                  setState(() {
                                    tipo = value!;
                                  });
                                },
                                value: 'Todos',
                                decoration: const InputDecoration(
                                  labelText: 'Filtra por tipo de gasto',
                                ),
                                isExpanded: true,
                                items: [
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
                                          semanticLabel:
                                          'Cualquier tipo de Comida',
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
                                          semanticLabel:
                                          'Cualquier tipo de gasto en casa',
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
                                          semanticLabel:
                                          'Cualquier gasto en salud',
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
                                          semanticLabel:
                                          'Cualquier tipo de Gasto',
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
                                          semanticLabel:
                                          'Cualquier tipo de Suscripciones',
                                        ),
                                        Text('Suscripciones'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    // Vista vertical
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            // Establecer alineación en stretch
                            children: [
                              Expanded(
                                child: ListTile(
                                  minVerticalPadding: 0,
                                  contentPadding: const EdgeInsets.all(1),
                                  leading: const Icon(Icons.diamond_outlined,
                                      color: Colors.yellow, size: 30.0),
                                  title: Text('Capital: ${widget.capital}',
                                      style: const TextStyle(fontSize: 20)),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  minVerticalPadding: 0,
                                  contentPadding: const EdgeInsets.all(1),
                                  leading: const Icon(Icons.money_off,
                                      color: Colors.green, size: 30.0),
                                  title: Text('Gasto: $totalGastado',
                                      style: const TextStyle(fontSize: 20)),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  minVerticalPadding: 0,
                                  contentPadding: const EdgeInsets.all(1),
                                  leading: const Icon(Icons.payments,
                                      color: Colors.green, size: 30.0),
                                  title: Text('Disponible: $disponible',
                                      style: const TextStyle(fontSize: 20)),
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
                              child: MyPieChart(
                                  disponible: widget.capital,
                                  gasto: totalGastado),
                            ),
                            Container(
                              margin:
                              const EdgeInsets.only(top: 40, bottom: 40),
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
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 320.0),
                          child: DropdownButtonFormField<String>(
                            onChanged: (value) {
                              setState(() {
                                tipo = value!;
                              });
                            },
                            value: null,
                            decoration: const InputDecoration(
                              labelText: 'Filtra por tipo de gasto',
                            ),
                            isExpanded: true,
                            items: [
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
                                      semanticLabel:
                                      'Cualquier tipo de gasto en casa',
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
                                      semanticLabel:
                                      'Cualquier tipo de Suscripciones',
                                    ),
                                    Text('Suscripciones'),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  Expense gasto = listaGastos[index];
                                  return Container(
                                    margin: const EdgeInsets.all(1.0),
                                    foregroundDecoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      border: Border.all(
                                        color: !gasto.state
                                            ? Colors.greenAccent
                                            : Colors.red,
                                        // Establece el color de fondo deseado aquí
                                        width: 1.0,
                                      ),
                                    ),
                                    child: lista(tipo, gasto),
                                  );
                                },
                              )),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}