/// Supabase Configuration для Brix Nutrition
/// 
/// Настройки подключения к Supabase Storage
/// 
/// ⚠️ ВАЖНО: 
/// - Замените значения на свои из Supabase Dashboard
/// - Project URL и Anon Key находятся в Settings → API
class SupabaseConfig {
  /// Supabase Project URL
  /// 
  /// Найти: Supabase Dashboard → Settings → API → Project URL
  /// Пример: 'https://abcdefghijklmnop.supabase.co'
  static const String url = 'YOUR_SUPABASE_URL'; // TODO: Заменить на свой

  /// Supabase Anon Public Key
  /// 
  /// Найти: Supabase Dashboard → Settings → API → Project API keys → anon public
  /// 
  /// ⚠️ Это ПУБЛИЧНЫЙ ключ - безопасно использовать в клиенте
  /// (защита через Row Level Security в Supabase)
  static const String anonKey = 'YOUR_SUPABASE_ANON_KEY'; // TODO: Заменить на свой

  /// Storage Buckets
  static const String avatarsBucket = 'avatars';
  static const String recipesBucket = 'recipes';
  static const String diaryPhotosBucket = 'diary-photos';
  static const String labTestsBucket = 'lab-tests';
  static const String courseMaterialsBucket = 'course-materials';
}




