import '../../domain/entities/plan_feature.dart';

class PlanFeatureModel {
  final String id;
  final String code;
  final String name;
  final String? description;
  final bool included;
  final int? limit;
  final int order;

  const PlanFeatureModel({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    required this.included,
    this.limit,
    required this.order,
  });

  factory PlanFeatureModel.fromJson(Map<String, dynamic> json) {
    return PlanFeatureModel(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      included: json['included'] as bool? ?? true,
      limit: json['limit'] as int?,
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'included': included,
      'limit': limit,
      'order': order,
    };
  }

  PlanFeature toEntity() {
    return PlanFeature(
      id: id,
      code: code,
      name: name,
      description: description,
      included: included,
      limit: limit,
      order: order,
    );
  }
}
