import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/csv_service.dart';
import '../models/prediction.dart';
import '../widgets/custom_dropdown.dart';

class ExportersScreen extends StatefulWidget {
  const ExportersScreen({super.key});

  @override
  State<ExportersScreen> createState() => _ExportersScreenState();
}

class _ExportersScreenState extends State<ExportersScreen> {
  String? selectedPais;
  int? selectedMes;
  Prediction? prediction;
  bool isLoading = false;
  String? errorMessage;

  final List<String> paises = [
    'colombia',
    'ecuador',
    'costa de marfil',
    'ghana',
  ];

  final List<int> meses = List.generate(12, (index) => index + 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predicción por País'),
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
              Card(
                color: const Color(0xFF6F4E37),
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                child: const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    'Predicción disponible solo para 2025',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CustomDropdown(
                label: 'País',
                value: selectedPais,
                items: paises.map((pais) {
                  return DropdownMenuItem(
                    value: pais,
                    child: Text(_capitalizeFirstLetter(pais), style: GoogleFonts.montserrat()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPais = value;
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
                              const Icon(Icons.location_on, color: Color(0xFFD9A066)),
                              const SizedBox(width: 8),
                              Text(
                                _capitalizeFirstLetter(prediction!.pais!),
                                style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.calendar_today, color: Color(0xFFD9A066)),
                              const SizedBox(width: 8),
                              Text(
                                '2025-${prediction!.mesNombre}',
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
                              Text(
                                '${prediction!.precioPredicho.toStringAsFixed(2)} USD/tonelada',
                                style: GoogleFonts.montserrat(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF6F4E37),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.currency_exchange, color: Color(0xFFD9A066)),
                              const SizedBox(width: 8),
                              Text(
                                _getPrecioCOPkg(prediction!.precioPredicho),
                                style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF6F4E37),
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
    return selectedPais != null && selectedMes != null && !isLoading;
  }

  Future<void> _generatePrediction() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      prediction = null;
    });

    try {
      final result = await CsvService.findExporterPrediction(
        selectedPais!,
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

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String _getPrecioCOPkg(double precioUsdTonelada) {
    // 1 tonelada = 1000 kg, ejemplo: 1 USD = 4200 COP
    const tasaCambio = 4200.0;
    final precioUsdKg = precioUsdTonelada / 1000.0;
    final precioCopKg = precioUsdKg * tasaCambio;
    return 'Equivalente: ${precioCopKg.toStringAsFixed(2)} COP/kg';
  }
} 