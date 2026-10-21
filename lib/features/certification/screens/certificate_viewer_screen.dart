import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/certification_models.dart';
import '../services/certification_storage_service.dart';

/// Renders a verified, high-resolution digital certificate of mastery.
class CertificateViewerScreen extends StatefulWidget {
  final ExamResult result;
  final CertificationStorageService? storageService;

  const CertificateViewerScreen({
    super.key,
    required this.result,
    this.storageService,
  });

  @override
  State<CertificateViewerScreen> createState() => _CertificateViewerScreenState();
}

class _CertificateViewerScreenState extends State<CertificateViewerScreen> {
  late String _candidateName;

  @override
  void initState() {
    super.initState();
    _candidateName = widget.result.candidateName;
  }

  Color get _trackColor {
    switch (widget.result.track) {
      case ExamTrack.flutter:
        return const Color(0xFF02569B);
      case ExamTrack.swiftui:
        return const Color(0xFF007AFF);
      case ExamTrack.claude:
        return const Color(0xFFD97706);
    }
  }

  void _showEditNameDialog() {
    final controller = TextEditingController(text: _candidateName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Certificate Name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Recipient Full Name',
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
                setState(() => _candidateName = newName);
                if (widget.storageService != null) {
                  await widget.storageService!.setCandidateName(newName);
                }
              }
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    ).then((_) => controller.dispose());
  }

  void _copyVerificationCode() {
    Clipboard.setData(ClipboardData(text: widget.result.certificateHash));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Certificate Hash copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verified Credential'),
        actions: [
          IconButton(
            tooltip: 'Edit Name',
            icon: const Icon(Icons.edit_outlined),
            onPressed: _showEditNameDialog,
          ),
          IconButton(
            tooltip: 'Copy Hash',
            icon: const Icon(Icons.copy_rounded),
            onPressed: _copyVerificationCode,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // The Certificate Container
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E2128) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(isDark ? 80 : 30),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFD4AF37), // Metallic Gold
                      width: 2.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Top Emblem & Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFD4AF37),
                                  _trackColor,
                                ],
                              ),
                            ),
                            child: const Icon(
                              Icons.verified_rounded,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'GLOBAL LEARNING HUB CERTIFICATION',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: isDark ? const Color(0xFFFACC15) : const Color(0xFF92400E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'CERTIFICATE OF MASTERY',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'This official credential is authenticated and awarded to',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Candidate Name
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _trackColor.withAlpha(120),
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          _candidateName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: _trackColor,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'for successfully demonstrating elite architectural knowledge and achieving an exam score of ${widget.result.scorePercentage}% in:',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 12),
                      // Track Title Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: _trackColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _trackColor.withAlpha(100)),
                        ),
                        child: Text(
                          widget.result.track.displayName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _trackColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Details Grid
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildDetailColumn(
                            'Score',
                            '${widget.result.scorePercentage}%',
                            widget.result.scorePercentage >= 90 ? 'Distinction' : 'Certified',
                          ),
                          _buildDetailColumn(
                            'Questions',
                            '${widget.result.correctCount}/${widget.result.totalQuestions}',
                            'Verified',
                          ),
                          _buildDetailColumn(
                            'Issued',
                            '${widget.result.completedAt.year}-${widget.result.completedAt.month.toString().padLeft(2, '0')}-${widget.result.completedAt.day.toString().padLeft(2, '0')}',
                            'Permanent',
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 8),
                      // Verification Hash
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shield_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Verification ID: ${widget.result.certificateHash}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontFamily: 'monospace',
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Domain Mastery Breakdown Card
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.withAlpha(40)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.analytics_rounded, size: 20, color: _trackColor),
                          const SizedBox(width: 8),
                          const Text(
                            'Domain Competency Breakdown',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...widget.result.domainBreakdown.entries.map((entry) {
                        final percent = (entry.value * 100).toInt();
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      entry.key,
                                      style: const TextStyle(fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '$percent%',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: percent >= 75 ? Colors.green : Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: LinearProgressIndicator(
                                  value: entry.value,
                                  minHeight: 5,
                                  backgroundColor: Colors.grey.withAlpha(40),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    percent >= 75 ? Colors.green : Colors.orange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Bottom Action Button
              FilledButton.icon(
                icon: const Icon(Icons.done_all_rounded),
                label: const Text('Done & Return to Hub'),
                style: FilledButton.styleFrom(
                  backgroundColor: _trackColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailColumn(String label, String value, String sub) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          sub,
          style: TextStyle(
            fontSize: 10,
            color: Colors.green.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
