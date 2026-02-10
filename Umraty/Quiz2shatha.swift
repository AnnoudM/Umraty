//
//  Quiz2-shatha.swift
//  Umraty
//
//  Created by Shatha Ghayath Aljabal  on 03/02/2026.
//

import SwiftUI
import AVFoundation

// MARK: - 1. السؤال الثاني
struct Quiz2View: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showWrongImage = false
    @State private var isInteractionDisabled = false

    @State private var showStar = false
    @State private var starRotation = 0.0
    @State private var starScale = 1.0
    @State private var starPosition: CGPoint = .zero

    @State private var showNextButton = false

    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {

                Color(red: 0.85, green: 0.93, blue: 0.85)
                    .ignoresSafeArea()

                Image("background")
                    .resizable()
                    .opacity(0.2)
                    .ignoresSafeArea()

                Image("السؤال الثاني")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90)
                    .padding(.top, 40)
                    .padding(.trailing, 30)
                    .zIndex(5)

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

                // نظام النجوم
                ZStack {
                    // نجمة السؤال الأول (ثابتة)
                    Image("star")
                        .frame(width: 250, height: 250)
                        .scaleEffect(0.2)
                        .position(x: (geometry.size.width / 2) - 35, y: 260)

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
                                        starPosition = CGPoint(x: (geometry.size.width / 2) + 35, y: 260)
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

                VStack(spacing: 0) {
                    Image("s")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 500)
                        .padding(.top, 100)

                    Spacer()

                    VStack(spacing: 50) {
                        Text("كم عدد أشواط الطواف حول الكعبة؟")
                            .font(.system(size: 30, weight: .bold))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)

                        LazyVGrid(columns: columns, spacing: 20) {
                            QuizOptionButton(text: "٥ أشواط", isCorrect: false, action: checkAnswer)
                            QuizOptionButton(text: "٦ أشواط", isCorrect: false, action: checkAnswer)
                            QuizOptionButton(text: "٨ أشواط", isCorrect: false, action: checkAnswer)
                            QuizOptionButton(text: "٧ أشواط", isCorrect: true, action: checkAnswer)
                        }
                        .padding(.horizontal, geometry.size.width * 0.05)
                        .disabled(isInteractionDisabled)
                    }

                    Spacer()
                    Spacer()
                }

                // ✅ زر التالي (ينقل إلى Quiz3View) — ملف مستقل
                if showNextButton {
                    VStack {
                        Spacer()

                        NavigationLink(destination: Quiz3View()) {
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

                if showWrongImage {
                    Image("wrong")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 500, height: 500)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        .zIndex(2)
                }
            }
        }
        .navigationBarHidden(true)
    }

    func checkAnswer(isCorrect: Bool) {
        isInteractionDisabled = true
        if isCorrect {
            runSound(named: "correctanswer")
            withAnimation { showStar = true }
        } else {
            runSound(named: "incorrectanswer")
            withAnimation(.spring()) { showWrongImage = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation {
                    showWrongImage = false
                    isInteractionDisabled = false
                }
            }
        }
    }

    func runSound(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.play()
    }
}

// MARK: - الأزرار (Components)
struct QuizOptionButton: View {
    let text: String
    let isCorrect: Bool
    let action: (Bool) -> Void

    var body: some View {
        Button(action: { action(isCorrect) }) {
            Text(text)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color(red: 0.92, green: 0.72, blue: 0.64))
                .cornerRadius(20)
                .shadow(radius: 5)
        }
    }
}

#Preview {
    NavigationStack {
        Quiz2View()
    }
}
