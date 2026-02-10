//
//  Quiz3-shatha.swift
//  Umraty
//
//  Created by Shatha Ghayath Aljabal  on 03/02/2026.
//

import SwiftUI
import AVFoundation

// MARK: - السؤال الثالث
struct Quiz3View: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showWrongImage = false
    @State private var isInteractionDisabled = false
    
    // متغيرات النجمة
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
                
                // 1. الخلفية
                Color(red: 0.85, green: 0.93, blue: 0.85)
                    .ignoresSafeArea()
                Image("background").resizable().ignoresSafeArea()

                // 2. رقم السؤال
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

                // 4. النجوم والأنيميشن
                ZStack {
                    // نجوم ثابتة من الأسئلة السابقة
                    Image("star")
                        .frame(width: 250, height: 250).scaleEffect(0.2)
                        .position(x: (geometry.size.width / 2) - 70, y: 260)
                    Image("star")
                        .frame(width: 250, height: 250).scaleEffect(0.2)
                        .position(x: (geometry.size.width / 2), y: 260)
                    
                    if showStar {
                        Image("star")
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
                                        starPosition = CGPoint(x: (geometry.size.width / 2) + 70, y: 260)
                                        starScale = 0.2
                                    }
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
                    Image("s").resizable().scaledToFit().frame(width: 500).padding(.top, 100)
                    Spacer()
                    VStack(spacing: 40) {
                        Text("ماذا نكرر كثيرا في طريقنا إلى الكعبة؟")
                            .font(.system(size: 30, weight: .bold))
                            .multilineTextAlignment(.center).padding(.horizontal, 30)
                        
                        // هنا تم تعديل الأزرار لحل المشكلة التي واجهتِك
                        LazyVGrid(columns: columns, spacing: 20) {
                            Quiz3Button(text: "السلام") { checkAnswer(isCorrect: false) }
                            Quiz3Button(text: "التلبية") { checkAnswer(isCorrect: true) }
                            Quiz3Button(text: "الأذان") { checkAnswer(isCorrect: false) }
                            Quiz3Button(text: "التشهد") { checkAnswer(isCorrect: false) }
                        }
                        .padding(.horizontal, geometry.size.width * 0.05)
                        .disabled(isInteractionDisabled)
                    }
                    Spacer()
                    Spacer()
                }

                // 6. زر التالي (ينقل لـ Quiz4View)
                if showNextButton {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            NavigationLink(destination: Quiz4View()) {
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
    
    // دالة التحقق من الإجابة
    func checkAnswer(isCorrect: Bool) {
        isInteractionDisabled = true
        if isCorrect {
            playSound(named: "correctanswer")
            withAnimation { showStar = true }
        } else {
            playSound(named: "incorrectanswer")
            withAnimation(.spring()) { showWrongImage = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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

// MARK: - مكون الزر (تم تصحيحه)
struct Quiz3Button: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
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

// المعاينة
#Preview {
    NavigationStack {
        Quiz3shatha()
    }
}
