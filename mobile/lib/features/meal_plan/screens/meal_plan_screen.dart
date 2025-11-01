import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

/// Экран рациона питания
class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _showMealList = false;
  bool _isMonthView = false; // переключатель неделя/месяц

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _generateWeekPlan() {
    setState(() {
      _showMealList = true;
    });
  }

  // Форматирование даты с месяцем в родительном падеже
  String _formatDateWithGenitive(DateTime date) {
    const monthsGenitive = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];
    return '${date.day} ${monthsGenitive[date.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    if (_showMealList) {
      return _buildMealListView();
    }
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 24),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Рацион',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Blog Card
              _buildBlogCard(),
              
              const SizedBox(height: 16),
              
              // Diary Button
              _buildDiaryButton(),
              
              const SizedBox(height: 24),
              
              // Calendar
              _buildCalendar(),
              
              const SizedBox(height: 24),
              
              // Generate Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _generateWeekPlan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Сформировать на неделю',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Courses Card
              _buildCoursesCard(),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlogCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            // ФОТО СЛЕВА - 170x153 с отступом 5px, borderRadius 28
            Padding(
              padding: const EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Container(
                  width: 170,
                  height: 153,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: Image.asset(
                    'assets/images/blog_food_2.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.restaurant,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            
            // ТЕКСТ СПРАВА
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Дата ${DateFormat('dd.MM.yy').format(DateTime.now())}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF8E8E93),
                          ),
                        ),
                        const Text(
                          '234 ккал',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF8E8E93),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Почему наш рацион уникален?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiaryButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 56,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE9FFA6),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'Перейти в дневник питания',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.41,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Круглый чёрный фон для стрелки
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    final now = DateTime.now();
    
    // Начало и конец недели для недельного вида - от _selectedDate!
    final weekStart = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Заголовок с датами и навигацией
          if (!_isMonthView)
            // РЕЖИМ НЕДЕЛИ
            Row(
              children: [
                // Стрелка влево
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = _selectedDate.subtract(const Duration(days: 7));
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Transform.rotate(
                      angle: 3.14159,
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // ДАТА НАЧАЛА недели - СЛЕВА
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFE9FFA6),
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      _formatDateWithGenitive(weekStart),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // ДАТА КОНЦА недели - СЛЕВА (не справа!)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFE9FFA6),
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      _formatDateWithGenitive(weekEnd),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Стрелка вправо
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = _selectedDate.add(const Duration(days: 7));
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Иконка календаря
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isMonthView = !_isMonthView;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            )
          else
            // РЕЖИМ МЕСЯЦА
            Row(
              children: [
                // Стрелка влево
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = _selectedDate.subtract(const Duration(days: 30));
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Transform.rotate(
                      angle: 3.14159,
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                
                Expanded(
                  child: Text(
                    DateFormat('MMMM yyyy', 'ru').format(_selectedDate),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                // Стрелка вправо
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = _selectedDate.add(const Duration(days: 30));
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Иконка календаря для возврата
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isMonthView = false;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE9FFA6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          
          const SizedBox(height: 16),
          
          // Дни недели
          if (_isMonthView)
            _buildMonthView()
          else
            _buildWeekView(),
        ],
      ),
    );
  }
  
  Widget _buildWeekView() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final today = DateTime(now.year, now.month, now.day);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final date = weekStart.add(Duration(days: index));
        final dateOnly = DateTime(date.year, date.month, date.day);
        final isToday = dateOnly == today;
        final isPast = dateOnly.isBefore(today);
        
        return GestureDetector(
          onTap: () => _selectDate(date),
          child: Container(
            width: isToday ? 47 : 45,
            height: 60,
            decoration: BoxDecoration(
              color: isToday 
                  ? const Color(0xFFE9FFA6)  // Сегодня - зелёный фон
                  : Colors.white,  // Будущие дни - белый фон
              borderRadius: BorderRadius.circular(26),
              border: isPast 
                  ? Border.all(color: const Color(0xFFE9FFA6), width: 1)  // Прошедшие - зелёная рамка
                  : null,  // Будущие - без рамки
            ),
            child: Center(
              child: Text(
                DateFormat('d').format(date),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
  
  Widget _buildMonthView() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    
    // Начинаем с понедельника недели, в которую попадает 1-е число
    final startDate = firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday - 1));
    
    // Количество недель для отображения
    final daysToShow = ((lastDayOfMonth.difference(startDate).inDays + 1) / 7).ceil() * 7;
    
    return Column(
      children: List.generate((daysToShow / 7).ceil(), (weekIndex) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (dayIndex) {
              final date = startDate.add(Duration(days: weekIndex * 7 + dayIndex));
              final dateOnly = DateTime(date.year, date.month, date.day);
              final isCurrentMonth = date.month == now.month;
              final isToday = dateOnly == today;
              final isPast = dateOnly.isBefore(today);
              
              if (!isCurrentMonth) {
                return const SizedBox(width: 45, height: 60);
              }
              
              return GestureDetector(
                onTap: () => _selectDate(date),
                child: Container(
                  width: isToday ? 47 : 45,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isToday 
                        ? const Color(0xFFE9FFA6)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    border: isPast 
                        ? Border.all(color: const Color(0xFFE9FFA6), width: 1)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      DateFormat('d').format(date),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }


  Widget _buildCoursesCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: 357,
      height: 171,
      decoration: BoxDecoration(
        color: const Color(0xFFFCE6CF),
        borderRadius: BorderRadius.circular(23),
      ),
      child: Stack(
        children: [
          // Фоновая картинка (плейсхолдер пока)
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23),
              ),
              child: Image.asset(
                'assets/images/courses_bg.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 180,
                    color: Colors.transparent,
                  );
                },
              ),
            ),
          ),
          
          // Контент
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 20, 14, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Заголовок
                const Text(
                  'Курсы\nи обучения',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),
                
                // Кнопка "Смотреть" - смещена вправо
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      // TODO: Navigate to courses screen
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Смотреть',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF818181),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Meal List View (второй экран)
  Widget _buildMealListView() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 24),
                    onPressed: () {
                      setState(() {
                        _showMealList = false;
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Рацион',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMealSection('Пробуждение', ['Цинк\n90г']),
                    _buildMealSection('Завтрак', ['Каша овсяная\n162г', 'Молоко\n90г']),
                    _buildMealSection('Ресурсные добавки', ['Цинк\n90г', 'Витамин А\n90г']),
                    _buildMealSection('Перекус', ['Яблоко\n94г']),
                    _buildMealSection('Обед', ['Яблоко\n94г', 'Кисель\n94г']),
                    _buildMealSection('Ужин', ['Картофель по деревенски\n90г', 'Салат сиичке\n90г']),
                    _buildMealSection('Ресурсные добавки', ['Цинк\n90г']),
                    
                    const SizedBox(height: 24),
                    
                    // Sleep section
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9FFA6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Отход ко сну',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            
            // Action Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE9FFA6),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Скачать план',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () {
                      Share.share('Мой план питания на неделю');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Colors.black),
                    ),
                    child: const Icon(Icons.share, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealSection(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!title.contains('Ресурсные'))
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE9FFA6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.info_outline, size: 16),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => _buildMealItem(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildMealItem(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.3,
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFE9FFA6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_forward, size: 16),
          ),
        ],
      ),
    );
  }
}
