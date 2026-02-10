//
//  Quiz5-shatha.swift
//  Umraty
//
//  Created by Shatha Ghayath Aljabal  on 03/02/2026.
//

import SwiftUI
import AVFoundation

// MARK: - السؤال الخامس
struct Quiz5View: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showWrongImage = false
    @State private var isInteractionDisabled = false

    @State private var showStar = false
    @State private var starRotation = 0.0
    @State private var starScale = 1.0
    @State private var starPosition: CGPoint = .zero

    @State private var showNextButton = false

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {

                // ✅ الخلفية (نفس Quiz2/3/4)
                Color(red: 0.85, green: 0.93, blue: 0.85)
                    .ignoresSafeArea()

                Image("background")
                    .resizable()
                    .opacity(0.2)
                    .ignoresSafeArea()

                // رقم السؤال
                Image("السؤال الخامس")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90)
                    .padding(.top, 40)
                    .padding(.trailing, 30)
                    .zIndex(5)

                // الأمواج
                VStack {
                    Spacer()
                    HStack(alignment: .bottom) {
                        Image("wave")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.25)
                        Spacer()
                        Image("wave1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.25)
                    }
                }
                .ignoresSafeArea()

                // ✅ النجوم (رفعناها شوي عشان ما تخرب على السؤال)
                ZStack {
                    Image("star")
                        .frame(width: 250, height: 250)
                        .scaleEffect(0.2)
                        .position(x: (geometry.size.width / 2) - 140, y: 235)

                    Image("star")
                        .frame(width: 250, height: 250)
                        .scaleEffect(0.2)
                        .position(x: (geometry.size.width / 2) - 70, y: 235)

                    Image("star")
                        .frame(width: 250, height: 250)
                        .scaleEffect(0.2)
                        .position(x: (geometry.size.width / 2), y: 235)

                    Image("star")
                        .frame(width: 250, height: 250)
                        .scaleEffect(0.2)
                        .position(x: (geometry.size.width / 2) + 70, y: 235)

                    if showStar {
                        Image("star")
                            .frame(width: 250, height: 250)
                            .scaleEffect(starScale)
                            .rotationEffect(.degrees(starRotation))
                            .position(
                                starPosition == .zero
                                ? CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                : starPosition
                            )
                            .onAppear {
                                starPosition = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                starScale = 2.0

                                withAnimation(.easeInOut(duration: 2.0)) {
                                    starRotation = 360
                                }

                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    withAnimation(.easeInOut(duration: 1.5)) {
                                        starPosition = CGPoint(x: (geometry.size.width / 2) + 140, y: 235)
                                        starScale = 0.2
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                        withAnimation { showNextButton = true }
                                    }
                                }
                            }
                    }
                }
                .zIndex(10)

                // ✅ المحتوى الرئيسي مرتب
                VStack(spacing: 0) {
                    Image("s")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 500)
                        .padding(.top, 100) // ✅ نفس ستايل الصفحات اللي قبل

                    Spacer()

                    VStack(spacing: 30) {
                        Text("ماذا تلبس المرأة في العمرة؟")
                            .font(.system(size: 35, weight: .bold))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)

                        HStack(spacing: 60) {
                            Button(action: { checkAnswer(isCorrect: false) }) {
                                Image("no1")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 320, height: 320)
                                    .background(Color.white.opacity(0.3))
                                    .cornerRadius(25)
                            }

                            Button(action: { checkAnswer(isCorrect: true) }) {
                                Image("yes1")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 320, height: 320)
                                    .background(Color.white.opacity(0.3))
                                    .cornerRadius(25)
                            }
                        }
                        .disabled(isInteractionDisabled)
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity)

                // ✅ زر التالي بالنص تحت + Color1
                if showNextButton {
                    VStack {
                        Spacer()

                        NavigationLink(destination: Quiz6View()) {
                            Text("التالي")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 60)
                                .background(Color("Color1"))
                                .cornerRadius(20)
                                .shadow(radius: 5)
                        }
                        .padding(.bottom, 50)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(15)
                }

                // صورة الخطأ
                if showWrongImage {
                    Image("wrong")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 500, height: 500)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        .zIndex(20)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    func checkAnswer(isCorrect: Bool) {
        isInteractionDisabled = true
        if isCorrect {
            playSound(named: "correctanswer")
            withAnimation { showStar = true }
        } else {
            playSound(named: "incorrectanswer")
            withAnimation(.spring()) { showWrongImage = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation {
                    showWrongImage = false
                    isInteractionDisabled = false
                }
            }
        }
    }

    func playSound(named fileName: String) {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
            audioPlayer = try? AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        Quiz5View()
    }
}
