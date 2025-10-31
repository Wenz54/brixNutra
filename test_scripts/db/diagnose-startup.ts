/**
 * Startup Diagnostics
 * Проверяет что мешает запуску сервера
 */

console.log('🔍 Diagnosing server startup issues...\n');

// Step 1: Check env
console.log('1️⃣ Loading environment...');
try {
  const dotenv = await import('dotenv');
  dotenv.config();
  console.log('   ✅ Environment loaded');
  console.log('   JWT_SECRET:', process.env.JWT_SECRET ? 'SET' : 'NOT SET');
  console.log('   DATABASE_HOST:', process.env.DATABASE_HOST);
} catch (err: any) {
  console.error('   ❌ Error:', err.message);
  process.exit(1);
}

// Step 2: Check config module
console.log('\n2️⃣ Loading config module...');
try {
  const { config } = await import('./src/config/env.ts');
  console.log('   ✅ Config loaded');
  console.log('   Server will run on:', `${config.server.host}:${config.server.port}`);
} catch (err: any) {
  console.error('   ❌ Error:', err.message);
  console.error('   Stack:', err.stack?.split('\n').slice(0, 3).join('\n'));
  process.exit(1);
}

// Step 3: Check auth module
console.log('\n3️⃣ Loading auth module...');
try {
  const authModule = await import('./src/modules/auth_module/index.ts');
  console.log('   ✅ Auth module loaded');
  console.log('   Exports:', Object.keys(authModule));
} catch (err: any) {
  console.error('   ❌ Error:', err.message);
  console.error('   Stack:', err.stack?.split('\n').slice(0, 5).join('\n'));
  process.exit(1);
}

// Step 4: Try to import Fastify
console.log('\n4️⃣ Testing Fastify...');
try {
  const Fastify = (await import('fastify')).default;
  const testApp = Fastify({ logger: false });
  
  testApp.get('/test', async () => ({ status: 'ok' }));
  
  await testApp.listen({ port: 3001, host: '0.0.0.0' });
  console.log('   ✅ Fastify works! Test server on :3001');
  
  await testApp.close();
  console.log('   ✅ Test server closed');
} catch (err: any) {
  console.error('   ❌ Error:', err.message);
}

// Step 5: Try to import main server module
console.log('\n5️⃣ Loading main server module...');
try {
  const serverModule = await import('./src/index.ts');
  console.log('   ✅ Main server module loaded!');
  console.log('   Exports:', Object.keys(serverModule));
} catch (err: any) {
  console.error('   ❌ Error:', err.message);
  console.error('\n📋 Full stack:');
  console.error(err.stack);
}

console.log('\n✅ Diagnostics complete!');
process.exit(0);


