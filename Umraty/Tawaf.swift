import SwiftUI
import AVFoundation

struct Tawaf: View {

    let selectedGender: ChildGender
    let onComplete: () -> Void   // ✅ جديد

    private let centerXOffset: CGFloat = 0.60
    private let centerYOffset: CGFloat = 280
    private let radiusX: CGFloat = 650
    private let radiusY: CGFloat = 590
    private let characterSize: CGFloat = 95
    private let kaabaYOffset: CGFloat = 120

    private let totalRounds: Int = 7
    private let roundDuration: Double = 5

    @State private var progress: Double = 0.5
    @State private var completedRounds: Int = 0
    @State private var showFront: Bool = true
    @State private var showBack: Bool = false
 
    @State private var audioPlayer: AVAudioPlayer?
    @State private var audioStarted: Bool = false
    @State private var tawafStarted: Bool = false

    // ✅ عشان نضمن ما ينادي onComplete مرتين
    @State private var didComplete: Bool = false

    private var walkFrame: String {
        selectedGender == .boy ? "BoyWalk 2" : "GirlWalk 2"
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
                    Text("Rounds \(min(completedRounds + 1, totalRounds)) / \(totalRounds)")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.green)
                        .padding(.top, 24)
                }
                Spacer()
            }
            .zIndex(3)

            VStack {
                Spacer()

                if completedRounds == totalRounds {

                    Text("Tawaf is completed!")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.blue)
                        .padding(.bottom, 40)

                } else if !tawafStarted {

                    Button("Start Tawaf") {
                        startTawaf()
                    }
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.blue)
                    .padding(.bottom, 40)
                }
            }
            .zIndex(5)
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

        let audioName = selectedGender == .boy ? "tawafaudio_boy" : "tawafaudio_girl"
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
        didComplete = false
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

            // ✅ نحدث التقدم مرة وحدة
            if !didComplete {
                didComplete = true
                onComplete()
            }
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
    Tawaf(selectedGender: .girl) { }
}
