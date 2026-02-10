//
//  Quiz1-shatha.swift
//  Umraty
//
//  Created by Shatha Ghayath Aljabal  on 02/02/2026.

import SwiftUI
import AVFoundation

// MARK: - 1. مدير الصوت
class QuizSoundManager {
    static let instance = QuizSoundManager()
    var player: AVAudioPlayer?

    func playCorrect() { playSound(name: "correctanswer") }
    func playIncorrect() { playSound(name: "incorrectanswer") }

    private func playSound(name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player?.play()
        } catch { print("❌ Sound Error") }
    }
}

// MARK: - 2. الواجهة الرئيسية للسؤال الأول
struct Quiz1_shatha: View {
    @Environment(\.layoutDirection) var layoutDirection
    
    @State private var scissorsOffset = CGSize.zero
    @State private var perfumeOffset = CGSize.zero
    @State private var nailClipperOffset = CGSize.zero
    
    @State private var showScissors = true
    @State private var showPerfume = true
    @State private var showNailClipper = true
    
    @State private var showStar = false
    @State private var starRotation = 0.0
    @State private var starScale = 1.0
    @State private var starPosition: CGPoint = .zero
    
    // متغير التحكم في زر التالي
    @State private var showNextButton = false
    
    var body: some View {
        NavigationStack { // أضفنا NavigationStack للتمكن من الانتقال
            GeometryReader { geometry in
                ZStack(alignment: .topTrailing) {
                    
                    // 1. الخلفية
                    Color(red: 0.85, green: 0.93, blue: 0.85)
                        .ignoresSafeArea()
                    
                    // 2. المحتوى الرئيسي
                    VStack(spacing: 0) {
                        Image("s")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 500)
                            .padding(.top, 100)
                        
                        Text("ضع العناصر في أماكنها الصحيحة")
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.top, 120)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    
                    // 3. منطقة اللعب
                    HStack {
                        VStack(spacing: 70) {
                            Image("الولد بدون احرام").resizable().frame(width: 240, height: 330)
                            Image("boy").resizable().frame(width: 150, height: 310)
                        }
                        .padding(.leading, 50)
                        
                        Spacer()
                        
                        VStack(spacing: 80) {
                            if showScissors {
                                dragImage(name: "scissors", offset: $scissorsOffset, width: 150, height: 150) { value in
                                    let horizontalMove = value.translation.width * (layoutDirection == .rightToLeft ? -1 : 1)
                                    if horizontalMove < -200 && value.translation.height > 100 {
                                        withAnimation { showScissors = false }
                                        checkFinalState()
                                    } else { returnToOriginal(offset: $scissorsOffset) }
                                }
                            }
                            
                            if showPerfume {
                                dragImage(name: "perfume", offset: $perfumeOffset, width: 130, height: 130) { value in
                                    let horizontalMove = value.translation.width * (layoutDirection == .rightToLeft ? -1 : 1)
                                    if horizontalMove < -200 && value.translation.height < 50 {
                                        withAnimation { showPerfume = false }
                                        checkFinalState()
                                    } else { returnToOriginal(offset: $perfumeOffset) }
                                }
                            }
                            
                            if showNailClipper {
                                dragImage(name: "nailclipper", offset: $nailClipperOffset, width: 180, height: 180) { value in
                                    let horizontalMove = value.translation.width * (layoutDirection == .rightToLeft ? -1 : 1)
                                    if horizontalMove < -200 && value.translation.height < -100 {
                                        withAnimation { showNailClipper = false }
                                        checkFinalState()
                                    } else { returnToOriginal(offset: $nailClipperOffset) }
                                }
                            }
                        }
                        .padding(.trailing, 40)
                    }
                    .frame(maxHeight: .infinity)
                    
                    // 4. تأثير النجمة
                    if showStar {
                        starAnimationView(geometry: geometry)
                    }
                    
                    // 5. زر التالي (يظهر في الزاوية اليمين تحت)
                    if showNextButton {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                NavigationLink(destination: Quiz2View()) {
                                    Text("التالي")
                                        .font(.system(size: 30, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.vertical, 15)
                                        .padding(.horizontal, 40)
                                        .background(Color.orange)
                                        .cornerRadius(20)
                                        .shadow(radius: 5)
                                }
                                .padding(.trailing, 50)
                                .padding(.bottom, 50)
                            }
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .zIndex(20)
                    }
                }
            }
            .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - الدوال المساعدة
    func dragImage(name: String, offset: Binding<CGSize>, width: CGFloat, height: CGFloat, onEnded: @escaping (DragGesture.Value) -> Void) -> some View {
        let multiplier: CGFloat = (layoutDirection == .rightToLeft) ? -1 : 1
        return Image(name)
            .resizable()
            .frame(width: width, height: height)
            .offset(x: offset.wrappedValue.width, y: offset.wrappedValue.height)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offset.wrappedValue = CGSize(
                            width: value.translation.width * multiplier,
                            height: value.translation.height
                        )
                    }
                    .onEnded(onEnded)
            )
    }
    
    func returnToOriginal(offset: Binding<CGSize>) {
        QuizSoundManager.instance.playIncorrect()
        withAnimation(.spring()) { offset.wrappedValue = .zero }
    }
    
    func checkFinalState() {
        if !showScissors && !showPerfume && !showNailClipper {
            withAnimation(.spring()) { showStar = true }
        }
    }
    
    @ViewBuilder
        func starAnimationView(geometry: GeometryProxy) -> some View {
            Image("star")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .scaleEffect(starScale)
                .rotationEffect(.degrees(starRotation))
                .position(starPosition == .zero ? CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2) : starPosition)
                .onAppear {
                    QuizSoundManager.instance.playCorrect()
                    starPosition = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    
                    // حركة الدوران والتكبير الابتدائي (تظهر كبيرة في المنتصف)
                    withAnimation(.easeInOut(duration: 2.0)) {
                        starRotation = 360
                        starScale = 2.0
                    }
                    
                    // توقيت حركة النجمة للاستقرار في الوسط العلوي
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation(.easeInOut(duration: 1.5)) {
                            // التعديل هنا: جعلنا x في المنتصف تماماً و y مرتفعة قليلاً
                            starPosition = CGPoint(x: geometry.size.width / 2, y: 260)
                            starScale = 0.4
                        }
                        
                        // إظهار زر التالي بعد استقرار النجمة
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                showNextButton = true
                            }
                        }
                    }
                }
                .zIndex(10)
        }
}
#Preview {
    Quiz1_shatha()
}
