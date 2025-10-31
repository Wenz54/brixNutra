const { Pool } = require('pg');
require('dotenv').config();

console.log('=== DATABASE DIAGNOSTICS ===');
console.log('DATABASE_URL:', process.env.DATABASE_URL);
console.log('');

const connectionString = process.env.DATABASE_URL;
const pool = new Pool({ connectionString });

async function test() {
  try {
    console.log('Attempting to connect...');
    const client = await pool.connect();
    console.log('✅ Connected successfully!');
    
    // Test query
    const dbResult = await client.query('SELECT current_database(), version()');
    console.log('\n✅ Database:', dbResult.rows[0].current_database);
    console.log('PostgreSQL Version:', dbResult.rows[0].version.split('\n')[0]);
    
    // Check tables
    const tablesResult = await client.query(`
      SELECT tablename FROM pg_tables 
      WHERE schemaname = 'public' 
      ORDER BY tablename
    `);
    console.log('\n✅ Tables in database:');
    tablesResult.rows.forEach(row => console.log('  -', row.tablename));
    
    // Check users table structure
    const structureResult = await client.query(`
      SELECT column_name, data_type, is_nullable
      FROM information_schema.columns
      WHERE table_name = 'users'
      ORDER BY ordinal_position
    `);
    console.log('\n✅ Users table structure:');
    structureResult.rows.forEach(row => {
      console.log(`  - ${row.column_name}: ${row.data_type} (${row.is_nullable === 'YES' ? 'NULL' : 'NOT NULL'})`);
    });
    
    client.release();
    await pool.end();
    console.log('\n✅ All checks passed!');
    process.exit(0);
  } catch (err) {
    console.error('\n❌ Error:', err.message);
    console.error('Code:', err.code);
    process.exit(1);
  }
}

test();


