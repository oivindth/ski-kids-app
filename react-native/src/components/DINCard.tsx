import React from 'react';
import { View, Text, Pressable } from 'react-native';
import MaterialCommunityIcons from '@expo/vector-icons/MaterialCommunityIcons';
import { AppColors } from '../theme/colors';
import { TagBadge } from './TagBadge';

interface DINCardProps {
  dinValue: string;
  code: string;
  skierType: string;
  isJuniorAdjusted: boolean;
  onPress: () => void;
}

export function DINCard({ dinValue, code, skierType, isJuniorAdjusted, onPress }: DINCardProps) {
  return (
    <Pressable
      onPress={onPress}
      accessibilityRole="button"
      accessibilityLabel={`DIN Setting ${dinValue}. Tap for details.`}
      style={({ pressed }) => ({ opacity: pressed ? 0.75 : 1 })}
    >
      <View
        className="bg-surface-light dark:bg-surface-dark rounded-2xl p-4 flex-row items-center gap-x-4"
        style={{
          borderWidth: 1.5,
          borderColor: AppColors.warning + '66',
          shadowColor: AppColors.warning,
          shadowOffset: { width: 0, height: 3 },
          shadowOpacity: 0.12,
          shadowRadius: 8,
          elevation: 3,
        }}
      >
        <View className="flex-1 gap-y-1">
          <View className="flex-row items-center gap-x-1.5">
            <MaterialCommunityIcons name="speedometer" size={18} color={AppColors.warning} />
            <Text className="text-sm font-semibold text-text-primary-light dark:text-text-primary-dark">
              DIN Setting
            </Text>
          </View>

          <View className="flex-row flex-wrap gap-1 mt-1">
            <TagBadge label={`Code ${code}`} color={AppColors.warning + '22'} textColor={AppColors.warning} />
            <TagBadge label={skierType} color={AppColors.primary + '1A'} textColor={AppColors.primary} />
            {isJuniorAdjusted && (
              <TagBadge label="Junior adj." color={AppColors.warning + '22'} textColor={AppColors.warning} />
            )}
          </View>
        </View>

        <View className="items-end gap-y-0.5">
          <Text
            className="font-bold"
            style={{ fontSize: 32, color: AppColors.warning, fontVariant: ['tabular-nums'] }}
          >
            {dinValue}
          </Text>
          <Text className="text-xs text-text-secondary-light dark:text-text-secondary-dark">
            tap for details
          </Text>
        </View>
      </View>
    </Pressable>
  );
}
