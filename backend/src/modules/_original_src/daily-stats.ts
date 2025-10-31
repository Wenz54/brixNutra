import { query } from '../db/connection';

/**
 * Daily statistics collection script
 * This script runs every day at 6:00 AM to collect and store daily statistics
 */
export async function collectDailyStats() {
  try {
    console.log('Starting daily statistics collection...');
    
    const today = new Date().toISOString().split('T')[0]; // YYYY-MM-DD format
    
    // Check if stats for today already exist
    const existingStats = await query(`
      SELECT id FROM daily_stats WHERE date = $1
    `, [today]);
    
    // Get user statistics
    const userStats = await query(`
      SELECT 
        COUNT(*) as total_users,
        COUNT(CASE WHEN premium = true THEN 1 END) as subscribed_users,
        COUNT(CASE WHEN DATE(created_at) = $1 THEN 1 END) as new_users_today
      FROM users
    `, [today]);
    
    // Get lesson statistics
    const lessonStats = await query(`
      SELECT 
        COUNT(*) as total_lessons,
        COALESCE(SUM(view_count), 0) as total_views
      FROM knowledge_lessons 
      WHERE is_active = true
    `);
    
    const userStatsRow = userStats.rows[0];
    const lessonStatsRow = lessonStats.rows[0];
    
    const totalUsers = parseInt(userStatsRow.total_users);
    const subscribedUsers = parseInt(userStatsRow.subscribed_users);
    const newUsersToday = parseInt(userStatsRow.new_users_today);
    const totalLessons = parseInt(lessonStatsRow.total_lessons);
    const totalViews = parseInt(lessonStatsRow.total_views);
    const subscriptionRate = totalUsers > 0 ? (subscribedUsers / totalUsers * 100) : 0;
    
    if (existingStats.rows.length > 0) {
      // Update existing record
      await query(`
        UPDATE daily_stats 
        SET 
          total_users = $2,
          subscribed_users = $3,
          new_users_today = $4,
          total_lessons = $5,
          total_views = $6,
          subscription_rate = $7,
          updated_at = CURRENT_TIMESTAMP
        WHERE date = $1
      `, [today, totalUsers, subscribedUsers, newUsersToday, totalLessons, totalViews, subscriptionRate]);
      
      console.log(`Updated daily stats for ${today}`);
    } else {
      // Insert new record
      await query(`
        INSERT INTO daily_stats (
          date, total_users, subscribed_users, new_users_today, 
          total_lessons, total_views, subscription_rate
        ) VALUES ($1, $2, $3, $4, $5, $6, $7)
      `, [today, totalUsers, subscribedUsers, newUsersToday, totalLessons, totalViews, subscriptionRate]);
      
      console.log(`Created daily stats for ${today}`);
    }
    
    console.log(`Daily stats collected: ${totalUsers} users, ${subscribedUsers} subscribed, ${newUsersToday} new today`);
    
    return {
      success: true,
      data: {
        date: today,
        totalUsers,
        subscribedUsers,
        newUsersToday,
        totalLessons,
        totalViews,
        subscriptionRate: Math.round(subscriptionRate * 100) / 100
      }
    };
    
  } catch (error) {
    console.error('Error collecting daily stats:', error);
    throw error;
  }
}

/**
 * Get recent daily statistics
 */
export async function getRecentDailyStats(days: number = 7) {
  try {
    const result = await query(`
      SELECT * FROM daily_stats 
      ORDER BY date DESC 
      LIMIT $1
    `, [days]);
    
    return result.rows;
  } catch (error) {
    console.error('Error fetching recent daily stats:', error);
    throw error;
  }
}

/**
 * Manual execution for testing
 */
if (require.main === module) {
  collectDailyStats()
    .then((result) => {
      console.log('Daily stats collection completed:', result);
      process.exit(0);
    })
    .catch((error) => {
      console.error('Daily stats collection failed:', error);
      process.exit(1);
    });
}