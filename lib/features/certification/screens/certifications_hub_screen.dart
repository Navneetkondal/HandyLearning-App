import 'package:flutter/material.dart';
import '../../ai_engineering/screens/ai_engineer_roadmap_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../models/certification_models.dart';
import '../services/certification_storage_service.dart';
import 'certificate_viewer_screen.dart';
import 'unified_exam_runner_screen.dart';

/// Central Hub for all certification tracks, progress tracking, and earned credentials.
class CertificationsHubScreen extends StatefulWidget {
  final bool hideAppBar;
  const CertificationsHubScreen({super.key, this.hideAppBar = false});

  @override
  State<CertificationsHubScreen> createState() => _CertificationsHubScreenState();
}

class _CertificationsHubScreenState extends State<CertificationsHubScreen> {
  CertificationStorageService? _storage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _storage = await CertificationStorageService.getInstance();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _showEditNameDialog() {
    if (_storage == null) return;
    final controller = TextEditingController(text: _storage!.getCandidateName());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Candidate Profile Name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            hintText: 'e.g. Alex Morgan',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                await _storage!.setCandidateName(newName);
                setState(() {});
              }
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ).then((_) => controller.dispose());
  }

  void _startExam(ExamTrack track) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => UnifiedExamRunnerScreen(
          track: track,
          storageService: _storage,
        ),
      ),
    );
    if (!mounted) return;
    setState(() {}); // refresh after exam
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _storage == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final candidateName = _storage!.getCandidateName();
    final earnedCertificates = _storage!.getEarnedCertificates();
    final history = _storage!.getExamHistory();

    return Scaffold(
      appBar: widget.hideAppBar
          ? null
          : AppBar(
              title: const Text('Certification & Exam Center'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.person_pin_circle_outlined),
                  tooltip: 'Candidate Name',
                  onPressed: _showEditNameDialog,
                ),
              ],
            ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Candidate Profile Card
            _buildProfileCard(candidateName, earnedCertificates.length, isDark),
            const SizedBox(height: 20),

            // Earned Credentials Section
            if (earnedCertificates.isNotEmpty) ...[
              Text(
                'YOUR VERIFIED CREDENTIALS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: AppColors.textSub(isDark),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: (140 * MediaQuery.textScalerOf(context).scale(1.0).clamp(1.0, 1.6)).toDouble(),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: earnedCertificates.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (ctx, idx) => _buildCertificateCard(earnedCertificates[idx], isDark),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // AI Engineering from Scratch ➔ Claude Master Card
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AiEngineerRoadmapScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF1E1B4B), const Color(0xFF2E1065)]
                        : [const Color(0xFFEEF2FF), const Color(0xFFFAF5FF)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF8B5CF6).withAlpha(120),
                    width: 1.2,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded, color: Color(0xFF8B5CF6), size: 28),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Child-to-Master AI Engineer Roadmap',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'First principles (523 lessons) ➔ Claude Academy ➔ Pearson VUE CCDV-F',
                            style: TextStyle(fontSize: 11.5, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF8B5CF6)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Active Certification Tracks
            const Text(
              'PROFESSIONAL CERTIFICATION TRACKS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            ...ExamTrack.values.map((track) => _buildTrackCard(track, isDark)),

            const SizedBox(height: 20),

            // Past Exam History
            if (history.isNotEmpty) ...[
              const Text(
                'EXAMINATION ATTEMPT HISTORY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              ...history.take(5).map((res) => _buildHistoryTile(res, isDark)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(String name, int earnedCount, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E2129), const Color(0xFF14171F)]
              : [const Color(0xFF2A2D3A), const Color(0xFF1A1C24)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFD4AF37).withAlpha(40),
              border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
            ),
            child: const Icon(Icons.school_rounded, color: Color(0xFFD4AF37), size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Semantics(
                      button: true,
                      label: 'Edit candidate profile name',
                      child: InkWell(
                        onTap: _showEditNameDialog,
                        borderRadius: BorderRadius.circular(24),
                        child: const SizedBox(
                          width: 48,
                          height: 48,
                          child: Center(
                            child: Icon(Icons.edit, size: 16, color: Colors.white70),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(20),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '$earnedCount / 3 Credentials Earned',
                        style: const TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateCard(ExamResult result, bool isDark) {
    Color trackColor;
    switch (result.track) {
      case ExamTrack.flutter:
        trackColor = const Color(0xFF02569B);
        break;
      case ExamTrack.swiftui:
        trackColor = const Color(0xFF007AFF);
        break;
      case ExamTrack.claude:
        trackColor = const Color(0xFFD97706);
        break;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CertificateViewerScreen(
              result: result,
              storageService: _storage,
            ),
          ),
        );
      },
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF22252D) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.goldBorder(isDark), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.verified_rounded, color: AppColors.goldText(isDark), size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    result.track.acronym,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(30),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${result.scorePercentage}%',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              result.track.displayName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: trackColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${result.completedAt.year}-${result.completedAt.month.toString().padLeft(2, '0')}-${result.completedAt.day.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                const Text(
                  'View Certificate ➔',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackCard(ExamTrack track, bool isDark) {
    Color trackColor;
    IconData icon;
    switch (track) {
      case ExamTrack.flutter:
        trackColor = const Color(0xFF02569B);
        icon = Icons.flutter_dash_rounded;
        break;
      case ExamTrack.swiftui:
        trackColor = const Color(0xFF007AFF);
        icon = Icons.apple_rounded;
        break;
      case ExamTrack.claude:
        trackColor = const Color(0xFFD97706);
        icon = Icons.psychology_rounded;
        break;
    }

    final bestResult = _storage!.getBestResult(track);
    final hasEarned = bestResult != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: hasEarned ? AppColors.goldBorder(isDark) : (isDark ? AppColors.borderSubtleDark : AppColors.borderSubtle),
          width: hasEarned ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: trackColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: trackColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.displayName,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '10 Questions • 15 Mins • Pass Threshold: ${track.passingPercentage}%',
                        style: TextStyle(fontSize: 11, color: AppColors.textSub(isDark)),
                      ),
                    ],
                  ),
                ),
                if (hasEarned)
                  Icon(Icons.verified_rounded, color: AppColors.goldText(isDark), size: 24),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hasEarned
                      ? 'Best Score: ${bestResult.scorePercentage}% (Certified 🏆)'
                      : 'Status: Not Yet Certified',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: hasEarned ? Colors.green : Colors.grey,
                  ),
                ),
                FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    backgroundColor: trackColor.withAlpha(30),
                    foregroundColor: trackColor,
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: () => _startExam(track),
                  child: Text(hasEarned ? 'Retake Exam' : 'Start Exam'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTile(ExamResult result, bool isDark) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.withAlpha(40)),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          result.passed ? Icons.check_circle_rounded : Icons.cancel_rounded,
          color: result.passed ? Colors.green : Colors.red,
        ),
        title: Text(result.track.displayName, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          'Score: ${result.scorePercentage}% (${result.correctCount}/${result.totalQuestions}) • '
          '${result.completedAt.month}/${result.completedAt.day} ${result.completedAt.hour}:${result.completedAt.minute.toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 11),
        ),
        trailing: result.passed
            ? IconButton(
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                tooltip: 'View Certificate',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CertificateViewerScreen(
                        result: result,
                        storageService: _storage,
                      ),
                    ),
                  );
                },
              )
            : null,
      ),
    );
  }
}
