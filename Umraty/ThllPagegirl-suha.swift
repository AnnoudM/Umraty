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
    
    // مشغل الصوت
    @State private var player: AVAudioPlayer?
    
    // حالة الأزرار التفاعلية
    @State private var isReplayPressed = false
    @State private var isNextPressed = false
    @State private var pulseArrow = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                // 🌿 الخلفية
                Color(red: 0.85, green: 0.93, blue: 0.85)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    
                    // العنوان
                    Text("التحلل من العمرة")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.0))
                    
                    Text("اسحبي المقص لتقصير الشعر✂️")
                        .font(.system(size: 26))
                        .foregroundColor(.black.opacity(0.7))
                    
                    Spacer()
                    
                    ZStack {
                        // الشعر المتساقط
                        if dropHair {
                            SharedFallingHairView()
                        }
                        
                        // صورة البنت
                        Image(hairImage)
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: geo.size.width * 0.45,
                                height: geo.size.height * 0.60
                            )
                        
                        // ✂️ المقص
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
                                                if player?.isPlaying == false { playCutSound() }
                                            }
                                            .onEnded { _ in
                                                stopCutSound()
                                                performTaqsir(geo: geo)
                                            }
                                    )
                                
                                Text("تقصير")
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color(red: 0.5, green: 0.5, blue: 0.0))
                                    .cornerRadius(12)
                            }
                            .position(
                                x: scissorsX ?? geo.size.width * 0.85,
                                y: geo.size.height * 0.4
                            )
                        }
                        
                        // ⭐ النجوم
                        if showStars {
                            SharedStarsView()
                        }
                    }
                    
                    Spacer()
                }
                
                // 🔘 أزرار موحدة باللون الزيتي مع نبض للزر التالي
                if !showScissors {
                    HStack(spacing: 40) {
                        
                        // 🔁 إعادة اللعب
                        Button {
                            resetGame()
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                                .padding(22)
                                .background(
                                    Circle().fill(Color(red: 0.5, green: 0.5, blue: 0.0))
                                )
                                .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
                        }
                        
                        // ⏭️ التالي مع نبض
                        NavigationLink(destination: UmrahPathView(selectedGender: .girl)) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                                .padding(22)
                                .background(
                                    Circle().fill(Color(red: 0.5, green: 0.5, blue: 0.0))
                                )
                                .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
                                .scaleEffect(pulseArrow ? 1.15 : 1)
                        }
                        .transition(.scale.combined(with: .opacity))
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                                pulseArrow = true
                            }
                        }
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
        guard let url = Bundle.main.url(forResource: "cutHair", withExtension: "wav") else { return }
        player = try? AVAudioPlayer(contentsOf: url)
        player?.numberOfLoops = -1
        player?.play()
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
            scissorsX = nil
        }
    }
}

// ✅ زر دائري موحد
struct CircleButton: View {
    let iconName: String
    @Binding var isPressed: Bool
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: { action?() }) {
            Image(systemName: iconName)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 70, height: 70)
                .background(Color(red: 0.5, green: 0.5, blue: 0.0))
                .clipShape(Circle())
                .scaleEffect(isPressed ? 1.2 : 1)
                .shadow(color: .yellow.opacity(isPressed ? 0.6 : 0), radius: 8, x: 0, y: 0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
                .onLongPressGesture(minimumDuration: 0.01, pressing: { pressing in
                    isPressed = pressing
                }, perform: {})
        }
    }
}

// ⭐ النجوم المتحركة المشتركة
struct SharedStarsView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<12) { _ in
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.system(size: 28))
                    .offset(
                        x: animate ? CGFloat.random(in: -160...160) : 0,
                        y: animate ? CGFloat.random(in: -160...160) : 0
                    )
                    .rotationEffect(.degrees(animate ? 360 : 0))
                    .opacity(animate ? 0 : 1)
                    .animation(.easeOut(duration: 1.2), value: animate)
            }
        }
        .onAppear { animate = true }
    }
}

// ✂️ الشعر المتساقط المشترك
struct SharedFallingHairView: View {
    @State private var fall = false
    
    var body: some View {
        ZStack {
            ForEach(0..<7) { _ in
                Image("شعر قليل")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .offset(
                        x: CGFloat.random(in: -50...50),
                        y: fall ? 280 : -30
                    )
                    .opacity(fall ? 0 : 1)
                    .animation(.easeIn(duration: 0.7), value: fall)
            }
        }
        .onAppear { fall = true }
    }
}

#Preview {
    NavigationStack {
        ThllPagegirl_suha()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
