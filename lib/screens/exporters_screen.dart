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
      backgroundColor: const Color(0xFFF5E9D7),
      appBar: AppBar(
        title: const Text('Predicción por País'),
        backgroundColor: const Color(0xFF8B5E3C),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF5E9D7), Color(0xFFEED7B2)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withAlpha(30),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5E3C),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.withAlpha(40),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'Predicción disponible solo para 2025',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
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
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _canGenerate() ? _generatePrediction : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD9A066),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 2,
                    ),
                    icon: const Icon(Icons.table_chart, size: 22),
                    label: Text(
                      'Generar',
                      style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                if (prediction != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 28),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.withAlpha(20),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Predicción',
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF8B5E3C),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Color(0xFFD9A066)),
                              const SizedBox(width: 8),
                              Text(
                                _capitalizeFirstLetter(prediction!.pais!),
                                style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, color: Color(0xFFD9A066)),
                              const SizedBox(width: 8),
                              Text(
                                '2025-${_getMesNombre(prediction!.mes)}',
                                style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
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
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF8B5E3C),
                                    ),
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.currency_exchange, color: Color(0xFFD9A066)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    _getPrecioCOPkg(prediction!.precioPredicho),
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF8B5E3C),
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
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Text(
                      errorMessage!,
                      style: GoogleFonts.montserrat(color: Colors.red[900], fontSize: 16, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF8B5E3C)),
                    label: Text(
                      'Volver a Selección de País',
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFF8B5E3C),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF8B5E3C),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
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