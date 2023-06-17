//Clase Gasto
class Gasto {
  String nombre;
  double cantidad;
  List<String> tipos;
  bool estado = false;

  Gasto(
      {required this.nombre,
        required this.cantidad,
        required this.tipos,
        this.estado = false});
}