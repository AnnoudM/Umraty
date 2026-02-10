import SwiftUI

struct finalPage_suha: View {

  let steps = [
    "step_ihram",
    "step_tawaf",
    "step_sai",
    "step_thallul"
  ]

  @State private var currentStep = 0
  @State private var pulseArrow = false
  @State private var showButton = false // الحالة لإظهار الزر بعد التأخير

  var body: some View {
    ZStack {
      Color(red: 0.85, green: 0.93, blue: 0.85)
        .ignoresSafeArea()

      VStack(spacing: 40) {

        Spacer()

        Text("finalPage_title")
          .font(.system(size: 70, weight: .bold))
          .foregroundColor(Color.color1)
          .multilineTextAlignment(.center)

        Text("finalPage_subtitle")
          .foregroundColor(Color(red: 0.83, green: 0.56, blue: 0.56))
          .font(.system(size: 50, weight: .semibold))
          .multilineTextAlignment(.center)

        VStack(spacing: 60) {
          ForEach(steps.indices, id: \.self) { index in
            HStack(spacing: 12) {

              Text(LocalizedStringKey(steps[index]))
                .font(.system(size: 35, weight: .semibold))
                .foregroundColor(.black)

              if index < currentStep {
                Image(systemName: "checkmark.circle.fill")
                  .foregroundColor(.green)
                  .font(.title)
              } else {
                Image(systemName: "circle")
                  .foregroundColor(.gray.opacity(0.5))
                  .font(.title)
              }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .environment(\.layoutDirection, .rightToLeft)
            .opacity(index < currentStep ? 1 : 0.3)
            .scaleEffect(index < currentStep ? 1.15 : 1)
            .animation(.easeInOut(duration: 0.4).delay(Double(index) * 0.4), value: currentStep)

            Divider()
          }
        }
        .padding()
        .frame(maxWidth: 500)
        .background(
          RoundedRectangle(cornerRadius: 20)
            .fill(Color(red: 0.81, green: 0.9, blue: 0.9))
            .shadow(radius: 5)
        )
        .padding(.horizontal, 30)

        //  زر الانتقال إلى SecondPage بعد التأخير
        if showButton {
          HStack(spacing: 40) {
            NavigationLink(destination: SecondPage(selectedGender: .girl)) {
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
        }

        Spacer()
      }
      .padding()
    }
    .onAppear {
      Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { timer in
        if currentStep < steps.count {
          currentStep += 1
        } else {
          timer.invalidate() // إيقاف التايمر بعد اكتمال جميع الخطوات

          //  تأخير ظهور الزر بعد الأنيميشن
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // 1 ثانية تأخير
            withAnimation {
              showButton = true
            }
          }
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    finalPage_suha()
      .environment(\.layoutDirection,.rightToLeft)
  }
}
