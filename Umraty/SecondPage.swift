import SwiftUI

struct SecondPage: View {

    let selectedGender: ChildGender
    @State private var umrahNavPath: [StepID] = []

    var body: some View {
        NavigationStack(path: $umrahNavPath) {
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
                                SecondMenuCircleButton(
                                    imageName: "image1 1",
                                    title: "العاب",
                                    circleSize: circleSize,
                                    pillWidth: pillWidth,
                                    pillHeight: pillHeight,
                                    imageScale: 1.20,
                                    imageX: 3,
                                    imageY: 0
                                )
                            }

                            NavigationLink(
                                destination: UmrahPathView(
                                    selectedGender: selectedGender,
                                    navPath: $umrahNavPath
                                )
                            ) {
                                SecondMenuCircleButton(
                                    imageName: "image2",
                                    title: "تعلم العمرة",
                                    circleSize: circleSize,
                                    pillWidth: pillWidth,
                                    pillHeight: pillHeight,
                                    imageScale: 1.90,
                                    imageX: 3,
                                    imageY: 0
                                )
                            }
                        }

                        NavigationLink(destination: Duaa()) {
                            SecondMenuCircleButton(
                                imageName: "image3",
                                title: "أدعية",
                                circleSize: circleSize,
                                pillWidth: pillWidth,
                                pillHeight: pillHeight,
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
            // ✅ هنا المكان الصح
            .navigationDestination(for: StepID.self) { stepID in
                UmrahStepRouterView(
                    selectedGender: selectedGender,
                    step: stepID.value
                )
            }
        }
    }
}

// MARK: - زر الدائرة
struct SecondMenuCircleButton: View {

    let imageName: String
    let title: String

    let circleSize: CGFloat
    let pillWidth: CGFloat
    let pillHeight: CGFloat

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

                Image(cleanName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: circleSize * 0.78, height: circleSize * 0.78)
                    .scaleEffect(imageScale)
                    .offset(x: imageX, y: imageY)
                    .allowsHitTesting(false)
            }

            Text(title)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(Color(red: 0.43, green: 0.59, blue: 0.57))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - صفحة مؤقتة للألعاب
struct GamesPage: View {
    var body: some View {
        Text("صفحة الألعاب")
            .font(.largeTitle)
    }
}

