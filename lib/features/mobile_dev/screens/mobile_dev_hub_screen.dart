import 'package:flutter/material.dart';
import '../../certification/models/certification_models.dart';
import '../../certification/screens/unified_exam_runner_screen.dart';
import '../../flutter_advanced/screens/flutter_track_hub_screen.dart';
import '../../swiftui_track/screens/swiftui_hub_screen.dart';
import '../../swiftui_track/screens/swiftui_rosetta_screen.dart';
import '../../swiftui_track/screens/swiftui_state_simulator_screen.dart';

/// Unified Hub combining Flutter & Dart Architecture with SwiftUI & Modern iOS.
class MobileDevHubScreen extends StatefulWidget {
  final int initialSubTab; // 0: Flutter & Dart, 1: SwiftUI & iOS

  const MobileDevHubScreen({
    super.key,
    this.initialSubTab = 0,
  });

  @override
  State<MobileDevHubScreen> createState() => _MobileDevHubScreenState();
}

class _MobileDevHubScreenState extends State<MobileDevHubScreen> {
  late int _selectedSubTab;

  @override
  void initState() {
    super.initState();
    _selectedSubTab = widget.initialSubTab;
  }

  @override
  void didUpdateWidget(covariant MobileDevHubScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSubTab != widget.initialSubTab) {
      _selectedSubTab = widget.initialSubTab;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.phone_iphone_rounded,
                color: Color(0xFF2563EB),
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Mobile Dev',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          // Flutter vs SwiftUI Rosetta Stone direct comparison
          IconButton(
            icon: const Icon(Icons.compare_arrows_rounded, color: Color(0xFF6366F1)),
            tooltip: 'Flutter vs SwiftUI Rosetta Stone',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SwiftUiRosettaScreen()),
              );
            },
          ),
          if (_selectedSubTab == 1)
            IconButton(
              icon: const Icon(Icons.play_circle_outline_rounded, color: Color(0xFF0284C7)),
              tooltip: 'SwiftUI State Simulator',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SwiftUiStateSimulatorScreen()),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.workspace_premium_rounded, color: Color(0xFFF59E0B)),
            tooltip: _selectedSubTab == 0 ? 'Take Flutter Master Exam' : 'Take SwiftUI Exam',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UnifiedExamRunnerScreen(
                    track: _selectedSubTab == 0 ? ExamTrack.flutter : ExamTrack.swiftui,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Sub-Tab Switcher (Material 3 sleek compact pills - standardized height)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              border: Border(
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  width: 0.8,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    selected: _selectedSubTab == 0,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                    avatar: Icon(
                      Icons.flutter_dash,
                      size: 14,
                      color: _selectedSubTab == 0 ? Colors.white : const Color(0xFF2563EB),
                    ),
                    label: const Text('Flutter & Dart (8)'),
                    selectedColor: const Color(0xFF2563EB),
                    backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    side: BorderSide(
                      color: _selectedSubTab == 0
                          ? const Color(0xFF2563EB)
                          : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                      width: 0.8,
                    ),
                    labelStyle: TextStyle(
                      color: _selectedSubTab == 0
                          ? Colors.white
                          : (isDark ? Colors.white70 : const Color(0xFF334155)),
                      fontWeight: _selectedSubTab == 0 ? FontWeight.bold : FontWeight.w500,
                      fontSize: 11.5,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedSubTab = 0);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    selected: _selectedSubTab == 1,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                    avatar: Icon(
                      Icons.apple_rounded,
                      size: 14,
                      color: _selectedSubTab == 1 ? Colors.white : const Color(0xFF6366F1),
                    ),
                    label: const Text('SwiftUI & iOS (3)'),
                    selectedColor: const Color(0xFF6366F1),
                    backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    side: BorderSide(
                      color: _selectedSubTab == 1
                          ? const Color(0xFF6366F1)
                          : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                      width: 0.8,
                    ),
                    labelStyle: TextStyle(
                      color: _selectedSubTab == 1
                          ? Colors.white
                          : (isDark ? Colors.white70 : const Color(0xFF334155)),
                      fontWeight: _selectedSubTab == 1 ? FontWeight.bold : FontWeight.w500,
                      fontSize: 11.5,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedSubTab = 1);
                    },
                  ),
                ),
              ],
            ),
          ),

          // IndexedStack preserves active scroll and category selections
          Expanded(
            child: IndexedStack(
              index: _selectedSubTab,
              children: const [
                FlutterTrackHubScreen(hideAppBar: true),
                SwiftUiHubScreen(hideAppBar: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
