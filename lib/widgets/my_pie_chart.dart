import 'package:flutter/material.dart';

class MyPieChart extends StatelessWidget {
  final double disponible;

  final double gasto;

  const MyPieChart({super.key, required this.disponible, required this.gasto});

  @override
  Widget build(BuildContext context) {
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
              value: porcentaje.isInfinite ? 0.0 : porcentaje / 100,
              strokeWidth: 10,
              color: progress(porcentaje / 100),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  '${porcentaje.isInfinite ? 0.0 : porcentaje.toStringAsFixed(1)}%',
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