import 'fish_mock.dart';

class FishRepository {
  String convert(String input) {
    return fishMock[input] ?? '該当する魚が見つかりません';
  }
}
