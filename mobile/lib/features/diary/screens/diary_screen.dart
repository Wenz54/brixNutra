import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/diary/diary.dart';
import 'package:mobile/shared/services/storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../dev_modules/ui_kit_module/theme/brix_theme.dart';

/// Экран дневника питания
///
/// Функции:
/// - Просмотр дня (все приемы пищи)
/// - Добавление приема пищи с фото
/// - Просмотр прогресса по КБЖУ
/// - Водный баланс
/// - История
class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  DateTime _selectedDate = DateTime.now();
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _loadDayDiary();
  }

  void _loadDayDiary() {
    context.read<DiaryBloc>().add(LoadDayDiaryRequested(_selectedDate));
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    context.read<DiaryBloc>().add(LoadDayDiaryRequested(date));
  }

  Future<void> _addMeal() async {
    // Show dialog to choose photo source
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить прием пищи'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Камера'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Галерея'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Найти продукт'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Open food search
              },
            ),
          ],
        ),
      ),
    );

    if (source != null && mounted) {
      // Upload photo
      try {
        final photoUrl = await _storageService.pickAndUploadDiaryPhoto(source: source);
        if (photoUrl != null && mounted) {
          // TODO: Open form to add meal details
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Фото загружено: $photoUrl'),
              action: SnackBarAction(
                label: 'Добавить',
                onPressed: () {
                  // TODO: Add meal with photo
                },
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('❌ Ошибка: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrixColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(BrixSpacing.lg),
              decoration: BoxDecoration(
                color: BrixColors.surface,
                boxShadow: BrixShadows.small,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Дневник питания',
                        style: BrixTypography.h2,
                      ),
                      IconButton(
                        icon: const Icon(Icons.history, color: BrixColors.textPrimary),
                        onPressed: () {
                          // TODO: Show history
                          context.read<DiaryBloc>().add(
                            const LoadDiaryHistoryRequested(limit: 30),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: BrixSpacing.lg),
                  // Date selector
                  _buildDateSelector(),
                ],
              ),
            ),

            // Content
            Expanded(
              child: BlocBuilder<DiaryBloc, DiaryState>(
                builder: (context, state) {
                  if (state is DiaryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is DiaryError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 60, color: Colors.red),
                          const SizedBox(height: 16),
                          Text('Ошибка: ${state.message}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadDayDiary,
                            child: const Text('Повторить'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is DayDiaryLoaded) {
                    return _buildDayContent(state.diaryDay);
                  }

                  return const Center(child: Text('Выберите дату'));
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addMeal,
        backgroundColor: const Color(0xFF4CAF50),
        icon: const Icon(Icons.add),
        label: const Text('Добавить'),
      ),
    );
  }

  Widget _buildDateSelector() {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index - 3));
          final isSelected = DateFormat('yyyy-MM-dd').format(date) ==
              DateFormat('yyyy-MM-dd').format(_selectedDate);
          final isToday = DateFormat('yyyy-MM-dd').format(date) ==
              DateFormat('yyyy-MM-dd').format(DateTime.now());

          return GestureDetector(
            onTap: () => _selectDate(date),
            child: Container(
              width: 55,
              margin: EdgeInsets.only(right: index < 6 ? 12 : 0),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF2196F3)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: isToday
                    ? Border.all(color: const Color(0xFF2196F3), width: 2)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE', 'ru').format(date).substring(0, 2),
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('d').format(date),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDayContent(DiaryDay day) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadDayDiary();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Stats Card
            _buildStatsCard(day.stats),

            // Water Tracker
            _buildWaterTracker(day.waterLog.totalAmount),

            // Meals
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                children: [
                  Icon(Icons.restaurant_menu, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Приемы пищи',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            if (day.meals.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.no_meals, size: 60, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      'Нет записей',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Нажмите "Добавить" чтобы начать',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...day.meals.map((meal) => _buildMealCard(meal)),

            const SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(DailyStats stats) {
    // Get goals from DiaryDay (passed separately)
    // For now using hardcoded goals, TODO: pass goals from parent
    final caloriesGoal = 2000;
    final caloriesProgress = caloriesGoal > 0
        ? (stats.totalCalories / caloriesGoal).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Calories
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Калории',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${stats.totalCalories} / $caloriesGoal ккал',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: caloriesProgress,
              backgroundColor: Colors.white30,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 20),
          // Macros
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMacroInfo(
                'Белки',
                stats.totalProtein,
                150, // TODO: pass from goals
                Icons.fitness_center,
              ),
              _buildMacroInfo(
                'Жиры',
                stats.totalFats,
                70, // TODO: pass from goals
                Icons.water_drop,
              ),
              _buildMacroInfo(
                'Углеводы',
                stats.totalCarbs,
                200, // TODO: pass from goals
                Icons.grain,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroInfo(String label, double consumed, double goal, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(
          '${consumed.toStringAsFixed(0)}г',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'из ${goal.toStringAsFixed(0)}г',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildWaterTracker(int waterMl) {
    const goal = 2000;
    final progress = (waterMl / goal).clamp(0.0, 1.0);
    final cups = (waterMl / 250).floor();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.water_drop, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Вода',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$waterMl мл / $goal мл',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.blue.shade100,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$cups стаканов',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {
              // Add 250ml
              context.read<DiaryBloc>().add(
                AddWaterRequested(date: _selectedDate, amount: 250),
              );
            },
            icon: const Icon(Icons.add_circle),
            color: Colors.blue,
            iconSize: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(DiaryMeal meal) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Meal photo or icon
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: meal.photoUrl != null
                  ? Image.network(
                      meal.photoUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.restaurant),
                        );
                      },
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.restaurant),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          meal.mealName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${meal.consumedAt.hour.toString().padLeft(2, '0')}:${meal.consumedAt.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildMealChip(
                        Icons.local_fire_department,
                        '${meal.calories} ккал',
                      ),
                      const SizedBox(width: 8),
                      _buildMealChip(
                        Icons.fitness_center,
                        'Б: ${meal.protein.toStringAsFixed(1)}г',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                // Delete meal
                context.read<DiaryBloc>().add(DeleteMealRequested(meal.id));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

