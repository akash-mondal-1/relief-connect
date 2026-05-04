import 'package:flutter_test/flutter_test.dart';
import 'package:volunteer_app/services/api_service.dart';

void main() {
  group('Need.fromJson', () {
    test('parses numeric ids safely', () {
      final need = Need.fromJson({
        'id': 7,
        'title': 'Food support',
        'location': 'Kolkata',
        'category': 'food',
        'urgency': 5,
        'description': 'Meals needed',
      });

      expect(need.id, '7');
      expect(need.urgency, 5);
      expect(need.title, 'Food support');
    });

    test('parses string ids safely', () {
      final need = Need.fromJson({
        'id': 'abc-123',
        'title': 'Medical support',
        'location': 'Delhi',
        'category': 'medical',
        'urgency': 4,
        'description': 'First aid needed',
      });

      expect(need.id, 'abc-123');
    });
  });

  group('MatchResult.fromJson', () {
    test('uses backend reason when present', () {
      final result = MatchResult.fromJson({
        'id': 2,
        'title': 'Medical Help Required',
        'location': 'Delhi',
        'category': 'medical',
        'urgency': 4,
        'description': 'First aid needed',
        'reason': 'Urgency 4/5; category match (medical)',
      });

      expect(result.need.category, 'medical');
      expect(result.reason, 'Urgency 4/5; category match (medical)');
    });

    test('fallback when reason missing', () {
      final result = MatchResult.fromJson({
        'id': 1,
        'title': 'Food Supplies',
        'location': 'Kolkata',
        'category': 'food',
        'urgency': 5,
        'description': 'Food required',
      });

      expect(result.reason, '');
    });
  });
}