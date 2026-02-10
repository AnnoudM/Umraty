import SwiftUI

struct IhramPage_suha_girl: View {
    
    @State private var zoomAllowed = false
    @State private var zoomForbidden = false
    @State private var showArrow = false
    @State private var pulseArrow = false
    
    // ✅ نحتاجها عشان نرجع للباث
    @Environment(\.dismiss) private var dismiss
    
    // ✅ نحدث التقدم للبنت
    @AppStorage("umrah_progress_girl") private var progressGirl: Int = 1
    
    var body: some View {
        ZStack {
            // الخلفية
            Color(red: 0.85, green: 0.93, blue: 0.85)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // العنوان
                Text("الإحرام")
                    .font(.system(size: 70, weight: .bold))
                    .foregroundColor(Color.color1) // اللون زيتي
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 3)
                
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
                    
                    // 👧 البنت بدون الحجاب
                    Image("بنت بدون حجاب")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 380)
                    
                    // ✅ المسموح (الحجاب)
                    Image("حجاب البنت")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 360)
                        .scaleEffect(zoomAllowed ? 1.6 : 1)
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
                
                // ⏭️ زر السهم (يظهر بعد انتهاء الأنيميشن)
                if showArrow {
                    Button {
                        // ✅ افتحي المرحلة اللي بعدها
                        if progressGirl < 2 { progressGirl = 2 }
                        // ✅ رجعي لصفحة الباث
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .padding(22)
                            .background(
                                Circle().fill(
                                    LinearGradient(
                                        colors: [Color.color1, Color.color1],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            )
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
                
                // 1️⃣ تكبير المسموح
                withAnimation(.easeInOut(duration: 0.9)) {
                    zoomAllowed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        zoomAllowed = false
                    }
                }
                
                // 2️⃣ تكبير الممنوع
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
                
                // 3️⃣ إظهار زر السهم بعد انتهاء كل الأنيميشن
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
                    withAnimation(.easeInOut) {
                        showArrow = true
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        IhramPage_suha_girl()
    }
}
