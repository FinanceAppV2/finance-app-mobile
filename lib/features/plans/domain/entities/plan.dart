import 'package:equatable/equatable.dart';

import 'plan_feature.dart';

enum PlanType {
  free('FREE'),
  plus('PLUS'),
  pro('PRO'),
  unknown('UNKNOWN');

  final String value;
  const PlanType(this.value);

  static PlanType fromString(String type) {
    return PlanType.values.firstWhere(
      (e) => e.value.toUpperCase() == type.toUpperCase(),
      orElse: () => PlanType.unknown,
    );
  }
}

class Plan extends Equatable {
  final String id;
  final String type;
  final String name;
  final String? description;
  final double price;
  final String billingPeriod;
  final bool active;
  final List<PlanFeature> features;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Plan({
    required this.id,
    required this.type,
    required this.name,
    this.description,
    required this.price,
    required this.billingPeriod,
    required this.active,
    this.features = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  PlanType get planType => PlanType.fromString(type);

  bool get isFree => planType == PlanType.free;
  bool get isPlus => planType == PlanType.plus;
  bool get isPro => planType == PlanType.pro;

  String get formattedPrice {
    if (price == 0) return 'R\$ 0,00';
    return 'R\$ ${price.toStringAsFixed(2).replaceAll('.', ',')}/mês';
  }

  PlanFeature? getFeature(PlanFeatureCode code) {
    try {
      return features.firstWhere((f) => f.featureCode == code);
    } catch (_) {
      return null;
    }
  }

  int? get maxCardsLimit {
    final feat = getFeature(PlanFeatureCode.maxCards);
    return feat?.limit;
  }

  @override
  List<Object?> get props => [
        id,
        type,
        name,
        description,
        price,
        billingPeriod,
        active,
        features,
        createdAt,
        updatedAt,
      ];
}
