import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'global_screen.dart';
import 'exporters_screen.dart';

class SelectTypeScreen extends StatelessWidget {
  const SelectTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Tipo de Predicción'),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPredictionCard(
                context,
                'Predicción Global',
                'Ver predicciones globales del precio del cacao',
                Icons.public,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GlobalScreen(),
                  ),
                ),
                color: const Color(0xFF6F4E37),
              ),
              const SizedBox(height: 32),
              _buildPredictionCard(
                context,
                'Predicción Top Países Exportadores',
                'Ver predicciones por país exportador',
                Icons.location_on,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExportersScreen(),
                  ),
                ),
                color: const Color(0xFFD9A066),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPredictionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    required Color color,
  }) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color.withAlpha((0.12 * 255).toInt()),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Icon(
                  icon,
                  size: 40,
                  color: color,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF6F4E37),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 