class Prediction {
  final String? pais;
  final int anio;
  final int mes;
  final double precioPredicho;

  Prediction({
    this.pais,
    required this.anio,
    required this.mes,
    required this.precioPredicho,
  });

  factory Prediction.fromGlobalCsv(Map<String, dynamic> map) {
    return Prediction(
      anio: int.parse(map['anio'].toString()),
      mes: int.parse(map['mes'].toString()),
      precioPredicho: double.parse(map['precio_predicho'].toString()),
    );
  }

  factory Prediction.fromExportersCsv(Map<String, dynamic> map) {
    return Prediction(
      pais: map['pais'].toString(),
      anio: int.parse(map['anio'].toString()),
      mes: int.parse(map['mes'].toString()),
      precioPredicho: double.parse(map['precio_predicho'].toString()),
    );
  }

  String get mesNombre {
    final meses = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return meses[mes - 1];
  }
} 