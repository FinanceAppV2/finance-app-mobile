import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app_mobile/features/plans/data/models/plan_model.dart';

void main() {
  group('PlanModel', () {
    test('should correctly deserialize from json and map to entity including features', () {
      final json = {
        'id': 'plan-123',
        'type': 'PLUS',
        'name': 'Plus',
        'description': 'Controle avançado',
        'price': 9.9,
        'billingPeriod': 'MONTHLY',
        'active': true,
        'features': [
          {
            'id': 'feat-1',
            'code': 'BANK_SYNC',
            'name': 'Sincronização bancária',
            'description': 'Open Finance',
            'included': true,
            'limit': null,
            'order': 1,
          },
          {
            'id': 'feat-2',
            'code': 'AI_INSIGHTS',
            'name': 'Insights IA',
            'description': null,
            'included': false,
            'limit': null,
            'order': 2,
          }
        ],
        'createdAt': '2026-01-01T00:00:00.000Z',
        'updatedAt': '2026-01-01T00:00:00.000Z',
      };

      final model = PlanModel.fromJson(json);

      expect(model.id, 'plan-123');
      expect(model.type, 'PLUS');
      expect(model.name, 'Plus');
      expect(model.description, 'Controle avançado');
      expect(model.price, 9.9);
      expect(model.billingPeriod, 'MONTHLY');
      expect(model.active, true);
      expect(model.features.length, 2);

      final entity = model.toEntity();
      expect(entity.id, 'plan-123');
      expect(entity.isPlus, isTrue);
      expect(entity.isFree, isFalse);
      expect(entity.isPro, isFalse);
      expect(entity.formattedPrice, 'R\$ 9,90/mês');
      expect(entity.features.length, 2);
      expect(entity.features[0].name, 'Sincronização bancária');
      expect(entity.features[0].included, isTrue);
      expect(entity.features[1].name, 'Insights IA');
      expect(entity.features[1].included, isFalse);
    });

    test('should format price as Grátis / R\$ 0,00 for FREE plan', () {
      final json = {
        'id': 'plan-free',
        'type': 'FREE',
        'name': 'Grátis',
        'description': 'Controle manual',
        'price': 0.0,
        'billingPeriod': 'MONTHLY',
        'active': true,
      };

      final model = PlanModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.isFree, isTrue);
      expect(entity.formattedPrice, 'R\$ 0,00');
    });
  });
}
