/**
 * Database Migration Runner
 * Выполняет SQL миграции в PostgreSQL
 */

import { readFileSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';
import pg from 'pg';
import dotenv from 'dotenv';

const { Pool } = pg;
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Load environment variables
dotenv.config({ path: join(__dirname, '../.env') });

// Database connection
const pool = new Pool({
  host: process.env.DATABASE_HOST || 'localhost',
  port: parseInt(process.env.DATABASE_PORT || '5432', 10),
  database: process.env.DATABASE_NAME || 'brix_nutrition',
  user: process.env.DATABASE_USERNAME || 'postgres',
  password: process.env.DATABASE_PASSWORD || 'postgres',
});

async function runMigration(migrationFile) {
  const migrationPath = join(__dirname, '..', migrationFile);
  
  console.log(`\n📄 Running migration: ${migrationFile}`);
  console.log(`   Path: ${migrationPath}`);
  
  try {
    // Read SQL file
    const sql = readFileSync(migrationPath, 'utf8');
    
    console.log(`   SQL length: ${sql.length} characters`);
    
    // Execute SQL
    const result = await pool.query(sql);
    
    console.log('✅ Migration completed successfully!');
    
    // Show any notices
    if (result && result.rows) {
      result.rows.forEach(row => {
        console.log('   ', row);
      });
    }
    
    return true;
  } catch (error) {
    console.error('❌ Migration failed!');
    console.error('   Error:', error.message);
    if (error.detail) {
      console.error('   Detail:', error.detail);
    }
    if (error.hint) {
      console.error('   Hint:', error.hint);
    }
    return false;
  }
}

async function main() {
  console.log('🚀 Brix Nutrition - Database Migration Runner');
  console.log('='.repeat(50));
  
  // Test connection
  console.log('\n🔌 Testing database connection...');
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT version()');
    console.log('✅ Connected to PostgreSQL');
    console.log(`   Version: ${result.rows[0].version.split(' ').slice(0, 2).join(' ')}`);
    client.release();
  } catch (error) {
    console.error('❌ Failed to connect to database');
    console.error('   Error:', error.message);
    console.error('\n💡 Make sure Docker containers are running:');
    console.error('   docker ps');
    process.exit(1);
  }
  
  // Run migrations
  const migrations = [
    'src/modules/database_module/migrations/001_initial_schema.sql',
  ];
  
  console.log(`\n📋 Running ${migrations.length} migration(s)...`);
  
  let successCount = 0;
  let failCount = 0;
  
  for (const migration of migrations) {
    const success = await runMigration(migration);
    if (success) {
      successCount++;
    } else {
      failCount++;
    }
  }
  
  // Summary
  console.log('\n' + '='.repeat(50));
  console.log('📊 Migration Summary');
  console.log('='.repeat(50));
  console.log(`✅ Successful: ${successCount}`);
  console.log(`❌ Failed: ${failCount}`);
  console.log(`📝 Total: ${migrations.length}`);
  
  if (failCount === 0) {
    console.log('\n🎉 All migrations completed successfully!');
    console.log('\n📚 Next steps:');
    console.log('   1. Start the backend server: npm run dev');
    console.log('   2. Check API documentation: http://localhost:3000/documentation');
  } else {
    console.log('\n⚠️  Some migrations failed. Please check the errors above.');
    process.exit(1);
  }
  
  // Close pool
  await pool.end();
}

// Run
main().catch(error => {
  console.error('Fatal error:', error);
  process.exit(1);
});


