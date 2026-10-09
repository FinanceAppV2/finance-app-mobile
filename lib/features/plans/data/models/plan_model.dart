import '../../domain/entities/plan.dart';
import 'plan_feature_model.dart';

class PlanModel {
  final String id;
  final String type;
  final String name;
  final String? description;
  final double price;
  final String billingPeriod;
  final bool active;
  final List<PlanFeatureModel> features;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PlanModel({
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

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    final rawFeatures = json['features'] as List<dynamic>?;
    final features = rawFeatures != null
        ? rawFeatures
            .map((f) => PlanFeatureModel.fromJson(f as Map<String, dynamic>))
            .toList()
        : <PlanFeatureModel>[];

    return PlanModel(
      id: json['id'] as String,
      type: json['type'] as String? ?? json['code'] as String? ?? 'FREE',
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      billingPeriod: json['billingPeriod'] as String? ?? 'MONTHLY',
      active: json['active'] as bool? ?? true,
      features: features,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'description': description,
      'price': price,
      'billingPeriod': billingPeriod,
      'active': active,
      'features': features.map((f) => f.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Plan toEntity() {
    return Plan(
      id: id,
      type: type,
      name: name,
      description: description,
      price: price,
      billingPeriod: billingPeriod,
      active: active,
      features: features.map((f) => f.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
