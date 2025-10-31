import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/shared/services/storage_service.dart';
import 'package:mobile/dev_modules/core_module/services/token_manager.dart';

/// Тестовый экран для проверки Supabase Storage
///
/// Функции:
/// - Загрузка аватара
/// - Загрузка фото из дневника (камера/галерея)
/// - Загрузка PDF анализа
/// - Просмотр загруженных файлов
class StorageTestScreen extends StatefulWidget {
  const StorageTestScreen({super.key});

  @override
  State<StorageTestScreen> createState() => _StorageTestScreenState();
}

class _StorageTestScreenState extends State<StorageTestScreen> {
  final StorageService _storageService = StorageService();
  final List<String> _uploadedUrls = [];
  String? _userId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final userId = await TokenManager.getUserId();
    setState(() {
      _userId = userId;
    });
  }

  void _log(String message) {
    setState(() {
      _uploadedUrls.insert(0, message);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase Storage Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              setState(() {
                _uploadedUrls.clear();
              });
            },
            tooltip: 'Очистить логи',
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Card
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.purple.shade50,
            child: Row(
              children: [
                const Icon(Icons.cloud_upload, color: Colors.purple),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Supabase Storage',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _userId != null
                            ? '✅ User ID: $_userId'
                            : '⚠️ User ID не установлен (нажмите "Set Mock User")',
                        style: TextStyle(
                          fontSize: 12,
                          color: _userId != null ? Colors.green : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),

          // Upload Buttons
          Expanded(
            flex: 3,
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildUploadButton(
                  icon: Icons.account_circle,
                  label: 'Upload Avatar',
                  color: Colors.blue,
                  onPressed: _uploadAvatar,
                ),
                _buildUploadButton(
                  icon: Icons.camera_alt,
                  label: 'Diary Photo\n(Camera)',
                  color: Colors.green,
                  onPressed: () => _uploadDiaryPhoto(ImageSource.camera),
                ),
                _buildUploadButton(
                  icon: Icons.photo_library,
                  label: 'Diary Photo\n(Gallery)',
                  color: Colors.orange,
                  onPressed: () => _uploadDiaryPhoto(ImageSource.gallery),
                ),
                _buildUploadButton(
                  icon: Icons.picture_as_pdf,
                  label: 'Upload\nLab Test PDF',
                  color: Colors.red,
                  onPressed: _uploadLabTest,
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Set Mock User Button
          if (_userId == null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: _setMockUser,
                icon: const Icon(Icons.person_add),
                label: const Text('Set Mock User'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

          // Uploaded Files Log
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: _uploadedUrls.isEmpty
                  ? const Center(
                      child: Text(
                        'Загруженные файлы появятся здесь',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _uploadedUrls.length,
                      itemBuilder: (context, index) {
                        final item = _uploadedUrls[index];
                        final isError = item.contains('❌');
                        final isUrl = item.startsWith('http');

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isError
                                  ? Colors.red.shade50
                                  : isUrl
                                      ? Colors.green.shade50
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isError
                                    ? Colors.red
                                    : isUrl
                                        ? Colors.green
                                        : Colors.grey.shade300,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isError
                                      ? Icons.error
                                      : isUrl
                                          ? Icons.check_circle
                                          : Icons.info,
                                  color: isError
                                      ? Colors.red
                                      : isUrl
                                          ? Colors.green
                                          : Colors.blue,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'monospace',
                                      color: isError
                                          ? Colors.red.shade900
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                                if (isUrl)
                                  IconButton(
                                    icon: const Icon(Icons.copy, size: 16),
                                    onPressed: () {
                                      // TODO: Copy to clipboard
                                      _log('📋 URL copied!');
                                    },
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Card(
      color: color.withOpacity(0.1),
      child: InkWell(
        onTap: _isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setMockUser() async {
    await TokenManager.saveUserData(
      userId: 'test-user-123',
      email: 'test@example.com',
      name: 'Test User',
    );
    await _loadUserId();
    _log('✅ Mock user установлен');
  }

  Future<void> _uploadAvatar() async {
    if (_userId == null) {
      _log('⚠️ Сначала установите User ID');
      return;
    }

    setState(() => _isLoading = true);
    _log('📤 Uploading avatar...');

    try {
      final url = await _storageService.pickAndUploadAvatar();
      if (url != null) {
        _log('✅ Avatar uploaded!');
        _log(url);
      } else {
        _log('ℹ️ Upload cancelled');
      }
    } catch (e) {
      _log('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _uploadDiaryPhoto(ImageSource source) async {
    if (_userId == null) {
      _log('⚠️ Сначала установите User ID');
      return;
    }

    setState(() => _isLoading = true);
    _log('📤 Uploading diary photo (${source == ImageSource.camera ? 'camera' : 'gallery'})...');

    try {
      final url = await _storageService.pickAndUploadDiaryPhoto(source: source);
      if (url != null) {
        _log('✅ Diary photo uploaded!');
        _log(url);
      } else {
        _log('ℹ️ Upload cancelled');
      }
    } catch (e) {
      _log('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _uploadLabTest() async {
    if (_userId == null) {
      _log('⚠️ Сначала установите User ID');
      return;
    }

    setState(() => _isLoading = true);
    _log('📤 Uploading lab test PDF...');

    try {
      final url = await _storageService.pickAndUploadLabTest();
      if (url != null) {
        _log('✅ Lab test uploaded!');
        _log(url);
      } else {
        _log('ℹ️ Upload cancelled');
      }
    } catch (e) {
      _log('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }
}

