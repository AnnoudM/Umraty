


import SwiftUI
import AVFoundation

struct Tawaf: View {

    let selectedGender: ChildGender

    private let centerXOffset: CGFloat = 0.60
    private let centerYOffset: CGFloat = 280
    private let radiusX: CGFloat = 650
    private let radiusY: CGFloat = 590
    private let characterSize: CGFloat = 95
    
    private let kaabaYOffset: CGFloat = 120

    private let totalRounds: Int = 7
    private let roundDuration: Double = 10.0

    @State private var progress: Double = 0.5
    @State private var completedRounds: Int = 0
    @State private var showFront: Bool = true
    @State private var showBack: Bool = false

    @State private var audioPlayer: AVAudioPlayer?
    @State private var audioStarted: Bool = false

    @State private var tawafStarted: Bool = false

    private var walkFrame: String {
        switch selectedGender {
        case .boy:
            return "BoyWalk 2"
        case .girl:
            return "GirlWalk 2"
        }
    }

    var body: some View {
        ZStack {

            Image("BackGround")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            if showBack {
                walkingCharacter(flipped: false, opacity: 0.6)
                    .zIndex(0)
            }

            Image("Kaaba")
                .resizable()
                .scaledToFit()
                .frame(width: 900)
                .offset(y: kaabaYOffset)
                .zIndex(1)

            if showFront {
                walkingCharacter(flipped: true, opacity: 1.0)
                    .zIndex(2)
            }

            VStack {
                if tawafStarted {
                    Text("الشوط \(min(completedRounds + 1, totalRounds)) / \(totalRounds)")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.green)
                        .padding(.top, 24)
                }
                Spacer()
            }
            .zIndex(3)

            if completedRounds == totalRounds {
                VStack {
                    Spacer()
                    Text("تم إكمال الطواف")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.green)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.9))
                        )
                        .shadow(radius: 10)
                        .offset(y: 140)
                    Spacer()
                }
                .zIndex(4)
            }

            if !tawafStarted {
                VStack {
                    Spacer()
                    Button("ابدأ الطواف") {
                        startTawaf()
                    }
                    .font(.system(size: 22, weight: .bold))
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.bottom, 40)
                }
                .zIndex(5)
            }
        }
        .onDisappear {
            stopTawafAudio()
        }
    }

   
    private func walkingCharacter(
        flipped: Bool,
        opacity: Double
    ) -> some View {

        let angle = Angle.degrees(-progress * 360)

        let x = cos(angle.radians) * radiusX
        let y = sin(angle.radians) * radiusY

        let centerX = UIScreen.main.bounds.midX + centerXOffset
        let centerY = UIScreen.main.bounds.midY + centerYOffset

        return Image(walkFrame)
            .resizable()
            .scaledToFit()
            .frame(width: characterSize)
            .scaleEffect(x: flipped ? 1 : -1, y: 1)
            .position(
                x: centerX + x,
                y: centerY + y
            )
            .opacity(opacity)
    }

    private func playTawafAudio() {
        guard !audioStarted else { return }
        audioStarted = true

        let audioName: String
        switch selectedGender {
        case .boy:
            audioName = "tawafaudio_boy"
        case .girl:
            audioName = "tawafaudio_girl"
        }

        guard let url = Bundle.main.url(forResource: audioName, withExtension: "mp3") else { return }

        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.play()
    }

    private func stopTawafAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
        audioStarted = false
    }

    private func startTawaf() {
        tawafStarted = true
        completedRounds = 0
        progress = 0.5
        playTawafAudio()
        animateRound()
    }

    private func animateRound() {

        if completedRounds == totalRounds {
            showFront = true
            showBack = false
            stopTawafAudio()
            return
        }

        showFront = true
        showBack = false

        withAnimation(.linear(duration: roundDuration)) {
            progress += 0.5
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + roundDuration) {

            showFront = false
            showBack = true

            withAnimation(.linear(duration: roundDuration / 2)) {
                progress += 0.5
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + roundDuration / 2) {
                completedRounds += 1
                animateRound()
            }
        }
    }
}

#Preview {
    Tawaf(selectedGender: .girl)
}
