import 'fish_mock.dart';

class FishRepository {
  String convert(
    String fishName, {
    String? prefecture,
    String? city,
    String? port,
  }) {
    final fishData = fishMock[fishName];
    if (fishData == null) {
      return '該当する魚が見つかりません';
    }

    // 地域情報が指定されている場合は、それも考慮する
    // 現時点では、魚名が一致すれば正式名称を返す
    // 将来的に地域情報も検索条件に含める場合は、ここで拡張可能
    return fishData['default'] ?? '該当する魚が見つかりません';
  }

  // 地域情報を取得するヘルパーメソッド
  Map<String, String>? getLocationInfo(String fishName) {
    return fishMock[fishName];
  }
}
