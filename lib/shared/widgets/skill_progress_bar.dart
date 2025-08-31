import 'package:flutter/material.dart';

/// スキルプログレスバーウィジェット
/// スキルレベルと経験値の進行度を視覚的に表示
class SkillProgressBar extends StatelessWidget {
  final String skillName;
  final int currentLevel;
  final int maxLevel;
  final double progress; // 0.0-1.0
  final Color? color;
  final double height;
  final bool showLabel;
  final bool showPercentage;

  const SkillProgressBar({
    super.key,
    required this.skillName,
    required this.currentLevel,
    this.maxLevel = 100,
    required this.progress,
    this.color,
    this.height = 20.0,
    this.showLabel = true,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressColor = color ?? theme.primaryColor;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skillName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$currentLevel/$maxLevel',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        Container(
          height: height,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(height / 2),
            child: Stack(
              children: [
                // 背景バー
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: theme.colorScheme.surfaceVariant,
                ),
                // プログレスバー
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: MediaQuery.of(context).size.width * progress * 0.8, // 画面幅の80%を基準
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        progressColor,
                        progressColor.withOpacity(0.8),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
                // パーセンテージ表示
                if (showPercentage)
                  Center(
                    child: Text(
                      '${(progress * 100).toStringAsFixed(1)}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _getTextColor(progressColor),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// テキスト色の決定（背景色に応じて白または黒を選択）
  Color _getTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

/// 経験値プログレスバーウィジェット
/// レベル進行度と経験値を表示
class ExperienceProgressBar extends StatelessWidget {
  final String scoutName;
  final int currentLevel;
  final int currentExperience;
  final int experienceToNextLevel;
  final Color? color;
  final double height;

  const ExperienceProgressBar({
    super.key,
    required this.scoutName,
    required this.currentLevel,
    required this.currentExperience,
    required this.experienceToNextLevel,
    this.color,
    this.height = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressColor = color ?? theme.primaryColor;
    final progress = experienceToNextLevel > 0 
        ? currentExperience / experienceToNextLevel 
        : 1.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$scoutName (Lv.$currentLevel)',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${currentExperience}/${experienceToNextLevel}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(height / 2),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(height / 2),
            child: Stack(
              children: [
                // 背景バー
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: theme.colorScheme.surfaceVariant,
                ),
                // プログレスバー
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: MediaQuery.of(context).size.width * progress * 0.8,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        progressColor,
                        progressColor.withOpacity(0.8),
                        progressColor.withOpacity(0.6),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
                // レベルアップインジケーター
                if (progress >= 1.0)
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.yellow.withOpacity(0.3),
                          Colors.orange.withOpacity(0.3),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 16,
                      ),
                    ),
                  ),
                // パーセンテージ表示
                Center(
                  child: Text(
                    '${(progress * 100).toStringAsFixed(1)}%',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _getTextColor(progressColor),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '次のレベルまで: ${experienceToNextLevel - currentExperience} exp',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  /// テキスト色の決定
  Color _getTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

/// スキルレベル表示ウィジェット
/// 個別スキルのレベルを表示
class SkillLevelDisplay extends StatelessWidget {
  final String skillName;
  final int level;
  final int maxLevel;
  final Color? color;
  final bool showProgress;

  const SkillLevelDisplay({
    super.key,
    required this.skillName,
    required this.level,
    this.maxLevel = 100,
    this.color,
    this.showProgress = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final skillColor = color ?? theme.primaryColor;
    final progress = level / maxLevel;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skillName,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: skillColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Lv.$level',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: skillColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (showProgress) ...[
            const SizedBox(height: 8),
            SkillProgressBar(
              skillName: '',
              currentLevel: level,
              maxLevel: maxLevel,
              progress: progress,
              color: skillColor,
              height: 8,
              showLabel: false,
              showPercentage: false,
            ),
          ],
        ],
      ),
    );
  }
}
