import 'dart:convert';

/// Learning tracks supported for certification.
enum ExamTrack {
  flutter,
  swiftui,
  claude;

  String get displayName {
    switch (this) {
      case ExamTrack.flutter:
        return 'Flutter Certified Master Engineer';
      case ExamTrack.swiftui:
        return 'Apple Certified SwiftUI Specialist';
      case ExamTrack.claude:
        return 'Claude Certified Architect & Developer';
    }
  }

  String get shortName {
    switch (this) {
      case ExamTrack.flutter:
        return 'Flutter Master';
      case ExamTrack.swiftui:
        return 'SwiftUI Pro';
      case ExamTrack.claude:
        return 'Claude LLM';
    }
  }

  String get acronym {
    switch (this) {
      case ExamTrack.flutter:
        return 'FCME';
      case ExamTrack.swiftui:
        return 'ACSS';
      case ExamTrack.claude:
        return 'CCAD';
    }
  }

  int get passingPercentage {
    switch (this) {
      case ExamTrack.flutter:
        return 75;
      case ExamTrack.swiftui:
        return 75;
      case ExamTrack.claude:
        return 72;
    }
  }

  int get durationMinutes {
    switch (this) {
      case ExamTrack.flutter:
        return 15;
      case ExamTrack.swiftui:
        return 15;
      case ExamTrack.claude:
        return 15;
    }
  }
}

/// Generic exam question model used across all certification tracks.
class ExamQuestion {
  final int id;
  final ExamTrack track;
  final int domainId;
  final String domainName;
  final String scenario;
  final List<String> options;
  final int correctIndex;
  final String rationale;
  final String? codeSnippet;

  const ExamQuestion({
    required this.id,
    required this.track,
    required this.domainId,
    required this.domainName,
    required this.scenario,
    required this.options,
    required this.correctIndex,
    required this.rationale,
    this.codeSnippet,
  });
}

/// Represents the evaluated result of a candidate's exam submission.
class ExamResult {
  final String id;
  final ExamTrack track;
  final String candidateName;
  final int scorePercentage;
  final int correctCount;
  final int totalQuestions;
  final bool passed;
  final DateTime completedAt;
  final Map<String, double> domainBreakdown; // domainName -> score ratio
  final String certificateHash;

  const ExamResult({
    required this.id,
    required this.track,
    required this.candidateName,
    required this.scorePercentage,
    required this.correctCount,
    required this.totalQuestions,
    required this.passed,
    required this.completedAt,
    required this.domainBreakdown,
    required this.certificateHash,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'track': track.name,
        'candidateName': candidateName,
        'scorePercentage': scorePercentage,
        'correctCount': correctCount,
        'totalQuestions': totalQuestions,
        'passed': passed,
        'completedAt': completedAt.toIso8601String(),
        'domainBreakdown': domainBreakdown,
        'certificateHash': certificateHash,
      };

  factory ExamResult.fromJson(Map<String, dynamic> json) => ExamResult(
        id: json['id'] as String,
        track: ExamTrack.values.firstWhere((e) => e.name == json['track']),
        candidateName: json['candidateName'] as String,
        scorePercentage: (json['scorePercentage'] as num).toInt(),
        correctCount: (json['correctCount'] as num).toInt(),
        totalQuestions: (json['totalQuestions'] as num).toInt(),
        passed: json['passed'] as bool,
        completedAt: DateTime.parse(json['completedAt'] as String),
        domainBreakdown: (json['domainBreakdown'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, (v as num).toDouble()),
        ),
        certificateHash: json['certificateHash'] as String,
      );

  String encode() => jsonEncode(toJson());
  static ExamResult decode(String str) =>
      ExamResult.fromJson(jsonDecode(str) as Map<String, dynamic>);
}
