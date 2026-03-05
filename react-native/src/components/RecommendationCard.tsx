import React from 'react';
import { View, Text } from 'react-native';
import Ionicons from '@expo/vector-icons/Ionicons';
import MaterialCommunityIcons from '@expo/vector-icons/MaterialCommunityIcons';
import { IconDef } from '../theme/icons';
import { AppColors } from '../theme/colors';

interface RecommendationCardProps {
  icon: IconDef;
  iconColor: string;
  title: string;
  subtitle?: string;
  value: string;
  detail?: string;
}

export function RecommendationCard({ icon, iconColor, title, subtitle, value, detail }: RecommendationCardProps) {
  return (
    <View
      className="bg-surface-light dark:bg-surface-dark rounded-2xl p-4"
      style={{ shadowColor: '#000', shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.05, shadowRadius: 6, elevation: 2 }}
    >
      <View className="flex-row items-center gap-x-3">
        <View
          className="items-center justify-center rounded-xl"
          style={{ width: 44, height: 44, backgroundColor: iconColor + '1F' }}
        >
          {icon.family === 'ionicons' ? (
            <Ionicons name={icon.name} size={20} color={iconColor} />
          ) : (
            <MaterialCommunityIcons name={icon.name} size={20} color={iconColor} />
          )}
        </View>

        <View className="flex-1">
          <Text className="text-sm font-semibold text-text-primary-light dark:text-text-primary-dark">
            {title}
          </Text>
          {subtitle ? (
            <Text className="text-xs text-text-secondary-light dark:text-text-secondary-dark mt-0.5">
              {subtitle}
            </Text>
          ) : null}
        </View>

        <Text
          className="text-xl font-bold"
          style={{ color: iconColor, fontVariant: ['tabular-nums'] }}
        >
          {value}
        </Text>
      </View>

      {detail ? (
        <Text
          className="text-xs text-text-secondary-light dark:text-text-secondary-dark mt-3"
          style={{ marginLeft: 56 }}
        >
          {detail}
        </Text>
      ) : null}
    </View>
  );
}
