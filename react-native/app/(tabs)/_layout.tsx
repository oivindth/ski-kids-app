import React from 'react';
import { Tabs } from 'expo-router';
import Ionicons from '@expo/vector-icons/Ionicons';
import { AppColors } from '@/src/theme/colors';
import { useColorScheme } from 'nativewind';

export default function TabLayout() {
  const { colorScheme } = useColorScheme();
  const effectiveScheme = colorScheme === 'dark' ? 'dark' : 'light';

  return (
    <Tabs
      screenOptions={{
        tabBarActiveTintColor: AppColors.primary,
        tabBarInactiveTintColor: effectiveScheme === 'dark' ? '#9CA3AF' : '#6B7280',
        tabBarStyle: {
          backgroundColor: effectiveScheme === 'dark' ? AppColors.surface.dark : AppColors.surface.light,
        },
        headerStyle: {
          backgroundColor: effectiveScheme === 'dark' ? AppColors.surface.dark : AppColors.surface.light,
        },
        headerTintColor: effectiveScheme === 'dark' ? AppColors.textPrimary.dark : AppColors.textPrimary.light,
      }}
    >
      <Tabs.Screen
        name="index"
        options={{
          title: 'My Kids',
          headerShown: false,
          tabBarIcon: ({ color, size }) => (
            <Ionicons name="people" size={size} color={color} />
          ),
        }}
      />
      <Tabs.Screen
        name="quick-calc"
        options={{
          title: 'Quick Calc',
          headerShown: false,
          tabBarIcon: ({ color, size }) => (
            <Ionicons name="flash" size={size} color={color} />
          ),
        }}
      />
      <Tabs.Screen
        name="tips"
        options={{
          title: 'Tips & Info',
          headerShown: false,
          tabBarIcon: ({ color, size }) => (
            <Ionicons name="information-circle" size={size} color={color} />
          ),
        }}
      />
    </Tabs>
  );
}
