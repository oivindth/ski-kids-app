import SwiftUI

struct ChildCardView: View {
    let child: Child
    let onDelete: () -> Void
    @State private var showingDeleteConfirmation = false

    private var abilityColor: Color {
        switch child.abilityLevel {
        case .beginner: return AppColors.secondary
        case .intermediate: return AppColors.primary
        case .advanced: return AppColors.accent
        }
    }

    private var skiTypeIcons: [String] {
        child.skiTypes.map { $0.icon }
    }

    private var lastMeasuredText: String {
        if let date = child.lastCalculated {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            return "Calculated \(formatter.localizedString(for: date, relativeTo: Date()))"
        }
        return "Not yet calculated"
    }

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)

                Text(child.name.prefix(1).uppercased())
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(child.name.isEmpty ? "Child" : child.name)
                        .font(.headline)
                        .foregroundStyle(AppColors.textPrimary)

                    Spacer()

                    HStack(spacing: 4) {
                        ForEach(skiTypeIcons, id: \.self) { icon in
                            Image(systemName: icon)
                                .font(.caption)
                                .foregroundStyle(AppColors.primary)
                        }
                    }
                }

                HStack(spacing: 12) {
                    Label("\(child.age) yrs", systemImage: "birthday.cake")
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)

                    Label("\(child.heightCm) cm", systemImage: "ruler")
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)

                    Label("\(child.weightKg) kg", systemImage: "scalemass")
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }

                HStack {
                    Text(child.abilityLevel.rawValue)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(abilityColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(abilityColor.opacity(0.12))
                        .clipShape(Capsule())

                    Spacer()

                    Text(lastMeasuredText)
                        .font(.caption2)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
        .padding(16)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        .contextMenu {
            Button(role: .destructive) {
                showingDeleteConfirmation = true
            } label: {
                Label("Delete Profile", systemImage: "trash")
            }
        }
        .alert("Delete \(child.name.isEmpty ? "this profile" : child.name)?", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("This will permanently remove the profile and all saved measurements.")
        }
    }
}
