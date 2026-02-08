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
                    Image("star").resizable().frame(width: 250, height: 250).scaleEffect(0.2).position(x: (geometry.size.width / 2) - 140, y: 160)
                    Image("star").resizable().frame(width: 250, height: 250).scaleEffect(0.2).position(x: (geometry.size.width / 2) - 70, y: 160)
                    Image("star").resizable().frame(width: 250, height: 250).scaleEffect(0.2).position(x: (geometry.size.width / 2), y: 160)
                    Image("star").resizable().frame(width: 250, height: 250).scaleEffect(0.2).position(x: (geometry.size.width / 2) + 70, y: 160)

                    if showStar {
                        Image("star")
                            .resizable().frame(width: 250, height: 250)
                            .scaleEffect(starScale).rotationEffect(.degrees(starRotation))
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
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        withAnimation(.spring()) { showNextButton = true }
                                    }
                                }
                            }
                    }
                }.zIndex(10)

                VStack(spacing: 0) {
                    Image("s").resizable().scaledToFit().frame(width: 400).padding(.top, 30)
                    Spacer()
                    VStack(spacing: 40) {
                        Text("ماذا تلبس المرأة في العمرة؟").font(.system(size: 32, weight: .bold))
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
                }.frame(maxWidth: .infinity)

                if showNextButton {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            NavigationLink(destination: Quiz6View()) {
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

// MARK: - السؤال السادس
struct Quiz6shathaView: View {
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
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                Image("background").resizable()
                Color(red: 0.85, green: 0.93, blue: 0.85).ignoresSafeArea()

                Image("السؤال السادس")
                    .resizable().scaledToFit().frame(width: 90)
                    .padding(.top, 40).padding(.trailing, 30).zIndex(15)

                ZStack {
                    ForEach(0..<5) { i in
                        Image("star").resizable().frame(width: 250, height: 250).scaleEffect(0.2)
                            .position(x: (geometry.size.width / 2) - 175 + CGFloat(i * 70), y: 160)
                    }
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
                                        starPosition = CGPoint(x: (geometry.size.width / 2) + 175, y: 160)
                                        starScale = 0.2
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        withAnimation(.spring()) { showNextButton = true }
                                    }
                                }
                            }
                    }
                }.zIndex(10)

                VStack(spacing: 0) {
                    Image("s").resizable().scaledToFit().frame(width: 400).padding(.top, 30)
                    Text("اسحب كل سلوك إلى مكانه الصحيح").font(.system(size: 32, weight: .bold)).multilineTextAlignment(.center).padding(.top, 100)
                    Spacer()
                    VStack(spacing: 30) {
                        if showTalbiya {
                            Text("التلبية وذكر الله").font(.title).bold().padding().background(Color.white.opacity(0.6)).cornerRadius(15).offset(talbiyaOffset)
                                .gesture(DragGesture().onChanged { talbiyaOffset = $0.translation }.onEnded { value in
                                    if value.translation.width < -100 && value.translation.height > 100 { withAnimation { showTalbiya = false }; checkCompletion() }
                                    else { withAnimation(.spring()) { talbiyaOffset = .zero } }
                                })
                        }
                        if showPerfume {
                            Text("التطيب بعد الإحرام").font(.title).bold().padding().background(Color.white.opacity(0.6)).cornerRadius(15).offset(perfumeOffset)
                                .gesture(DragGesture().onChanged { perfumeOffset = $0.translation }.onEnded { value in
                                    if value.translation.width > 100 && value.translation.height > 100 { withAnimation { showPerfume = false }; checkCompletion() }
                                    else { withAnimation(.spring()) { perfumeOffset = .zero } }
                                })
                        }
                    }
                    Spacer()
                    HStack {
                        VStack { Image("right").resizable().scaledToFit().frame(width: 200); Text("سلوك صحيح").bold().font(.title2) }
                        Spacer()
                        VStack { Image("wrong").resizable().scaledToFit().frame(width: 200); Text("سلوك خاطئ").bold().font(.title2) }
                    }.padding(.horizontal, 50).padding(.bottom, 50)
                }.frame(maxWidth: .infinity)

                if showNextButton {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            NavigationLink(destination: Text("نهاية اللعبة")) {
                                Text("إنهاء").font(.system(size: 30, weight: .bold)).foregroundColor(.white)
                                    .padding(.vertical, 15).padding(.horizontal, 40)
                                    .background(Color.orange).cornerRadius(20).shadow(radius: 5)
                            }
                            .padding(.trailing, 50).padding(.bottom, 50)
                        }
                    }.zIndex(20).transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }.navigationBarBackButtonHidden(true)
    }

    func checkCompletion() {
        if !showTalbiya && !showPerfume {
            playSound(named: "correctanswer")
            withAnimation { showStar = true }
        }
    }

    func playSound(named fileName: String) {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
            audioPlayer = try? AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        }
    }
}

// MARK: - الـ Preview الموحد الذي يبدأ من السؤال الخامس وينتقل للسادس
#Preview {
    NavigationStack {
        Quiz5View()
    }
}
