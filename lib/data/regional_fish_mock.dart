// 地域の魚情報のモックデータ
class RegionalFish {
  final String id;
  final String localName;
  final String formalName;
  final String prefecture;
  final String city;
  final String? port;
  final String? notes;

  RegionalFish({
    required this.id,
    required this.localName,
    required this.formalName,
    required this.prefecture,
    required this.city,
    this.port,
    this.notes,
  });
}

final List<RegionalFish> regionalFishMock = [
  RegionalFish(
    id: '1',
    localName: 'ハマチ',
    formalName: 'ブリ',
    prefecture: '福岡県',
    city: '福岡市',
    port: '博多港',
    notes: '福岡県でよく使われる呼び名',
  ),
  RegionalFish(
    id: '2',
    localName: 'ツバス',
    formalName: 'ブリ',
    prefecture: '長崎県',
    city: '長崎市',
    port: '長崎港',
    notes: '長崎県で若いブリを指す呼び名',
  ),
  RegionalFish(
    id: '3',
    localName: 'イナダ',
    formalName: 'ブリ',
    prefecture: '静岡県',
    city: '静岡市',
    port: '清水港',
    notes: '静岡県で中サイズのブリを指す呼び名',
  ),
  RegionalFish(
    id: '4',
    localName: 'アジ',
    formalName: 'マアジ',
    prefecture: '千葉県',
    city: '銚子市',
    port: '銚子漁港',
    notes: '千葉県で一般的に使われる呼び名',
  ),
  RegionalFish(
    id: '5',
    localName: 'サバ',
    formalName: 'マサバ',
    prefecture: '宮城県',
    city: '気仙沼市',
    port: '気仙沼漁港',
    notes: '気仙沼で水揚げされるサバ',
  ),
  RegionalFish(
    id: '6',
    localName: 'ワカシ',
    formalName: 'ブリ',
    prefecture: '新潟県',
    city: '新潟市',
    port: '新潟港',
    notes: '新潟県で小さいブリを指す呼び名',
  ),
  RegionalFish(
    id: '7',
    localName: 'メジカ',
    formalName: 'マアジ',
    prefecture: '愛媛県',
    city: '宇和島市',
    port: '宇和島港',
    notes: '愛媛県でアジの一種を指す呼び名',
  ),
  RegionalFish(
    id: '8',
    localName: 'ゴマサバ',
    formalName: 'ゴマサバ',
    prefecture: '高知県',
    city: '高知市',
    port: '高知港',
    notes: '高知県でよく見られるサバの種類',
  ),
  RegionalFish(
    id: '9',
    localName: 'カンパチ',
    formalName: 'カンパチ',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    port: '鹿児島港',
    notes: '鹿児島県でよく水揚げされる',
  ),
  RegionalFish(
    id: '10',
    localName: 'ヒラマサ',
    formalName: 'ヒラマサ',
    prefecture: '沖縄県',
    city: '那覇市',
    port: '那覇港',
    notes: '沖縄県でよく見られる魚',
  ),
];
