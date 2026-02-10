//
//  Yay!.swift
//  Umraty
//
//  Created by Shatha Ghayath Aljabal  on 04/02/2026.

import SwiftUI
import AVFoundation

// MARK: - مشغل الصوت المطور
class GiftSoundManager {
    static let instance = GiftSoundManager()
    var player: AVAudioPlayer?

    func playYay() {
        // تأكدي أن اسم الملف في المشروع هو "yaysound" وبصيغة mp3
        guard let url = Bundle.main.url(forResource: "yaysound", withExtension: "mp3") else {
            print("❌ ملف الصوت غير موجود")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("❌ خطأ في تشغيل الصوت: \(error.localizedDescription)")
        }
    }
}

struct GiftView: View {
    @State private var isOpened = false
    @State private var startFalling = false
    @Environment(\.dismiss) var dismiss // للرجوع للصفحة السابقة
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            ZStack {
                // 1. الخلفية
                Color(red: 0.85, green: 0.93, blue: 0.85)
                    .ignoresSafeArea()
                Image("background")
                    .resizable()
                    .opacity(0.2)
                    .ignoresSafeArea()

                // 2. النصوص العلوية
                VStack {
                    Text("هناك هدية لك لحصولك على ٧ نجوم")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.top, 100)
                    
                    if !isOpened {
                        Text("اضغط على هديتك لفتحها")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.top, 20)
                    }
                    Spacer()
                }
                .zIndex(5)

                // 3. المفرقعات
                if isOpened {
                    ForEach(0..<15) { i in
                        Image("fire")
                            .resizable()
                            .frame(width: 300, height: 300)
                            .brightness(-0.2)
                            .position(
                                x: CGFloat.random(in: 50...screenWidth-50),
                                y: startFalling ? screenHeight + 200 : -200
                            )
                            .animation(
                                Animation.linear(duration: Double.random(in: 3.0...4.5))
                                    .repeatForever(autoreverses: false)
                                    .delay(Double.random(in: 0...2.5)),
                                value: startFalling
                            )
                    }
                }

                // 4. منطقة الهدية وزر الرجوع
                VStack(spacing: 30) {
                    if !isOpened {
                        Image("open")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 400)
                            .onTapGesture {
                                GiftSoundManager.instance.playYay() // تشغيل الصوت
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                                    isOpened = true
                                    startFalling = true
                                }
                            }
                    } else {
                        // محتوى ما بعد فتح الهدية
                        Image("هدية")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 450)
                            .transition(.asymmetric(
                                insertion: .scale(scale: 0.1).combined(with: .opacity),
                                removal: .opacity
                            ))
                        
                        // زر العودة الذي طلبتيه
                        Button(action: {
                            dismiss() // يغلق صفحة الهدية ويعود لـ SecondPage
                        }) {
                            HStack {
                                Image(systemName: "arrow.right.circle.fill")
                                Text("العودة للمجموعة")
                            }
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.vertical, 15)
                            .padding(.horizontal, 40)
                            .background(Color(red: 0.43, green: 0.59, blue: 0.57))
                            .cornerRadius(20)
                            .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 5)
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .frame(width: screenWidth, height: screenHeight)
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

// MARK: - معاينة الكود
#Preview {
    NavigationStack {
        GiftView()
    }
}
