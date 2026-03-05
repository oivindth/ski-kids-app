import SwiftUI

struct AppearanceSettingsView: View {
    @AppStorage("appearanceMode") private var appearanceMode: AppearanceMode = .system
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()

                VStack(spacing: 20) {
                    FormCard(title: "Appearance", icon: "paintbrush.fill", iconColor: AppColors.primary) {
                        VStack(spacing: 0) {
                            ForEach(AppearanceMode.allCases, id: \.rawValue) { mode in
                                Button {
                                    appearanceMode = mode
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: mode.icon)
                                            .font(.body)
                                            .foregroundStyle(appearanceMode == mode ? AppColors.primary : AppColors.textSecondary)
                                            .frame(width: 24)

                                        Text(mode.label)
                                            .font(.body)
                                            .fontWeight(appearanceMode == mode ? .semibold : .regular)
                                            .foregroundStyle(appearanceMode == mode ? AppColors.primary : AppColors.textPrimary)

                                        Spacer()

                                        if appearanceMode == mode {
                                            Image(systemName: "checkmark")
                                                .font(.body)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(AppColors.primary)
                                        }
                                    }
                                    .padding(.vertical, 12)
                                }

                                if mode != AppearanceMode.allCases.last {
                                    Divider()
                                }
                            }
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.primary)
                }
            }
        }
    }
}
