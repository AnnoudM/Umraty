import SwiftUI
import AVFoundation

struct FirstSai: View {
    
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
    @State private var stage = 0
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(red: 0.93, green: 0.99, blue: 0.93)
                    .ignoresSafeArea()
                
                VStack(spacing: geo.size.height * 0.05) {
                    Text(NSLocalizedString("sai_title", comment: ""))
                        .font(.system(size: geo.size.width * 0.08, weight: .bold))
                        .foregroundColor(Color("Color1"))
                    
                    if stage == 0 && currentIndex < dialogues.count {
                        HStack(spacing: geo.size.width * 0.1) {
                            VStack(alignment: .leading, spacing: 12) {
                                Image("Mohammed")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: geo.size.height * 0.3)
                                
                                if dialogues[currentIndex].speaker == "محمد" {
                                    Text(NSLocalizedString(dialogues[currentIndex].textKey, comment: ""))
                                        .font(.system(size: geo.size.width * 0.045, weight: .semibold))
                                        .foregroundColor(Color("Color1"))
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
                                    Text(NSLocalizedString(dialogues[currentIndex].textKey, comment: ""))
                                        .font(.system(size: geo.size.width * 0.045, weight: .semibold))
                                        .foregroundColor(Color("Color1"))
                                        .padding()
                                        .background(Color.green.opacity(0.1))
                                        .cornerRadius(12)
                                }
                            }
                        }
                        .onAppear {
                            playDialogue()
                        }
                    }
                    
                    if stage == 2 {
                        Sai()
                            .frame(height: geo.size.height * 0.75)
                    }
                }
                .padding()
            }
        }
    }
    
    func playDialogue() {
        guard currentIndex < dialogues.count else {
            stage = 2 // بعد انتهاء كل الحوار نروح للسعي
            return
        }
        
        let audioName = dialogues[currentIndex].audioName
        
        guard let url = Bundle.main.url(forResource: audioName, withExtension: "wav") else {
            currentIndex += 1
            playDialogue()
            return
        }
        
        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
        
        let duration = audioPlayer?.duration ?? 1.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.2) {
            currentIndex += 1
            playDialogue()
        }
    }
}
#Preview {
    FirstSai()
}

