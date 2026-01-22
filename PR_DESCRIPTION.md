# 地域の魚情報一覧・詳細画面の実装とナビゲーション改善

## 概要
地域の魚情報を一覧表示し、詳細画面への遷移機能を実装しました。また、ボトムナビゲーションの順序を調整し、魚名登録画面に閉じるボタンを追加しました。

## 主な変更内容

### 新規機能
- **地域の魚情報一覧画面** (`lib/pages/regional_fish_list_page.dart`)
  - モックデータから地域の魚情報をリスト表示
  - 各アイテムをタップで詳細画面に遷移
  - 右下に追加ボタン（FloatingActionButton）を配置
  - 追加ボタンで編集画面に遷移

- **地域の魚情報詳細画面** (`lib/pages/regional_fish_detail_page.dart`)
  - 魚の詳細情報を表示（ローカル名、正式名称、県名、市区町村名、漁港名、備考）
  - 戻るボタンで一覧に戻る機能

- **モックデータの追加** (`lib/data/regional_fish_mock.dart`)
  - `RegionalFish`クラスを定義
  - 10件のモックデータを追加（5件から2倍に増加）
  - 各データにid、ローカル名、正式名称、地域情報、備考を含む

### UI改善
- **魚名登録画面に×ボタンを追加**
  - ヘッダー右側に×ボタンを配置
  - 押下時に画面を閉じる機能を実装

### ルーティング・ナビゲーション改善
- **ルーティングの変更** (`lib/router.dart`)
  - `/` → 地域の魚情報一覧ページ（初期表示）
  - `/fish-convert` → 魚名変換ページ
  - `/regional-fish-detail/:id` → 詳細画面（IDパラメータ付き）
  - `/regional-fish-edit` → 編集画面（追加画面）

- **ボトムナビゲーションの順序変更** (`lib/app/main_scaffold.dart`)
  - 左端: 魚の登録（地域の魚情報一覧）
  - 中央: 変換（魚名変換）
  - 右端: 漁港登録

## 変更ファイル
- `lib/pages/regional_fish_list_page.dart` (新規)
- `lib/pages/regional_fish_detail_page.dart` (新規)
- `lib/data/regional_fish_mock.dart` (新規)
- `lib/app/main_scaffold.dart` (+14行, -14行)
- `lib/pages/regional_fish_registration_page.dart` (+57行, -27行)
- `lib/router.dart` (+15行, -1行)

## 技術的な詳細
- GoRouterを使用した画面遷移
- モックデータベースのリスト構造
- 既存のデザインスタイルに統一されたUI

## テスト
- [x] 一覧画面でのモックデータ表示
- [x] リストアイテムタップ時の詳細画面遷移
- [x] 詳細画面での情報表示
- [x] ×ボタンでの画面閉じる機能
- [x] ボトムナビゲーションからの各画面への遷移
