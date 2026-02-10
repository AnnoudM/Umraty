//
//  Quiz6-shatha.swift
//  Umraty
//
//  Created by Shatha Ghayath Aljabal  on 03/02/2026.
//

import SwiftUI
import AVFoundation

struct Quiz6View: View {
    // إضافة فحص اتجاه اللغة لإصلاح مشكلة السحب المعكوس
    @Environment(\.layoutDirection) var layoutDirection
    
    @State private var audioPlayer: AVAudioPlayer?
    @State private var talbiyaOffset = CGSize.zero
    @State private var perfumeOffset = CGSize.zero
    @State private var showTalbiya = true
    @State private var showPerfume = true
    @State private var showStar = false
    @State private var starRotation = 0.0
    @State private var starScale = 1.0
    @State private var starPosition: CGPoint = .zero
    @State private var showNextButton = false

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .topTrailing) {
                    
                    Image("background").resizable()
                    Color(red: 0.85, green: 0.93, blue: 0.85).ignoresSafeArea()

                    Image("السؤال السادس").resizable().scaledToFit().frame(width: 90)
                        .padding(.top, 40).padding(.trailing, 30).zIndex(15)

                    // --- قسم النجوم ---
                    ZStack {
                        // النجوم الخمسة السابقة - تم تعديل الارتفاع y إلى 260
                        ForEach(0..<5) { i in
                            Image("star")
                                .frame(width: 250, height: 250).scaleEffect(0.2)
                                .position(x: (geometry.size.width / 2) - 175 + CGFloat(i * 70), y: 260)
                        }
                        
                        // النجمة السادسة (الجديدة)
                        if showStar {
                            Image("star")
                                .frame(width: 250, height: 250)
                                .scaleEffect(starScale).rotationEffect(.degrees(starRotation))
                                .position(starPosition == .zero ? CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2) : starPosition)
                                .onAppear {
                                    playSound(named: "correctanswer")
                                    starPosition = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                    starScale = 2.0
                                    withAnimation(.easeInOut(duration: 2.0)) { starRotation = 360 }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                        withAnimation(.easeInOut(duration: 1.5)) {
                                            // استقرار النجمة السادسة في الصف العلوي عند y: 260
                                            starPosition = CGPoint(x: (geometry.size.width / 2) + 175, y: 260)
                                            starScale = 0.2
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            withAnimation { showNextButton = true }
                                        }
                                    }
                                }
                        }
                    }.zIndex(10)

                    VStack(spacing: 0) {
                        Image("s").resizable().scaledToFit().frame(width: 500).padding(.top, 100)
                        
                        Text("اسحب كل سلوك إلى مكانه الصحيح")
                            .font(.system(size: 30, weight: .bold))
                            .multilineTextAlignment(.center).padding(.top, 200)
                        
                        Spacer()
                        
                        VStack(spacing: 30) {
                            // --- التلبية (سلوك صحيح - يمين) ---
                            if showTalbiya {
                                Text("التلبية وذكر الله")
                                    .font(.title).bold().padding()
                                    .background(Color.white.opacity(0.6)).cornerRadius(15)
                                    .offset(talbiyaOffset)
                                    .gesture(DragGesture()
                                        .onChanged { value in
                                            let multiplier: CGFloat = (layoutDirection == .rightToLeft) ? -1 : 1
                                            talbiyaOffset = CGSize(width: value.translation.width * multiplier, height: value.translation.height)
                                        }
                                        .onEnded { value in
                                            let multiplier: CGFloat = (layoutDirection == .rightToLeft) ? -1 : 1
                                            let horizontalMove = value.translation.width * multiplier
                                            
                                            // التحقق من السحب لجهة اليمين (الصحيح)
                                            if horizontalMove < -100 {
                                                withAnimation { showTalbiya = false }
                                                checkCompletion()
                                            } else {
                                                if horizontalMove > 100 { playSound(named: "incorrectanswer") }
                                                withAnimation(.spring()) { talbiyaOffset = .zero }
                                            }
                                        })
                            }
                            
                            // --- التطيب (سلوك خاطئ - يسار) ---
                            if showPerfume {
                                Text("التطيب بعد الإحرام")
                                    .font(.title).bold().padding()
                                    .background(Color.white.opacity(0.6)).cornerRadius(15)
                                    .offset(perfumeOffset)
                                    .gesture(DragGesture()
                                        .onChanged { value in
                                            let multiplier: CGFloat = (layoutDirection == .rightToLeft) ? -1 : 1
                                            perfumeOffset = CGSize(width: value.translation.width * multiplier, height: value.translation.height)
                                        }
                                        .onEnded { value in
                                            let multiplier: CGFloat = (layoutDirection == .rightToLeft) ? -1 : 1
                                            let horizontalMove = value.translation.width * multiplier
                                            
                                            // التحقق من السحب لجهة اليسار (الخاطئ)
                                            if horizontalMove > 100 {
                                                withAnimation { showPerfume = false }
                                                checkCompletion()
                                            } else {
                                                if horizontalMove < -100 { playSound(named: "incorrectanswer") }
                                                withAnimation(.spring()) { perfumeOffset = .zero }
                                            }
                                        })
                            }
                        }
                        
                        Spacer()
                        
                        HStack {
                            VStack {
                                Image("right").resizable().scaledToFit().frame(width: 200)
                                Text("سلوك صحيح").bold().font(.title2)
                            }
                            Spacer()
                            VStack {
                                Image("wrong").resizable().scaledToFit().frame(width: 200)
                                Text("سلوك خاطئ").bold().font(.title2)
                            }
                        }.padding(.horizontal, 50).padding(.bottom, 50)
                    }

                    if showNextButton {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                // تأكد من وجود Quiz7shathaView في مشروعك
                                NavigationLink(destination: Quiz7shathaView()) {
                                    Text("التالي").font(.system(size: 30, weight: .bold)).foregroundColor(.white)
                                        .padding(.vertical, 15).padding(.horizontal, 40)
                                        .background(Color.orange).cornerRadius(20).shadow(radius: 5)
                                }
                                .padding(.trailing, 50).padding(.bottom, 50)
                            }
                        }
                        .zIndex(15)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    func checkCompletion() {
        if !showTalbiya && !showPerfume {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation { showStar = true }
            }
        }
    }
    
    func playSound(named fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch { print("❌ خطأ صوتي") }
    }
}

#Preview {
    Quiz6View()
}
