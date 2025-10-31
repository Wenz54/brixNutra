import { FastifyInstance } from 'fastify';

export interface LabParameter {
  id: string;
  parameter_code: string;
  name: string;
  category: string;
  default_unit: string;
  available_units?: string[];
  reference_ranges: any[];
  description?: string;
  low_causes?: string[];
  high_causes?: string[];
  recommendations?: string;
}

export interface LabTest {
  id: string;
  user_id: string;
  test_type: string;
  test_name?: string;
  test_date: string;
  uploaded_at: Date;
  file_url?: string;
  interpretation_generated: boolean;
  interpretation_generated_at?: Date;
  doctor_notes?: string;
  user_notes?: string;
  results?: LabResult[];
}

export interface LabResult {
  id: string;
  lab_test_id: string;
  parameter_code: string;
  value: number;
  unit: string;
  status?: string;
  reference_min?: number;
  reference_max?: number;
  interpretation?: string;
  causes?: string[];
  recommendations?: string;
  parameter?: LabParameter;
}

export class LabTestService {
  private fastify: FastifyInstance;

  constructor(fastify: FastifyInstance) {
    this.fastify = fastify;
  }

  /**
   * Upload lab test with results
   */
  async uploadTest(
    userId: string,
    testData: {
      test_type: string;
      test_name?: string;
      test_date: string;
      file_url?: string;
      results: Array<{
        parameter_code: string;
        value: number;
        unit: string;
      }>;
      doctor_notes?: string;
      user_notes?: string;
    }
  ): Promise<LabTest> {
    const db = await import('../../database_module/connection.js');

    // Create lab test
    const testQuery = `
      INSERT INTO lab_tests (user_id, test_type, test_name, test_date, file_url, doctor_notes, user_notes)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING *
    `;

    const testValues = [
      userId,
      testData.test_type,
      testData.test_name || null,
      testData.test_date,
      testData.file_url || null,
      testData.doctor_notes || null,
      testData.user_notes || null,
    ];

    const testResult = await db.query(testQuery, testValues);
    const labTest = testResult.rows[0];

    // Insert results and interpret them
    const results: LabResult[] = [];

    for (const result of testData.results) {
      const interpreted = await this.interpretResult(
        userId,
        result.parameter_code,
        result.value,
        result.unit
      );

      const resultQuery = `
        INSERT INTO lab_results (
          lab_test_id,
          parameter_code,
          value,
          unit,
          status,
          reference_min,
          reference_max,
          interpretation,
          causes,
          recommendations
        )
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
        RETURNING *
      `;

      const resultValues = [
        labTest.id,
        result.parameter_code,
        result.value,
        result.unit,
        interpreted.status,
        interpreted.reference_min,
        interpreted.reference_max,
        interpreted.interpretation,
        JSON.stringify(interpreted.causes || []),
        interpreted.recommendations,
      ];

      const insertedResult = await db.query(resultQuery, resultValues);
      results.push(insertedResult.rows[0]);
    }

    // Mark interpretation as generated
    await db.query(
      `UPDATE lab_tests SET interpretation_generated = true, interpretation_generated_at = NOW() WHERE id = $1`,
      [labTest.id]
    );

    this.fastify.log.info(`✅ Lab test uploaded for user ${userId}: ${testData.test_type}`);

    return {
      ...labTest,
      results,
    };
  }

  /**
   * Interpret a single result
   */
  private async interpretResult(
    userId: string,
    parameterCode: string,
    value: number,
    unit: string
  ): Promise<{
    status: string;
    reference_min: number;
    reference_max: number;
    interpretation: string;
    causes: string[];
    recommendations: string;
  }> {
    const db = await import('../../database_module/connection.js');

    // Get parameter info
    const paramQuery = `SELECT * FROM lab_parameters WHERE parameter_code = $1`;
    const paramResult = await db.query(paramQuery, [parameterCode]);

    if (paramResult.rows.length === 0) {
      return {
        status: 'unknown',
        reference_min: 0,
        reference_max: 0,
        interpretation: 'Параметр не найден в базе данных',
        causes: [],
        recommendations: '',
      };
    }

    const parameter = paramResult.rows[0];

    // Get user info for age/gender (mock for now)
    // TODO: Get real user age/gender from users table
    const userGender = 'both'; // mock
    const userAge = 30; // mock

    // Find appropriate reference range
    let referenceRange = parameter.reference_ranges.find((range: any) => {
      const genderMatch = range.gender === 'both' || range.gender === userGender;
      const ageMatch = userAge >= range.age_min && userAge <= range.age_max;
      return genderMatch && ageMatch;
    });

    // Fallback to first range if no match
    if (!referenceRange && parameter.reference_ranges.length > 0) {
      referenceRange = parameter.reference_ranges[0];
    }

    if (!referenceRange) {
      return {
        status: 'unknown',
        reference_min: 0,
        reference_max: 0,
        interpretation: 'Референсные значения не найдены',
        causes: [],
        recommendations: '',
      };
    }

    // Determine status
    let status = 'normal';
    let interpretation = `${parameter.name}: значение в пределах нормы`;
    let causes: string[] = [];
    const recommendations = parameter.recommendations || '';

    const min = referenceRange.min;
    const max = referenceRange.max;

    if (value < min) {
      const deviation = ((min - value) / min) * 100;

      if (deviation > 50) {
        status = 'critical_low';
        interpretation = `${parameter.name}: критически низкое значение (${value} ${unit}). Норма: ${min}-${max} ${unit}`;
      } else {
        status = 'low';
        interpretation = `${parameter.name}: ниже нормы (${value} ${unit}). Норма: ${min}-${max} ${unit}`;
      }

      causes = parameter.low_causes || [];
    } else if (value > max) {
      const deviation = ((value - max) / max) * 100;

      if (deviation > 50) {
        status = 'critical_high';
        interpretation = `${parameter.name}: критически высокое значение (${value} ${unit}). Норма: ${min}-${max} ${unit}`;
      } else {
        status = 'high';
        interpretation = `${parameter.name}: выше нормы (${value} ${unit}). Норма: ${min}-${max} ${unit}`;
      }

      causes = parameter.high_causes || [];
    } else {
      interpretation = `${parameter.name}: в норме (${value} ${unit}). Референсные значения: ${min}-${max} ${unit}`;
    }

    return {
      status,
      reference_min: min,
      reference_max: max,
      interpretation,
      causes,
      recommendations,
    };
  }

