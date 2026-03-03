import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String? _selectedType;
  String? _selectedArea;
  bool _submitted = false;

  final List<Map<String, dynamic>> _reportTypes = [
    {'icon': '🚗', 'label': 'Accident', 'color': Color(0xFFFF2D55)},
    {'icon': '🕳️', 'label': 'Pothole', 'color': Color(0xFFFF9500)},
    {'icon': '🚦', 'label': 'Signal Issue', 'color': Color(0xFFFFCC00)},
    {'icon': '🌊', 'label': 'Waterlogging', 'color': Color(0xFF6C63FF)},
    {'icon': '🚧', 'label': 'Road Block', 'color': Color(0xFFFF6B9D)},
    {'icon': '💡', 'label': 'No Lighting', 'color': Color(0xFF00C9A7)},
  ];

  final List<String> _areas = [
    'Koramangala', 'Whitefield', 'Indiranagar', 'Silk Board',
    'Marathahalli', 'Hebbal', 'Electronic City', 'Jayanagar',
    'Rajajinagar', 'Yeshwanthpur',
  ];

  final List<Map<String, dynamic>> _recentReports = [
    {
      'type': 'Pothole',
      'icon': '🕳️',
      'location': 'HSR Layout, 5th Sector',
      'by': '@ravi_blr',
      'time': '10 min ago',
      'votes': 24,
      'color': Color(0xFFFF9500),
    },
    {
      'type': 'Waterlogging',
      'icon': '🌊',
      'location': 'Bellandur underpass',
      'by': '@priya_bengaluru',
      'time': '28 min ago',
      'votes': 67,
      'color': Color(0xFF6C63FF),
    },
    {
      'type': 'Signal Issue',
      'icon': '🚦',
      'location': 'BTM Layout 2nd Stage',
      'by': '@suresh_k',
      'time': '1 hr ago',
      'votes': 12,
      'color': Color(0xFFFFCC00),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: _submitted ? _buildSuccess() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeader()),
        SliverToBoxAdapter(child: _buildTypeSelector()),
        SliverToBoxAdapter(child: _buildAreaSelector()),
        SliverToBoxAdapter(child: _buildDescField()),
        SliverToBoxAdapter(child: _buildSubmitButton()),
        SliverToBoxAdapter(child: _buildRecentReports()),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16162A),
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.06))),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Report an Issue',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Help your fellow Bengalureans navigate better',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('What are you reporting?',
              style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.3,
            ),
            itemCount: _reportTypes.length,
            itemBuilder: (ctx, i) {
              final type = _reportTypes[i];
              final isSelected = _selectedType == type['label'];
              final color = type['color'] as Color;
              return GestureDetector(
                onTap: () => setState(() => _selectedType = type['label'] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? color : Colors.white.withOpacity(0.08),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(type['icon'] as String, style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 4),
                      Text(
                        type['label'] as String,
                        style: TextStyle(
                          color: isSelected ? color : Colors.white54,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAreaSelector() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Area',
              style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _areas.length,
              itemBuilder: (ctx, i) {
                final isSelected = _selectedArea == _areas[i];
                return GestureDetector(
                  onTap: () => setState(() => _selectedArea = _areas[i]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE8581C).withOpacity(0.2)
                          : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFE8581C)
                            : Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: Text(
                      _areas[i],
                      style: TextStyle(
                        color: isSelected ? const Color(0xFFE8581C) : Colors.white54,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description (Optional)',
              style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: TextField(
              maxLines: 3,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Describe the issue briefly...',
                hintStyle: TextStyle(color: Colors.white30),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: GestureDetector(
        onTap: () => setState(() => _submitted = true),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE8581C), Color(0xFFFF8C42)],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE8581C).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.send_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                'Submit Report',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentReports() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Community Reports',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          ..._recentReports.map((r) => _buildRecentCard(r)),
        ],
      ),
    );
  }

  Widget _buildRecentCard(Map<String, dynamic> report) {
    final color = report['color'] as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF16162A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Text(report['icon'] as String, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report['location'] as String,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                Text('${report['by']} · ${report['time']}',
                    style: TextStyle(color: Colors.white38, fontSize: 10)),
              ],
            ),
          ),
          Column(
            children: [
              const Icon(Icons.thumb_up_rounded, color: Colors.white38, size: 16),
              const SizedBox(height: 2),
              Text('${report['votes']}',
                  style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF00C9A7).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: Color(0xFF00C9A7), size: 54),
            ),
            const SizedBox(height: 24),
            Text('Report Submitted!',
                style: GoogleFonts.plusJakartaSans(
                    color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            Text(
              'Thanks for helping Bengalureans navigate better!\nYour report is now live on the map.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.6),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () => setState(() => _submitted = false),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8581C),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text('Report Another',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
