import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LiveTrafficScreen extends StatefulWidget {
  const LiveTrafficScreen({super.key});

  @override
  State<LiveTrafficScreen> createState() => _LiveTrafficScreenState();
}

class _LiveTrafficScreenState extends State<LiveTrafficScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Critical', 'Construction', 'Events', 'Accidents', 'Flood'];

  final List<Map<String, dynamic>> _allIncidents = [
    {
      'type': 'Accidents',
      'icon': '🚗',
      'location': 'Silk Board Junction',
      'desc': '3-vehicle pile-up, 2 lanes blocked. Emergency services on site.',
      'time': '12 min ago',
      'severity': 'CRITICAL',
      'color': Color(0xFFFF2D55),
    },
    {
      'type': 'Construction',
      'icon': '🚧',
      'location': 'ORR near Marathahalli',
      'desc': 'Metro Phase 3 construction. Road width reduced to 1 lane each side.',
      'time': '2 hrs ago',
      'severity': 'HIGH',
      'color': Color(0xFFFF9500),
    },
    {
      'type': 'Events',
      'icon': '🎭',
      'location': 'Palace Grounds, Bellary Rd',
      'desc': 'Large concert event tonight. Expect heavy traffic 5–11 PM.',
      'time': '1 hr ago',
      'severity': 'MODERATE',
      'color': Color(0xFFFFCC00),
    },
    {
      'type': 'Accidents',
      'icon': '🚑',
      'location': 'Tin Factory, KR Puram',
      'desc': 'Breakdown blocking right lane. Tow truck dispatched.',
      'time': '34 min ago',
      'severity': 'HIGH',
      'color': Color(0xFFFF9500),
    },
    {
      'type': 'Construction',
      'icon': '🏗️',
      'location': 'Whitefield Main Road',
      'desc': 'BBMP road widening project. Single lane operational.',
      'time': 'Ongoing',
      'severity': 'MODERATE',
      'color': Color(0xFFFFCC00),
    },
    {
      'type': 'Flood',
      'icon': '🌊',
      'location': 'Bellandur underpass',
      'desc': 'Waterlogging reported post rain. Avoid this stretch.',
      'time': '45 min ago',
      'severity': 'CRITICAL',
      'color': Color(0xFFFF2D55),
    },
  ];

  List<Map<String, dynamic>> get _filteredIncidents {
    if (_selectedFilter == 'All') return _allIncidents;
    if (_selectedFilter == 'Critical') {
      return _allIncidents.where((i) => i['severity'] == 'CRITICAL').toList();
    }
    return _allIncidents.where((i) => i['type'] == _selectedFilter).toList();
  }

  void _showReportDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF16162A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Report an Incident',
                style: GoogleFonts.plusJakartaSans(
                    color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('Tap the Report tab below to file a full report',
                style: TextStyle(color: Colors.white54, fontSize: 13)),
            const SizedBox(height: 20),
            ...['🚗 Accident', '🚧 Construction', '🌊 Flooding', '🚦 Signal Issue'].map((type) =>
              ListTile(
                title: Text(type, style: const TextStyle(color: Colors.white, fontSize: 14)),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 14),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Use the Report tab to file a $type report'),
                      backgroundColor: const Color(0xFFE8581C),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showRouteInfo(Map<String, dynamic> incident) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF16162A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Avoid Route — ${incident['location']}',
            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(incident['desc'] as String,
                style: const TextStyle(color: Colors.white60, fontSize: 13)),
            const SizedBox(height: 16),
            const Text('💡 Suggested alternatives:',
                style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, fontSize: 13)),
            const SizedBox(height: 8),
            Text('• Use Outer Ring Road via Marathahalli\n• Take NICE Road if heading south\n• Metro recommended where available',
                style: const TextStyle(color: Colors.white54, fontSize: 12, height: 1.6)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it', style: TextStyle(color: Color(0xFFE8581C))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final incidents = _filteredIncidents;
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: Column(
        children: [
          _buildHeader(incidents.length),
          _buildFilterRow(),
          Expanded(
            child: incidents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('✅', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text('No $_selectedFilter incidents right now',
                            style: const TextStyle(color: Colors.white54, fontSize: 14)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    itemCount: incidents.length,
                    itemBuilder: (ctx, i) => _buildIncidentCard(incidents[i]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showReportDialog,
        backgroundColor: const Color(0xFFE8581C),
        icon: const Icon(Icons.add_location_alt_rounded, color: Colors.white),
        label: const Text('Report', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _buildHeader(int count) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16162A),
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.06))),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Live Traffic',
                      style: GoogleFonts.plusJakartaSans(
                          color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                  Text('$count active incidents across Bengaluru',
                      style: const TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF2D55).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(children: [
                  Container(width: 6, height: 6,
                      decoration: const BoxDecoration(color: Color(0xFFFF2D55), shape: BoxShape.circle)),
                  const SizedBox(width: 5),
                  const Text('LIVE', style: TextStyle(color: Color(0xFFFF2D55), fontSize: 10, fontWeight: FontWeight.w800)),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Container(
      height: 44,
      margin: const EdgeInsets.only(top: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        itemBuilder: (ctx, i) {
          final isSelected = _selectedFilter == _filters[i];
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = _filters[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE8581C) : Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? const Color(0xFFE8581C) : Colors.white.withOpacity(0.1),
                ),
              ),
              child: Text(_filters[i],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white54,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  )),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIncidentCard(Map<String, dynamic> incident) {
    final color = incident['color'] as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16162A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.25)),
        boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 12, spreadRadius: 1)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(incident['icon'] as String, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(incident['location'] as String,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                child: Text(incident['severity'] as String,
                    style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(incident['desc'] as String,
              style: const TextStyle(color: Colors.white60, fontSize: 12, height: 1.5)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.access_time_rounded, color: Colors.white38, size: 12),
              const SizedBox(width: 4),
              Text(incident['time'] as String,
                  style: const TextStyle(color: Colors.white38, fontSize: 11)),
              const Spacer(),
              GestureDetector(
                onTap: () => _showRouteInfo(incident),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.alt_route_rounded, color: Colors.white54, size: 14),
                      SizedBox(width: 4),
                      Text('Avoid Route', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
