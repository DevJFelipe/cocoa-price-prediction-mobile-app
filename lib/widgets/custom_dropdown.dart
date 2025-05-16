import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final List<DropdownMenuItem<dynamic>> items;
  final dynamic value;
  final Function(dynamic) onChanged;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF6F4E37),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFEDEDED),
              border: Border.all(color: const Color(0xFFD9A066), width: 1.2),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withAlpha((0.07 * 255).toInt()),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<dynamic>(
                value: value,
                items: items,
                onChanged: onChanged,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF6F4E37)),
                style: GoogleFonts.montserrat(
                  color: const Color(0xFF6F4E37),
                  fontSize: 16,
                ),
                dropdownColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 