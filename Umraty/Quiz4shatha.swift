//
//  Quiz4-shatha.swift
//  Umraty
//
//  Created by Shatha Ghayath Aljabal  on 03/02/2026.
//

import SwiftUI
import AVFoundation

// MARK: - السؤال الرابع
struct Quiz4View: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showWrongImage = false
    @State private var isInteractionDisabled = false
    @State private var showStar = false
    @State private var starRotation = 0.0
    @State private var starScale = 1.0
    @State private var starPosition: CGPoint = .zero
    
    // متغير لإظهار زر التالي بعد الإجابة الصحيحة
    @State private var showNextButton = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                
                // 1. الخلفية
                Image("background").resizable()
                Color(red: 0.85, green: 0.93, blue: 0.85).ignoresSafeArea()

                // 2. صورة رقم السؤال
                Image("السؤال الرابع")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90)
                    .padding(.top, 40)
                    .padding(.trailing, 30)
                    .zIndex(5)

                // 3. الأمواج
                VStack {
                    Spacer()
                    HStack(alignment: .bottom) {
                        Image("wave1").resizable().scaledToFit().frame(width: geometry.size.width * 0.25)
                        Spacer()
                        Image("wave").resizable().scaledToFit().frame(width: geometry.size.width * 0.25)
                    }
                }.ignoresSafeArea()

                // 4. حاوية النجوم
                ZStack {
                    Image("star").resizable().frame(width: 250, height: 250).scaleEffect(0.2)
                        .position(x: (geometry.size.width / 2) - 105, y: 160)
                    Image("star").resizable().frame(width: 250, height: 250).scaleEffect(0.2)
                        .position(x: (geometry.size.width / 2) - 35, y: 160)
                    Image("star").resizable().frame(width: 250, height: 250).scaleEffect(0.2)
                        .position(x: (geometry.size.width / 2) + 35, y: 160)
                    
                    if showStar {
                        Image("star")
                            .resizable()
                            .frame(width: 250, height: 250)
                            .scaleEffect(starScale)
                            .rotationEffect(.degrees(starRotation))
                            .position(starPosition == .zero ? CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2) : starPosition)
                            .onAppear {
                                starPosition = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                starScale = 2.0
                                withAnimation(.easeInOut(duration: 2.0)) { starRotation = 360 }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    withAnimation(.easeInOut(duration: 1.5)) {
                                        starPosition = CGPoint(x: (geometry.size.width / 2) + 105, y: 160)
                                        starScale = 0.2
                                    }
                                    // إظهار زر التالي بعد استقرار النجمة
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        withAnimation { showNextButton = true }
                                    }
                                }
                            }
                    }
                }.zIndex(10)

                // 5. المحتوى الرئيسي
                VStack(spacing: 0) {
                    Image("s").resizable().scaledToFit().frame(width: 400)
                        .padding(.top, geometry.safeAreaInsets.top > 0 ? 10 : 30)
                    Spacer()
                    VStack(spacing: 40) {
                        Text("ماذا يلبس الرجل في العمرة؟")
                            .font(.system(size: 32, weight: .bold)).foregroundColor(.black)
                        HStack(spacing: 60) {
                            Button(action: { checkAnswer(isCorrect: false) }) {
                                Image("no").resizable().scaledToFit().frame(width: 300, height: 300)
                                    .background(Color.white.opacity(0.3)).cornerRadius(25)
                            }
                            Button(action: { checkAnswer(isCorrect: true) }) {
                                Image("yes").resizable().scaledToFit().frame(width: 300, height: 300)
                                    .background(Color.white.opacity(0.3)).cornerRadius(25)
                            }
                        }.disabled(isInteractionDisabled)
                    }
                    Spacer()
                    Color.clear.frame(height: geometry.size.height * 0.15)
                }

                // 6. الزر البرتقالي للانتقال للسؤال الخامس
                if showNextButton {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            NavigationLink(destination: Quiz4View()) { // يوجه إلى شاشتك الأصلية
                                Text("التالي")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.vertical, 15)
                                    .padding(.horizontal, 40)
                                    .background(Color.orange)
                                    .cornerRadius(20)
                                    .shadow(radius: 5)
                            }
                            .padding(.trailing, 50).padding(.bottom, 50)
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(15)
                }

                if showWrongImage {
                    Image("wrong").resizable().scaledToFit().frame(width: 500, height: 500)
                        .zIndex(20).position(x: geometry.size.width / 2, y: geometry.size.height / 2)
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
                withAnimation { showWrongImage = false; isInteractionDisabled = false }
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

// MARK: - السؤال الخامس
struct Quiz5shathaView: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showWrongImage = false
    @State private var isInteractionDisabled = false
    @State private var showStar = false
    @State private var starRotation = 0.0
    @State private var starScale = 1.0
    @State private var starPosition: CGPoint = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                
                Image("background").resizable()
                Color(red: 0.85, green: 0.93, blue: 0.85).ignoresSafeArea()

                Image("السؤال الخامس")
                    .resizable().scaledToFit().frame(width: 90)
                    .padding(.top, 40).padding(.trailing, 30).zIndex(5)

                VStack {
                    Spacer()
                    HStack(alignment: .bottom) {
                        Image("wave1").resizable().scaledToFit().frame(width: geometry.size.width * 0.25)
                        Spacer()
                        Image("wave").resizable().scaledToFit().frame(width: geometry.size.width * 0.25)
                    }
                }.ignoresSafeArea()

                ZStack {
                    // النجوم الأربعة السابقة ثابتة
                    ForEach(0..<4) { i in
                        Image("star").resizable().frame(width: 250, height: 250).scaleEffect(0.2)
                            .position(x: (geometry.size.width / 2) + CGFloat((i - 2) * 70) + 35, y: 160)
                    }
                    
                    if showStar {
                        Image("star")
                            .resizable()
                            .frame(width: 250, height: 250)
                            .scaleEffect(starScale)
                            .rotationEffect(.degrees(starRotation))
                            .position(starPosition == .zero ? CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2) : starPosition)
                            .onAppear {
                                starPosition = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                starScale = 2.0
                                withAnimation(.easeInOut(duration: 2.0)) { starRotation = 360 }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    withAnimation(.easeInOut(duration: 1.5)) {
                                        starPosition = CGPoint(x: (geometry.size.width / 2) + 140, y: 160)
                                        starScale = 0.2
                                    }
                                }
                            }
                    }
                }.zIndex(10)

                VStack(spacing: 0) {
                    Image("s").resizable().scaledToFit().frame(width: 400)
                        .padding(.top, geometry.safeAreaInsets.top > 0 ? 10 : 30)
                    Spacer()
                    VStack(spacing: 40) {
                        Text("ماذا تلبس المرأة في العمرة؟")
                            .font(.system(size: 32, weight: .bold)).foregroundColor(.black)
                        HStack(spacing: 60) {
                            Button(action: { checkAnswer(isCorrect: false) }) {
                                Image("no1").resizable().scaledToFit().frame(width: 300, height: 300)
                                    .background(Color.white.opacity(0.3)).cornerRadius(25)
                            }
                            Button(action: { checkAnswer(isCorrect: true) }) {
                                Image("yes1").resizable().scaledToFit().frame(width: 300, height: 300)
                                    .background(Color.white.opacity(0.3)).cornerRadius(25)
                            }
                        }.disabled(isInteractionDisabled)
                    }
                    Spacer()
                    Color.clear.frame(height: geometry.size.height * 0.15)
                }

                if showWrongImage {
                    Image("wrong").resizable().scaledToFit().frame(width: 500, height: 500)
                        .zIndex(20).position(x: geometry.size.width / 2, y: geometry.size.height / 2)
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
                withAnimation { showWrongImage = false; isInteractionDisabled = false }
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

// MARK: - المعاينة
#Preview {
    NavigationStack {
        Quiz4View()
    }
}
