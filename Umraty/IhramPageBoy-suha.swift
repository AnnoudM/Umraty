import SwiftUI

struct IhramPageBoy_suha: View {
    
    @State private var zoomAllowed = false
    @State private var zoomForbidden = false
    
    var body: some View {
        ZStack {
            // الخلفية
            Color(red: 0.94, green: 0.98, blue: 0.94)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // العنوان
                Text("الإحرام")
                    .font(.system(size: 70, weight: .bold))
                    .foregroundColor(Color(red: 0.55, green: 0.72, blue: 0.69))
                    .shadow(
                        color: Color.black.opacity(0.15),
                        radius: 4,
                        x: 0,
                        y: 3
                    )
                
                Divider()
                
                Spacer()
                
                HStack(spacing: 60) {
                    
                    // ❌ الممنوع
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
                    
                    // 👦 الطفل
                    Image("الولد بدون احرام")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 480)
                    
                    // ✅ المسموح (الإحرام)
                    Image("احرام فقط")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 290)
                        .scaleEffect(zoomAllowed ? 1.5: 1)
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
                
                // الأسهم للتنقل
                HStack(spacing: 80) {
                    Image(systemName: "chevron.left")
                    Image(systemName: "chevron.right")
                }
                .font(.system(size: 34))
                .foregroundColor(.gray)
            }
            .padding(.horizontal, 40)
            .onAppear {
                // تكبير ثم رجوع المسموح أولاً
                withAnimation(.easeInOut(duration: 0.9)) {
                    zoomAllowed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        zoomAllowed = false
                    }
                }
                
                // بعد المسموح: تكبير ثم رجوع الممنوع
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
        }
    }
}

#Preview {
    IhramPageBoy_suha()
}
