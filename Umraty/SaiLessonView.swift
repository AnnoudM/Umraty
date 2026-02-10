import SwiftUI
import AVFoundation

struct SaiLessonView: View {
    
    var onFinishSai: () -> Void

    // MARK: - Dialogue
    let dialogues: [(speaker: String, textKey: String, audioName: String)] = [
        ("محمد", "sai_d_1", "mohammed_0"),
        ("نورة", "sai_d_2", "noura_1"),
        ("محمد", "sai_d_3", "mohammed_2"),
        ("نورة", "sai_d_4", "noura_3"),
        ("محمد", "sai_d_5", "mohammed_4"),
        ("نورة", "sai_d_6", "noura_5"),
        ("محمد", "sai_d_7", "mohammed_6")
    ]

    @State private var currentIndex = 0
    @State private var showSaiSection = false
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(red: 0.93, green: 0.99, blue: 0.93).ignoresSafeArea()

                VStack(spacing: 0) {

                    // ✅ نفس مسافة العنوان اللي في CharacterSelectionView
                    if !showSaiSection {
                        Spacer(minLength: geo.size.height * 0.08)

                        Text(NSLocalizedString("sai_title", comment: ""))
                            .font(.system(size: min(geo.size.width, geo.size.height) * 0.08, weight: .bold))
                            .foregroundColor(Color("Color1"))
                            .minimumScaleFactor(0.7)

                        Spacer(minLength: geo.size.height * 0.08)
                    } else {
                        // نخلي فيه مسافة بسيطة بدل العنوان عشان ما يخرب الترتيب
                        Spacer(minLength: geo.size.height * 0.04)
                    }

                    // ✅ هذا يخلي المحتوى ينزل للنص شوي
                    Group {
                        if !showSaiSection {
                            dialogueSection(geo: geo)
                                .transition(.opacity.combined(with: .scale))
                                .onAppear {
                                    if currentIndex == 0 { playDialogue() }
                                }
                        } else {
                            SaiInteractionView(onDone: { onFinishSai()})
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                    Spacer(minLength: geo.size.height * 0.05)
                }
                .padding(.horizontal, geo.size.width * 0.05)
                .padding(.bottom, 16)

            }
        }
    }

    // MARK: - UI: Dialogue
    private func dialogueSection(geo: GeometryProxy) -> some View {
        let size = min(geo.size.width, geo.size.height)
        let charH = size * 0.32
        let bubbleFont = size * 0.045

        let isMohammedSpeaking = (currentIndex < dialogues.count && dialogues[currentIndex].speaker == "محمد")
        let bubbleMaxW = geo.size.width * 0.42   // لا تخليه عريض مره

        return HStack(alignment: .top, spacing: geo.size.width * 0.10) {

            // ✅ محمد يسار
            VStack(alignment: .center, spacing: 10) {
                Image("Mohammed")
                    .resizable()
                    .scaledToFit()
                    .frame(height: charH)

                if isMohammedSpeaking {
                    Text(currentDialogueText())
                        .font(.system(size: bubbleFont, weight: .semibold))
                        .foregroundColor(Color("Color1"))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 14)
                        .frame(maxWidth: bubbleMaxW)
                        .background(Color.white.opacity(0.65))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color("Color1").opacity(0.15), lineWidth: 1)
                        )
                } else {
                    // مكان فاضي بسيط عشان ما يقفز الlayout
                    Spacer().frame(height: 70)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // ✅ نورة يمين + نخليها "تناظر السبورة"
            VStack(alignment: .center, spacing: 10) {
                Image("Noura")
                    .resizable()
                    .scaledToFit()
                    .frame(height: charH)
                    .scaleEffect(x: -1, y: 1) // 👈 هذا اللي يخليها تلف يمين/يسار

                if !isMohammedSpeaking {
                    Text(currentDialogueText())
                        .font(.system(size: bubbleFont, weight: .semibold))
                        .foregroundColor(Color("Color1"))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 14)
                        .frame(maxWidth: bubbleMaxW)
                        .background(Color.white.opacity(0.65))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color("Color1").opacity(0.15), lineWidth: 1)
                        )
                } else {
                    Spacer().frame(height: 70)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.top, geo.size.height * 0.03)   // ينزل شوي إضافي
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }


    private func currentDialogueText() -> String {
        guard currentIndex < dialogues.count else { return "" }
        return NSLocalizedString(dialogues[currentIndex].textKey, comment: "")
    }

    private func currentSpeakerName() -> String {
        guard currentIndex < dialogues.count else { return "" }
        return dialogues[currentIndex].speaker
    }

    // MARK: - Audio + Flow
    private func playDialogue() {
        guard currentIndex < dialogues.count else {
            withAnimation(.easeInOut) { showSaiSection = true }
            return
        }

        let audioName = dialogues[currentIndex].audioName

        guard let url = Bundle.main.url(forResource: audioName, withExtension: "wav") else {
            // لو ملف ناقص نمشي لقدام
            currentIndex += 1
            playDialogue()
            return
        }

        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()

        let duration = audioPlayer?.duration ?? 1.0

        DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.25) {
            currentIndex += 1
            playDialogue()
        }
    }
}

#Preview {
    NavigationStack {
        SaiLessonView(onFinishSai: {})
    }
}
