import 'package:equatable/equatable.dart';

enum PlanFeatureCode {
  maxCards('MAX_CARDS'),
  manualExpenses('MANUAL_EXPENSES'),
  basicReports('BASIC_REPORTS'),
  bankSync('BANK_SYNC'),
  aiInsights('AI_INSIGHTS'),
  advancedReports('ADVANCED_REPORTS'),
  patrimonyTracking('PATRIMONY_TRACKING'),
  prioritySupport('PRIORITY_SUPPORT'),
  unknown('UNKNOWN');

  final String value;
  const PlanFeatureCode(this.value);

  static PlanFeatureCode fromString(String code) {
    return PlanFeatureCode.values.firstWhere(
      (e) => e.value.toUpperCase() == code.toUpperCase(),
      orElse: () => PlanFeatureCode.unknown,
    );
  }
}

class PlanFeature extends Equatable {
  final String id;
  final String code;
  final String name;
  final String? description;
  final bool included;
  final int? limit;
  final int order;

  const PlanFeature({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    required this.included,
    this.limit,
    required this.order,
  });

  PlanFeatureCode get featureCode => PlanFeatureCode.fromString(code);

  bool get isMaxCards => featureCode == PlanFeatureCode.maxCards;
  bool get isAiInsights => featureCode == PlanFeatureCode.aiInsights;
  bool get isBankSync => featureCode == PlanFeatureCode.bankSync;

  @override
  List<Object?> get props => [
        id,
        code,
        name,
        description,
        included,
        limit,
        order,
      ];
}
