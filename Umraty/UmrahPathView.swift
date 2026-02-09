import SwiftUI

struct UmrahPathView: View {

    let selectedGender: ChildGender

    @State private var selectedStep: StepID? = nil

    @AppStorage("umrah_progress_boy") private var progressBoy: Int = 1
    @AppStorage("umrah_progress_girl") private var progressGirl: Int = 1

    @State private var showLockedAlert = false
    @State private var lockedStepTapped: Int = 0

    private func getCurrentStep() -> Int {
        selectedGender == .boy ? progressBoy : progressGirl
    }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let circleSize = min(w, h) * 0.13
            let iconSize = circleSize * 0.42
            let numberSize = circleSize * 0.35
            let characterSize = circleSize * 0.90
            let centerY = h * 0.50
            let currentStep = getCurrentStep()

            ZStack {
                Color(red: 0.85, green: 0.93, blue: 0.85).ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer(minLength: geo.size.height * 0.08)

                    Text("umrah_steps_title")
                        .font(.system(size: min(w, h) * 0.07, weight: .bold))
                        .foregroundColor(Color("Color1"))
                        .shadow(color: Color.black.opacity(0.15), radius: 3, x: 0, y: 3)

                    Spacer()

                    ZStack {
                        UmrahCurvedPath()
                            .stroke(Color.gray.opacity(0.35),
                                    style: StrokeStyle(
                                        lineWidth: max(2, circleSize * 0.06),
                                        lineCap: .round,
                                        dash: [10, 10]
                                    ))
                            .frame(width: w * 0.78, height: h * 0.22)
                            .position(x: w * 0.54, y: centerY)

                        ForEach(1...5, id: \.self) { step in
                            StepNode(
                                step: step,
                                currentStep: currentStep,
                                circleSize: circleSize,
                                iconSize: iconSize,
                                numberSize: numberSize,
                                position: nodePosition(step: step, w: w, centerY: centerY),
                                iconAssetName: iconAssetName(step: step),
                                onTap: { tapped in
                                    if tapped <= currentStep {
                                        selectedStep = StepID(value: tapped)   // ✅ بدل navPath.append
                                    } else {
                                        lockedStepTapped = tapped
                                        showLockedAlert = true
                                    }
                                }
                            )
                        }

                        Image(selectedGender == .boy ? "boy" : "girl")
                            .resizable()
                            .scaledToFit()
                            .frame(width: characterSize)
                            .position(characterPosition(
                                base: nodePosition(step: currentStep, w: w, centerY: centerY),
                                yOffset: circleSize * 1.35
                            ))
                    }

                    Spacer()
                }
            }
        }
        .alert(Text("step_locked_title"), isPresented: $showLockedAlert) {
            Button("step_locked_ok", role: .cancel) { }
        } message: {
            Text(String(format: NSLocalizedString("step_locked_message", comment: ""),
                        "\(lockedStepTapped)"))
        }
        .navigationDestination(item: $selectedStep) { stepID in
            UmrahStepRouterView(
                selectedGender: selectedGender,
                step: stepID.value
            )
        }
    }
    }

    private func nodePosition(step: Int, w: CGFloat, centerY: CGFloat) -> CGPoint {
        let points: [CGPoint] = [
            CGPoint(x: w * 0.20, y: centerY + 10),
            CGPoint(x: w * 0.36, y: centerY - 2),
            CGPoint(x: w * 0.50, y: centerY - 10),
            CGPoint(x: w * 0.64, y: centerY - 6),
            CGPoint(x: w * 0.78, y: centerY - 14)
        ]
        return points[max(0, min(step - 1, points.count - 1))]
    }

    private func characterPosition(base: CGPoint, yOffset: CGFloat) -> CGPoint {
        CGPoint(x: base.x, y: base.y - yOffset)
    }

    private func iconAssetName(step: Int) -> String {
        switch step {
        case 1: return "ihram"
        case 2: return "tawaf"
        case 3: return "sai"
        case 4: return "tah"
        default: return "quizz"
        }
    }


// MARK: - StepNode
struct StepNode: View {

    let step: Int
    let currentStep: Int
    let circleSize: CGFloat
    let iconSize: CGFloat
    let numberSize: CGFloat
    let position: CGPoint
    let iconAssetName: String
    let onTap: (Int) -> Void

