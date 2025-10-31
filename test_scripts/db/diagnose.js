/**
 * Diagnostic script to check what's wrong with the server
 */

console.log('🔍 Brix Backend Diagnostics\n');

// Step 1: Check environment
console.log('1️⃣ Checking environment variables...');
try {
  const dotenv = await import('dotenv');
  dotenv.config();
  console.log('✅ .env loaded');
  console.log('   DATABASE_HOST:', process.env.DATABASE_HOST || '❌ NOT SET');
  console.log('   DATABASE_NAME:', process.env.DATABASE_NAME || '❌ NOT SET');
  console.log('   JWT_SECRET:', process.env.JWT_SECRET ? '✅ SET' : '❌ NOT SET');
} catch (err) {
  console.error('❌ Failed to load dotenv:', err.message);
}

// Step 2: Check database connection
console.log('\n2️⃣ Checking database module...');
try {
  const dbModule = await import('./src/modules/database_module/connection.js');
  console.log('✅ Database module loaded');
  
  // Try to query
  const result = await dbModule.query('SELECT 1 as test');
  console.log('✅ Database connection works!', result.rows);
} catch (err) {
  console.error('❌ Database error:', err.message);
  console.error('   Stack:', err.stack?.split('\n')[0]);
}

// Step 3: Check config
console.log('\n3️⃣ Checking config module...');
try {
  const configModule = await import('./src/config/env.js');
  console.log('✅ Config module loaded');
  console.log('   Server port:', configModule.config.server.port);
  console.log('   Server host:', configModule.config.server.host);
} catch (err) {
  console.error('❌ Config error:', err.message);
}

// Step 4: Try to import main server
console.log('\n4️⃣ Checking main server module...');
try {
  const serverModule = await import('./src/index.js');
  console.log('✅ Server module loaded!');
  console.log('   Exports:', Object.keys(serverModule));
} catch (err) {
  console.error('❌ Server module error:', err.message);
  console.error('\n📋 Full error:');
  console.error(err.stack);
}

console.log('\n✅ Diagnostics complete!');
process.exit(0);


