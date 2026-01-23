import 'package:gyofu/data/regional_fish_mock.dart';

/// モックデータから都道府県リストを取得
List<String> getPrefecturesFromMock() {
  final prefectures = regionalFishMock
      .map((fish) => fish.prefecture)
      .toSet()
      .toList();
  
  return prefectures..sort();
}

/// モックデータから市区町村リストを取得（県名でフィルタリング）
List<String> getCitiesByPrefecture(String? prefecture) {
  if (prefecture == null || prefecture.isEmpty) {
    return [];
  }
  
  final cities = regionalFishMock
      .where((fish) => fish.prefecture == prefecture)
      .map((fish) => fish.city)
      .toSet()
      .toList();
  
  return cities..sort();
}

/// モックデータから漁港名リストを取得（県名と市区町村でフィルタリング）
List<String> getPortsByPrefectureAndCity(String? prefecture, String? city) {
  if (prefecture == null || prefecture.isEmpty || city == null || city.isEmpty) {
    return [];
  }
  
  final ports = regionalFishMock
      .where((fish) => 
          fish.prefecture == prefecture && 
          fish.city == city &&
          fish.port != null &&
          fish.port!.isNotEmpty)
      .map((fish) => fish.port!)
      .toSet()
      .toList();
  
  return ports..sort();
}