    var body: some View {
        let unlocked = step <= currentStep
        let fill = stepColor(step).opacity(unlocked ? 1.0 : 0.40)

        Button {
            onTap(step)
        } label: {
            ZStack {
                Circle()
                    .fill(fill)
                    .frame(width: circleSize, height: circleSize)
                    .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 6)

                let isBig = (step == 2 || step == 3 || step == 5)
                let scale: CGFloat = isBig ? 2.1 : 1.55

                Image(iconAssetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize * scale, height: iconSize * scale)
                    .opacity(unlocked ? 1.0 : 0.85)

                if !unlocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: circleSize * 0.28, weight: .bold))
                        .foregroundColor(Color.black.opacity(0.70))
                        .offset(x: circleSize * 0.38, y: circleSize * 0.32)
                }

                Text("\(step)")
                    .font(.system(size: numberSize, weight: .heavy))
                    .foregroundColor(Color("Color1"))
                    .shadow(color: Color.black.opacity(0.15), radius: 3, x: 0, y: 3)
                    .offset(y: circleSize * 0.95)
            }
        }
        .buttonStyle(.plain)
        .position(position)
    }

    private func stepColor(_ step: Int) -> Color {
        switch step {
        case 1: return Color(red: 0.98, green: 0.96, blue: 0.73)
        case 2: return Color(red: 0.95, green: 0.66, blue: 0.62)
        case 3: return Color(red: 0.56, green: 0.76, blue: 0.82)
        case 4: return Color(red: 0.70, green: 0.92, blue: 0.74)
        default: return Color(red: 0.97, green: 0.64, blue: 0.56)
        }
    }
}


// MARK: - Curved Path
struct UmrahCurvedPath: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let start = CGPoint(x: rect.minX + rect.width * 0.05, y: rect.minY + rect.height * 0.60)
        let end = CGPoint(x: rect.minX + rect.width * 0.95, y: rect.minY + rect.height * 0.42)
        p.move(to: start)
        p.addCurve(
            to: end,
            control1: CGPoint(x: rect.minX + rect.width * 0.28, y: rect.minY + rect.height * 0.30),
            control2: CGPoint(x: rect.minX + rect.width * 0.68, y: rect.minY + rect.height * 0.80)
        )
        return p
    }
}


// MARK: - StepID
struct StepID: Identifiable, Hashable {
    let value: Int
    var id: Int { value }
}


// MARK: - StepDetailView
struct StepDetailView: View {

    let step: Int
    let onComplete: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color(red: 0.95, green: 0.98, blue: 0.94)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Text(stepTitleKey(step))
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)

                Text("step_content_placeholder")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                Button {
                    onComplete()
                    dismiss()
                } label: {
                    Text("step_finish")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 28)
                        .background(Color(red: 0.55, green: 0.7, blue: 0.7))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(radius: 4)
                }

                Button {
                    dismiss()
                } label: {
                    Text("back")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black.opacity(0.7))
                }
                .padding(.top, 8)
            }
            .padding(.top, 40)
        }
    }

    private func stepTitleKey(_ step: Int) -> LocalizedStringKey {
        switch step {
        case 1: return "step_title_ihram"
        case 2: return "step_title_tawaf"
        case 3: return "step_title_sai"
        case 4: return "step_title_tahallul"
        default: return "step_title_quiz"
        }
    }
}


// MARK: - Router
struct UmrahStepRouterView: View {

    let selectedGender: ChildGender
    let step: Int

    @AppStorage("umrah_progress_boy") private var progressBoy: Int = 1
    @AppStorage("umrah_progress_girl") private var progressGirl: Int = 1

    private func getCurrentStep() -> Int {
        selectedGender == .boy ? progressBoy : progressGirl
    }

    private func setCurrentStep(_ newValue: Int) {
        let v = max(1, min(newValue, 5))
        if selectedGender == .boy { progressBoy = v } else { progressGirl = v }
    }

    private func completeStep(_ step: Int) {
        let current = getCurrentStep()
        if step == current && current < 5 {
            setCurrentStep(current + 1)
        }
    }

    @ViewBuilder
    var body: some View {
        if step == 1 {
            if selectedGender == .girl {
                IhramPage_suha_girl()
            } else {
                IhramPageBoy_suha()
            }

        } else if step == 2 {
                    Tawaf(selectedGender: selectedGender) {
                completeStep(2)
            }

        } else if step == 3 {
            SaiLessonView {
                completeStep(3) }
                
        } else if step == 4 {
            if selectedGender == .girl {
                ThllPagegirl_suha()
            } else {
                ThllPage_suha()
            }

        } else {
            StepDetailView(step: step) { completeStep(step) }
        }
    }
}

// MARK: - Preview
#Preview {
    UmrahPathView(selectedGender: .boy)
}
