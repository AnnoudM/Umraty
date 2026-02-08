//
//  Quiz6-shatha.swift
//  Umraty
//
//  Created by Shatha Ghayath Aljabal  on 03/02/2026.
//

import SwiftUI
import AVFoundation

struct Quiz6View: View {
    // 1. مشغل الصوت وجلسة الصوت
    @State private var audioPlayer: AVAudioPlayer?
    
    // إحداثيات السحب للعناصر
    @State private var talbiyaOffset = CGSize.zero
    @State private var perfumeOffset = CGSize.zero
    
    // حالات التحكم في ظهور العناصر
    @State private var showTalbiya = true
    @State private var showPerfume = true
    @State private var showStar = false
    
    // متغيرات أنيميشن النجمة السادسة
    @State private var starRotation = 0.0
    @State private var starScale = 1.0
    @State private var starPosition: CGPoint = .zero
    
    // حالة ظهور زر الانتقال
    @State private var showNextButton = false

    var body: some View {
        NavigationStack { // لتمكين الانتقال للسؤال التالي
            GeometryReader { geometry in
                ZStack(alignment: .topTrailing) {
                    
                    // 1. الخلفية الأساسية
                    Image("background").resizable()
                    Color(red: 0.85, green: 0.93, blue: 0.85)
                        .ignoresSafeArea()

                    // 2. صورة "السؤال السادس"
                    Image("السؤال السادس")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90)
                        .padding(.top, 40)
                        .padding(.trailing, 30)
                        .zIndex(15)

                    // 3. عرض النجوم (5 ثابتة + النجمة السادسة المتحركة)
                    ZStack {
                        ForEach(0..<5) { i in
                            Image("star")
                                .resizable()
                                .frame(width: 250, height: 250)
                                .scaleEffect(0.2)
                                .position(x: (geometry.size.width / 2) - 175 + CGFloat(i * 70), y: 160)
                        }
                        
                        if showStar {
                            Image("star")
                                .resizable()
                                .frame(width: 250, height: 250)
                                .scaleEffect(starScale)
                                .rotationEffect(.degrees(starRotation))
                                .position(starPosition == .zero ? CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2) : starPosition)
                                .onAppear {
                                    playSound(named: "correctanswer")
                                    starPosition = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                    starScale = 2.0
                                    withAnimation(.easeInOut(duration: 2.0)) { starRotation = 360 }
                                    
                                    // توقيت حركة الاستقرار وظهور زر التالي
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                        withAnimation(.easeInOut(duration: 1.5)) {
                                            starPosition = CGPoint(x: (geometry.size.width / 2) + 175, y: 160)
                                            starScale = 0.2
                                        }
                                        // يظهر زر التالي بعد استقرار النجمة تماماً
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            withAnimation { showNextButton = true }
                                        }
                                    }
                                }
                        }
                    }
                    .zIndex(10)

                    // 4. المحتوى الرئيسي
                    VStack(spacing: 0) {
                        Image("s").resizable().scaledToFit().frame(width: 400).padding(.top, 30)
                        
                        Text("اسحب كل سلوك إلى مكانه الصحيح")
                            .font(.system(size: 32, weight: .bold))
                            .multilineTextAlignment(.center)
                            .padding(.top, 100)
                        
                        Spacer()
                        
                        VStack(spacing: 30) {
                            if showTalbiya {
                                Text("التلبية وذكر الله")
                                    .font(.title).bold().padding()
                                    .background(Color.white.opacity(0.6)).cornerRadius(15)
                                    .offset(talbiyaOffset)
                                    .gesture(DragGesture()
                                        .onChanged { talbiyaOffset = $0.translation }
                                        .onEnded { value in
                                            if value.translation.width < -100 && value.translation.height > 100 {
                                                withAnimation { showTalbiya = false }
                                                checkCompletion()
                                            } else {
                                                if value.translation.width > 100 && value.translation.height > 100 { playSound(named: "incorrectanswer") }
                                                withAnimation(.spring()) { talbiyaOffset = .zero }
                                            }
                                        })
                            }
                            
                            if showPerfume {
                                Text("التطيب بعد الإحرام")
                                    .font(.title).bold().padding()
                                    .background(Color.white.opacity(0.6)).cornerRadius(15)
                                    .offset(perfumeOffset)
                                    .gesture(DragGesture()
                                        .onChanged { perfumeOffset = $0.translation }
                                        .onEnded { value in
                                            if value.translation.width > 100 && value.translation.height > 100 {
                                                withAnimation { showPerfume = false }
                                                checkCompletion()
                                            } else {
                                                if value.translation.width < -100 && value.translation.height > 100 { playSound(named: "incorrectanswer") }
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

                    // 5. زر الانتقال (يظهر بعد حل السؤال)
                    if showNextButton {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                NavigationLink(destination: Quiz7View()) {
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
        } catch { print("❌ خطأ صوني") }
    }
}

// MARK: - Preview
#Preview {
    Quiz6View()
}
