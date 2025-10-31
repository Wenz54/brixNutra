import 'package:flutter/material.dart';
import '../theme/brix_theme.dart';

/// Селектор настроения Brix
/// 
/// Используется для выбора настроения пользователя в дневнике
/// Поддерживает 5 уровней настроения (1-5 звезд)
class BrixMoodSelector extends StatelessWidget {
  final int? selectedMood; // 1-5 (null = не выбрано)
  final Function(int)? onMoodSelected;
  final bool isCompact;

  const BrixMoodSelector({
    super.key,
    this.selectedMood,
    this.onMoodSelected,
    this.isCompact = false,
  });

  String _getMoodLabel(int mood) {
    switch (mood) {
      case 1:
        return 'Очень плохо';
      case 2:
        return 'Плохо';
      case 3:
        return 'Нормально';
      case 4:
        return 'Хорошо';
      case 5:
        return 'Отлично';
      default:
        return '';
    }
  }

  String _getMoodEmoji(int mood) {
    switch (mood) {
      case 1:
        return '😢';
      case 2:
        return '😕';
      case 3:
        return '😐';
      case 4:
        return '🙂';
      case 5:
        return '😄';
      default:
        return '';
    }
  }

  Color _getMoodColor(int mood) {
    switch (mood) {
      case 1:
        return BrixColors.error;
      case 2:
        return BrixColors.warning;
      case 3:
        return BrixColors.secondary;
      case 4:
        return BrixColors.accent;
      case 5:
        return BrixColors.success;
      default:
        return BrixColors.textTertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _buildCompactVersion();
    }

    return _buildFullVersion();
  }

  Widget _buildFullVersion() {
    return Container(
      padding: EdgeInsets.all(BrixSpacing.lg),
      decoration: BoxDecoration(
        color: BrixColors.surface,
        borderRadius: BrixSpacing.borderRadiusMD,
        boxShadow: BrixShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.emoji_emotions_outlined,
                color: BrixColors.secondary,
                size: 24,
              ),
              SizedBox(width: BrixSpacing.sm),
              Text(
                'Как настроение?',
                style: BrixTypography.h5,
              ),
            ],
          ),

          SizedBox(height: BrixSpacing.lg),

          // Mood Options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int mood = 1; mood <= 5; mood++)
                _buildMoodButton(mood, isLarge: true),
            ],
          ),

          // Selected Mood Label
          if (selectedMood != null) ...[
            SizedBox(height: BrixSpacing.md),
            Center(
              child: Text(
                _getMoodLabel(selectedMood!),
                style: BrixTypography.bodyMedium.copyWith(
                  color: _getMoodColor(selectedMood!),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactVersion() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int mood = 1; mood <= 5; mood++) ...[
          _buildMoodButton(mood, isLarge: false),
          if (mood < 5) SizedBox(width: BrixSpacing.sm),
        ],
      ],
    );
  }

  Widget _buildMoodButton(int mood, {required bool isLarge}) {
    final isSelected = selectedMood == mood;
    final size = isLarge ? 56.0 : 40.0;
    final iconSize = isLarge ? 32.0 : 24.0;

    return GestureDetector(
      onTap: () => onMoodSelected?.call(mood),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isSelected
              ? _getMoodColor(mood).withOpacity(0.2)
              : BrixColors.surfaceDark,
          borderRadius: BrixSpacing.borderRadiusMD,
          border: Border.all(
            color: isSelected
                ? _getMoodColor(mood)
                : BrixColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            _getMoodEmoji(mood),
            style: TextStyle(fontSize: iconSize),
          ),
        ),
      ),
    );
  }
}

/// Простой индикатор настроения (только показ, без выбора)
class BrixMoodIndicator extends StatelessWidget {
  final int mood; // 1-5

  const BrixMoodIndicator({
    super.key,
    required this.mood,
  });

  String _getMoodLabel() {
    switch (mood) {
      case 1:
        return 'Очень плохо';
      case 2:
        return 'Плохо';
      case 3:
        return 'Нормально';
      case 4:
        return 'Хорошо';
      case 5:
        return 'Отлично';
      default:
        return 'Не указано';
    }
  }

  String _getMoodEmoji() {
    switch (mood) {
      case 1:
        return '😢';
      case 2:
        return '😕';
      case 3:
        return '😐';
      case 4:
        return '🙂';
      case 5:
        return '😄';
      default:
        return '❓';
    }
  }

  Color _getMoodColor() {
    switch (mood) {
      case 1:
        return BrixColors.error;
      case 2:
        return BrixColors.warning;
      case 3:
        return BrixColors.secondary;
      case 4:
        return BrixColors.accent;
      case 5:
        return BrixColors.success;
      default:
        return BrixColors.textTertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: BrixSpacing.md,
        vertical: BrixSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: _getMoodColor().withOpacity(0.1),
        borderRadius: BrixSpacing.borderRadiusMD,
        border: Border.all(
          color: _getMoodColor().withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _getMoodEmoji(),
            style: const TextStyle(fontSize: 20),
          ),
          SizedBox(width: BrixSpacing.sm),
          Text(
            _getMoodLabel(),
            style: BrixTypography.labelMedium.copyWith(
              color: _getMoodColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}



