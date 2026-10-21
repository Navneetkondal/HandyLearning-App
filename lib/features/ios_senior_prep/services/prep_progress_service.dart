import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ios_prep_hierarchy_models.dart';

/// Central progress and mastery tracking service for handyLearn.
/// Tracks topic mastery (○ Not Started, ◐ In Progress, ✓ Completed, ★ Mastered),
/// domain completion percentages, interview questions answered, and system designs.
class PrepProgressService extends ChangeNotifier {
  static final PrepProgressService instance = PrepProgressService._internal();

  static const String _keyTopicStatuses = 'prep_topic_statuses_v1';
  static const String _keyBookmarkedTopics = 'prep_bookmarked_topics_v1';
  static const String _keyCompletedSystemDesigns = 'prep_completed_sys_designs_v1';
  static const String _keyAnsweredQuestions = 'prep_answered_questions_v1';
  static const String _keyRecentlyStudied = 'prep_recently_studied_v1';
  static const String _keyActiveCourse = 'prep_active_course_v1';
  static const String _keyActiveModule = 'prep_active_module_v1';
  static const String _keyActiveTopic = 'prep_active_topic_v1';
  static const String _keyActiveTopicId = 'prep_active_topic_id_v1';
  static const String _keyActiveDomainNumber = 'prep_active_domain_num_v1';

  SharedPreferences? _prefs;
  Future<void>? _initFuture;

  PrepProgressService._internal() {
    _seedDefaultProgress();
    _initFuture = _initPersistence();
  }

