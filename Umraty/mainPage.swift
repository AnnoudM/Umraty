


import SwiftUI

struct mainPage: View {

    // MARK: - States
    @State private var kidsBobbing = false
    @State private var kidsScale = 1.0
    @State private var viewOpacity = 1.0
    @State private var moveToNextScreen = false

    // ☁️ Clouds
    @State private var cloud1Move = false
    @State private var cloud2Move = false
    @State private var cloud3Angle: Double = 0
    @State private var cloudsOpacity = 1.0
    @State private var stopAnimations = false

    var body: some View {
        ZStack {

            // الخلفية
            Image("main page")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(viewOpacity)

            // ☁️ الغيوم
            ZStack {
                Image("cloud 1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 280)
                    .offset(x: cloud1Move ? 450 : -450, y: -300)

                Image("cloud 2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 260)
                    .offset(x: cloud2Move ? -450 : 450, y: -200)

                Image("cloud 3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 320)
                    .offset(
                        x: cos(cloud3Angle) * 60,
                        y: -260
                    )
            }
            .opacity(cloudsOpacity)

            VStack {

                Text("عمرتي")
                    .font(.system(size: 100, weight: .bold, design: .serif))
                    .foregroundColor(Color("Color1"))
                    .opacity(viewOpacity)

                Spacer()

                // 👣 الشخصيات أقدامهم ثابتة
                ZStack(alignment: .bottom) {

                    Image("kabaa")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 1200)
                        .opacity(viewOpacity)

                    Image("characters")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 800)
                        .scaleEffect(kidsScale)
                        .offset(y: kidsBobbing ? -40 : 0) // ✅ FIX
                }
            }
        }
        .onAppear {
            startAnimations()
            startAutoTransition()
        }
        .fullScreenCover(isPresented: $moveToNextScreen) {
            CharacterSelectionView()
        }
    }

    // MARK: - Animations
    func startAnimations() {

        // 👦 حركة لطيفة بدون كسر الأرض
        withAnimation(
            .easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
        ) {
            kidsBobbing = true
        }

        // ☁️ الغيوم
        withAnimation(.linear(duration: 18).repeatForever()) {
            cloud1Move = true
        }

        withAnimation(.linear(duration: 22).repeatForever()) {
            cloud2Move = true
        }

        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            if stopAnimations {
                timer.invalidate()
            } else {
                cloud3Angle += 0.02
            }
        }
    }

    // MARK: - Auto Transition
    func startAutoTransition() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {

            stopAnimations = true
            kidsBobbing = false

            withAnimation(.easeOut(duration: 1.5)) {
                cloudsOpacity = 0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeInOut(duration: 2)) {
                    kidsScale = 1.6
                    viewOpacity = 0
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                moveToNextScreen = true
            }
        }
    }
}

#Preview {
    mainPage()
}
