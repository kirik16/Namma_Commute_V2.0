import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigate;
  const HomeScreen({super.key, this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, dynamic>> _hotspots = [
    {'name': 'Silk Board Junction',     'level': 'SEVERE',   'delay': '45 min', 'color': Color(0xFFFF2D55)},
    {'name': 'Marathahalli Bridge',     'level': 'HIGH',     'delay': '28 min', 'color': Color(0xFFFF9500)},
    {'name': 'KR Puram Signal',         'level': 'HIGH',     'delay': '32 min', 'color': Color(0xFFFF9500)},
    {'name': 'Hebbal Flyover',          'level': 'MODERATE', 'delay': '15 min', 'color': Color(0xFFFFCC00)},
    {'name': 'Tin Factory Junction',    'level': 'MODERATE', 'delay': '18 min', 'color': Color(0xFFFFCC00)},
  ];

  final List<Map<String, dynamic>> _quickActions = [
    {'icon': Icons.directions_car_rounded,  'label': 'Live\nTraffic', 'color': Color(0xFFE8581C), 'tab': 1},
    {'icon': Icons.train_rounded,           'label': 'Namma\nMetro',  'color': Color(0xFF6C63FF), 'tab': 2},
    {'icon': Icons.report_problem_rounded,  'label': 'Report\nIssue', 'color': Color(0xFF00C9A7), 'tab': 3},
    {'icon': Icons.emergency_rounded,       'label': 'SOS\nHelp',    'color': Color(0xFFFF4444), 'tab': 4},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0)
        .animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildTrafficScore()),
          SliverToBoxAdapter(child: _buildQuickActions()),
          SliverToBoxAdapter(child: _buildHotspotsHeader()),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => _buildHotspotCard(_hotspots[i], i),
              childCount: _hotspots.length,
            ),
          ),
          SliverToBoxAdapter(child: _buildWeatherBanner()),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      backgroundColor: const Color(0xFF0F0F1A),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A0A00), Color(0xFF0F0F1A)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8581C).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE8581C).withOpacity(0.3)),
                      ),
                      child: const Text('● LIVE',
                          style: TextStyle(color: Color(0xFFE8581C), fontSize: 10, fontWeight: FontWeight.w800)),
                    ),
                    const Spacer(),
                    const Text('🌤️  28°C', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Namma Commute',
                    style: GoogleFonts.plusJakartaSans(
                        color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
                const Text('Bengaluru Traffic Intelligence',
                    style: TextStyle(color: Colors.white54, fontSize: 13)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrafficScore() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFFE8581C).withOpacity(0.15), const Color(0xFF16162A)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE8581C).withOpacity(0.2)),
        ),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (ctx, child) => Transform.scale(scale: _pulseAnimation.value, child: child),
              child: SizedBox(
                width: 90, height: 90,
                child: CustomPaint(
                  painter: _RingPainter(0.38),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('38', style: TextStyle(color: Color(0xFFFFCC00), fontSize: 28, fontWeight: FontWeight.w900)),
                        Text('/100', style: TextStyle(color: Colors.white38, fontSize: 10)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('City Traffic Index',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFFCC00).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text('MODERATE CONGESTION',
                        style: TextStyle(color: Color(0xFFFFCC00), fontSize: 10, fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(height: 8),
                  const Text('Peak hours: 8-10 AM, 5-8 PM',
                      style: TextStyle(color: Colors.white54, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: _quickActions.map((action) {
          final color = action['color'] as Color;
          final tab = action['tab'] as int;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => widget.onNavigate?.call(tab),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: color.withOpacity(0.25)),
                  ),
                  child: Column(
                    children: [
                      Icon(action['icon'] as IconData, color: color, size: 24),
                      const SizedBox(height: 6),
                      Text(action['label'] as String,
                          style: TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHotspotsHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        children: [
          const Text('🔥 Traffic Hotspots',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
          const Spacer(),
          GestureDetector(
            onTap: () => widget.onNavigate?.call(1),
            child: const Text('See All →',
                style: TextStyle(color: Color(0xFFE8581C), fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildHotspotCard(Map<String, dynamic> hotspot, int index) {
    final color = hotspot['color'] as Color;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: GestureDetector(
        onTap: () => widget.onNavigate?.call(1),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF16162A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.25)),
          ),
          child: Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                child: Center(child: Text('${index + 1}',
                    style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 14))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hotspot['name'] as String,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                      child: Text(hotspot['level'] as String,
                          style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(hotspot['delay'] as String,
                      style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w900)),
                  const Text('delay', style: TextStyle(color: Colors.white38, fontSize: 10)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF6C63FF).withOpacity(0.2), const Color(0xFF00C9A7).withOpacity(0.1)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.2)),
        ),
        child: const Row(
          children: [
            Text('🌧️', style: TextStyle(fontSize: 28)),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rain Alert - Outer Ring Road',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                  SizedBox(height: 2),
                  Text('Heavy rain expected 5-7 PM. Allow extra 20 min.',
                      style: TextStyle(color: Colors.white54, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  _RingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    canvas.drawCircle(center, radius,
        Paint()..color = Colors.white.withOpacity(0.07)..strokeWidth = 8..style = PaintingStyle.stroke);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, 2 * pi * progress, false,
      Paint()..color = const Color(0xFFFFCC00)..strokeWidth = 8..style = PaintingStyle.stroke..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}
