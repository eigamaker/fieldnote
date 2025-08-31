# Phase 7: Scout Network and Information Sharing System

## 概要
Phase 7では、スカウトネットワークと情報共有システムを追加し、スカウト間の協力・競合関係、情報の価値評価、レピュテーション管理を実現します。

## 追加機能

### 1. スカウトネットワークシステム
- **ネットワーク接続管理**: スカウト間の関係性（同僚、師匠、弟子、競合、知人、友人）の管理
- **信頼レベル**: 低、中、高、非常に高いの4段階での信頼度評価
- **接続強度計算**: 信頼レベルと最終連絡日時を考慮した接続の強度評価
- **ネットワーク分析**: ネットワーク強度、多様性、アクティブ接続数の計算

### 2. 情報共有システム
- **情報タイプ**: 選手レポート、スカウトデータ、チーム分析、大会情報、市場動向、内部情報
- **品質評価**: 低、普通、良、優秀、卓越の5段階評価
- **共有権限**: 非公開、共有、独占、公開の4段階
- **価値評価**: 品質、新鮮度、共有数、タイプ、権限を考慮した総合価値計算

### 3. スカウトレポートシステム
- **レポートステータス**: 下書き、作成中、完了、レビュー済み、アーカイブ
- **信頼度**: 低、中、高、非常に高いの4段階
- **品質スコア**: 実行サマリー、詳細分析、強み・弱み・推奨事項の完全性評価
- **レポート共有**: 特定スカウトとの情報共有と公開設定

### 4. スカウトレピュテーションシステム
- **レピュテーションレベル**: 無名、初心者、確立、尊敬、著名、伝説の6段階
- **評価カテゴリ**: 選手評価、情報精度、ネットワーク影響力、倫理的行動、総合評価
- **信頼性スコア**: 検証状況、評価数、実績を考慮した信頼性評価
- **影響力スコア**: ネットワーク影響力、総合評価、推薦数を考慮した影響力評価

## ファイル構造

### エンティティ
- `lib/core/domain/entities/scout_network.dart` - スカウトネットワークと接続関係
- `lib/core/domain/entities/information_share.dart` - 情報共有と価値評価
- `lib/core/domain/entities/scouting_report.dart` - スカウトレポートと品質管理
- `lib/core/domain/entities/scout_reputation.dart` - スカウトレピュテーションと評価

### リポジトリ
- `lib/core/domain/repositories/network_repository.dart` - ネットワークデータ管理
- `lib/core/domain/repositories/report_repository.dart` - レポートデータ管理
- `lib/core/domain/repositories/information_repository.dart` - 情報共有データ管理
- `lib/core/domain/repositories/reputation_repository.dart` - レピュテーションデータ管理

### マネージャー
- `lib/features/network/managers/network_manager.dart` - ネットワーク業務ロジック
- `lib/features/network/managers/reputation_manager.dart` - レピュテーション業務ロジック
- `lib/features/information/managers/report_manager.dart` - レポート業務ロジック

### サービス
- `lib/features/information/services/value_calculator.dart` - 情報価値計算サービス

### 画面（プレースホルダー）
- `lib/features/network/screens/network_screen.dart` - ネットワーク表示画面
- `lib/features/network/screens/scout_list_screen.dart` - スカウト一覧画面
- `lib/features/network/screens/cooperation_screen.dart` - 協力・競合画面
- `lib/features/information/screens/report_creation_screen.dart` - レポート作成画面
- `lib/features/information/screens/report_library_screen.dart` - レポートライブラリ画面
- `lib/features/information/screens/information_market_screen.dart` - 情報市場画面

### 共有ウィジェット（プレースホルダー）
- `lib/shared/widgets/network_node.dart` - ネットワークノード表示
- `lib/shared/widgets/report_card.dart` - レポートカード表示
- `lib/shared/widgets/reputation_indicator.dart` - レピュテーション指標表示

## 主要な計算ロジック

### 情報価値計算
```dart
// 基本価値 × 品質 × 新鮮度 × 共有数 × タイプ × 権限
final value = baseValue * qualityMultiplier * freshnessMultiplier * 
              shareMultiplier * typeMultiplier * permissionMultiplier;
```

### ネットワーク強度計算
```dart
// 全接続の信頼レベル平均
final strength = connections.map((c) => c.trustLevel.index + 1)
                           .reduce((a, b) => a + b) / connections.length;
```

### レポート品質スコア
```dart
// 基本情報(50点) + 分析内容(50点) + 信頼度ボーナス
final score = (executiveSummary ? 20 : 0) + (detailedAnalysis ? 30 : 0) +
              (strengths ? 15 : 0) + (weaknesses ? 15 : 0) + 
              (recommendations ? 20 : 0) + (confidence.index + 1) * 5;
```

### レピュテーション信頼性スコア
```dart
// 基本スコア + 検証ボーナス + 評価数ボーナス + 実績ボーナス
final score = overallScore + (isVerified ? 10 : 0) + 
              (totalRatings >= 100 ? 5 : totalRatings >= 50 ? 3 : 1) +
              (achievements.length * 2).clamp(0, 20);
```

## 統合ポイント

### 既存システムとの連携
- **スカウトアクション**: スカウト成功時にレピュテーション更新
- **週次進行**: ネットワーク接続の有効性チェック、情報の新鮮度更新
- **選手生成**: スカウトレポートとの連携で選手評価の精度向上

### データフロー
1. スカウトアクション実行
2. レポート作成・更新
3. 情報共有・価値評価
4. レピュテーション更新
5. ネットワーク効果反映

## 今後の実装予定

### Flutter UI実装
- ネットワーク可視化画面
- レポート作成・編集画面
- 情報市場・取引画面
- レピュテーション管理画面

### 高度な機能
- 機械学習による価値予測
- リアルタイム通知システム
- 高度な分析・レポート機能
- モバイル最適化

## 技術仕様

### データ永続化
- JSONファイルによるローカルストレージ
- ストリームベースのリアクティブ更新
- データ整合性チェック・検証

### パフォーマンス
- インデックス作成による検索最適化
- クエリ最適化
- メモリ効率的なデータ管理

### 拡張性
- プラグイン可能な価値計算アルゴリズム
- 設定可能な評価パラメータ
- モジュラー設計による機能追加の容易性
