
import SwiftUI
import AVFoundation

struct Tawaf: View {

    let selectedGender: ChildGender
    let onComplete: () -> Void

    private let centerXOffset: CGFloat = 0.60
    private let centerYOffset: CGFloat = 260
    private let tawafRadius: CGFloat = 260
    private let characterSize: CGFloat = 95
    private let kaabaYOffset: CGFloat = 120

    private let totalRounds: Int = 7
    private let roundDuration: Double = 3

    @State private var progress: Double = 0.0
    @State private var completedRounds: Int = 0
    @State private var showFront: Bool = true
    @State private var showBack: Bool = false

    @State private var audioPlayer: AVAudioPlayer?
    @State private var audioStarted: Bool = false
    @State private var tawafStarted: Bool = false
    @State private var didComplete: Bool = false

    private var walkFrame: String {
        selectedGender == .boy ? "BoyWalk 2" : "GirlWalk 2"
    }

    var body: some View {
        ZStack {

            Image("Background")
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
                .frame(width: 750)
                .offset(y: kaabaYOffset)
                .zIndex(1)

            if showFront {
                walkingCharacter(flipped: true, opacity: 1.0)
                    .zIndex(2)
            }

            // 🔹 TOP UI
            VStack {

                if !tawafStarted {

                    Button(action: startTawaf) {
                        Text("Start Tawaf")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 14)
                            .background(Color("Color1"))
                            .clipShape(Capsule())
                            .shadow(radius: 4)
                    }
                    .padding(.top, 24)

                } else if completedRounds < totalRounds {

                    Text("Rounds \(min(completedRounds + 1, totalRounds)) / \(totalRounds)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 14)
                        .background(Color("Color1"))
                        .clipShape(Capsule())
                        .shadow(radius: 4)
                        .padding(.top, 24)

                } else {

                    Text("Tawaf is completed!")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 14)
                        .background(Color("Color1"))
                        .clipShape(Capsule())
                        .shadow(radius: 4)
                        .padding(.top, 24)
                }

                Spacer()
            }
            .zIndex(3)
        }
        .onDisappear {
            stopTawafAudio()
        }
    }

    // MARK: - Character
    private func walkingCharacter(
        flipped: Bool,
        opacity: Double
    ) -> some View {

        let angle = Angle.degrees(progress * 360)

        let x = cos(angle.radians) * tawafRadius
        let y = sin(angle.radians) * tawafRadius

        let centerX = UIScreen.main.bounds.midX + centerXOffset
        let centerY = UIScreen.main.bounds.midY + centerYOffset

        return Image(walkFrame)
            .resizable()
            .scaledToFit()
            .frame(width: characterSize)
            .scaleEffect(x: flipped ? 1 : -1, y: 1)
            .position(x: centerX + x, y: centerY + y)
            .opacity(opacity)
    }

    // MARK: - Audio (FIXED & DEBUG SAFE)
    private func playTawafAudio() {
        guard !audioStarted else { return }
        audioStarted = true

        let audioName = selectedGender == .boy
            ? "tawafaudio_boy"
            : "tawafaudio_girl"

        guard let url = Bundle.main.url(forResource: audioName, withExtension: "mp3") else {
            print("❌ Audio file NOT found:", audioName)
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1   // 🔁 loop during tawaf
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            print("✅ Playing audio:", audioName)
        } catch {
            print("❌ Audio error:", error.localizedDescription)
        }
    }

    private func stopTawafAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
        audioStarted = false
    }

    // MARK: - Tawaf Logic
    private func startTawaf() {
        didComplete = false
        tawafStarted = true
        completedRounds = 0
        progress = 0.0
        playTawafAudio()
        animateRound()
    }

    private func animateRound() {

        if completedRounds == totalRounds {
            showFront = true
            showBack = false
            stopTawafAudio()

            if !didComplete {
                didComplete = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    onComplete()
                }
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
