// Standard API response helpers

export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  message?: string;
  meta?: Record<string, any>;
}

export interface ApiErrorResponse {
  success: false;
  error: string;
  message: string;
  statusCode: number;
  details?: any;
}

export interface PaginatedApiResponse<T> {
  success: boolean;
  data: T[];
  pagination: {
    total: number;
    page: number;
    limit: number;
    pages: number;
  };
}

// Success response helper
export function successResponse<T>(
  data: T,
  message?: string,
  meta?: Record<string, any>
): ApiResponse<T> {
  return {
    success: true,
    data,
    message,
    meta,
  };
}

// Error response helper
export function errorResponse(
  message: string,
  statusCode: number = 500,
  details?: any
): ApiErrorResponse {
  return {
    success: false,
    error: getErrorCode(statusCode),
    message,
    statusCode,
    details,
  };
}

// Paginated response helper
export function paginatedResponse<T>(
  data: T[],
  total: number,
  page: number,
  limit: number
): PaginatedApiResponse<T> {
  return {
    success: true,
    data,
    pagination: {
      total,
      page,
      limit,
      pages: Math.ceil(total / limit),
    },
  };
}

// Get error code by status code
function getErrorCode(statusCode: number): string {
  const errorCodes: Record<number, string> = {
    400: 'BAD_REQUEST',
    401: 'UNAUTHORIZED',
    403: 'FORBIDDEN',
    404: 'NOT_FOUND',
    409: 'CONFLICT',
    422: 'VALIDATION_ERROR',
    500: 'INTERNAL_SERVER_ERROR',
  };
  
  return errorCodes[statusCode] || 'UNKNOWN_ERROR';
}

