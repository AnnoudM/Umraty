//
//  IhramPage-suha.swift
//  Umraty
//
//  Created by سهى الشهري on 14/08/1447 AH.
//

import SwiftUI

struct IhramPage_suha: View {
    
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
                            .scaleEffect(zoomForbidden ? 2: 1)
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
                    
                    // 👦 الطفل/الشخص
                    Image("بنت بدون حجاب")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 380)
                    
                    // ✅ المسموح
                    Image("حجاب البنت")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 360)
                        .scaleEffect(zoomAllowed ? 1.6: 1) // تكبير أقوى
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
                
                // الأسهم للتنقل (اختياري)
                HStack(spacing: 80) {
                    Image(systemName: "chevron.left")
                    Image(systemName: "chevron.right")
                }
                .font(.system(size: 34))
                .foregroundColor(.gray)
            }
            .padding(.horizontal, 40)
            .onAppear {
                // أولاً: تكبير ثم رجوع المسموح
                withAnimation(.easeInOut(duration: 0.9)) {
                    zoomAllowed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        zoomAllowed = false
                    }
                }
                
                // بعد انتهاء المسموح: تكبير ثم رجوع الممنوع
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { // 0.9 + 0.6
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
    IhramPage_suha()
}
