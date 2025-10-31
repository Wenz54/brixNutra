import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/lab_tests/lab_tests.dart';
import 'package:intl/intl.dart';
import '../../../dev_modules/ui_kit_module/theme/brix_theme.dart';
import '../../../dev_modules/ui_kit_module/buttons/brix_button.dart';

/// Экран лабораторных анализов
///
/// Функции:
/// - Список загруженных анализов
/// - Загрузка нового анализа (PDF/фото)
/// - Просмотр результатов с интерпретацией
/// - Тренды параметров (графики)
/// - Рекомендации от AI
class LabTestsScreen extends StatefulWidget {
  const LabTestsScreen({super.key});

  @override
  State<LabTestsScreen> createState() => _LabTestsScreenState();
}

class _LabTestsScreenState extends State<LabTestsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LabTestsBloc>().add(const LoadMyTestsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrixColors.background,
      appBar: AppBar(
        backgroundColor: BrixColors.surface,
        elevation: 0,
        title: Text('Анализы', style: BrixTypography.h3),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: BrixColors.textPrimary),
            onPressed: () {
              // TODO: Show info about parameters
            },
          ),
        ],
      ),
      body: BlocBuilder<LabTestsBloc, LabTestsState>(
        builder: (context, state) {
          if (state is LabTestsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: BrixColors.primary,
              ),
            );
          }

          if (state is LabTestsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: BrixColors.error),
                  SizedBox(height: BrixSpacing.lg),
                  Text('Ошибка: ${state.message}', style: BrixTypography.bodyLarge),
                  SizedBox(height: BrixSpacing.lg),
                  BrixButton.primary(
                    text: 'Повторить',
                    onPressed: () {
                      context.read<LabTestsBloc>().add(const LoadMyTestsRequested());
                    },
                  ),
                ],
              ),
            );
          }

          if (state is MyTestsLoaded) {
            final tests = state.tests;

            if (tests.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.science_outlined, size: 80, color: BrixColors.textTertiary),
                    SizedBox(height: BrixSpacing.lg),
                    Text(
                      'Нет загруженных анализов',
                      style: BrixTypography.bodyLarge.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Загрузите PDF или фото анализов',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<LabTestsBloc>().add(const LoadMyTestsRequested());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: tests.length,
                itemBuilder: (context, index) {
                  final testPreview = tests[index];
                  return _buildTestCard(testPreview);
                },
              ),
            );
          }

          return const Center(child: Text('Загрузка...'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _uploadTest,
        backgroundColor: const Color(0xFFFF9800),
        icon: const Icon(Icons.upload_file),
        label: const Text('Загрузить'),
      ),
    );
  }

  Widget _buildTestCard(LabTestPreview test) {
    final date = DateFormat('dd MMM yyyy', 'ru').format(test.testDate);
    final hasIssues = test.abnormalCount > 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to test detail
          context.read<LabTestsBloc>().add(LoadTestRequested(test.id));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Открыть детали анализа ${test.title}')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: hasIssues ? Colors.orange.shade50 : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.science,
                      color: hasIssues ? Colors.orange : Colors.green,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          test.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (hasIssues)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Требует внимания',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.orange.shade900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildStatChip(
                    Icons.analytics,
                    '${test.parametersCount} параметров',
                    Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  _buildStatChip(
                    Icons.check_circle,
                    '${test.parametersCount - test.abnormalCount} норма',
                    Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadTest() async {
    // TODO: Show bottom sheet with options (PDF, photo)
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Загрузить анализы',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text('PDF файл'),
              subtitle: const Text('Загрузить PDF анализа'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Upload PDF
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Выбрать PDF файл')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: const Text('Фото анализа'),
              subtitle: const Text('Загрузить фото из галереи'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Upload photo
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Выбрать фото из галереи')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.green),
              title: const Text('Сделать фото'),
              subtitle: const Text('Сфотографировать анализ'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Take photo
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Открыть камеру')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

