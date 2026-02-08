import SwiftUI
import AVFoundation

struct FirstSai: View {

    let dialogues: [(speaker: String, text: String)] = [
        ("محمد", "يا نورة، هل تعرفين لماذا نسعى بين الصفا والمروة؟"),
        ("نورة", "لا يا محمد، لماذا؟"),
        ("محمد", "لأن السعي قصة جميلة بدأت مع السيدة هاجر. كانت تبحث عن الماء لابنها إسماعيل."),
        ("نورة", "وماذا فعلت؟"),
        ("محمد", "مشت بين جبل الصفا وجبل المروة سبع مرات. ثم ظهر ماء زمزم."),
        ("نورة", "إذًا نحن نسعى مثلها؟"),
        ("محمد", "نعم يا نورة، نسعى مثلها في الحج والعمرة لنطيع الله ونتذكر قصتها الجميلة")
    ]

    @State private var currentIndex = 0
    @State private var stage = 0
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.green.opacity(0.2).ignoresSafeArea()

                VStack(spacing: geo.size.height * 0.05) {

                    Text("تعلم السعي")
                        .font(.system(size: geo.size.width * 0.08, weight: .bold))
                        .foregroundColor(.olive)

                    // المرحلة 0: الحوار
                    if stage == 0 && currentIndex < dialogues.count {
                        HStack(spacing: geo.size.width * 0.1) {

                            VStack(alignment: .leading, spacing: 12) {
                                Image("Mohammed")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: geo.size.height * 0.3)

                                if dialogues[currentIndex].speaker == "محمد" {
                                    Text(dialogues[currentIndex].text)
                                        .font(.system(size: geo.size.width * 0.045, weight: .semibold))
                                        .foregroundColor(.olive)
                                        .padding()
                                        .background(Color.green.opacity(0.1))
                                        .cornerRadius(12)
                                }
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 12) {
                                Image("Noura")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: geo.size.height * 0.3)

                                if dialogues[currentIndex].speaker == "نورة" {
                                    Text(dialogues[currentIndex].text)
                                        .font(.system(size: geo.size.width * 0.045, weight: .semibold))
                                        .foregroundColor(.olive)
                                        .padding()
                                        .background(Color.green.opacity(0.1))
                                        .cornerRadius(12)
                                }
                            }
                        }
                    }

                    // المرحلة 1: زر البدء
                    if stage == 1 {
                        Button("ابدأ السعي") {
                            stage = 2
                        }
                        .font(.title2.bold())
                        .padding()
                        .background(Color.olive)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }

                    // المرحلة 2: صفحة اللعبة
                    if stage == 2 {
                        Sai()
                            .frame(height: geo.size.height * 0.75)
                    }
                }
                .padding()
            }
            .onAppear {
                setupAudioSession()
                playDialogue()
            }
        }
    }

    func setupAudioSession() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    func playDialogue() {
        guard currentIndex < dialogues.count else {
            stage = 1
            return
        }

        let audioName: String

        switch currentIndex {
        case 0: audioName = "mohammed_0"
        case 1: audioName = "noura_1"
        case 2: audioName = "mohammed_2"
        case 3: audioName = "noura"
        case 4: audioName = "mohammed_4"
        case 5: audioName = "noura_5"
        case 6: audioName = "mohammed_6"
        default: return
        }

        guard let url = Bundle.main.url(forResource: audioName, withExtension: "wav") else {
            currentIndex += 1
            playDialogue()
            return
        }

        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()

        let duration = audioPlayer?.duration ?? 0

        DispatchQueue.main.asyncAfter(deadline: .now() + duration + 1) {
            currentIndex += 1
            playDialogue()
        }
    }
}

extension Color {
    static let olive = Color(red: 128/255, green: 128/255, blue: 0/255)
}

#Preview {
    FirstSai()
}
