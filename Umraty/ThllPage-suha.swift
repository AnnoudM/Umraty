import SwiftUI
import AVFoundation

struct ThllPage_suha: View {

  // MARK: - RTL Support
  @Environment(\.layoutDirection) private var layoutDirection
  var rtlMultiplier: CGFloat { layoutDirection == .rightToLeft ? -1 : 1 }

  // MARK: - States
  @State private var hairImage = "ولد بشعر"

  // المقص للتقصير
  @State private var showScissors = true
  @State private var scissorsOffset = CGSize.zero
  @State private var scissorsX: CGFloat? = nil
  @State private var isCutting = false

  // ماكينة الحلاقة للحلق
  @State private var showRazor = true
  @State private var razorOffset = CGSize.zero
  @State private var razorX: CGFloat? = nil

  // النجوم وسقوط الشعر
  @State private var showStars = false
  @State private var dropHair = false

  // مشغل الصوت
  @State private var player: AVAudioPlayer?

  // حالة السهم المتحرك
  @State private var pulseArrow = false

  //  الانتقال لصفحة النهاية
  @State private var goToFinalPage = false

  var body: some View {
    GeometryReader { geo in
      ZStack {
        //  الخلفية
        Color(red: 0.85, green: 0.93, blue: 0.85)
          .ignoresSafeArea()

        VStack(spacing: 16) {
          // العنوان
          Text("thllPage_title")
            .font(.system(size: 70, weight: .bold))
            .foregroundColor(Color.color1)

          Text("thllPage_instruction")
            .font(.system(size: 50))
            .foregroundColor(.black.opacity(0.7))

          Spacer()

          ZStack {
            // الشعر المتساقط
            if dropHair {
              FallingHairView()
            }

            // صورة الطفل
            Image(hairImage)
              .resizable()
              .scaledToFit()
              .frame(
                width: geo.size.width * 0.45,
                height: geo.size.height * 0.60
              )

            //  المقص
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
                        scissorsOffset = CGSize(
                          width: value.translation.width * rtlMultiplier,
                          height: value.translation.height - 30
                        )
                        if player?.isPlaying == false { playCutSound() }
                      }
                      .onEnded { _ in
                        stopCutSound()
                        performTaqsir(geo: geo)
                      }
                  )

                Text("button_cut")
                  .font(.system(size: 40, weight: .bold))
                  .foregroundColor(.white)
                  .padding(.horizontal, 16)
                  .padding(.vertical, 8)
                  .background(Color.color1)
                  .cornerRadius(12)
              }
              .position(
                x: scissorsX ?? geo.size.width * 0.15,
                y: geo.size.height * 0.25
              )
            }

            //  ماكينة الحلاقة
            if showRazor {
              VStack(spacing: 8) {
                Image("ماكينه")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 190)
                  .offset(razorOffset)
                  .gesture(
                    DragGesture()
                      .onChanged { value in
                        razorOffset = CGSize(
                          width: value.translation.width * rtlMultiplier,
                          height: value.translation.height - 30
                        )
                        if player?.isPlaying == false { playShaveSound() }
                      }
                      .onEnded { _ in
                        stopShaveSound()
                        performHalq(geo: geo)
                      }
                  )

                Text("button_shave")
                  .font(.system(size: 40, weight: .bold))
                  .foregroundColor(.white)
                  .padding(.horizontal, 16)
                  .padding(.vertical, 8)
                  .background(Color.color1)
                  .cornerRadius(12)
              }
              .position(
                x: razorX ?? geo.size.width * 0.15,
                y: geo.size.height * 0.60
              )
            }

            //  النجوم
            if showStars {
              StarsView()
            }
          }

          Spacer()
        }

        //  الأزرار بعد الانتهاء
        if !showScissors && !showRazor {
          HStack(spacing: 40) {
            Button {
              resetGame()
            } label: {
              Image(systemName: "arrow.clockwise")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .padding(22)
                .background(Circle().fill(Color.color1))
                .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
            }

            //  النكست → صفحة النهاية (بدون الخريطة)
            Button {
              goToFinalPage = true
            } label: {
              Image(systemName: "chevron.right")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .padding(22)
                .background(Circle().fill(Color.color1))
                .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
                .scaleEffect(pulseArrow ? 1.15 : 1)
            }
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
    //  الربط النهائي
    .navigationDestination(isPresented: $goToFinalPage) {
      finalPage_suha()
        .environment(\.layoutDirection, .rightToLeft)
    }
  }

  // MARK: - Actions

  func performHalq(geo: GeometryProxy) {
    playShaveSound()
    hairImage = "بدون شعر"

    withAnimation(.easeInOut(duration: 0.5)) {
      razorX = geo.size.width * 0.75
      razorOffset = .zero
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      stopShaveSound()
    }

    finishAction()
  }

  func performTaqsir(geo: GeometryProxy) {
    playCutSound()
    dropHair = true

    let centerX = geo.size.width * 0.5
    withAnimation(.easeInOut(duration: 0.5)) {
      scissorsX = centerX
      scissorsOffset = .zero
    }

    isCutting = true
    var count = 0

    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
      withAnimation(.easeInOut(duration: 0.18)) {
        let offsetAmount: CGFloat = 30
        scissorsOffset.width = (count % 2 == 0 ? offsetAmount : -offsetAmount)
        scissorsOffset.height = 0
      }
      count += 1

      if count > 5 {
        timer.invalidate()
        stopCutSound()

        withAnimation {
          scissorsOffset = .zero
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
      showRazor = false
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

  func playShaveSound() {
    guard let url = Bundle.main.url(forResource: "cutHair", withExtension: "wav") else { return }
    player = try? AVAudioPlayer(contentsOf: url)
    player?.numberOfLoops = -1
    player?.play()
  }

  func stopShaveSound() {
    player?.stop()
    player = nil
  }

  func resetGame() {
    withAnimation {
      hairImage = "ولد بشعر"
      showScissors = true
      showRazor = true
      showStars = false
      dropHair = false
      scissorsOffset = .zero
      scissorsX = nil
      razorOffset = .zero
      razorX = nil
    }
  }
}

//  النجوم
struct StarsView: View {
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

//  الشعر المتساقط
struct FallingHairView: View {
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
    ThllPage_suha()
      .previewInterfaceOrientation(.landscapeLeft)
  }
}
