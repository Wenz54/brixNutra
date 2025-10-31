import { createClient } from '@supabase/supabase-js';

// Get Supabase credentials from environment variables
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseServiceKey) {
  console.warn('⚠️ Supabase credentials not found in .env');
  console.warn('   Add SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY to .env file');
}

/**
 * Supabase Client для Backend
 * 
 * Использует Service Role Key для полного доступа ко всем buckets
 * (минуя Row Level Security)
 */
export const supabase = supabaseUrl && supabaseServiceKey 
  ? createClient(supabaseUrl, supabaseServiceKey, {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
      },
    })
  : null;

// Log initialization
if (supabase) {
  console.log('✅ Supabase Client initialized');
} else {
  console.log('⚠️ Supabase Client NOT initialized (missing credentials)');
}




