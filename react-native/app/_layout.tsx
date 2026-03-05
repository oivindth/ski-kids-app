import { DarkTheme, DefaultTheme, ThemeProvider } from '@react-navigation/native';
import { useFonts } from 'expo-font';
import { Stack, router } from 'expo-router';
import * as SplashScreen from 'expo-splash-screen';
import { useEffect } from 'react';
import { useColorScheme as useSystemColorScheme } from 'react-native';
import { useColorScheme } from 'nativewind';
import 'react-native-reanimated';
import '../global.css';

import { useAppSettingsStore } from '@/src/stores/app-settings-store';

export { ErrorBoundary } from 'expo-router';

export const unstable_settings = {
  initialRouteName: '(tabs)',
};

SplashScreen.preventAutoHideAsync();

export default function RootLayout() {
  const [loaded, error] = useFonts({
    SpaceMono: require('../assets/fonts/SpaceMono-Regular.ttf'),
  });

  useEffect(() => {
    if (error) throw error;
  }, [error]);

  useEffect(() => {
    if (loaded) {
      SplashScreen.hideAsync();
    }
  }, [loaded]);

  if (!loaded) {
    return null;
  }

  return <RootLayoutNav />;
}

function RootLayoutNav() {
  const systemScheme = useSystemColorScheme();
  const { setColorScheme } = useColorScheme();
  const appearanceMode = useAppSettingsStore((s) => s.appearanceMode);
  const hasSeenOnboarding = useAppSettingsStore((s) => s.hasSeenOnboarding);

  useEffect(() => {
    if (!hasSeenOnboarding) {
      router.push('/onboarding');
    }
  }, [hasSeenOnboarding]);

  // Sync NativeWind's color scheme with user preference
  useEffect(() => {
    setColorScheme(appearanceMode);
  }, [appearanceMode, setColorScheme]);

  const effectiveScheme =
    appearanceMode === 'system' ? systemScheme ?? 'light' : appearanceMode;

  return (
    <ThemeProvider value={effectiveScheme === 'dark' ? DarkTheme : DefaultTheme}>
      <Stack>
        <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
        <Stack.Screen name="add-child" options={{ presentation: 'modal', headerShown: false }} />
        <Stack.Screen name="results" options={{ headerShown: false }} />
        <Stack.Screen name="child/[id]" options={{ headerShown: false }} />
        <Stack.Screen name="child/[id]/edit" options={{ headerShown: false }} />
        <Stack.Screen name="din-detail" options={{ presentation: 'modal', title: 'DIN Details' }} />
        <Stack.Screen name="shop-mode" options={{ presentation: 'fullScreenModal', title: 'Ski Shop' }} />
        <Stack.Screen name="settings" options={{ presentation: 'modal', title: 'Settings' }} />
        <Stack.Screen name="onboarding" options={{ presentation: 'fullScreenModal', headerShown: false }} />
      </Stack>
    </ThemeProvider>
  );
}
