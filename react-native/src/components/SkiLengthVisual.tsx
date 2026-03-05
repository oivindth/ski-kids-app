import React, { useState } from 'react';
import { View, Text, LayoutChangeEvent } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { AppColors } from '../theme/colors';

interface SkiLengthVisualProps {
  minCm: number;
  maxCm: number;
  heightCm: number;
  color?: string;
}

const BAR_MIN = 50;
const BAR_MAX = 220;
const BAR_RANGE = BAR_MAX - BAR_MIN;

export function SkiLengthVisual({ minCm, maxCm, heightCm, color = AppColors.primary }: SkiLengthVisualProps) {
  const [barWidth, setBarWidth] = useState(0);

  const rangeStart = Math.max(0, Math.min(1, (minCm - BAR_MIN) / BAR_RANGE));
  const rangeEnd = Math.max(0, Math.min(1, (maxCm - BAR_MIN) / BAR_RANGE));
  const heightFraction = Math.max(0, Math.min(1, (heightCm - BAR_MIN) / BAR_RANGE));

  const fillLeft = rangeStart * barWidth;
  const fillWidth = Math.max(14, (rangeEnd - rangeStart) * barWidth);
  const heightMarkerLeft = heightFraction * barWidth - 1;

  function handleLayout(e: LayoutChangeEvent) {
    setBarWidth(e.nativeEvent.layout.width);
  }

  return (
    <View
      className="bg-surface-light dark:bg-surface-dark rounded-xl p-3.5"
      style={{ shadowColor: '#000', shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.04, shadowRadius: 4, elevation: 1 }}
      accessibilityLabel={`Ski length range: ${minCm} to ${maxCm} centimeters. Child height: ${heightCm} centimeters.`}
      accessibilityElementsHidden={false}
    >
      <View className="flex-row items-center justify-between mb-2">
        <Text className="text-xs text-text-secondary-light dark:text-text-secondary-dark">
          Size range visualization
        </Text>
        <Text className="text-xs text-text-secondary-light dark:text-text-secondary-dark">
          {BAR_MIN} cm · {BAR_MAX} cm
        </Text>
      </View>

      <View className="relative h-6 justify-center" onLayout={handleLayout}>
        <View
          className="absolute rounded-md"
          style={{ left: 0, right: 0, height: 14, backgroundColor: '#00000026' }}
        />
        {barWidth > 0 && (
          <LinearGradient
            colors={[color + 'CC', color]}
            start={{ x: 0, y: 0.5 }}
            end={{ x: 1, y: 0.5 }}
            style={{
              position: 'absolute',
              left: fillLeft,
              width: fillWidth,
              height: 14,
              borderRadius: 6,
            }}
          />
        )}
        {barWidth > 0 && (
          <View
            className="absolute"
            style={{
              left: heightMarkerLeft,
              width: 2,
              height: 22,
              top: -4,
              backgroundColor: AppColors.textSecondary.light + '99',
            }}
          />
        )}
      </View>

      <View className="flex-row items-center justify-between mt-2">
        <View className="flex-row items-center gap-x-1">
          <Text className="text-xs font-semibold" style={{ color }}>
            {minCm} cm
          </Text>
          {minCm !== maxCm && (
            <>
              <Text className="text-xs text-text-secondary-light dark:text-text-secondary-dark">–</Text>
              <Text className="text-xs font-semibold" style={{ color }}>
                {maxCm} cm
              </Text>
            </>
          )}
        </View>

        <View className="flex-row items-center gap-x-1">
          <View
            style={{ width: 2, height: 10, backgroundColor: AppColors.textSecondary.light + '80' }}
          />
          <Text className="text-xs text-text-secondary-light dark:text-text-secondary-dark">
            child height ({heightCm} cm)
          </Text>
        </View>
      </View>
    </View>
  );
}
