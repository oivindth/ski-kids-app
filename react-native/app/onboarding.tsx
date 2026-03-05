import React, { useRef, useState } from 'react';
import {
  Dimensions,
  FlatList,
  Pressable,
  Text,
  View,
  ViewToken,
} from 'react-native';
import { router } from 'expo-router';
import { LinearGradient } from 'expo-linear-gradient';
import { OnboardingPage } from '@/src/components/OnboardingPage';
import { useAppSettingsStore } from '@/src/stores/app-settings-store';
import { AppColors } from '@/src/theme/colors';
import { AppIcons } from '@/src/theme/icons';
import { IconDef } from '@/src/theme/icons';

const { width: SCREEN_WIDTH } = Dimensions.get('window');

interface PageData {
  key: string;
  icon: IconDef;
  iconColor: string;
  title: string;
  subtitle: string;
  gradientColors: [string, string];
}

const PAGES: PageData[] = [
  {
    key: 'welcome',
    icon: AppIcons.skiAlpine,
    iconColor: AppColors.primary,
    title: 'Welcome to SkiKids',
    subtitle: 'Find the perfect ski equipment for your child',
    gradientColors: [AppColors.primary, AppColors.secondary],
  },
  {
    key: 'measurements',
    icon: AppIcons.ruler,
    iconColor: AppColors.secondary,
    title: 'Enter Measurements',
    subtitle:
      "Height, weight, age, and ability level — we calculate ski lengths, pole lengths, and DIN settings",
    gradientColors: [AppColors.secondary, '#00695C'],
  },
  {
    key: 'safety',
    icon: AppIcons.shield,
    iconColor: AppColors.accent,
    title: 'Safety Matters',
    subtitle:
      'DIN settings are recommendations only. Always have bindings set by a certified technician.',
    gradientColors: [AppColors.accent, '#E65100'],
  },
];

export default function OnboardingScreen() {
  const [currentIndex, setCurrentIndex] = useState(0);
  const flatListRef = useRef<FlatList<PageData>>(null);
  const setHasSeenOnboarding = useAppSettingsStore(
    (s) => s.setHasSeenOnboarding,
  );

  const onViewableItemsChanged = useRef(
    ({ viewableItems }: { viewableItems: ViewToken[] }) => {
      if (viewableItems.length > 0 && viewableItems[0].index != null) {
        setCurrentIndex(viewableItems[0].index);
      }
    },
  ).current;

  const viewabilityConfig = useRef({ itemVisiblePercentThreshold: 50 }).current;

  function handleGetStarted() {
    setHasSeenOnboarding(true);
    router.back();
  }

  return (
    <View className="flex-1">
      <FlatList
        ref={flatListRef}
        data={PAGES}
        keyExtractor={(item) => item.key}
        horizontal
        pagingEnabled
        showsHorizontalScrollIndicator={false}
        onViewableItemsChanged={onViewableItemsChanged}
        viewabilityConfig={viewabilityConfig}
        renderItem={({ item, index }) => (
          <View style={{ width: SCREEN_WIDTH, flex: 1 }}>
            <OnboardingPage
              icon={item.icon}
              iconColor={item.iconColor}
              title={item.title}
              subtitle={item.subtitle}
              gradientColors={item.gradientColors}
            />
            {index === PAGES.length - 1 && (
              <LinearGradient
                colors={item.gradientColors}
                start={{ x: 0, y: 0 }}
                end={{ x: 1, y: 1 }}
                className="px-10 pb-16"
              >
                <Pressable
                  onPress={handleGetStarted}
                  accessibilityRole="button"
                  accessibilityLabel="Get Started"
                  accessibilityHint="Dismisses the introduction and opens the app"
                  className="items-center justify-center rounded-2xl py-5"
                  style={{
                    backgroundColor: '#FFFFFF',
                    shadowColor: '#000',
                    shadowOffset: { width: 0, height: 4 },
                    shadowOpacity: 0.15,
                    shadowRadius: 8,
                  }}
                >
                  <Text
                    className="text-base font-bold"
                    style={{ color: item.gradientColors[0] }}
                  >
                    Get Started
                  </Text>
                </Pressable>
              </LinearGradient>
            )}
          </View>
        )}
      />

      <View
        className="absolute bottom-8 left-0 right-0 flex-row items-center justify-center gap-x-2"
        pointerEvents="none"
      >
        {PAGES.map((_, index) => (
          <View
            key={index}
            style={{
              width: index === currentIndex ? 20 : 8,
              height: 8,
              borderRadius: 4,
              backgroundColor:
                index === currentIndex
                  ? 'rgba(255,255,255,1)'
                  : 'rgba(255,255,255,0.45)',
            }}
          />
        ))}
      </View>
    </View>
  );
}
