import React from 'react';
import { View, Text } from 'react-native';
import Ionicons from '@expo/vector-icons/Ionicons';
import { AppColors } from '../theme/colors';

interface InfoBannerProps {
  text: string;
  type?: 'info' | 'warning';
  color?: string;
}

export function InfoBanner({ text, type = 'info', color }: InfoBannerProps) {
  const resolvedColor = color ?? (type === 'warning' ? AppColors.warning : AppColors.secondary);

  return (
    <View
      className="flex-row items-start gap-x-2 rounded-xl p-2.5"
      style={{ backgroundColor: resolvedColor + '14' }}
    >
      <Ionicons
        name="information-circle"
        size={14}
        color={resolvedColor}
        style={{ marginTop: 1 }}
      />
      <Text className="flex-1 text-xs text-text-primary-light dark:text-text-primary-dark">
        {text}
      </Text>
    </View>
  );
}
