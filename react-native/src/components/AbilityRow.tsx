import React from 'react';
import { View, Text, Pressable } from 'react-native';
import * as Haptics from 'expo-haptics';
import { AbilityLevel } from '../models/types';
import { AppColors } from '../theme/colors';

const ABILITY_DESCRIPTIONS: Record<AbilityLevel, string> = {
  [AbilityLevel.Beginner]: 'Just starting out, learning basic control',
  [AbilityLevel.Intermediate]: 'Comfortable on groomed runs, improving technique',
  [AbilityLevel.Advanced]: 'Confident on varied terrain, strong technique',
};

interface AbilityRowProps {
  level: AbilityLevel;
  selected: boolean;
  onSelect: () => void;
  description?: string;
}

export function AbilityRow({ level, selected, onSelect, description }: AbilityRowProps) {
  const desc = description ?? ABILITY_DESCRIPTIONS[level];

  function handlePress() {
    Haptics.selectionAsync();
    onSelect();
  }

  return (
    <Pressable
      onPress={handlePress}
      accessibilityRole="radio"
      accessibilityState={{ selected }}
      accessibilityLabel={level}
      accessibilityHint={desc}
      className="flex-row items-start gap-x-3 p-2.5 rounded-xl min-h-[44px]"
      style={selected ? { backgroundColor: AppColors.primary + '0F' } : undefined}
    >
      <View className="mt-0.5 items-center justify-center" style={{ width: 22, height: 22 }}>
        <View
          className="rounded-full border-2 items-center justify-center"
          style={{
            width: 22,
            height: 22,
            borderColor: selected ? AppColors.primary : AppColors.textSecondary.light + '4D',
          }}
        >
          {selected && (
            <View
              className="rounded-full"
              style={{ width: 12, height: 12, backgroundColor: AppColors.primary }}
            />
          )}
        </View>
      </View>

      <View className="flex-1">
        <Text
          className="text-base"
          style={{
            fontWeight: selected ? '600' : '400',
            color: selected ? AppColors.primary : undefined,
          }}
        >
          {level}
        </Text>
        <Text className="text-xs text-text-secondary-light dark:text-text-secondary-dark mt-0.5">
          {desc}
        </Text>
      </View>
    </Pressable>
  );
}
