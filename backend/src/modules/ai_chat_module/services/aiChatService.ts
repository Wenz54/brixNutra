import { FastifyInstance } from 'fastify';
import OpenAI from 'openai';

export interface ChatMessage {
  role: 'system' | 'user' | 'assistant';
  content: string;
}

export interface ChatSession {
  id: string;
  user_id: string;
  title: string;
  messages: ChatMessage[];
  created_at: Date;
  updated_at: Date;
}

export class AIChatService {
  private fastify: FastifyInstance;
  private openai: OpenAI;

  constructor(fastify: FastifyInstance) {
    this.fastify = fastify;
    
    // Initialize OpenAI
    const apiKey = process.env.OPENAI_API_KEY;
    if (!apiKey) {
      this.fastify.log.warn('⚠️ OPENAI_API_KEY not set, AI chat will not work');
    }
    
    this.openai = new OpenAI({
      apiKey: apiKey || 'dummy-key',
    });
  }

  async chat(userId: string, message: string, conversationHistory: ChatMessage[] = []): Promise<{
    response: string;
    usage?: any;
  }> {
    try {
      // System prompt for nutrition assistant
      const systemPrompt: ChatMessage = {
        role: 'system',
        content: `Ты - профессиональный нутрициолог и персональный ассистент Brix Nutrition.

Твоя задача:
- Отвечать на вопросы о правильном питании, КБЖУ, рецептах
- Помогать пользователям достигать их целей (похудение, набор массы, здоровье)
- Анализировать дневник питания и давать рекомендации
- Интерпретировать результаты анализов (если спрашивают)
- Рекомендовать рецепты и блюда из базы
- Быть дружелюбным, понятным и мотивирующим

Отвечай на русском языке, кратко и по делу, но дружелюбно.`,
      };

      // Build messages array
      const messages: ChatMessage[] = [
        systemPrompt,
        ...conversationHistory.slice(-10), // Last 10 messages for context
        { role: 'user', content: message },
      ];

      // Call OpenAI
      const completion = await this.openai.chat.completions.create({
        model: 'gpt-4o-mini', // or 'gpt-3.5-turbo' for cheaper
        messages: messages as any,
        temperature: 0.7,
        max_tokens: 500,
      });

      const response = completion.choices[0]?.message?.content || 'Извините, не могу ответить на этот вопрос.';

      this.fastify.log.info(`✅ AI chat response generated for user ${userId}`);

      return {
        response,
        usage: completion.usage,
      };
    } catch (error: any) {
      this.fastify.log.error('Error in AI chat:', error);
      
      if (error.code === 'invalid_api_key') {
        throw new Error('OpenAI API key is invalid');
      }
      
      throw error;
    }
  }

  async saveChatSession(userId: string, sessionData: any): Promise<any> {
    const db = await import('../../database_module/connection.js');

    const query = `
      INSERT INTO chat_sessions (user_id, title, messages)
      VALUES ($1, $2, $3)
      RETURNING *
    `;

    const result = await db.query(query, [
      userId,
      sessionData.title || 'Новый чат',
      JSON.stringify(sessionData.messages || []),
    ]);

    return result.rows[0];
  }

  async getChatSessions(userId: string): Promise<any[]> {
    const db = await import('../../database_module/connection.js');

    const query = `
      SELECT id, user_id, title, created_at, updated_at,
        (messages->-1) as last_message
      FROM chat_sessions
      WHERE user_id = $1
      ORDER BY updated_at DESC
      LIMIT 20
    `;

    const result = await db.query(query, [userId]);

    return result.rows;
  }

  async getChatSession(sessionId: string, userId: string): Promise<any> {
    const db = await import('../../database_module/connection.js');

    const query = `
      SELECT * FROM chat_sessions
      WHERE id = $1 AND user_id = $2
    `;

    const result = await db.query(query, [sessionId, userId]);

    if (result.rows.length === 0) {
      return null;
    }

    return result.rows[0];
  }

  async updateChatSession(sessionId: string, userId: string, messages: ChatMessage[]): Promise<void> {
    const db = await import('../../database_module/connection.js');

    const query = `
      UPDATE chat_sessions
      SET messages = $1, updated_at = NOW()
      WHERE id = $2 AND user_id = $3
    `;

    await db.query(query, [JSON.stringify(messages), sessionId, userId]);
  }

  async deleteChatSession(sessionId: string, userId: string): Promise<boolean> {
    const db = await import('../../database_module/connection.js');

    const query = `
      DELETE FROM chat_sessions
      WHERE id = $1 AND user_id = $2
    `;

    const result = await db.query(query, [sessionId, userId]);

    return (result.rowCount || 0) > 0;
  }

  // Специализированные методы

  async analyzeUserDiary(userId: string, date: string): Promise<string> {
    const db = await import('../../database_module/connection.js');

    // Get diary data
    const query = `
      SELECT 
        ds.total_calories, ds.total_protein, ds.total_carbs, ds.total_fats,
        ds.goal_calories, ds.goal_protein, ds.goal_carbs, ds.goal_fats,
        json_agg(de.*) as entries
      FROM daily_stats ds
      LEFT JOIN diary_entries de ON de.user_id = ds.user_id AND de.meal_date = ds.date
      WHERE ds.user_id = $1 AND ds.date = $2
      GROUP BY ds.id
    `;

    const result = await db.query(query, [userId, date]);

    if (result.rows.length === 0) {
      return 'Нет данных о питании за этот день.';
    }

    const data = result.rows[0];

    const prompt = `Проанализируй дневник питания пользователя за ${date}:

Съедено: ${data.total_calories} ккал (цель: ${data.goal_calories})
Белки: ${data.total_protein}г (цель: ${data.goal_protein}г)
Жиры: ${data.total_fats}г (цель: ${data.goal_fats}г)
Углеводы: ${data.total_carbs}г (цель: ${data.goal_carbs}г)

Приёмы пищи: ${data.entries?.length || 0}

Дай краткую оценку и рекомендации (до 200 слов).`;

    const response = await this.chat(userId, prompt);

    return response.response;
  }

  async recommendRecipes(userId: string, preferences: string): Promise<string> {
    const prompt = `Пользователь хочет рецепты: ${preferences}

Порекомендуй 3-5 блюд из нашей базы рецептов (завтраки, обеды, ужины, снеки), 
учитывая здоровое питание и баланс КБЖУ. Дай краткое описание каждого блюда.`;

    const response = await this.chat(userId, prompt);

    return response.response;
  }
}

