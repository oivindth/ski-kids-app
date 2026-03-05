import React from 'react';
import { View, Text } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import Ionicons from '@expo/vector-icons/Ionicons';
import MaterialCommunityIcons from '@expo/vector-icons/MaterialCommunityIcons';
import { IconDef } from '../theme/icons';

interface OnboardingPageProps {
  icon: IconDef;
  iconColor: string;
  title: string;
  subtitle: string;
  gradientColors?: [string, string];
  backgroundColor?: string;
}

export function OnboardingPage({
  icon,
  iconColor,
  title,
  subtitle,
  gradientColors,
  backgroundColor,
}: OnboardingPageProps) {
  const bg = backgroundColor ?? iconColor;

  const content = (
    <View className="flex-1 items-center justify-center px-10">
      <View className="flex-1 items-center justify-center gap-y-8">
        <View
          className="rounded-full items-center justify-center"
          style={{ width: 140, height: 140, backgroundColor: 'rgba(255,255,255,0.15)' }}
          accessibilityElementsHidden
          importantForAccessibility="no-hide-descendants"
        >
          {icon.family === 'ionicons' ? (
            <Ionicons name={icon.name} size={64} color="#FFFFFF" />
          ) : (
            <MaterialCommunityIcons name={icon.name} size={64} color="#FFFFFF" />
          )}
        </View>

        <View className="items-center gap-y-4">
          <Text className="text-4xl font-bold text-white text-center">
            {title}
          </Text>
          <Text className="text-base text-center" style={{ color: 'rgba(255,255,255,0.9)' }}>
            {subtitle}
          </Text>
        </View>
      </View>
    </View>
  );

  if (gradientColors) {
    return (
      <LinearGradient
        colors={gradientColors}
        start={{ x: 0, y: 0 }}
        end={{ x: 1, y: 1 }}
        style={{ flex: 1 }}
      >
        {content}
      </LinearGradient>
    );
  }

  return (
    <View className="flex-1" style={{ backgroundColor: bg }}>
      {content}
    </View>
  );
}
