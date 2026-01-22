// モックデータ: 魚名、県名、市区町村名、漁港名の組み合わせで正式名称を返す
const Map<String, Map<String, String>> fishMock = {
  // ハマチ関連
  'ハマチ': {
    'default': 'ブリ',
    'prefecture': '福岡県',
    'city': '福岡市',
    'port': '博多港',
  },
  // ツバス関連
  'ツバス': {
    'default': 'ブリ',
    'prefecture': '長崎県',
    'city': '長崎市',
    'port': '長崎港',
  },
  // イナダ関連
  'イナダ': {
    'default': 'ブリ',
    'prefecture': '静岡県',
    'city': '静岡市',
    'port': '清水港',
  },
  // アジ関連
  'アジ': {
    'default': 'マアジ',
    'prefecture': '千葉県',
    'city': '銚子市',
    'port': '銚子漁港',
  },
  // サバ関連
  'サバ': {
    'default': 'マサバ',
    'prefecture': '宮城県',
    'city': '気仙沼市',
    'port': '気仙沼漁港',
  },
};
