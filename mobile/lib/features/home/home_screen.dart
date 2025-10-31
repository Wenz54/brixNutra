import 'package:flutter/material.dart';
import 'package:mobile/dev_modules/core_module/services/token_manager.dart';
import 'dart:io';

/// Главный экран приложения Brix Nutrition
/// Дизайн воссоздан пиксель-в-пиксель согласно макету
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Цвета из дизайна
class BrixHomeColors {
  static const green = Color(0xFFE9FFA6); // Зелёный
  static const pink = Color(0xFFFCCFE9); // Розовый
  static const white = Color(0xFFFFFFFF);
  static const background = Color(0xFFFAFAFA);
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF666666);
  static const black = Color(0xFF000000);
}

class _HomeScreenState extends State<HomeScreen> {
  String? _userName = 'Саша';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await TokenManager.getUserName();
    if (name != null) {
    setState(() {
        _userName = name;
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrixHomeColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const SizedBox(height: 12),
                // Header (только иконки)
                _buildHeader(),
                const SizedBox(height: 20),
                
                // Приветствие (не более 60% ширины)
                _buildGreeting(),
                const SizedBox(height: 24),
                
                // Горизонтальный скролл с карточками
                SizedBox(
                  height: 256,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildWaterCard(),
                      const SizedBox(width: 12),
                      _buildMealPlanCard(),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Tip Card
                _buildTipCard(),
                const SizedBox(height: 24),
                
                // Инструменты Section
                const Text(
                  'Инструменты',
                  style: TextStyle(
                    fontSize: 20,
                                fontWeight: FontWeight.bold,
                    color: BrixHomeColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                
                // План питания на неделю (отдельная карточка)
                _buildWeeklyPlanCard(),
                const SizedBox(height: 12),
                
                // Tools Grid (2x2)
                    _buildToolsGrid(),
                const SizedBox(height: 24),
                
                // Мои подписки
                const Text(
                  'Мои подписки',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: BrixHomeColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSubscriptionCard(),
                const SizedBox(height: 24),
                
                // Новости. Наш блог
                _buildBlogHeader(),
                const SizedBox(height: 16),
                _buildBlogCards(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Header - только иконки без приветствия
  Widget _buildHeader() {
    return Row(
      children: [
        // Menu Icon
        IconButton(
          icon: const Icon(Icons.menu, size: 28),
          onPressed: () {},
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const Spacer(),
        // Notifications Icon
        IconButton(
          icon: const Icon(Icons.notifications_outlined, size: 28),
          onPressed: () {},
          padding: EdgeInsets.zero,
        ),
        const SizedBox(width: 8),
        // User Avatar
        CircleAvatar(
          radius: 20,
          backgroundColor: BrixHomeColors.green,
          child: Text(
            _userName?.substring(0, 1).toUpperCase() ?? 'U',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: BrixHomeColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  // Приветствие - отдельный блок (не более 60% ширины)
  Widget _buildGreeting() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6, // Максимум 60% ширины
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Привет, $_userName!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: BrixHomeColors.textPrimary,
              height: 1.2,
            ),
          ),
          const Text(
            'Твоя доска выглядит отлично',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: BrixHomeColors.textPrimary,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  // Карточка "Питьевой режим" с изображением девушки
  Widget _buildWaterCard() {
    return Container(
      width: 278,
      height: 256,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      decoration: BoxDecoration(
        color: BrixHomeColors.green,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Изображение девушки в правом нижнем углу без отступов
          Positioned(
            right: 0,
            bottom: 0,
            width: 180,
            height: 180,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20),
              ),
              child: Opacity(
                opacity: 0.9,
                child: _buildImagePlaceholder('hero_girl.jpg'),
              ),
            ),
          ),
          // Контент поверх изображения
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Питьевой\nрежим',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: BrixHomeColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Соблюдай режим\nи делай своё\nтело лучше!',
                    style: TextStyle(
                      fontSize: 13,
                      color: BrixHomeColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '26%',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: BrixHomeColors.textPrimary,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: BrixHomeColors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: BrixHomeColors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Карточка "План питания на неделю"
  Widget _buildMealPlanCard() {
    return Container(
      width: 278,
      height: 256,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'План питания\nна неделю',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: BrixHomeColors.textPrimary,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Переходи\nи начать',
                style: TextStyle(
                  fontSize: 13,
                  color: BrixHomeColors.textPrimary,
                  height: 1.2,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '0%',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: BrixHomeColors.textPrimary,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: BrixHomeColors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: BrixHomeColors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: BrixHomeColors.textPrimary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Карточка с подсказкой
  Widget _buildTipCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BrixHomeColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BrixHomeColors.textSecondary.withOpacity(0.2)),
      ),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              height: 1.4,
            ),
            children: [
              TextSpan(text: 'Ты - '),
              TextSpan(
                text: 'то, что ты ешь',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              TextSpan(text: '. Выбирай пищу осознанно, и здоровье станет твоим отражением!'),
            ],
          ),
        ),
      ),
    );
  }

  // Карточка "План питания на неделю" (отдельная)
  Widget _buildWeeklyPlanCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BrixHomeColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: BrixHomeColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.calendar_today_outlined, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'План питания на неделю',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: BrixHomeColors.textPrimary,
              ),
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: BrixHomeColors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: BrixHomeColors.black,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // Сетка инструментов 2x2
  Widget _buildToolsGrid() {
    return Column(
      children: [
          Row(
            children: [
              _buildToolCard(
                title: 'Дневник\nпитания',
                buttonText: 'Перейти',
                backgroundColor: BrixHomeColors.green,
                buttonColor: BrixHomeColors.black,
                onTap: () {},
              ),
            const SizedBox(width: 12),
              _buildToolCard(
                title: 'Курсы\nи обучения',
                buttonText: 'Смотреть',
                backgroundColor: BrixHomeColors.pink,
                buttonColor: BrixHomeColors.black,
                onTap: () {},
              ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
                  children: [
              _buildToolCard(
                title: 'Расшифровка\nанализов',
                buttonText: 'Смотреть',
                backgroundColor: BrixHomeColors.white,
                buttonColor: BrixHomeColors.green,
                onTap: () {},
              ),
            const SizedBox(width: 12),
              _buildToolCard(
                title: 'AI консультант',
                buttonText: 'Узнать всё',
                backgroundColor: BrixHomeColors.white,
                buttonColor: BrixHomeColors.pink,
                onTap: () {},
                      ),
                  ],
        ),
      ],
    );
  }

  // Отдельная карточка инструмента
  Widget _buildToolCard({
    required String title,
    required String buttonText,
    required Color backgroundColor,
    required Color buttonColor,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 175,
      height: 171,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: backgroundColor == BrixHomeColors.white
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: BrixHomeColors.textPrimary,
              height: 1.2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 13,
                  color: BrixHomeColors.textSecondary,
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: buttonColor == BrixHomeColors.black
                      ? BrixHomeColors.white
                      : BrixHomeColors.black,
                  size: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Карточка подписки
  Widget _buildSubscriptionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BrixHomeColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: BrixHomeColors.green.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.workspace_premium,
              color: BrixHomeColors.black,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Премиум',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: BrixHomeColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '14-04-26 действителен',
                  style: TextStyle(
                    fontSize: 13,
                    color: BrixHomeColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: BrixHomeColors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: BrixHomeColors.black,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // Заголовок блога
  Widget _buildBlogHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Новости. Наш блог',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: BrixHomeColors.textPrimary,
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Показать всё',
            style: TextStyle(
              fontSize: 14,
              color: BrixHomeColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  // Карточки блога
  Widget _buildBlogCards() {
    return Row(
      children: [
        Expanded(
          child: _buildBlogCard(
            imageName: 'blog_food_1.jpg',
            date: '23.04.25',
            calories: '254 ккал',
            title: 'Как начать следить за питанием и сделать это привычкой',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildBlogCard(
            imageName: 'blog_food_2.jpg',
            date: '23.04.25',
            calories: null,
            title: 'Как восстановить микрофлору кишечника?',
          ),
        ),
      ],
    );
  }

  // Отдельная карточка блога
  Widget _buildBlogCard({
    required String imageName,
    required String date,
    String? calories,
    required String title,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: BrixHomeColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: _buildImagePlaceholder(imageName, height: 120),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Дата $date',
                      style: const TextStyle(
                        fontSize: 11,
                        color: BrixHomeColors.textSecondary,
                      ),
                    ),
                    if (calories != null) ...[
                      const SizedBox(width: 8),
                Text(
                        calories,
                        style: const TextStyle(
                          fontSize: 11,
                          color: BrixHomeColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: BrixHomeColors.textPrimary,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Плейсхолдер для изображений
  Widget _buildImagePlaceholder(String imageName, {double? height}) {
    final placeholderPath = 'assets/placeholders/$imageName';
    
    return Container(
      height: height,
      color: BrixHomeColors.background,
      child: File(placeholderPath).existsSync()
          ? Image.file(
              File(placeholderPath),
              fit: BoxFit.cover,
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: 40,
                    color: BrixHomeColors.textSecondary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    imageName,
                    style: TextStyle(
                      fontSize: 11,
                      color: BrixHomeColors.textSecondary.withOpacity(0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}

