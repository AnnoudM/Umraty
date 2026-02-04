import SwiftUI

struct finalPage_suha: View {

    let steps = ["الإحرام", "الطواف", "السعي", "التحلل"]
    @State private var currentStep = 0
    
    var body: some View {
        ZStack {
            Color(red: 0.94, green: 0.98, blue: 0.94)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                
                Spacer()  // محتوى الصفحة في الوسط عمودياً
                
                // العنوان الرئيسي
                Text("تطوري مع العمرة")
                    .font(.system(size: 70, weight: .bold))
                    .foregroundColor(Color(red: 0.55, green: 0.72, blue: 0.69))
                    .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                // العنوان الفرعي
                Text("ماذا تعلمت في هذه الرحلة :")
                    .foregroundColor(Color(red: 0.83, green: 0.56, blue: 0.56))
                    .font(.system(size: 50, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                VStack(alignment: .trailing, spacing: 30) {
                    ForEach(steps.indices, id: \.self) { index in
                        HStack(spacing: 12) {
                            Text(steps[index])
                                .font(.system(size: 26, weight: .semibold))
                                .foregroundColor(.black)
                            
                            if index < currentStep {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color.green)
                                    .font(.title)
                                    .transition(.scale.combined(with: .opacity))
                            } else {
                                Image(systemName: "circle")
                                    .foregroundColor(Color.gray.opacity(0.5))
                                    .font(.title)
                                    .transition(.opacity)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .opacity(index < currentStep ? 1 : 0.3)
                        .scaleEffect(index < currentStep ? 1.15 : 1)
                        .animation(.easeInOut(duration: 0.4).delay(Double(index) * 0.4), value: currentStep)
                        Divider()
                    }
                }
                .padding()
                .frame(maxWidth: 500, minHeight: 300, alignment: .trailing)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.81, green: 0.9, blue: 0.9))
                        .shadow(radius: 5)
                )
                .padding(.horizontal, 30)
                
                Spacer() // محتوى الصفحة في الوسط عمودياً
            }
            .padding()
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { timer in
                if currentStep < steps.count {
                    withAnimation {
                        currentStep += 1
                    }
                } else {
                    timer.invalidate()
                }
            }
        }
    }
}

#Preview {
    finalPage_suha()
}
