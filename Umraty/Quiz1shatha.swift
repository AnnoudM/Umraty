//
//  Quiz1-shatha.swift
//  Umraty
//
//  Created by Shatha Ghayath Aljabal  on 02/02/2026.

import SwiftUI
import AVFoundation

// MARK: - 1. مدير الصوت العام
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

// MARK: - 2. شاشة السؤال الأول (Quiz1_shatha)
struct Quiz1_shatha: View {
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
    @State private var showNextButton = false // لظهور زر التالي

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                Image("background").resizable()
                Color(red: 0.85, green: 0.93, blue: 0.85)
                    .ignoresSafeArea()

                Image("السؤال الأول").resizable().scaledToFit().frame(width: 100)
                    .padding(.top, 40).padding(.trailing, 30).zIndex(5)

                VStack(spacing: 0) {
                    Image("s").resizable().scaledToFit().frame(width: 380).padding(.top, 50)
                    Text("ضع العناصر في أماكنها الصحيحة")
                        .font(.system(size: 40, weight: .bold)).padding(.top, 80)
                    Spacer()
                }.frame(maxWidth: .infinity)

                HStack {
                    VStack(spacing: 70) {
                        Image("boy").resizable().frame(width: 130, height: 300)
                        Image("boy2").resizable().frame(width: 130, height: 300)
                    }.padding(.leading, 50)
                    Spacer()
                    VStack(spacing: 20) {
                        if showScissors {
                            dragImage(name: "scissors", offset: $scissorsOffset, width: 150, height: 150) { value in
                                if value.translation.width < -200 && value.translation.height > 100 {
                                    withAnimation { showScissors = false }; checkFinalState()
                                } else { returnToOriginal(offset: $scissorsOffset) }
                            }
                        }
                        if showPerfume {
                            dragImage(name: "perfume", offset: $perfumeOffset, width: 130, height: 130) { value in
                                if value.translation.width < -200 && value.translation.height < 50 {
                                    withAnimation { showPerfume = false }; checkFinalState()
                                } else { returnToOriginal(offset: $perfumeOffset) }
                            }
                        }
                        if showNailClipper {
                            dragImage(name: "nailclipper", offset: $nailClipperOffset, width: 180, height: 180) { value in
                                if value.translation.width < -200 && value.translation.height < -100 {
                                    withAnimation { showNailClipper = false }; checkFinalState()
                                } else { returnToOriginal(offset: $nailClipperOffset) }
                            }
                        }
                    }.padding(.trailing, 40)
                }.frame(maxHeight: .infinity)

                if showStar { starAnimationView(geometry: geometry) }
                
                // --- زر التالي المرتبط بالسؤال الثاني ---
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
                            .padding(.trailing, 50).padding(.bottom, 50)
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }

    // دوال مساعدة للسحب والتحقق
    func dragImage(name: String, offset: Binding<CGSize>, width: CGFloat, height: CGFloat, onEnded: @escaping (DragGesture.Value) -> Void) -> some View {
        Image(name).resizable().frame(width: width, height: height).offset(offset.wrappedValue)
            .gesture(DragGesture().onChanged { offset.wrappedValue = $0.translation }.onEnded(onEnded))
    }
    func returnToOriginal(offset: Binding<CGSize>) {
        QuizSoundManager.instance.playIncorrect()
        withAnimation(.spring()) { offset.wrappedValue = .zero }
    }
    func checkFinalState() {
        if !showScissors && !showPerfume && !showNailClipper { withAnimation { showStar = true } }
    }
    @ViewBuilder
    func starAnimationView(geometry: GeometryProxy) -> some View {
        Image("star").resizable().frame(width: 250, height: 250)
            .scaleEffect(starScale).rotationEffect(.degrees(starRotation))
            .position(starPosition == .zero ? CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2) : starPosition)
            .onAppear {
                QuizSoundManager.instance.playCorrect()
                starPosition = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                withAnimation(.easeInOut(duration: 2.0)) { starRotation = 360 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        starPosition = CGPoint(x: geometry.size.width / 2 - 175, y: 160)
                        starScale = 0.2
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        withAnimation { showNextButton = true }
                    }
                }
            }
    }
}

