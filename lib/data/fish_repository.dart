import 'regional_fish_mock.dart';

class FishRepository {
  // 複数の結果を返すように変更
  List<RegionalFish> convertMultiple(
    String fishName, {
    String? prefecture,
    String? city,
    String? port,
  }) {
    // ローカル名または正式名称で検索（大文字小文字区別なし）
    var results = regionalFishMock.where((fish) {
      final inputLower = fishName.toLowerCase();
      return fish.localName.toLowerCase() == inputLower ||
             fish.formalName.toLowerCase() == inputLower;
    }).toList();

    // 地域情報でフィルタリング
    if (prefecture != null && prefecture.isNotEmpty) {
      results = results.where((fish) => fish.prefecture == prefecture).toList();
    }
    
    if (city != null && city.isNotEmpty) {
      results = results.where((fish) => fish.city == city).toList();
    }
    
    if (port != null && port.isNotEmpty) {
      results = results.where((fish) => fish.port == port).toList();
    }

    return results;
  }

  // 後方互換性のため、単一の結果を返すメソッドも残す
  String convert(
    String fishName, {
    String? prefecture,
    String? city,
    String? port,
  }) {
    final results = convertMultiple(
      fishName,
      prefecture: prefecture,
      city: city,
      port: port,
    );
    
    if (results.isEmpty) {
      return '該当する魚が見つかりません';
    }
    
    if (results.length == 1) {
      return results.first.formalName;
    }
    
    // 複数ある場合は最初の1件
    return results.first.formalName;
  }
}
