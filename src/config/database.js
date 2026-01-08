import 'dotenv/config';
import { neon, neonConfig } from '@neondatabase/serverless';
import { drizzle } from 'drizzle-orm/neon-http';

const { NODE_ENV, NEON_LOCAL, DATABASE_URL } = process.env;

if (NEON_LOCAL === 'true') {
  neonConfig.fetchEndpoint = 'http://neon-local:5432/sql';
  neonConfig.useSecureWebSocket = false;
  neonConfig.poolQueryViaFetch = true;
}

const sql = neon(DATABASE_URL);

const db = drizzle(sql, {
  logger: NODE_ENV === 'development',
});

export { db, sql };