// MARK: - 3. شاشة السؤال الثاني (التي أرفقتها أنت)
struct Quiz2shatha: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showWrongImage = false
    @State private var isInteractionDisabled = false
    @State private var showStar = false
    @State private var starRotation = 0.0
    @State private var starScale = 1.0
    @State private var starPosition: CGPoint = .zero
    
    let columns = [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                Image("background").resizable().aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped().ignoresSafeArea()

                Image("السؤال الثاني").resizable().scaledToFit().frame(width: 90)
                    .padding(.top, 40).padding(.trailing, 30).zIndex(5)

                // الأمواج والنجوم
                VStack {
                    Spacer()
                    HStack(alignment: .bottom) {
                        Image("wave1").resizable().scaledToFit().frame(width: geometry.size.width * 0.25)
                        Spacer()
                        Image("wave").resizable().scaledToFit().frame(width: geometry.size.width * 0.25)
                    }
                }.ignoresSafeArea()

                // حاوية النجوم
                ZStack {
                    Image("star").resizable().frame(width: 250, height: 250).scaleEffect(0.2)
                        .position(x: (geometry.size.width / 2) - 35, y: 160)
                    
                    if showStar {
                        Image("star").resizable().frame(width: 250, height: 250)
                            .scaleEffect(starScale).rotationEffect(.degrees(starRotation))
                            .position(starPosition == .zero ? CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2) : starPosition)
                            .onAppear {
                                starPosition = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                starScale = 2.0
                                withAnimation(.easeInOut(duration: 2.0)) { starRotation = 360 }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    withAnimation(.easeInOut(duration: 1.5)) {
                                        starPosition = CGPoint(x: (geometry.size.width / 2) + 35, y: 160)
                                        starScale = 0.2
                                    }
                                }
                            }
                    }
                }.zIndex(10)

                VStack(spacing: 0) {
                    Image("s").resizable().scaledToFit().frame(width: 400).padding(.top, 30)
                    Spacer()
                    VStack(spacing: 50) {
                        Text("كم عدد أشواط الطواف حول الكعبة؟")
                            .font(.system(size: 40, weight: .bold)).multilineTextAlignment(.center).padding(.horizontal, 30)
                        LazyVGrid(columns: columns, spacing: 20) {
                            QuizOptionButton(text: "٥ أشواط", isCorrect: false, action: checkAnswer)
                            QuizOptionButton(text: "٦ أشواط", isCorrect: false, action: checkAnswer)
                            QuizOptionButton(text: "٨ أشواط", isCorrect: false, action: checkAnswer)
                            QuizOptionButton(text: "٧ أشواط", isCorrect: true, action: checkAnswer)
                        }.padding(.horizontal, geometry.size.width * 0.08).disabled(isInteractionDisabled)
                    }
                    Spacer()
                }.frame(maxWidth: .infinity)

                if showWrongImage {
                    Image("wrong").resizable().scaledToFit().frame(width: 500, height: 500)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2).zIndex(2)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    func checkAnswer(isCorrect: Bool) {
        isInteractionDisabled = true
        if isCorrect {
            runSound(named: "correctanswer"); withAnimation { showStar = true }
        } else {
            runSound(named: "incorrectanswer"); withAnimation(.spring()) { showWrongImage = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation { showWrongImage = false; isInteractionDisabled = false }
            }
        }
    }
    func runSound(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
        audioPlayer = try? AVAudioPlayer(contentsOf: url); audioPlayer?.play()
    }
}

// MARK: - المعاينة
#Preview {
    NavigationStack {
        Quiz1_shatha()
    }
}
