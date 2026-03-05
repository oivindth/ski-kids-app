import type { SQLiteDatabase } from 'expo-sqlite';

export function runMigrations(db: SQLiteDatabase): void {
  db.runSync(`
    CREATE TABLE IF NOT EXISTS children (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL DEFAULT '',
      height_cm INTEGER NOT NULL,
      weight_kg INTEGER NOT NULL,
      age INTEGER NOT NULL,
      bsl_mm INTEGER,
      bsl_input_mode_raw INTEGER DEFAULT 0,
      shoe_size INTEGER,
      ability_level TEXT NOT NULL DEFAULT 'Beginner',
      ski_types TEXT NOT NULL DEFAULT '["Alpine"]',
      last_calculated INTEGER,
      created_at INTEGER NOT NULL
    )
  `);
}
