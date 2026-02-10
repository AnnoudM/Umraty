import SwiftUI
import AVFoundation

struct IhramPageBoy_suha: View {
    
    @State private var zoomAllowed = false
    @State private var zoomForbidden = false
    @State private var pulseArrow = false
    @State private var showArrow = false
    @State private var audioPlayer: AVAudioPlayer?
    
    @Environment(\.dismiss) private var dismiss
    @AppStorage("umrah_progress_boy") private var progressBoy: Int = 1
    
    var body: some View {
        ZStack {
            
            Color(red: 0.85, green: 0.93, blue: 0.85)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                Text("الإحرام")
                    .font(.system(size: 70, weight: .bold))
                    .foregroundColor(Color.color1)
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 3)
                
                Divider()
                Spacer()
                
                HStack(spacing: 60) {
                    
                    VStack(spacing: 30) {
                        Image("مقص")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 110)
                            .scaleEffect(zoomForbidden ? 2 : 1)
                            .animation(.easeInOut(duration: 0.8), value: zoomForbidden)
                        
                        Image("عطر")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 110)
                            .scaleEffect(zoomForbidden ? 2 : 1)
                            .animation(.easeInOut(duration: 0.8).delay(0.2), value: zoomForbidden)
                    }
                    .frame(width: 180)
                    .overlay(
                        Image(systemName: "xmark")
                            .font(.system(size: 44, weight: .bold))
                            .foregroundColor(.red)
                            .offset(y: -160),
                        alignment: .top
                    )
                    
                    Image("الولد بدون احرام")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 480)
                    
                    Image("احرام فقط")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 290)
                        .scaleEffect(zoomAllowed ? 1.5 : 1)
                        .animation(.easeInOut(duration: 0.9), value: zoomAllowed)
                        .overlay(
                            Image(systemName: "checkmark")
                                .font(.system(size: 44, weight: .bold))
                                .foregroundColor(.green)
                                .offset(y: -160),
                            alignment: .top
                        )
                }
                
                Spacer()
                
                if showArrow {
                    Button {
                        audioPlayer?.stop()
                        if progressBoy < 2 { progressBoy = 2 }
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .padding(22)
                            .background(Circle().fill(Color.color1))
                            .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
                            .scaleEffect(pulseArrow ? 1.15 : 1)
                    }
                    .buttonStyle(.plain)
                    .transition(.scale.combined(with: .opacity))
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                            pulseArrow = true
                        }
                    }
                }
            }
            .padding(.horizontal, 40)
            .onAppear {
                
                playAudio()
                
                withAnimation(.easeInOut(duration: 0.9)) {
                    zoomAllowed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        zoomAllowed = false
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        zoomForbidden = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            zoomForbidden = false
                        }
                    }
                }
            }
            .onDisappear {
                audioPlayer?.stop()
            }
        }
    }
    
    func playAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            if let url = Bundle.main.url(forResource: "Boy_Ihram_audio", withExtension: "wav") {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
                
                let duration = audioPlayer?.duration ?? 0
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    withAnimation(.easeInOut) {
                        showArrow = true
                    }
                }
            }
        } catch {
            print(error)
        }
    }
}

#Preview {
    NavigationStack {
        IhramPageBoy_suha()
    }
}
