//
//  Quiz3-shatha.swift
//  Umraty
//
//  Created by Shatha Ghayath Aljabal  on 03/02/2026.
//

import SwiftUI
import AVFoundation

// MARK: - السؤال الثالث
struct Quiz3shathaView: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showWrongImage = false
    @State private var isInteractionDisabled = false
    
    @State private var showStar = false
    @State private var starRotation = 0.0
    @State private var starScale = 1.0
    @State private var starPosition: CGPoint = .zero
    
    // المتغير المسؤول عن إظهار الزر الذي طلبته
    @State private var showNextButton = false
    
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                
                // 1. الخلفية
                Image("background").resizable()
                Color(red: 0.85, green: 0.93, blue: 0.85)
                    .ignoresSafeArea()

                // 2. صورة السؤال
                Image("السؤال الثالث")
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
                        Image("wave1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.25)
                        Spacer()
                        Image("wave")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.25)
                    }
                }
                .ignoresSafeArea()

                // 4. النجوم
                ZStack {
                    Image("star").resizable().frame(width: 250, height: 250).scaleEffect(0.2)
                        .position(x: (geometry.size.width / 2) - 70, y: 160)
                    Image("star").resizable().frame(width: 250, height: 250).scaleEffect(0.2)
                        .position(x: (geometry.size.width / 2), y: 160)
                    
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
                                        starPosition = CGPoint(x: (geometry.size.width / 2) + 70, y: 160)
                                        starScale = 0.2
                                    }
                                    // إظهار زر "التالي" البرتقالي بعد انتهاء حركة النجمة
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        withAnimation { showNextButton = true }
                                    }
                                }
                            }
                    }
                }
                .zIndex(10)

                // 5. المحتوى الرئيسي
                VStack(spacing: 0) {
                    Image("s").resizable().scaledToFit().frame(width: 400).padding(.top, 30)
                    Spacer()
                    VStack(spacing: 40) {
                        Text("ماذا نكرر كثيرا في طريقنا إلى الكعبة؟")
                            .font(.system(size: 26, weight: .bold))
                            .multilineTextAlignment(.center).padding(.horizontal, 30)
                        
                        LazyVGrid(columns: columns, spacing: 20) {
                            Quiz3Button(text: "السلام", isCorrect: false, action: checkAnswer)
                            Quiz3Button(text: "التلبية", isCorrect: true, action: checkAnswer)
                            Quiz3Button(text: "الأذان", isCorrect: false, action: checkAnswer)
                            Quiz3Button(text: "التشهد", isCorrect: false, action: checkAnswer)
                        }
                        .padding(.horizontal, geometry.size.width * 0.08)
                        .disabled(isInteractionDisabled)
                    }
                    Spacer()
                    Color.clear.frame(height: geometry.size.height * 0.1)
                }

                // 6. إضافة زر "التالي" البرتقالي الذي طلبته
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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

// MARK: - السؤال الرابع (كما هو بدون تغيير)
struct Quiz4shathaView: View {
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
                Image("السؤال الرابع").resizable().scaledToFit().frame(width: 90).padding(.top, 40).padding(.trailing, 30)
                
                // (بقية كود السؤال الرابع الذي أرفقته سابقاً...)
                Text("شاشة السؤال الرابع").position(x: geometry.size.width/2, y: geometry.size.height/2)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - المكونات المشتركة
struct Quiz3Button: View {
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
                .cornerRadius(20).shadow(radius: 5)
        }
    }
}

#Preview {
    NavigationStack {
        Quiz3shathaView()
    }
}
