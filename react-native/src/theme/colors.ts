import { useColorScheme } from 'nativewind';

export const AppColors = {
  primary: '#1A73E8',
  secondary: '#00897B',
  accent: '#FF6D00',
  warning: '#F59E0B',
  background: {
    light: '#F5F7FA',
    dark: '#1A1A2E',
  },
  surface: {
    light: '#FFFFFF',
    dark: '#2A2A3E',
  },
  textPrimary: {
    light: '#1A1A2E',
    dark: '#F0F0F5',
  },
  textSecondary: {
    light: '#6B7280',
    dark: '#9CA3AF',
  },
} as const;

export function useThemeColors() {
  const { colorScheme } = useColorScheme();
  const mode = colorScheme === 'dark' ? 'dark' : 'light';

  return {
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    accent: AppColors.accent,
    warning: AppColors.warning,
    background: AppColors.background[mode],
    surface: AppColors.surface[mode],
    textPrimary: AppColors.textPrimary[mode],
    textSecondary: AppColors.textSecondary[mode],
    mode,
  };
}
