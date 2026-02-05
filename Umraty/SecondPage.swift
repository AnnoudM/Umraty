

import SwiftUI
import UIKit

struct SecondPage: View {

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height

                let circleSize = min(w, h) * 0.23
                let pillWidth  = circleSize * 1.7
                let pillHeight = circleSize * 1.05

                ZStack {
                    Color(red: 0.94, green: 0.98, blue: 0.95)
                        .ignoresSafeArea()

                    VStack(spacing: h * 0.08) {

                        HStack(spacing: w * 0.10) {

                            NavigationLink(destination: GamesPage()) {
                                MenuCircleButton(
                                    imageName: "image1 1",
                                    title: "العاب",
                                    circleSize: circleSize,
                                    pillWidth: pillWidth,
                                    pillHeight: pillHeight,

                                    // ✅ Adjust image1 alone
                                    imageScale: 1.20,
                                    imageX: 3,
                                    imageY: 0
                                )
                            }

                            NavigationLink(destination: LearnUmrahPage()) {
                                MenuCircleButton(
                                    imageName: "image2",
                                    title: "تعلم العمرة",
                                    circleSize: circleSize,
                                    pillWidth: pillWidth,
                                    pillHeight: pillHeight,

                                    // ✅ Adjust image2 alone
                                    imageScale: 1.90,
                                    imageX: 3,
                                    imageY: 0
                                )
                            }
                        }

                        NavigationLink(destination: PrayersPage()) {
                            MenuCircleButton(
                                imageName: "image3",
                                title: "أدعية",
                                circleSize: circleSize,
                                pillWidth: pillWidth,
                                pillHeight: pillHeight,

                                // ✅ Adjust image3 alone
                                imageScale: 1.90,
                                imageX: 3,
                                imageY: 0
                            )
                        }

                        Spacer()
                    }
                    .padding(.top, h * 0.12)
                    .padding(.horizontal, w * 0.08)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .overlay(alignment: .topLeading) {
                BackButton()
                    .padding(.top, 18)
                    .padding(.leading, 18)
            }
        }
    }
}

// MARK: - Menu Button (each image controlled alone)
struct MenuCircleButton: View {

    let imageName: String
    let title: String

    let circleSize: CGFloat
    let pillWidth: CGFloat
    let pillHeight: CGFloat

    // ✅ Per-image controls
    let imageScale: CGFloat
    let imageX: CGFloat
    let imageY: CGFloat

    private var cleanName: String {
        imageName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: pillHeight / 2)
                    .fill(Color(red: 0.84, green: 0.93, blue: 0.86))
                    .frame(width: pillWidth, height: pillHeight)

                Circle()
                    .fill(Color(red: 0.86, green: 0.94, blue: 0.88))
                    .frame(width: circleSize, height: circleSize)

                // Base frame (keeps things consistent)
                if let uiImage = UIImage(named: cleanName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: circleSize * 0.78, height: circleSize * 0.78)
                        .scaleEffect(imageScale)          // ✅ size per image
                        .offset(x: imageX, y: imageY)     // ✅ move per image
                        .allowsHitTesting(false)
                } else {
                    Image(systemName: "photo")
                        .font(.system(size: circleSize * 0.35, weight: .semibold))
                        .foregroundColor(.black.opacity(0.25))
                        .overlay(
                            Text(cleanName)
                                .font(.caption2)
                                .foregroundColor(.black.opacity(0.35))
                                .offset(y: circleSize * 0.30)
                        )
                        .allowsHitTesting(false)
                }
            }

            Text(title)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(Color(red: 0.43, green: 0.59, blue: 0.57))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Back Button
struct BackButton: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button { dismiss() } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.black.opacity(0.65))
                .padding(10)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Dummy Pages
struct GamesPage: View { var body: some View { Text("صفحة الألعاب").font(.largeTitle) } }
struct LearnUmrahPage: View { var body: some View { Text("صفحة تعلم العمرة").font(.largeTitle) } }
struct PrayersPage: View { var body: some View { Text("صفحة الأدعية").font(.largeTitle) } }

// MARK: - Preview
struct SecondPage_Previews: PreviewProvider {
    static var previews: some View {
        SecondPage()
            .previewDevice("iPad (11-inch)")
    }
}

