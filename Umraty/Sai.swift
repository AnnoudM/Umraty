//
//  Sai.swift
//  Umraty
//
//  Created by Noura Alghamdi on 14/08/1447 AH.
//



import Combine
import SwiftUI
import AVFoundation

struct Sai: View {

    // الرجل
    @State private var manProgress: CGFloat = 0
    @State private var manRounds = 0
    @State private var manGoingForward = true
    @State private var manAuto = false
    @State private var manFinished = false
    @State private var manSpoken = false

    // المرأة
    @State private var womanProgress: CGFloat = 0
    @State private var womanRounds = 0
    @State private var womanGoingForward = true
    @State private var womanAuto = false
    @State private var womanFinished = false
    @State private var womanSpoken = false

    let speaker = AVSpeechSynthesizer()

    var body: some View {
        GeometryReader { geo in

            let isLandscape = geo.size.width > geo.size.height
            let textColor = Color("Color1")

            let startBtnW = min(geo.size.width * 0.28, 220)

            let trackPadding = geo.size.width * 0.10
            let trackStartX = trackPadding
            let trackEndX = geo.size.width - trackPadding
            let trackWidth = trackEndX - trackStartX

            let greenWidth = trackWidth * 0.20
            let greenStartProgress = ((trackWidth * 0.5) - (greenWidth / 2)) / trackWidth
            let greenEndProgress   = ((trackWidth * 0.5) + (greenWidth / 2)) / trackWidth

            // ارتفاع لوحة المسار
            let trackHeight = geo.size.height * (isLandscape ? 0.34 : 0.38)

            ZStack {

                // الخلفية
                Image("background2")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: isLandscape ? 12 : 16) {

                    // العنوان
                    Text("السعي بين الصفا والمروة")
                        .font(.system(size: geo.size.width * 0.05, weight: .bold))
                        .padding(.top, 6)

                    // العدادات
                    HStack(spacing: geo.size.width * 0.10) {
                        VStack(spacing: 2) {
                            Text("الرجل")
                                .font(.system(size: geo.size.width * 0.035, weight: .bold))
                            Text(manFinished ? "تم السعي" : "الأشواط: \(manRounds)")
                                .font(.system(size: geo.size.width * 0.025))
                        }

                        VStack(spacing: 2) {
                            Text("المرأة")
                                .font(.system(size: geo.size.width * 0.035, weight: .bold))
                            Text(womanFinished ? "تم السعي" : "الأشواط: \(womanRounds)")
                                .font(.system(size: geo.size.width * 0.025))
                        }
                    }

                    // المسار
                    ZStack {

                        // الجبال
                        HStack {
                            Image("mountain")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 0.22)

                            Spacer()

                            Image("mountain")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 0.22)
                        }
                        .padding(.horizontal, trackPadding)

                        // ✅ النور الأخضر في النص
                        Rectangle()
                            .fill(Color.green.opacity(0.5))
                            .frame(width: greenWidth, height: trackHeight * 0.13)
                            .position(
                                x: geo.size.width * 0.5,
                                y: trackHeight * 0.5
                            )

                        // الرجل
                        Image("manWalk")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width * 0.11)
                            .scaleEffect(x: manGoingForward ? 1 : -1)
                            .position(
                                x: trackStartX + (trackWidth * manProgress),
                                y: trackHeight * 0.65
                            )

                        // المرأة
                        Image("womanWalk")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width * 0.11)
                            .scaleEffect(x: womanGoingForward ? 1 : -1)
                            .position(
                                x: trackStartX + (trackWidth * womanProgress),
                                y: trackHeight * 0.80
                            )
                    }
                    .frame(height: trackHeight)

                    // ✅ أزرار التشغيل (Color1 + كتابة بيضاء)
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

                    // أزرار التحريك (تظهر فقط بالعرض)
                    if isLandscape {
                        HStack(spacing: 28) {
                            controlColumn(
                                title: "تحريك الرجل",
                                leftAction: { moveMan(by: -0.05) },
                                rightAction: { moveMan(by: 0.05) }
                            )

                            controlColumn(
                                title: "تحريك المرأة",
                                leftAction: { moveWoman(by: -0.05) },
                                rightAction: { moveWoman(by: 0.05) }
                            )
                        }
                        .padding(.bottom, 6)
                    }
                }
                .foregroundColor(textColor)
            }
            .onReceive(Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()) { _ in
                if manAuto && !manFinished {
                    let inGreen = manProgress > greenStartProgress && manProgress < greenEndProgress
                    moveMan(by: inGreen ? 0.012 : 0.006)
                }

                if womanAuto && !womanFinished {
                    moveWoman(by: 0.003)
                }
            }
        }
    }

    // MARK: - Controls
    private func controlColumn(title: String,
                               leftAction: @escaping () -> Void,
                               rightAction: @escaping () -> Void) -> some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))

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
        }
    }

    // MARK: - Speech
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ar-SA")
        utterance.rate = 0.5
        speaker.speak(utterance)
    }

    // MARK: - Movement
    func moveMan(by amount: CGFloat) {
        manProgress += manGoingForward ? amount : -amount
        if manProgress >= 1 || manProgress <= 0 {
            manProgress = 0
            manGoingForward.toggle()
            manRounds += 1
        }
        if manRounds >= 7 && !manSpoken {
            manFinished = true
            manAuto = false
            speak("تم الانتهاء من السعي للرجل")
            manSpoken = true
        }
    }

    func moveWoman(by amount: CGFloat) {
        womanProgress += womanGoingForward ? amount : -amount
        if womanProgress >= 1 || womanProgress <= 0 {
            womanProgress = 0
            womanGoingForward.toggle()
            womanRounds += 1
        }
        if womanRounds >= 7 && !womanSpoken {
            womanFinished = true
            womanAuto = false
            speak("تم الانتهاء من السعي للمرأة")
            womanSpoken = true
        }
    }
}

#Preview {
    Sai()
}
