import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import '../models/prediction.dart';

class CsvService {
  static Future<List<Prediction>> loadGlobalPredictions() async {
    try {
      final rawData = await rootBundle.loadString('assets/pronostico_cacao_global_2025_2027.csv');
      List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);
      
      // Skip header row
      listData = listData.sublist(1);
      
      return listData.map((row) {
        return Prediction.fromGlobalCsv({
          'anio': row[0],
          'mes': row[1],
          'precio_predicho': row[2],
        });
      }).toList();
    } catch (e) {
      throw Exception('Error al cargar predicciones globales: $e');
    }
  }

  static Future<List<Prediction>> loadExportersPredictions() async {
    try {
      final rawData = await rootBundle.loadString('assets/predicciones_cacao_2025.csv');
      List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);
      
      // Skip header row
      listData = listData.sublist(1);
      
      return listData.map((row) {
        return Prediction.fromExportersCsv({
          'pais': row[0].toString().trim(),
          'anio': row[1],
          'mes': row[2],
          'precio_predicho': row[3],
        });
      }).toList();
    } catch (e) {
      throw Exception('Error al cargar predicciones de exportadores: $e');
    }
  }

  static Future<Prediction?> findGlobalPrediction(int anio, int mes) async {
    final predictions = await loadGlobalPredictions();
    return predictions.firstWhere(
      (p) => p.anio == anio && p.mes == mes,
      orElse: () => throw Exception('No se encontró predicción para el año $anio y mes $mes'),
    );
  }

  static Future<Prediction?> findExporterPrediction(String pais, int mes) async {
    final predictions = await loadExportersPredictions();
    return predictions.firstWhere(
      (p) => p.pais?.toLowerCase().trim() == pais.toLowerCase().trim() && p.mes == mes,
      orElse: () => throw Exception('No se encontró predicción para $pais en el mes $mes'),
    );
  }
} 