  /**
   * Get all user tests
   */
  async getUserTests(userId: string): Promise<LabTest[]> {
    const db = await import('../../database_module/connection.js');

    const query = `
      SELECT * FROM lab_tests
      WHERE user_id = $1
      ORDER BY test_date DESC, uploaded_at DESC
    `;

    const result = await db.query(query, [userId]);

    return result.rows;
  }

  /**
   * Get test by ID with results
   */
  async getTestById(testId: string, userId: string): Promise<LabTest | null> {
    const db = await import('../../database_module/connection.js');

    // Get test
    const testQuery = `
      SELECT * FROM lab_tests
      WHERE id = $1 AND user_id = $2
    `;

    const testResult = await db.query(testQuery, [testId, userId]);

    if (testResult.rows.length === 0) {
      return null;
    }

    const test = testResult.rows[0];

    // Get results with parameters
    const resultsQuery = `
      SELECT 
        lr.*,
        lp.parameter_code as param_code,
        lp.name as param_name,
        lp.category as param_category,
        lp.description as param_description
      FROM lab_results lr
      INNER JOIN lab_parameters lp ON lr.parameter_code = lp.parameter_code
      WHERE lr.lab_test_id = $1
      ORDER BY lp.category, lp.name
    `;

    const resultsResult = await db.query(resultsQuery, [testId]);

    const results: LabResult[] = resultsResult.rows.map(row => ({
      id: row.id,
      lab_test_id: row.lab_test_id,
      parameter_code: row.parameter_code,
      value: parseFloat(row.value),
      unit: row.unit,
      status: row.status,
      reference_min: row.reference_min ? parseFloat(row.reference_min) : undefined,
      reference_max: row.reference_max ? parseFloat(row.reference_max) : undefined,
      interpretation: row.interpretation,
      causes: row.causes,
      recommendations: row.recommendations,
      parameter: {
        id: row.id,
        parameter_code: row.param_code,
        name: row.param_name,
        category: row.param_category,
        description: row.param_description,
      } as any,
    }));

    return {
      ...test,
      results,
    };
  }

  /**
   * Get all lab parameters
   */
  async getParameters(category?: string): Promise<LabParameter[]> {
    const db = await import('../../database_module/connection.js');

    let query = `SELECT * FROM lab_parameters`;
    const params: any[] = [];

    if (category) {
      query += ` WHERE category = $1`;
      params.push(category);
    }

    query += ` ORDER BY category, name`;

    const result = await db.query(query, params);

    return result.rows.map(row => ({
      id: row.id,
      parameter_code: row.parameter_code,
      name: row.name,
      category: row.category,
      default_unit: row.default_unit,
      available_units: row.available_units,
      reference_ranges: row.reference_ranges,
      description: row.description,
      low_causes: row.low_causes,
      high_causes: row.high_causes,
      recommendations: row.recommendations,
    }));
  }

  /**
   * Get trends for a parameter
   */
  async getParameterTrend(userId: string, parameterCode: string): Promise<any> {
    const db = await import('../../database_module/connection.js');

    const query = `
      SELECT * FROM lab_trends
      WHERE user_id = $1 AND parameter_code = $2
    `;

    const result = await db.query(query, [userId, parameterCode]);

    if (result.rows.length === 0) {
      return null;
    }

    return result.rows[0];
  }

  /**
   * Delete lab test
   */
  async deleteTest(testId: string, userId: string): Promise<boolean> {
    const db = await import('../../database_module/connection.js');

    const query = `
      DELETE FROM lab_tests
      WHERE id = $1 AND user_id = $2
    `;

    const result = await db.query(query, [testId, userId]);

    return (result.rowCount || 0) > 0;
  }
}

