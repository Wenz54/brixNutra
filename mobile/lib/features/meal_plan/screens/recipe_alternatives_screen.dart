import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/meal_plan/meal_plan.dart';

/// Экран альтернативных рецептов
///
/// Показывает список похожих рецептов для замены текущего блюда
/// Учитывает:
/// - Тип приема пищи (breakfast, lunch, dinner, snack)
/// - Калорийность (±20%)
/// - Диетические предпочтения
class RecipeAlternativesScreen extends StatefulWidget {
  final String originalRecipeId;
  final String originalRecipeName;
  final MealType? mealType;

  const RecipeAlternativesScreen({
    super.key,
    required this.originalRecipeId,
    required this.originalRecipeName,
    this.mealType,
  });

  @override
  State<RecipeAlternativesScreen> createState() => _RecipeAlternativesScreenState();
}

class _RecipeAlternativesScreenState extends State<RecipeAlternativesScreen> {
  @override
  void initState() {
    super.initState();
    // Load alternatives
    context.read<MealPlanBloc>().add(
      LoadRecipeAlternativesRequested(
        recipeId: widget.originalRecipeId,
        mealType: widget.mealType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбрать другое блюдо'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Info header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: Border(
                bottom: BorderSide(color: Colors.blue.shade100),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.info_outline, size: 20, color: Colors.blue),
                    const SizedBox(width: 8),
                    const Text(
                      'Текущее блюдо',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.originalRecipeName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.mealType != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.mealType!.displayName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Alternatives list
          Expanded(
            child: BlocBuilder<MealPlanBloc, MealPlanState>(
              builder: (context, state) {
                if (state is MealPlanLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is MealPlanError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 60, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Ошибка: ${state.message}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<MealPlanBloc>().add(
                              LoadRecipeAlternativesRequested(
                                recipeId: widget.originalRecipeId,
                                mealType: widget.mealType,
                              ),
                            );
                          },
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is RecipeAlternativesLoaded) {
                  final alternatives = state.alternatives;

                  if (alternatives.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 80, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            'Альтернативы не найдены',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Попробуйте изменить фильтры',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: alternatives.length,
                    itemBuilder: (context, index) {
                      final recipe = alternatives[index];
                      return _buildRecipeCard(recipe);
                    },
                  );
                }

                return const Center(child: Text('Загрузка...'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    final caloriesDiff = (recipe.calories - 500).abs(); // Mock original calories
    final isLowerCalories = recipe.calories < 500;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to recipe detail or confirm replacement
          _showReplaceDialog(recipe);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Recipe image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  recipe.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.restaurant, size: 30),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildInfoChip(
                          Icons.local_fire_department,
                          '${recipe.calories} ккал',
                          isLowerCalories ? Colors.green : Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          Icons.timer,
                          '${recipe.prepTime} мин',
                          Colors.grey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (caloriesDiff > 50)
                      Row(
                        children: [
                          Icon(
                            isLowerCalories ? Icons.arrow_downward : Icons.arrow_upward,
                            size: 14,
                            color: isLowerCalories ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${isLowerCalories ? '-' : '+'}$caloriesDiff ккал',
                            style: TextStyle(
                              fontSize: 12,
                              color: isLowerCalories ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showReplaceDialog(Recipe newRecipe) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Заменить блюдо?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Заменить "${widget.originalRecipeName}" на "${newRecipe.name}"?',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Калории:', style: TextStyle(fontSize: 12)),
                Text(
                  '${newRecipe.calories} ккал',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Время:', style: TextStyle(fontSize: 12)),
                Text(
                  '${newRecipe.prepTime} мин',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
            ),
            child: const Text('Заменить'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      // TODO: Dispatch replace meal event
      context.read<MealPlanBloc>().add(
        ReplaceMealRequested(
          mealSlotId: widget.originalRecipeId, // TODO: use actual slot ID
          newRecipeId: newRecipe.id,
        ),
      );

      if (mounted) {
        Navigator.pop(context, newRecipe);
      }
    }
  }
}




