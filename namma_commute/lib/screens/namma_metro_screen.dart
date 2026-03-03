import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NammaMetroScreen extends StatefulWidget {
  const NammaMetroScreen({super.key});

  @override
  State<NammaMetroScreen> createState() => _NammaMetroScreenState();
}

class _NammaMetroScreenState extends State<NammaMetroScreen> {
  int _selectedLine = 0;

  final List<Map<String, dynamic>> _lines = [
    {
      'name': 'Purple Line',
      'route': 'Challaghatta ↔ Baiyappanahalli',
      'color': Color(0xFF7B2D8B),
      'stations': [
        'Challaghatta', 'Kengeri', 'Jnanabharathi', 'Rajarajeshwari Nagar',
        'Nayandahalli', 'Mysore Road', 'Deepanjali Nagar', 'Attiguppe',
        'Vijayanagar', 'Magadi Road', 'City Railway Station', 'Majestic',
        'Cubbon Park', 'MG Road', 'Trinity', 'Halasuru', 'Indiranagar',
        'Swami Vivekananda Road', 'Baiyappanahalli',
      ],
    },
    {
      'name': 'Green Line',
      'route': 'Nagasandra ↔ Silk Board',
      'color': Color(0xFF1D8348),
      'stations': [
        'Nagasandra', 'Dasarahalli', 'Jalahalli', 'Peenya Industry',
        'Peenya', 'Goraguntepalya', 'Yeshwanthpur', 'Sandal Soap Factory',
        'Mahalakshmi', 'Rajajinagar', 'Kuvempu Road', 'Srirampura',
        'Mantri Square Sampige Road', 'Majestic', 'Sir MV', 'Vidhana Soudha',
        'Cubbon Park', 'Shivaji Nagar', 'Ulsoor', 'Halasuru', 'Indiranagar',
        'Domlur', 'Swami Vivekananda Road', 'Baiyappanahalli',
      ],
    },
  ];

  final List<Map<String, dynamic>> _nextTrains = [
    {'station': 'MG Road → Majestic', 'time': '3 min', 'status': 'On Time'},
    {'station': 'Indiranagar → Byappanahalli', 'time': '7 min', 'status': 'On Time'},
    {'station': 'Yeshwanthpur → Majestic', 'time': '5 min', 'status': '2 min late'},
  ];

  @override
  Widget build(BuildContext context) {
    final line = _lines[_selectedLine];
    final lineColor = line['color'] as Color;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: Column(
        children: [
          _buildHeader(line, lineColor),
          _buildLineSelector(lineColor),
          _buildNextTrains(lineColor),
          Expanded(child: _buildStationList(line, lineColor)),
        ],
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> line, Color lineColor) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            lineColor.withOpacity(0.3),
            const Color(0xFF0F0F1A),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Namma Metro',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                line['route'] as String,
                style: TextStyle(color: lineColor, fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _statBox('28', 'Stations', lineColor),
                  const SizedBox(width: 12),
                  _statBox('42 km', 'Distance', lineColor),
                  const SizedBox(width: 12),
                  _statBox('5-8 min', 'Frequency', lineColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statBox(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w900)),
            Text(label,
                style: TextStyle(color: Colors.white38, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildLineSelector(Color lineColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: List.generate(_lines.length, (i) {
          final l = _lines[i];
          final isSelected = _selectedLine == i;
          final c = l['color'] as Color;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedLine = i),
              child: Container(
                margin: EdgeInsets.only(right: i == 0 ? 8 : 0),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? c.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? c : Colors.white.withOpacity(0.08),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  l['name'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? c : Colors.white38,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNextTrains(Color lineColor) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF16162A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🚇 Next Trains',
              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          ..._nextTrains.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(t['station'] as String,
                          style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ),
                    Text(
                      t['time'] as String,
                      style: TextStyle(
                        color: lineColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: t['status'] == 'On Time'
                            ? const Color(0xFF00C9A7).withOpacity(0.15)
                            : const Color(0xFFFF9500).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        t['status'] as String,
                        style: TextStyle(
                          color: t['status'] == 'On Time'
                              ? const Color(0xFF00C9A7)
                              : const Color(0xFFFF9500),
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildStationList(Map<String, dynamic> line, Color lineColor) {
    final stations = line['stations'] as List<String>;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: stations.length,
      itemBuilder: (ctx, i) {
        final isHub = ['Majestic', 'MG Road', 'Indiranagar'].contains(stations[i]);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 40,
              child: Column(
                children: [
                  if (i > 0)
                    Container(
                      width: 2,
                      height: 12,
                      color: lineColor.withOpacity(0.5),
                    ),
                  Container(
                    width: isHub ? 14 : 10,
                    height: isHub ? 14 : 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isHub ? lineColor : lineColor.withOpacity(0.4),
                      border: isHub ? Border.all(color: Colors.white, width: 2) : null,
                    ),
                  ),
                  if (i < stations.length - 1)
                    Container(
                      width: 2,
                      height: 28,
                      color: lineColor.withOpacity(0.5),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 2),
                child: Text(
                  stations[i],
                  style: TextStyle(
                    color: isHub ? Colors.white : Colors.white70,
                    fontSize: isHub ? 13 : 12,
                    fontWeight: isHub ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            ),
            if (isHub)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: lineColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('HUB',
                      style: TextStyle(color: lineColor, fontSize: 8, fontWeight: FontWeight.w800)),
                ),
              ),
          ],
        );
      },
    );
  }
}
