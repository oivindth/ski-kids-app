import SwiftUI

struct SkiLengthVisual: View {
    let minCm: Int
    let maxCm: Int
    let heightCm: Int
    let color: Color

    private let barMin = 50
    private let barMax = 220

    private var rangeStart: Double {
        Double(minCm - barMin) / Double(barMax - barMin)
    }

    private var rangeEnd: Double {
        Double(maxCm - barMin) / Double(barMax - barMin)
    }

    private var heightFraction: Double {
        Double(heightCm - barMin) / Double(barMax - barMin)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Size range visualization")
                    .font(.caption2)
                    .foregroundStyle(AppColors.textSecondary)
                Spacer()
                Text("\(barMin) cm")
                    .font(.caption2)
                    .foregroundStyle(AppColors.textSecondary)
                Text("·")
                    .font(.caption2)
                    .foregroundStyle(AppColors.textSecondary)
                Text("\(barMax) cm")
                    .font(.caption2)
                    .foregroundStyle(AppColors.textSecondary)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 14)

                    let start = max(0, min(1, rangeStart))
                    let end = max(0, min(1, rangeEnd))
                    let width = geo.size.width

                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [color.opacity(0.8), color],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(
                            width: max(14, (end - start) * width),
                            height: 14
                        )
                        .offset(x: start * width)

                    let heightPos = min(1, max(0, heightFraction)) * width
                    Rectangle()
                        .fill(AppColors.textSecondary.opacity(0.6))
                        .frame(width: 2, height: 22)
                        .offset(x: heightPos - 1, y: -4)
                }
                .frame(height: 14)
            }
            .frame(height: 22)

            HStack {
                Text("\(minCm) cm")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(color)

                if minCm != maxCm {
                    Text("–")
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)

                    Text("\(maxCm) cm")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(color)
                }

                Spacer()

                HStack(spacing: 4) {
                    Rectangle()
                        .fill(AppColors.textSecondary.opacity(0.5))
                        .frame(width: 2, height: 10)
                    Text("child height (\(heightCm) cm)")
                        .font(.caption2)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
        .padding(14)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}
