import { db } from './client';
import { AbilityLevel, SkiType, type Child } from '../models/types';

function generateUUID(): string {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
    const r = Math.random() * 16 | 0;
    const v = c === 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}

interface ChildRow {
  id: string;
  name: string;
  height_cm: number;
  weight_kg: number;
  age: number;
  bsl_mm: number | null;
  bsl_input_mode_raw: number | null;
  shoe_size: number | null;
  ability_level: string;
  ski_types: string;
  last_calculated: number | null;
  created_at: number;
}

function rowToChild(row: ChildRow): Child {
  const abilityLevel = Object.values(AbilityLevel).includes(row.ability_level as AbilityLevel)
    ? (row.ability_level as AbilityLevel)
    : AbilityLevel.Beginner;

  let skiTypes: SkiType[];
  try {
    const parsed = JSON.parse(row.ski_types) as unknown[];
    skiTypes = parsed.filter((s): s is SkiType =>
      Object.values(SkiType).includes(s as SkiType)
    );
  } catch {
    skiTypes = [SkiType.Alpine];
  }

  return {
    id: row.id,
    name: row.name,
    heightCm: row.height_cm,
    weightKg: row.weight_kg,
    age: row.age,
    bslMm: row.bsl_mm,
    bslInputModeRaw: row.bsl_input_mode_raw,
    shoeSize: row.shoe_size,
    abilityLevel,
    skiTypes,
    lastCalculated: row.last_calculated != null ? new Date(row.last_calculated) : null,
    createdAt: new Date(row.created_at),
  };
}

export function getAllChildren(): Child[] {
  const rows = db.getAllSync<ChildRow>(
    'SELECT * FROM children ORDER BY created_at DESC'
  );
  return rows.map(rowToChild);
}

export function getChild(id: string): Child | null {
  const row = db.getFirstSync<ChildRow>(
    'SELECT * FROM children WHERE id = ?',
    id
  );
  return row ? rowToChild(row) : null;
}

export function insertChild(data: Omit<Child, 'id' | 'createdAt'>): Child {
  const id = generateUUID();
  const createdAt = Date.now();

  db.runSync(
    `INSERT INTO children (
      id, name, height_cm, weight_kg, age, bsl_mm, bsl_input_mode_raw,
      shoe_size, ability_level, ski_types, last_calculated, created_at
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    id,
    data.name,
    data.heightCm,
    data.weightKg,
    data.age,
    data.bslMm ?? null,
    data.bslInputModeRaw ?? null,
    data.shoeSize ?? null,
    data.abilityLevel,
    JSON.stringify(data.skiTypes),
    data.lastCalculated ? data.lastCalculated.getTime() : null,
    createdAt
  );

  return {
    ...data,
    id,
    createdAt: new Date(createdAt),
  };
}

export function updateChild(
  id: string,
  data: Partial<Omit<Child, 'id' | 'createdAt'>>
): void {
  const fields: string[] = [];
  const values: (string | number | null)[] = [];

  if (data.name !== undefined) {
    fields.push('name = ?');
    values.push(data.name);
  }
  if (data.heightCm !== undefined) {
    fields.push('height_cm = ?');
    values.push(data.heightCm);
  }
  if (data.weightKg !== undefined) {
    fields.push('weight_kg = ?');
    values.push(data.weightKg);
  }
  if (data.age !== undefined) {
    fields.push('age = ?');
    values.push(data.age);
  }
  if (data.bslMm !== undefined) {
    fields.push('bsl_mm = ?');
    values.push(data.bslMm);
  }
  if (data.bslInputModeRaw !== undefined) {
    fields.push('bsl_input_mode_raw = ?');
    values.push(data.bslInputModeRaw);
  }
  if (data.shoeSize !== undefined) {
    fields.push('shoe_size = ?');
    values.push(data.shoeSize);
  }
  if (data.abilityLevel !== undefined) {
    fields.push('ability_level = ?');
    values.push(data.abilityLevel);
  }
  if (data.skiTypes !== undefined) {
    fields.push('ski_types = ?');
    values.push(JSON.stringify(data.skiTypes));
  }
  if (data.lastCalculated !== undefined) {
    fields.push('last_calculated = ?');
    values.push(data.lastCalculated ? data.lastCalculated.getTime() : null);
  }

  if (fields.length === 0) return;

  values.push(id);
  db.runSync(
    `UPDATE children SET ${fields.join(', ')} WHERE id = ?`,
    ...values
  );
}

export function deleteChild(id: string): void {
  db.runSync('DELETE FROM children WHERE id = ?', id);
}

export function updateLastCalculated(id: string): void {
  db.runSync(
    'UPDATE children SET last_calculated = ? WHERE id = ?',
    Date.now(),
    id
  );
}
