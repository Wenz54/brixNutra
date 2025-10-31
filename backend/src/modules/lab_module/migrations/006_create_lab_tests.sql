-- Migration 006: Lab Tests Module
-- Laboratory tests analysis and interpretation

-- Lab parameters (reference values)
CREATE TABLE IF NOT EXISTS lab_parameters (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parameter_code VARCHAR(50) UNIQUE NOT NULL, -- HGB, RBC, WBC, GLU, CHOL
  name VARCHAR(255) NOT NULL, -- Гемоглобин
  category VARCHAR(100) NOT NULL, -- blood_general, biochemistry, hormones
  
  -- Units
  default_unit VARCHAR(20), -- г/л, мг/дл
  available_units JSONB, -- ['г/л', 'мг/дл']
  
  -- Reference ranges by gender and age
  reference_ranges JSONB NOT NULL, -- [{gender, age_min, age_max, min, max, unit}]
  
  -- Descriptions
  description TEXT,
  low_causes JSONB, -- Причины низких значений
  high_causes JSONB, -- Причины высоких значений
  recommendations TEXT,
  
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- User lab tests
CREATE TABLE IF NOT EXISTS lab_tests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  
  -- Test info
  test_type VARCHAR(100) NOT NULL, -- blood_general, biochemistry, hormones, thyroid
  test_name VARCHAR(255),
  test_date DATE NOT NULL,
  
  -- Upload
  uploaded_at TIMESTAMP DEFAULT NOW(),
  file_url VARCHAR(500), -- Scanned PDF/image
  
  -- Status
  interpretation_generated BOOLEAN DEFAULT FALSE,
  interpretation_generated_at TIMESTAMP,
  
  -- Notes
  doctor_notes TEXT,
  user_notes TEXT,
  
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Lab results (individual parameters in a test)
CREATE TABLE IF NOT EXISTS lab_results (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lab_test_id UUID NOT NULL REFERENCES lab_tests(id) ON DELETE CASCADE,
  parameter_code VARCHAR(50) NOT NULL, -- Reference to lab_parameters
  
  -- Value
  value DECIMAL(10,4) NOT NULL,
  unit VARCHAR(20) NOT NULL,
  
  -- Interpretation
  status VARCHAR(20), -- normal, low, high, critical_low, critical_high
  reference_min DECIMAL(10,4),
  reference_max DECIMAL(10,4),
  
  -- AI interpretation
  interpretation TEXT,
  causes JSONB, -- Possible causes for abnormal values
  recommendations TEXT,
  
  created_at TIMESTAMP DEFAULT NOW()
);

-- Lab test trends (track parameter over time)
CREATE TABLE IF NOT EXISTS lab_trends (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  parameter_code VARCHAR(50) NOT NULL,
  
  -- Data points
  trend_data JSONB NOT NULL, -- [{date, value, status}]
  
  -- Analysis
  trend_direction VARCHAR(20), -- improving, worsening, stable
  last_value DECIMAL(10,4),
  last_test_date DATE,
  
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  
  UNIQUE (user_id, parameter_code)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_lab_parameters_category ON lab_parameters(category);
CREATE INDEX IF NOT EXISTS idx_lab_parameters_code ON lab_parameters(parameter_code);
CREATE INDEX IF NOT EXISTS idx_lab_tests_user ON lab_tests(user_id, test_date DESC);
CREATE INDEX IF NOT EXISTS idx_lab_results_test ON lab_results(lab_test_id);
CREATE INDEX IF NOT EXISTS idx_lab_results_parameter ON lab_results(parameter_code);
CREATE INDEX IF NOT EXISTS idx_lab_trends_user ON lab_trends(user_id, parameter_code);

-- Comments
COMMENT ON TABLE lab_parameters IS 'Reference parameters for lab tests';
COMMENT ON TABLE lab_tests IS 'User lab tests';
COMMENT ON TABLE lab_results IS 'Individual parameter results within a test';
COMMENT ON TABLE lab_trends IS 'Parameter trends over time';

COMMENT ON COLUMN lab_parameters.parameter_code IS 'Unique code like HGB, RBC, GLU';
COMMENT ON COLUMN lab_parameters.reference_ranges IS 'Array of {gender, age_min, age_max, min, max, unit}';
COMMENT ON COLUMN lab_results.status IS 'normal, low, high, critical_low, critical_high';
COMMENT ON COLUMN lab_trends.trend_direction IS 'improving, worsening, stable';

-- Function to update lab trends
CREATE OR REPLACE FUNCTION update_lab_trends()
RETURNS TRIGGER AS $$
DECLARE
  v_user_id UUID;
  v_test_date DATE;
  v_trend_data JSONB;
BEGIN
  -- Get user_id and test_date
  SELECT user_id, test_date INTO v_user_id, v_test_date
  FROM lab_tests
  WHERE id = NEW.lab_test_id;
  
  -- Get existing trend data
  SELECT trend_data INTO v_trend_data
  FROM lab_trends
  WHERE user_id = v_user_id AND parameter_code = NEW.parameter_code;
  
  -- Append new data point
  IF v_trend_data IS NULL THEN
    v_trend_data := '[]'::jsonb;
  END IF;
  
  v_trend_data := v_trend_data || jsonb_build_array(
    jsonb_build_object(
      'date', v_test_date,
      'value', NEW.value,
      'status', NEW.status,
      'unit', NEW.unit
    )
  );
  
  -- Insert or update trend
  INSERT INTO lab_trends (user_id, parameter_code, trend_data, last_value, last_test_date)
  VALUES (v_user_id, NEW.parameter_code, v_trend_data, NEW.value, v_test_date)
  ON CONFLICT (user_id, parameter_code) DO UPDATE SET
    trend_data = v_trend_data,
    last_value = NEW.value,
    last_test_date = v_test_date,
    updated_at = NOW();
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-update trends
CREATE TRIGGER trigger_update_lab_trends
AFTER INSERT ON lab_results
FOR EACH ROW
EXECUTE FUNCTION update_lab_trends();

-- Success message
DO $$
BEGIN
  RAISE NOTICE '✅ Migration 006: Lab Tests tables created';
  RAISE NOTICE '   - lab_parameters (reference values)';
  RAISE NOTICE '   - lab_tests (user tests)';
  RAISE NOTICE '   - lab_results (individual results)';
  RAISE NOTICE '   - lab_trends (tracking over time)';
  RAISE NOTICE '   - Auto-update trends trigger installed';
END $$;

