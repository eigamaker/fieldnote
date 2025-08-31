# FIELD NOTE

野球スカウトゲームのPhase 1実装

## 概要

FIELD NOTEは、野球スカウトをテーマにしたシミュレーションゲームです。このPhase 1では、基本的なゲーム進行システムを実装しています。

## 機能

### Phase 1 実装済み機能
- ✅ ゲーム開始/終了機能
- ✅ 基本的な週進行（年/月/週管理）
- ✅ シンプルなゲーム状態管理
- ✅ 基本的なデータ保存/読み込み機能（JSONファイル）

### スカウトベース選手生成システム（新規追加）
- ✅ 選手エンティティ（能力値、ポジション、学年など）
- ✅ 学校エンティティ（レベル、所在地、種類など）
- ✅ スカウトアクション管理
- ✅ 選手生成ロジック（スカウトスキル依存）
- ✅ 学校への選手配属システム
- ✅ スカウト結果表示・管理
- ✅ 選手詳細情報表示
- ✅ 学校一覧・詳細画面
- ✅ ゲーム開始時の選手生成なし（設計制約遵守）

### 今後の実装予定
- 🔄 トーナメントシステム
- 🔄 統計・分析機能
- 🔄 より詳細なスカウト機能

## 技術仕様

- **フレームワーク**: Flutter 3.8.1+
- **ゲームエンジン**: Flame 1.32.0+
- **アーキテクチャ**: Clean Architecture
- **データ保存**: JSONファイル（ローカルストレージ）
- **対応プラットフォーム**: Windows, Android, iOS, Web, macOS, Linux

## プロジェクト構造

```
lib/
├── core/                           # コア機能
│   ├── domain/                     # ドメイン層
│   │   ├── entities/               # エンティティ
│   │   │   ├── game_state.dart     # ゲーム状態
│   │   │   ├── game_progress.dart  # ゲーム進行状況
│   │   │   ├── player.dart         # 選手エンティティ
│   │   │   ├── player_abilities.dart # 選手能力値
│   │   │   ├── school.dart         # 学校エンティティ
│   │   │   └── scout_action.dart   # スカウトアクション
│   │   └── repositories/           # リポジトリインターフェース
│   │       ├── game_repository.dart
│   │       ├── player_repository.dart
│   │       └── school_repository.dart
│   └── data/                       # データ層
│       └── local/                  # ローカルデータ
│           └── json_storage.dart   # JSONストレージ
├── features/                       # 機能別モジュール
│   ├── game_progression/          # ゲーム進行機能
│   │   ├── managers/               # マネージャー
│   │   │   └── game_progress_manager.dart
│   │   └── screens/                # 画面
│   │       ├── main_menu_screen.dart
│   │       └── game_screen.dart
│   ├── scouting/                   # スカウト機能
│   │   ├── managers/               # マネージャー
│   │   │   ├── scouting_manager.dart
│   │   │   └── player_generator.dart
│   │   └── screens/                # 画面
│   │       ├── scouting_screen.dart
│   │       └── scouting_result_screen.dart
│   └── schools/                    # 学校管理機能
│       ├── managers/               # マネージャー
│       │   └── school_manager.dart
│       └── screens/                # 画面
│           ├── school_list_screen.dart
│           └── school_detail_screen.dart
├── shared/                         # 共有ウィジェット
│   └── widgets/                    # ウィジェット
│       └── scouting_action_button.dart
└── main.dart                       # エントリーポイント
```

## 開発ルール

- 各クラス最大150行
- 各ファイル最大200行
- 循環依存を避ける
- 各クラスは単一責任を持つ

## セットアップ

### 前提条件
- Flutter SDK 3.8.1以上
- Dart SDK 3.8.1以上

### インストール手順

1. リポジトリをクローン
```bash
git clone <repository-url>
cd field_note
```

2. 依存関係をインストール
```bash
flutter pub get
```

3. アプリケーションを実行
```bash
flutter run
```

## 使用方法

### 基本ゲーム進行
1. **新規ゲーム開始**: メインメニューから「新規ゲーム開始」を選択
2. **週進行**: ゲーム画面で「次の週」ボタンをタップ
3. **月進行**: ゲーム画面で「次の月」ボタンをタップ
4. **年進行**: ゲーム画面で「次の年」ボタンをタップ
5. **ゲーム保存**: ゲーム画面の保存ボタンで手動保存
6. **ゲーム続行**: メインメニューから「ゲーム続行」を選択

### スカウトシステム
1. **スカウト実行**: ゲーム画面の「スカウト実行」ボタンでスカウト画面に移動
2. **学校選択**: スカウト対象校を選択
3. **スカウトスキル設定**: スカウトスキルを調整（10-100）
4. **スカウト実行**: スカウトを実行して選手を発見
5. **結果確認**: 発見した選手の詳細を確認
6. **学校一覧**: ゲーム画面の「学校一覧」ボタンで学校情報を確認

## データ保存

ゲームデータは以下のJSONファイルに保存されます：
- `data/game_state.json`: ゲーム状態
- `data/game_progress.json`: ゲーム進行状況

## ライセンス

このプロジェクトは開発中のため、ライセンスは未定です。

## 開発者

FIELD NOTE開発チーム

## バージョン

- **Phase 1**: 基本的なゲーム進行システム
- **Version**: 1.0.0
