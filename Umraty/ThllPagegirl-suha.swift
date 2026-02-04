import SwiftUI
import AVFoundation

struct ThllPagegirl_suha: View {
    
    // MARK: - States
    @State private var hairImage = "بنت بشعر"
    
    // المقص للتقصير
    @State private var showScissors = true
    @State private var scissorsOffset = CGSize.zero
    @State private var scissorsX: CGFloat? = nil
    @State private var isCutting = false
    
    // النجوم وسقوط الشعر
    @State private var showStars = false
    @State private var dropHair = false
    
    // مشغل الصوت الخارجي
    @State private var player: AVAudioPlayer?

    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                // 🌿 الخلفية
                Color(red: 0.78, green: 0.92, blue: 0.80)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    
                    // العنوان
                    Text("التحلل من العمرة")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.0))
                    
                    Text("اسحبي المقص على الشعر✂️")
                        .font(.system(size: 26))
                        .foregroundColor(.black.opacity(0.7))
                    
                    Spacer()
                    
                    ZStack {
                        // الشعر المتساقط
                        if dropHair {
                            FallingHairViewGirl()
                        }
                        
                        // صورة البنت
                        Image(hairImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width * 0.45,
                                   height: geo.size.height * 0.60)
                        
                        // المقص مع نص "تقصير" يتحرك مع المقص
                        if showScissors {
                            VStack(spacing: 8) {
                                Image("مقص شعر")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 140)
                                    .offset(scissorsOffset)
                                    .gesture(
                                        DragGesture()
                                            .onChanged { value in
                                                scissorsOffset = value.translation
                                                if player?.isPlaying == false {
                                                    playCutSound()
                                                }
                                            }
                                            .onEnded { _ in
                                                stopCutSound()
                                                performTaqsir(geo: geo)
                                            }
                                    )
                                
                                Text("تقصير")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color(red: 0.5, green: 0.5, blue: 0.0))
                                    .cornerRadius(12)
                            }
                            .position(
                                x: scissorsX ?? geo.size.width * 0.85,
                                y: geo.size.height * 0.40
                            )
                        }
                        
                        // النجوم بعد الانتهاء
                        if showStars {
                            StarsViewGirl()
                        }
                    }
                    
                    Spacer()
                }
                
                // زر إعادة اللعب
                if !showScissors {
                    Button {
                        resetGame()
                    } label: {
                        Text("🔁 إعادة اللعب")
                            .font(.system(size: 24, weight: .bold))
                            .padding(.horizontal, 40)
                            .padding(.vertical, 18)
                            .background(Color(red: 0.5, green: 0.5, blue: 0.0))
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }
                    .position(
                        x: geo.size.width / 2,
                        y: geo.size.height * 0.9
                    )
                }
            }
        }
    }
    
    // MARK: - Actions
    
    func performTaqsir(geo: GeometryProxy) {
        playCutSound()
        dropHair = true
        withAnimation(.easeInOut(duration: 0.5)) {
            scissorsX = geo.size.width * 0.75
            scissorsOffset = .zero
        }
        isCutting = true
        
        var count = 0
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            withAnimation(.easeInOut(duration: 0.18)) {
                scissorsOffset.width = (count % 2 == 0 ? 30 : -30)
            }
            count += 1
            if count > 5 {
                timer.invalidate()
                
                stopCutSound()
                
                withAnimation {
                    scissorsOffset = .zero
                    hairImage = "بنت بدون احرام"
                }
                isCutting = false
                dropHair = false
                finishAction()
            }
        }
    }
    
    func finishAction() {
        withAnimation {
            showScissors = false
            showStars = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            showStars = false
        }
    }
    
    // MARK: - Sounds
    
    func playCutSound() {
        guard let url = Bundle.main.url(forResource: "cutHair", withExtension: "wav") else {
            print("❌ ملف الصوت غير موجود")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.prepareToPlay()
            player?.volume = 1.0
            player?.play()
        } catch {
            print("❌ خطأ في تشغيل الصوت")
        }
    }
    
    func stopCutSound() {
        player?.stop()
        player = nil
    }
    
    func resetGame() {
        withAnimation {
            hairImage = "بنت بشعر"
            showScissors = true
            showStars = false
            dropHair = false
            scissorsOffset = .zero
            isCutting = false
            scissorsX = nil
        }
    }
}

#Preview {
    ThllPagegirl_suha()
        .previewInterfaceOrientation(.landscapeLeft)
}

// ⭐ النجوم المتحركة للبنت
struct StarsViewGirl: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<12) { i in
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.system(size: 28))
                    .offset(
                        x: animate ? CGFloat.random(in: -160...160) : 0,
                        y: animate ? CGFloat.random(in: -160...160) : 0
                    )
                    .rotationEffect(.degrees(animate ? 360 : 0))
                    .opacity(animate ? 0 : 1)
                    .animation(
                        .easeOut(duration: 1.2).delay(Double(i) * 0.06),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

// ✂️ الشعر الذي يطيح خلف البنت
struct FallingHairViewGirl: View {
    @State private var fall = false
    
    var body: some View {
        ZStack {
            ForEach(0..<7) { i in
                Image("شعر قليل")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .offset(
                        x: CGFloat.random(in: -50...50),
                        y: fall ? 280 : -30
                    )
                    .opacity(fall ? 0 : 1)
                    .animation(
                        .easeIn(duration: 0.7).delay(Double(i) * 0.05),
                        value: fall
                    )
            }
        }
        .onAppear {
            fall = true
        }
    }
}
