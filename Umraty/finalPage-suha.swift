import SwiftUI

struct finalPage_suha: View {

    let steps = [
        "step_ihram",
        "step_tawaf",
        "step_sai",
        "step_thallul"
    ]
    
    @State private var currentStep = 0
    
    var body: some View {
        ZStack {
            Color(red: 0.94, green: 0.98, blue: 0.94)
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

                            // النص دائماً يمين
                            Text(LocalizedStringKey(steps[index]))
                                .font(.system(size: 35, weight: .semibold))
                                .foregroundColor(.black)

                            // الأيقونة دائماً يسار النص
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
                        .frame(maxWidth: .infinity, alignment: .center) // ← إجبار يمين
                        .environment(\.layoutDirection, .rightToLeft)     // ← أهم سطر!
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
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { timer in
                if currentStep < steps.count {
                    currentStep += 1
                } else {
                    timer.invalidate()
                }
            }
        }
    }
}

#Preview {
    finalPage_suha()
        .environment(\.layoutDirection,.rightToLeft) // ← حتى في العرض يكون يمين تمامًا
}
