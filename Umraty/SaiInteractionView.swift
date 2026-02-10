import SwiftUI
import Combine
import AVFoundation

struct SaiInteractionView: View {

    var onDone: () -> Void

    // MARK: - Man
    @State private var manProgress: CGFloat = 0
    @State private var manRounds = 0
    @State private var manForward = true
    @State private var manAuto = false
    @State private var manFinished = false
    @State private var manSpoken = false

    // MARK: - Woman
    @State private var womanProgress: CGFloat = 0
    @State private var womanRounds = 0
    @State private var womanForward = true
    @State private var womanAuto = false
    @State private var womanFinished = false
    @State private var womanSpoken = false

    // MARK: - Arrow
    @State private var showArrow = false
    @State private var pulseArrow = false
    @Environment(\.dismiss) private var dismiss

    private let speaker = AVSpeechSynthesizer()
    private let timer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height
            let textColor = Color("Color1")

            let startBtnW = min(geo.size.width * 0.28, 220)

            // ✅ إزاحة بسيطة لليمين للأزرار (كما طلبتي)
            let buttonsShiftRight = geo.size.width * -0.03

            // ✅ مسار الحركة
            let trackPadding = geo.size.width * 0.10
            let trackStartX = trackPadding
            let trackEndX = geo.size.width - trackPadding
            let trackWidth = trackEndX - trackStartX

            // ✅ لوحة المسار (نرفعها شوي عشان ما تقرب من الأزرار)
            let trackHeight = geo.size.height * (isLandscape ? 0.28 : 0.33)

            // ✅ أحجام
            let mountainW = trackHeight * 1.15
            let charW = trackHeight * 0.70
            let greenHeight = trackHeight * 0.12

            // ✅ أماكن العناصر
            let groundY = trackHeight * 0.92
            let mtnY = trackHeight * 0.25
            let manY = trackHeight * 0.45
            let womanY = trackHeight * 0.70

            let leftMtnX = trackStartX + trackWidth * 0.20
            let rightMtnX = trackStartX + trackWidth * 0.80

            // ✅ الأخضر بينهم
            let greenX = (leftMtnX + rightMtnX) / 2
            let greenY = trackHeight * 0.20

            // ✅ منطقة الهرولة (للمنطق)
            let greenWidth = trackWidth * 0.22
            let greenStartProgress = ((trackWidth * 0.5) - (greenWidth / 2)) / trackWidth
            let greenEndProgress   = ((trackWidth * 0.5) + (greenWidth / 2)) / trackWidth

            // ✅ عرض الأشواط بشكل ثابت 0/7 .. 7/7
            let manShown = min(manRounds, 7)
            let womanShown = min(womanRounds, 7)

