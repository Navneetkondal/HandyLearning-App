import 'package:shared_preferences/shared_preferences.dart';
import '../models/certification_models.dart';

/// Persistence and state management service for certification results and progress.
class CertificationStorageService {
  static const String _keyCandidateName = 'cert_candidate_name';
  static const String _keyExamResults = 'cert_exam_results_v1';
  static const String _keyCompletedTopics = 'cert_completed_topics_v1';

  final SharedPreferences _prefs;

  CertificationStorageService(this._prefs);

  static Future<CertificationStorageService> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return CertificationStorageService(prefs);
  }

  // ---------------------------------------------------------------------------
  // CANDIDATE PROFILE
  // ---------------------------------------------------------------------------
  String getCandidateName() {
    return _prefs.getString(_keyCandidateName) ?? 'Senior Full-Stack Engineer';
  }

  Future<bool> setCandidateName(String name) {
    return _prefs.setString(_keyCandidateName, name.trim().isEmpty ? 'Senior Full-Stack Engineer' : name.trim());
  }

  // ---------------------------------------------------------------------------
  // EXAM RESULTS & CERTIFICATES
  // ---------------------------------------------------------------------------
  List<ExamResult> getExamHistory() {
    final list = _prefs.getStringList(_keyExamResults) ?? [];
    return list.map((item) {
      try {
        return ExamResult.decode(item);
      } catch (_) {
        return null;
      }
    }).whereType<ExamResult>().toList();
  }

  Future<bool> saveExamResult(ExamResult result) async {
    final history = getExamHistory();
    history.insert(0, result);
    final encoded = history.map((e) => e.encode()).toList();
    return _prefs.setStringList(_keyExamResults, encoded);
  }

  ExamResult? getBestResult(ExamTrack track) {
    final trackResults = getExamHistory().where((e) => e.track == track && e.passed).toList();
    if (trackResults.isEmpty) return null;
    trackResults.sort((a, b) => b.scorePercentage.compareTo(a.scorePercentage));
    return trackResults.first;
  }

  bool hasEarnedCertificate(ExamTrack track) {
    return getBestResult(track) != null;
  }

  List<ExamResult> getEarnedCertificates() {
    final earned = <ExamResult>[];
    for (final track in ExamTrack.values) {
      final best = getBestResult(track);
      if (best != null) {
        earned.add(best);
      }
    }
    return earned;
  }

  // ---------------------------------------------------------------------------
  // TOPIC & MODULE PROGRESS
  // ---------------------------------------------------------------------------
  Set<String> getCompletedTopics() {
    return (_prefs.getStringList(_keyCompletedTopics) ?? []).toSet();
  }

  Future<bool> toggleTopicCompleted(String topicId) async {
    final current = getCompletedTopics();
    if (current.contains(topicId)) {
      current.remove(topicId);
    } else {
      current.add(topicId);
    }
    return _prefs.setStringList(_keyCompletedTopics, current.toList());
  }

  bool isTopicCompleted(String topicId) {
    return getCompletedTopics().contains(topicId);
  }

  int getCompletedCountForTrack(String prefix) {
    final completed = getCompletedTopics();
    return completed.where((id) => id.startsWith(prefix)).length;
  }

  // ---------------------------------------------------------------------------
  // HASH GENERATION
  // ---------------------------------------------------------------------------
  static String generateCertificateHash(ExamTrack track, String name, int score) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toRadixString(16).toUpperCase();
    final nameChecksum = name.hashCode.abs().toRadixString(16).toUpperCase().padLeft(4, '0');
    final raw = 'FLH-${track.acronym}-$score-$nameChecksum-$timestamp';
    return raw.length >= 24 ? raw.substring(0, 24) : raw;
  }
}
