import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SOSScreen extends StatefulWidget {
  const SOSScreen({super.key});

  @override
  State<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> with SingleTickerProviderStateMixin {
  late AnimationController _sosController;
  late Animation<double> _sosAnimation;
  bool _sosActivated = false;

  final List<Map<String, dynamic>> _emergencyContacts = [
    {'name': 'Traffic Police', 'number': '103', 'icon': Icons.local_police_rounded, 'color': Color(0xFF6C63FF)},
    {'name': 'Ambulance', 'number': '108', 'icon': Icons.medical_services_rounded, 'color': Color(0xFFFF2D55)},
    {'name': 'BBMP Helpline', 'number': '1533', 'icon': Icons.business_rounded, 'color': Color(0xFF00C9A7)},
    {'name': 'Fire Service', 'number': '101', 'icon': Icons.local_fire_department_rounded, 'color': Color(0xFFFF9500)},
  ];

  final List<Map<String, dynamic>> _tips = [
    {'icon': '🚗', 'tip': 'Move vehicle to the left side of the road immediately'},
    {'icon': '📸', 'tip': 'Document the scene with photos before moving'},
    {'icon': '⚠️', 'tip': 'Switch on hazard lights and place safety triangle'},
    {'icon': '🤝', 'tip': 'Exchange insurance and contact details with other party'},
    {'icon': '🏥', 'tip': 'Call 108 if anyone is injured — do not move injured persons'},
  ];

  @override
  void initState() {
    super.initState();
    _sosController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
    _sosAnimation = Tween<double>(begin: 0.95, end: 1.05)
        .animate(CurvedAnimation(parent: _sosController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _sosController.dispose();
    super.dispose();
  }

  void _callNumber(String number, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF16162A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Call $name?',
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
        content: Text('This will dial $number',
            style: const TextStyle(color: Colors.white54, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white38)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE8581C)),
            onPressed: () {
              Navigator.pop(ctx);
              // Copy number to clipboard as fallback (URL launcher not available without plugin)
              Clipboard.setData(ClipboardData(text: number));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('📋 $number copied! Open your dialer to call $name'),
                  backgroundColor: const Color(0xFFE8581C),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 3),
                ),
              );
            },
            child: Text('Call $number', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _activateSOS() {
    setState(() => _sosActivated = true);
    // Copy all emergency numbers to clipboard
    const sosMessage = 'EMERGENCY! I need help. Emergency numbers: Police: 103 | Ambulance: 108 | Fire: 101 | BBMP: 1533';
    Clipboard.setData(const ClipboardData(text: sosMessage));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🆘 SOS Activated! Emergency info copied to clipboard. Call 108 or 103 now!'),
        backgroundColor: Color(0xFFFF2D55),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildSOSButton()),
          SliverToBoxAdapter(child: _buildEmergencyContacts()),
          SliverToBoxAdapter(child: _buildAccidentTips()),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
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
              Text('Emergency SOS',
                  style: GoogleFonts.plusJakartaSans(
                      color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
              const Text('Tap SOS to activate · Tap contacts to call',
                  style: TextStyle(color: Colors.white38, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSOSButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _sosAnimation,
            builder: (ctx, child) => Transform.scale(
              scale: _sosActivated ? _sosAnimation.value : 1.0,
              child: child,
            ),
            child: GestureDetector(
              onTap: _sosActivated
                  ? () => setState(() => _sosActivated = false)
                  : _activateSOS,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 180, height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: _sosActivated
                        ? [const Color(0xFFFF2D55), const Color(0xFFCC0025)]
                        : [const Color(0xFF2A0010), const Color(0xFF1A0008)],
                  ),
                  border: Border.all(
                      color: const Color(0xFFFF2D55), width: _sosActivated ? 3 : 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF2D55)
                          .withOpacity(_sosActivated ? 0.6 : 0.2),
                      blurRadius: _sosActivated ? 40 : 20,
                      spreadRadius: _sosActivated ? 10 : 0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.emergency_rounded, color: Colors.white, size: 48),
                    const SizedBox(height: 8),
                    Text('SOS',
                        style: GoogleFonts.plusJakartaSans(
                            color: Colors.white, fontSize: 28,
                            fontWeight: FontWeight.w900, letterSpacing: 4)),
                    if (_sosActivated)
                      const Text('ACTIVE',
                          style: TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 2)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _sosActivated
                ? '🔴 SOS Active — Emergency info copied to clipboard!'
                : 'Tap SOS button to activate emergency alert',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _sosActivated ? const Color(0xFFFF2D55) : Colors.white38,
              fontSize: 12,
              fontWeight: _sosActivated ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          if (_sosActivated) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => setState(() => _sosActivated = false),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: const Text('Cancel SOS', style: TextStyle(color: Colors.white54, fontSize: 12)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmergencyContacts() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Emergency Contacts',
              style: GoogleFonts.plusJakartaSans(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          const Text('Tap any contact to call',
              style: TextStyle(color: Colors.white38, fontSize: 11)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 2.2,
            ),
            itemCount: _emergencyContacts.length,
            itemBuilder: (ctx, i) {
              final contact = _emergencyContacts[i];
              final color = contact['color'] as Color;
              return GestureDetector(
                onTap: () => _callNumber(contact['number'] as String, contact['name'] as String),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(contact['icon'] as IconData, color: color, size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(contact['number'] as String,
                                style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w900)),
                            Text(contact['name'] as String,
                                style: const TextStyle(color: Colors.white54, fontSize: 9),
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      Icon(Icons.phone_rounded, color: color.withOpacity(0.6), size: 14),
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

  Widget _buildAccidentTips() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("If You're in an Accident",
              style: GoogleFonts.plusJakartaSans(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          ..._tips.asMap().entries.map((entry) {
            final i = entry.key;
            final tip = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF2D55).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text('${i + 1}',
                          style: const TextStyle(color: Color(0xFFFF2D55),
                              fontSize: 12, fontWeight: FontWeight.w800)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('${tip['icon']}  ${tip['tip']}',
                          style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.5)),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
