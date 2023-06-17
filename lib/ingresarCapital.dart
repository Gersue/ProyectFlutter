//Widget de entrada de capital
import 'package:flutter/material.dart';

import 'gestionCapital.dart';

class CapitalInputWidget extends StatefulWidget {
  const CapitalInputWidget({super.key});

  @override
  _CapitalInputWidgetState createState() => _CapitalInputWidgetState();
}

//Clase inputCapital
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
    return Flexible(
      fit: FlexFit.tight,
      child: Center(
        child: SizedBox(
          width: 380,
          height: 200,
          child: Column(
            children: [
              const Text("Bienvenido", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
              Expanded(child: Card(
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
                            contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: _saveCapital,
                            child: const Text('Guardar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
            ],
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Debe ingresar un dato válido'),
          width: 228,
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
