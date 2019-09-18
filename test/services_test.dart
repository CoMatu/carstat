import 'package:carstat/models/car.dart';
import 'package:carstat/services/image_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('проверка image service', () async {
    final imageService = ImageService();
    final Car car = Car();
    car.carId = '12345';
    var result = await imageService.getImage(car);
  });
}