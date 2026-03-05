import { openDatabaseSync } from 'expo-sqlite';
import { runMigrations } from './migrations';

const db = openDatabaseSync('skikids.db');

runMigrations(db);

export { db };
