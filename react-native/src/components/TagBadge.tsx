import React from 'react';
import { View, Text } from 'react-native';
import { AppColors } from '../theme/colors';

interface TagBadgeProps {
  label: string;
  color?: string;
  textColor?: string;
}

export function TagBadge({ label, color, textColor }: TagBadgeProps) {
  const bg = color ?? AppColors.primary + '1A';
  const fg = textColor ?? AppColors.primary;

  return (
    <View
      className="rounded-full px-2 py-0.5"
      style={{ backgroundColor: bg }}
    >
      <Text className="text-xs font-semibold" style={{ color: fg }}>
        {label}
      </Text>
    </View>
  );
}
