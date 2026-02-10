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
    @State private var showNextButton = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                Image("background").resizable()
                Color(red: 0.85, green: 0.93, blue: 0.85).ignoresSafeArea()

                Image("السؤال الرابع")
                    .resizable().scaledToFit().frame(width: 90)
                    .padding(.top, 40).padding(.trailing, 30).zIndex(5)

                VStack {
                    Spacer()
                    HStack(alignment: .bottom) {
                        Image("wave").resizable().scaledToFit().frame(width: geometry.size.width * 0.25)
                        Spacer()
                        Image("wave1").resizable().scaledToFit().frame(width: geometry.size.width * 0.25)
                    }
                }.ignoresSafeArea()

                // النجوم
                ZStack {
                    Image("star")
                        .frame(width: 250, height: 250).scaleEffect(0.2).position(x: (geometry.size.width / 2) - 105, y: 260)
                    Image("star")
                        .frame(width: 250, height: 250).scaleEffect(0.2).position(x: (geometry.size.width / 2) - 35, y: 260)
                    Image("star")
                        .frame(width: 250, height: 250).scaleEffect(0.2).position(x: (geometry.size.width / 2) + 35, y: 260)
                    
                    if showStar {
                        Image("star")
                            .frame(width: 250, height: 250)
                            .scaleEffect(starScale).rotationEffect(.degrees(starRotation))
                            .position(starPosition == .zero ? CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2) : starPosition)
                            .onAppear {
                                starPosition = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                starScale = 2.0
                                withAnimation(.easeInOut(duration: 2.0)) { starRotation = 360 }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    withAnimation(.easeInOut(duration: 1.5)) {
                                        starPosition = CGPoint(x: (geometry.size.width / 2) + 105, y: 260); starScale = 0.2
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { withAnimation { showNextButton = true } }
                                }
                            }
                    }
                }.zIndex(10)

                // --- التعديل هنا لتوسيط المحتوى ---
                VStack(spacing: 0) {
                    Image("s").resizable().scaledToFit().frame(width: 450)
                        .padding(.top, 60)
                    
                    Spacer() // يوزع المساحة لرفع النص والصور للمنتصف
                    
                    VStack(spacing: 40) {
                        Text("ماذا يلبس الرجل في العمرة؟")
                            .font(.system(size: 35, weight: .bold))
                        
                        HStack(spacing: 60) {
                            Button(action: { checkAnswer(isCorrect: false) }) {
                                Image("no").resizable().scaledToFit().frame(width: 400, height: 400)
                                    .background(Color.white.opacity(0.3)).cornerRadius(25)
                            }
                            Button(action: { checkAnswer(isCorrect: true) }) {
                                Image("yes").resizable().scaledToFit().frame(width:400, height: 400)
                                    .background(Color.white.opacity(0.3)).cornerRadius(25)
                            }
                        }.disabled(isInteractionDisabled)
                    }
                    
                    Spacer() // دفع إضافي من الأسفل
                    Spacer()
                }.frame(maxWidth: .infinity)

                if showNextButton {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            NavigationLink(destination: Quiz5View()) {
                                Text("التالي").font(.system(size: 30, weight: .bold)).foregroundColor(.white)
                                    .padding(.vertical, 15).padding(.horizontal, 40)
                                    .background(Color.orange).cornerRadius(20).shadow(radius: 5)
                            }
                            .padding(.trailing, 50).padding(.bottom, 50)
                        }
                    }.zIndex(15).transition(.move(edge: .bottom).combined(with: .opacity))
                }

                if showWrongImage {
                    Image("wrong").resizable().scaledToFit().frame(width: 500, height: 500)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2).zIndex(20)
                }
            }
        }.navigationBarBackButtonHidden(true)
    }

    func checkAnswer(isCorrect: Bool) {
        isInteractionDisabled = true
        if isCorrect { playSound(named: "correctanswer"); withAnimation { showStar = true } }
        else {
            playSound(named: "incorrectanswer"); withAnimation(.spring()) { showWrongImage = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { withAnimation { showWrongImage = false; isInteractionDisabled = false } }
        }
    }

    func playSound(named fileName: String) {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
            audioPlayer = try? AVAudioPlayer(contentsOf: url); audioPlayer?.play()
        }
    }
}
// MARK: - المعاينة
#Preview {
    NavigationStack {
        Quiz4View()
    }
}