  Future<void> _initPersistence() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _hydrateFromStorage();
    } catch (_) {
      // Graceful fallback if SharedPreferences is unavailable in testing environments
    }
  }

  void _hydrateFromStorage() {
    if (_prefs == null) return;
    final savedStatuses = _prefs?.getString(_keyTopicStatuses);
    if (savedStatuses != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(savedStatuses);
        decoded.forEach((key, val) {
          final status = TopicMasteryStatus.values.firstWhere(
            (e) => e.name == val,
            orElse: () => TopicMasteryStatus.notStarted,
          );
          _topicStatuses.putIfAbsent(key, () => status);
        });
      } catch (_) {}
    }

    final bookmarks = _prefs?.getStringList(_keyBookmarkedTopics);
    if (bookmarks != null) {
      _bookmarkedTopics.clear();
      _bookmarkedTopics.addAll(bookmarks);
    }

    final sysDesigns = _prefs?.getStringList(_keyCompletedSystemDesigns);
    if (sysDesigns != null) {
      _completedSystemDesigns.clear();
      _completedSystemDesigns.addAll(sysDesigns.map((e) => int.tryParse(e) ?? 0).where((id) => id > 0));
    }

    _answeredQuestionsCount = _prefs?.getInt(_keyAnsweredQuestions) ?? _answeredQuestionsCount;

    final recents = _prefs?.getStringList(_keyRecentlyStudied);
    if (recents != null) {
      _recentlyStudiedTopicIds.clear();
      _recentlyStudiedTopicIds.addAll(recents);
    }

    _activeCourse = _prefs?.getString(_keyActiveCourse) ?? _activeCourse;
    _activeModule = _prefs?.getString(_keyActiveModule) ?? _activeModule;
    _activeTopic = _prefs?.getString(_keyActiveTopic) ?? _activeTopic;
    _activeTopicId = _prefs?.getString(_keyActiveTopicId) ?? _activeTopicId;
    _activeDomainNumber = _prefs?.getInt(_keyActiveDomainNumber) ?? _activeDomainNumber;

    notifyListeners();
  }

  Future<void> _saveState() async {
    if (_prefs == null && _initFuture != null) {
      await _initFuture;
    }
    if (_prefs == null) return;
    try {
      final statusMap = _topicStatuses.map((k, v) => MapEntry(k, v.name));
      await _prefs?.setString(_keyTopicStatuses, jsonEncode(statusMap));
      await _prefs?.setStringList(_keyBookmarkedTopics, _bookmarkedTopics.toList());
      await _prefs?.setStringList(_keyCompletedSystemDesigns, _completedSystemDesigns.map((e) => e.toString()).toList());
      await _prefs?.setInt(_keyAnsweredQuestions, _answeredQuestionsCount);
      await _prefs?.setStringList(_keyRecentlyStudied, _recentlyStudiedTopicIds);
      await _prefs?.setString(_keyActiveCourse, _activeCourse);
      await _prefs?.setString(_keyActiveModule, _activeModule);
      await _prefs?.setString(_keyActiveTopic, _activeTopic);
      await _prefs?.setString(_keyActiveTopicId, _activeTopicId);
      await _prefs?.setInt(_keyActiveDomainNumber, _activeDomainNumber);
    } catch (_) {}
  }

  // Topic mastery map: topicId -> TopicMasteryStatus
  final Map<String, TopicMasteryStatus> _topicStatuses = {};

  // Bookmarked topic IDs
  final Set<String> _bookmarkedTopics = {};

  // Completed system design IDs (default: 0 completed)
  final Set<int> _completedSystemDesigns = {};

  // Mock interview scores (history)
  final List<MockInterviewRecord> _interviewHistory = [];

  // Answered questions counter (default: 0)
  int _answeredQuestionsCount = 0;

  // Recently studied topic IDs (ordered most recent first)
  final List<String> _recentlyStudiedTopicIds = [];

  // Current learning pointer for "Continue Learning" (defaults to starting Domain 01)
  String _activeCourse = 'iOS Senior & Lead Prep';
  String _activeModule = 'Domain 01: Swift Language Core';
  String _activeTopic = 'Value vs Reference Semantics';
  String _activeTopicId = 'dom01_top01';
  int _activeDomainNumber = 1;

  String get activeCourse => _activeCourse;
  String get activeModule => _activeModule;
  String get activeTopic => _activeTopic;
  String get activeTopicId => _activeTopicId;
  int get activeDomainNumber => _activeDomainNumber;

  bool get hasStarted =>
      completedTopicsCount > 0 || inProgressTopicsCount > 0 || _answeredQuestionsCount > 0 || _completedSystemDesigns.isNotEmpty;

  List<String> get recentlyStudiedTopicIds => List.unmodifiable(_recentlyStudiedTopicIds);

  void setActiveTopic({
    required String course,
    required String module,
    required String topic,
    required String topicId,
    required int domainNumber,
  }) {
    _activeCourse = course;
    _activeModule = module;
    _activeTopic = topic;
    _activeTopicId = topicId;
    _activeDomainNumber = domainNumber;
    recordTopicStudied(topicId);
    if (getTopicStatus(topicId) == TopicMasteryStatus.notStarted) {
      setTopicStatus(topicId, TopicMasteryStatus.inProgress);
    }
    _saveState();
    notifyListeners();
  }

  void recordTopicStudied(String topicId) {
    _recentlyStudiedTopicIds.remove(topicId);
    _recentlyStudiedTopicIds.insert(0, topicId);
    if (_recentlyStudiedTopicIds.length > 10) {
      _recentlyStudiedTopicIds.removeLast();
    }
    _saveState();
    notifyListeners();
  }

  TopicMasteryStatus getTopicStatus(String topicId) {
    return _topicStatuses[topicId] ?? TopicMasteryStatus.notStarted;
  }

  void setTopicStatus(String topicId, TopicMasteryStatus status) {
    _topicStatuses[topicId] = status;
    recordTopicStudied(topicId);
    _saveState();
    notifyListeners();
  }

  void cycleTopicStatus(String topicId) {
    final current = getTopicStatus(topicId);
    TopicMasteryStatus next;
    switch (current) {
      case TopicMasteryStatus.notStarted:
        next = TopicMasteryStatus.inProgress;
        break;
      case TopicMasteryStatus.inProgress:
        next = TopicMasteryStatus.completed;
        break;
      case TopicMasteryStatus.completed:
        next = TopicMasteryStatus.mastered;
        break;
      case TopicMasteryStatus.mastered:
        next = TopicMasteryStatus.notStarted;
        break;
    }
    _topicStatuses[topicId] = next;
    recordTopicStudied(topicId);
    _saveState();
    notifyListeners();
  }

  bool isBookmarked(String topicId) => _bookmarkedTopics.contains(topicId);

  void toggleBookmark(String topicId) {
    if (_bookmarkedTopics.contains(topicId)) {
      _bookmarkedTopics.remove(topicId);
    } else {
      _bookmarkedTopics.add(topicId);
    }
    _saveState();
    notifyListeners();
  }

  bool isSystemDesignCompleted(int id) => _completedSystemDesigns.contains(id);

  void toggleSystemDesignCompleted(int id) {
    if (_completedSystemDesigns.contains(id)) {
      _completedSystemDesigns.remove(id);
    } else {
      _completedSystemDesigns.add(id);
    }
    _saveState();
    notifyListeners();
  }

  void recordMockInterview(MockInterviewRecord record) {
    _interviewHistory.add(record);
    notifyListeners();
  }

  void recordQuestionAnswered() {
    _answeredQuestionsCount++;
    _saveState();
    notifyListeners();
  }

  /// Default starting state: 0 progress across all metrics.
  /// Progress tracking begins dynamically as soon as the user starts studying.
  void _seedDefaultProgress() {
    _topicStatuses.clear();
    _completedSystemDesigns.clear();
    _answeredQuestionsCount = 0;
    _recentlyStudiedTopicIds.clear();
  }

  /// Explicitly reset all progress back to 0.
  void resetAllProgress() {
    _seedDefaultProgress();
    _bookmarkedTopics.clear();
    _interviewHistory.clear();
    _activeCourse = 'iOS Senior & Lead Prep';
    _activeModule = 'Domain 01: Swift Language Core';
    _activeTopic = 'Value vs Reference Semantics';
    _activeTopicId = 'dom01_top01';
    _activeDomainNumber = 1;
    _saveState();
    notifyListeners();
  }

  int get completedTopicsCount => _topicStatuses.values.where(
        (s) => s == TopicMasteryStatus.completed || s == TopicMasteryStatus.mastered,
      ).length;

  int get masteredTopicsCount => _topicStatuses.values.where(
        (s) => s == TopicMasteryStatus.mastered,
      ).length;

  int get inProgressTopicsCount => _topicStatuses.values.where(
        (s) => s == TopicMasteryStatus.inProgress,
      ).length;

  int get totalDomainsCount => 32;
  int get totalTopicsCount => 128;
  int get totalQuestionsCount => 100;
  int get answeredQuestionsCount => _answeredQuestionsCount;
  int get completedSystemDesignsCount => _completedSystemDesigns.length;
  int get totalSystemDesignsCount => 10;

  int get completedDomainsCount {
    int count = 0;
    for (int d = 1; d <= totalDomainsCount; d++) {
      if (getDomainProgress(d) >= 1.0) {
        count++;
      }
    }
    return count;
  }

  double get overallProgressPercentage {
    if (totalTopicsCount == 0) return 0.0;
    return (completedTopicsCount / totalTopicsCount).clamp(0.0, 1.0);
  }

  double getDomainProgress(int domainNumber) {
    final prefix = 'dom${domainNumber.toString().padLeft(2, '0')}_';
    final domainEntries = _topicStatuses.entries.where((e) => e.key.startsWith(prefix));
    if (domainEntries.isEmpty) return 0.0;

    const int topicsPerDomain = 4;
    double progressSum = 0.0;
    for (final entry in domainEntries) {
      if (entry.value == TopicMasteryStatus.mastered || entry.value == TopicMasteryStatus.completed) {
        progressSum += 1.0;
      } else if (entry.value == TopicMasteryStatus.inProgress) {
        progressSum += 0.5;
      }
    }
    return (progressSum / topicsPerDomain).clamp(0.0, 1.0);
  }
}

class MockInterviewRecord {
  final DateTime date;
  final String mode; // 'Quick 10', 'Senior 25', 'Lead 40', 'Mock Interview'
  final int totalQuestions;
  final int correctQuestions;
  final int scorePercentage;

  MockInterviewRecord({
    required this.date,
    required this.mode,
    required this.totalQuestions,
    required this.correctQuestions,
    required this.scorePercentage,
  });
}
