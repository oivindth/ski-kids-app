import React, { ReactNode } from 'react';
import { View, Text } from 'react-native';
import Ionicons from '@expo/vector-icons/Ionicons';
import MaterialCommunityIcons from '@expo/vector-icons/MaterialCommunityIcons';
import { IconDef } from '../theme/icons';

interface FormCardProps {
  title: string;
  icon: IconDef;
  iconColor?: string;
  children: ReactNode;
}

export function FormCard({ title, icon, iconColor = '#1A73E8', children }: FormCardProps) {
  return (
    <View className="bg-surface-light dark:bg-surface-dark rounded-2xl p-4 shadow-sm"
      style={{ shadowColor: '#000', shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.05, shadowRadius: 6, elevation: 2 }}>
      <View className="flex-row items-center gap-x-2 mb-3">
        {icon.family === 'ionicons' ? (
          <Ionicons name={icon.name} size={16} color={iconColor} />
        ) : (
          <MaterialCommunityIcons name={icon.name} size={16} color={iconColor} />
        )}
        <Text className="text-sm font-semibold text-text-primary-light dark:text-text-primary-dark">
          {title}
        </Text>
      </View>
      {children}
    </View>
  );
}
