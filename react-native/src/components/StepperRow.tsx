import React, { useState, useRef } from 'react';
import { View, Text, Pressable, TextInput } from 'react-native';
import Ionicons from '@expo/vector-icons/Ionicons';
import MaterialCommunityIcons from '@expo/vector-icons/MaterialCommunityIcons';
import { AppColors } from '../theme/colors';

interface StepperRowProps {
  label: string;
  value: number;
  min: number;
  max: number;
  step?: number;
  unit: string;
  onChange: (value: number) => void;
  error?: string;
  icon?: string;
  iconFamily?: 'ionicons' | 'material';
  iconColor?: string;
}

export function StepperRow({ label, value, min, max, step = 1, unit, onChange, error, icon, iconFamily = 'ionicons', iconColor = AppColors.textSecondary.light }: StepperRowProps) {
  const [isEditing, setIsEditing] = useState(false);
  const [editText, setEditText] = useState('');
  const inputRef = useRef<TextInput>(null);

  function commitEdit(text?: string) {
    const raw = text ?? editText;
    const parsed = parseInt(raw, 10);
    if (!isNaN(parsed)) {
      onChange(Math.min(Math.max(parsed, min), max));
    }
    setIsEditing(false);
  }

  function handleMinusPress() {
    if (isEditing) commitEdit();
    const next = value - step;
    if (next >= min) onChange(next);
  }

  function handlePlusPress() {
    if (isEditing) commitEdit();
    const next = value + step;
    if (next <= max) onChange(next);
  }

  function handleValuePress() {
    setEditText(String(value));
    setIsEditing(true);
    setTimeout(() => inputRef.current?.focus(), 50);
  }

  const atMin = value <= min;
  const atMax = value >= max;

  return (
    <View>
      <View className="flex-row items-center">
        {icon ? (
          <View style={{ width: 24, marginRight: 8, alignItems: 'center' }}>
            {iconFamily === 'material' ? (
              <MaterialCommunityIcons name={icon as any} size={18} color={iconColor} />
            ) : (
              <Ionicons name={icon as any} size={18} color={iconColor} />
            )}
          </View>
        ) : null}
        <Text className="flex-1 text-sm text-text-primary-light dark:text-text-primary-dark">
          {label}
        </Text>
        <View className="flex-row items-center gap-x-2">
          <Pressable
            onPress={handleMinusPress}
            disabled={atMin}
            hitSlop={8}
            className="w-11 h-11 items-center justify-center"
            accessibilityLabel={`Decrease ${label}`}
          >
            <Ionicons
              name="remove-circle"
              size={26}
              color={atMin ? AppColors.textSecondary.light + '4D' : AppColors.primary}
            />
          </Pressable>

          {isEditing ? (
            <TextInput
              ref={inputRef}
              value={editText}
              onChangeText={setEditText}
              keyboardType="number-pad"
              returnKeyType="done"
              onSubmitEditing={() => commitEdit()}
              onBlur={() => commitEdit()}
              className="w-16 text-center font-bold text-base text-text-primary-light dark:text-text-primary-dark rounded-lg py-1 px-2"
              style={{ backgroundColor: AppColors.primary + '14' }}
            />
          ) : (
            <Pressable
              onPress={handleValuePress}
              className="w-16 items-center justify-center rounded-lg py-1 px-2"
              style={{ backgroundColor: AppColors.primary + '0D' }}
              accessibilityLabel={`${label}: ${value} ${unit}, tap to edit`}
            >
              <Text
                className="font-bold text-base text-text-primary-light dark:text-text-primary-dark text-center"
                style={{ fontVariant: ['tabular-nums'] }}
              >
                {value}
              </Text>
            </Pressable>
          )}

          <Text className="text-xs text-text-secondary-light dark:text-text-secondary-dark w-8">
            {unit}
          </Text>

          <Pressable
            onPress={handlePlusPress}
            disabled={atMax}
            hitSlop={8}
            className="w-11 h-11 items-center justify-center"
            accessibilityLabel={`Increase ${label}`}
          >
            <Ionicons
              name="add-circle"
              size={26}
              color={atMax ? AppColors.textSecondary.light + '4D' : AppColors.primary}
            />
          </Pressable>
        </View>
      </View>
      {error ? (
        <Text className="text-xs text-red-500 mt-1 ml-1">{error}</Text>
      ) : null}
    </View>
  );
}