            ZStack {
                Image("background2")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                // ✅ نخلي المحتوى يملى الشاشة، والأزرار تروح لأسفل الصفحة
                VStack(spacing: 0) {

                    // ✅ الجزء العلوي (عداد + المسار)
                    VStack(spacing: isLandscape ? 12 : 16) {
                        Spacer(minLength: geo.size.height * 0.03)

                        // ✅✅ عداد الأشواط (فوق بالنص)
                        HStack(spacing: geo.size.width * 0.10) {
                            counterCard(
                                title: "الرجل",
                                value: "الأشواط: \(manShown)/7" + (manFinished ? " ✅" : ""),
                                geo: geo
                            )
                            counterCard(
                                title: "المرأة",
                                value: "الأشواط: \(womanShown)/7" + (womanFinished ? " ✅" : ""),
                                geo: geo
                            )
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .offset(
                            x: geo.size.width * -0.03,   // ➜ يمين شوي
                            y: -geo.size.height * 0.20  // ➜ فوق عند الغيوم
                        )

                        // ✅⬅️ هنا التغيير الوحيد (رفع للأعلى بالنص)

                        // ✅ المسار
                        ZStack {
                            Rectangle()
                                .fill(Color.black.opacity(0.001))
                                .frame(width: trackWidth, height: 1)
                                .position(x: trackStartX + trackWidth * 0.5, y: groundY)

                            Image("mountain")
                                .resizable()
                                .scaledToFit()
                                .frame(width: mountainW)
                                .position(x: leftMtnX, y: mtnY)

                            Image("mountain")
                                .resizable()
                                .scaledToFit()
                                .frame(width: mountainW)
                                .position(x: rightMtnX, y: mtnY)

                            Rectangle()
                                .fill(Color.green.opacity(0.45))
                                .frame(width: greenWidth, height: greenHeight)
                                .position(x: greenX, y: greenY)

                            Image("manWalk")
                                .resizable()
                                .scaledToFit()
                                .frame(width: charW)
                                .scaleEffect(x: manForward ? 1 : -1)
                                .position(
                                    x: trackStartX + (trackWidth * manProgress),
                                    y: manY
                                )

                            Image("womanWalk")
                                .resizable()
                                .scaledToFit()
                                .frame(width: charW)
                                .scaleEffect(x: womanForward ? 1 : -1)
                                .position(
                                    x: trackStartX + (trackWidth * womanProgress),
                                    y: womanY
                                )
                        }
                        .frame(height: trackHeight)
                        .environment(\.layoutDirection, .leftToRight)
                    }
                    .padding(.horizontal, geo.size.width * 0.05)
                    .foregroundColor(textColor)

                    // ✅ هذا يفصل بين المسار والأزرار ويضمن ما يصير تلامس
                    Spacer(minLength: geo.size.height * 0.06)

                    // ✅ الأزرار دائمًا بأسفل الصفحة
                    VStack(spacing: 14) {

                        // ✅ أزرار التشغيل
                        HStack(spacing: 14) {
                            Button {
                                if !manFinished { manAuto.toggle() }
                            } label: {
                                Text(manAuto ? "إيقاف الرجل" : "ابدأ الرجل")
                                    .frame(width: startBtnW, height: 44)
                                    .background(Color("Color1"))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }

                            Button {
                                if !womanFinished { womanAuto.toggle() }
                            } label: {
                                Text(womanAuto ? "إيقاف المرأة" : "ابدأ المرأة")
                                    .frame(width: startBtnW, height: 44)
                                    .background(Color("Color1"))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .offset(x: buttonsShiftRight)

                        // ✅ التحكم اليدوي
                        HStack(spacing: 22) {
                            manualControl(
                                title: "تحريك الرجل",
                                leftAction: { moveMan(by: -0.05) },
                                rightAction: { moveMan(by: 0.05) }
                            )

                            manualControl(
                                title: "تحريك المرأة",
                                leftAction: { moveWoman(by: -0.05) },
                                rightAction: { moveWoman(by: 0.05) }
                            )
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .offset(x: buttonsShiftRight)

                        if showArrow {
                            Button {
                                onDone()
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(22)
                                    .background(Circle().fill(Color("Color1")))
                                    .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
                                    .scaleEffect(pulseArrow ? 1.15 : 1)
                            }
                            .buttonStyle(.plain)
                            .transition(.scale.combined(with: .opacity))
                            .onAppear {
                                withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                                    pulseArrow = true
                                }
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding(.horizontal, geo.size.width * 0.05)
                    .padding(.bottom, max(18, geo.safeAreaInsets.bottom + 12))
                    .foregroundColor(textColor)
                }
            }
            .onReceive(timer) { _ in
                if manAuto && !manFinished {
                    let inGreen = manProgress > greenStartProgress && manProgress < greenEndProgress
                    moveMan(by: inGreen ? 0.012 : 0.006)
                }

                if womanAuto && !womanFinished {
                    moveWoman(by: 0.005)
                }

                if manFinished && womanFinished && !showArrow {
                    withAnimation(.easeInOut) { showArrow = true }
                }
            }
        }
    }

    // MARK: - Small UI
    private func counterCard(title: String, value: String, geo: GeometryProxy) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: geo.size.width * 0.035, weight: .bold))
            Text(value)
                .font(.system(size: geo.size.width * 0.025))
        }
        .foregroundColor(Color("Color1"))
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(Color.white.opacity(0.45))
        .cornerRadius(14)
    }

    private func manualControl(title: String,
                               leftAction: @escaping () -> Void,
                               rightAction: @escaping () -> Void) -> some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color("Color1"))

            HStack(spacing: 10) {
                Button(action: leftAction) {
                    Image(systemName: "arrow.left")
                        .frame(width: 56, height: 44)
                        .background(Color.black.opacity(0.18))
                        .cornerRadius(10)
                }

                Button(action: rightAction) {
                    Image(systemName: "arrow.right")
                        .frame(width: 56, height: 44)
                        .background(Color.black.opacity(0.18))
                        .cornerRadius(10)
                }
            }
            .foregroundColor(Color("Color1"))
        }
    }

    // MARK: - Speech
    private func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ar-SA")
        utterance.rate = 0.5
        speaker.speak(utterance)
    }

    // MARK: - Movement Logic
    private func moveMan(by amount: CGFloat) {
        guard !manFinished else { return }

        manProgress += manForward ? amount : -amount

        if manProgress >= 1 {
            manProgress = 1
            manForward = false
            manRounds += 1
        } else if manProgress <= 0 {
            manProgress = 0
            manForward = true
            manRounds += 1
        }

        if manRounds >= 7 && !manSpoken {
            manFinished = true
            manAuto = false
            manRounds = 7
            speak("تم الانتهاء من السعي للرجل")
            manSpoken = true
        }
    }

    private func moveWoman(by amount: CGFloat) {
        guard !womanFinished else { return }

        womanProgress += womanForward ? amount : -amount

        if womanProgress >= 1 {
            womanProgress = 1
            womanForward = false
            womanRounds += 1
        } else if womanProgress <= 0 {
            womanProgress = 0
            womanForward = true
            womanRounds += 1
        }

        if womanRounds >= 7 && !womanSpoken {
            womanFinished = true
            womanAuto = false
            womanRounds = 7
            speak("تم الانتهاء من السعي للمرأة")
            womanSpoken = true
        }
    }
}

#Preview {
    NavigationStack {
        SaiInteractionView(onDone: {})
    }
}
