import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/csv_service.dart';
import '../models/prediction.dart';
import '../widgets/custom_dropdown.dart';

class GlobalScreen extends StatefulWidget {
  const GlobalScreen({super.key});

  @override
  State<GlobalScreen> createState() => _GlobalScreenState();
}

class _GlobalScreenState extends State<GlobalScreen> {
  int? selectedAnio;
  int? selectedMes;
  Prediction? prediction;
  bool isLoading = false;
  String? errorMessage;

  final List<int> anios = [2025, 2026, 2027];
  final List<int> meses = List.generate(12, (index) => index + 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predicción Global'),
        backgroundColor: const Color(0xFF6F4E37),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF5F3EE),
              Color(0xFFD9A066),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomDropdown(
                label: 'Año',
                value: selectedAnio,
                items: anios.map((anio) {
                  return DropdownMenuItem(
                    value: anio,
                    child: Text(anio.toString(), style: GoogleFonts.montserrat()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedAnio = value;
                    prediction = null;
                    errorMessage = null;
                  });
                },
              ),
              CustomDropdown(
                label: 'Mes',
                value: selectedMes,
                items: meses.map((mes) {
                  return DropdownMenuItem(
                    value: mes,
                    child: Text(_getMesNombre(mes), style: GoogleFonts.montserrat()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMes = value;
                    prediction = null;
                    errorMessage = null;
                  });
                },
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: _canGenerate() ? _generatePrediction : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD9A066),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                ),
                icon: const Icon(Icons.analytics, color: Colors.white),
                label: Text(
                  'Generar',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 28),
                  child: Card(
                    color: Colors.red[100],
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        errorMessage!,
                        style: GoogleFonts.montserrat(
                          color: Colors.red[900],
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              if (prediction != null)
                Padding(
                  padding: const EdgeInsets.only(top: 28),
                  child: Card(
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        children: [
                          Text(
                            'Predicción',
                            style: GoogleFonts.montserrat(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6F4E37),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.calendar_today, color: Color(0xFFD9A066)),
                              const SizedBox(width: 8),
                              Text(
                                '${prediction!.anio}-${prediction!.mesNombre}',
                                style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.attach_money, color: Color(0xFFD9A066)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${prediction!.precioPredicho.toStringAsFixed(2)} USD/tonelada',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF6F4E37),
                                    ),
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canGenerate() {
    return selectedAnio != null && selectedMes != null && !isLoading;
  }

  Future<void> _generatePrediction() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      prediction = null;
    });

    try {
      final result = await CsvService.findGlobalPrediction(
        selectedAnio!,
        selectedMes!,
      );
      setState(() {
        prediction = result;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _getMesNombre(int mes) {
    final meses = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return meses[mes - 1];
  }
}