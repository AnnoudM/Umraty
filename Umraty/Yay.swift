//
//  Yay!.swift
//  Umraty
//
//  Created by Shatha Ghayath Aljabal  on 04/02/2026.
//

import SwiftUI
import AVFoundation

// MARK: - مشغل الصوت
class GiftSoundManager {
    static let instance = GiftSoundManager()
    var player: AVAudioPlayer?

    func playYay() {
        guard let url = Bundle.main.url(forResource: "yaysound", withExtension: "mp3") else {
            print("❌ ملف الصوت غير موجود")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("❌ خطأ في تشغيل الصوت")
        }
    }
}

struct GiftView: View {
    @State private var isOpened = false
    @State private var startFalling = false

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height

            ZStack {
                // الخلفية
                Color(red: 0.85, green: 0.93, blue: 0.85)
                    .ignoresSafeArea()

                Image("background")
                    .resizable()
                    .opacity(0.2)
                    .ignoresSafeArea()

                // النص العلوي
                VStack {
                    Text("هناك هدية لك لحصولك على ٧ نجوم")
                        .font(.system(size: 30, weight: .bold))
                        .padding(.top, 100)

                    if !isOpened {
                        Text("اضغط على هديتك لفتحها")
                            .font(.system(size: 30, weight: .bold))
                            .padding(.top, 20)
                    }

                    Spacer()
                }
                .zIndex(5)

                // المفرقعات
                if isOpened {
                    ForEach(0..<15) { _ in
                        Image("fire")
                            .resizable()
                            .frame(width: 300, height: 300)
                            .brightness(-0.2)
                            .position(
                                x: CGFloat.random(in: 50...screenWidth - 50),
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

                // الهدية + زر الرجوع
                VStack(spacing: 30) {
                    if !isOpened {
                        Image("open")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 400)
                            .onTapGesture {
                                GiftSoundManager.instance.playYay()
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                                    isOpened = true
                                    startFalling = true
                                }
                            }
                    } else {
                        Image("هدية")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 450)
                            .transition(.scale.combined(with: .opacity))

                        // ✅ زر العودة للمجموعة
                        NavigationLink(
                            destination: SecondPage(selectedGender: .boy)
                        ) {
                            Text("العودة للمجموعة")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 60)
                                .background(Color("Color1"))   // ✅ نفس لون باقي الأزرار
                                .cornerRadius(20)
                                .shadow(radius: 5)
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

// MARK: - Preview
#Preview {
    NavigationStack {
        GiftView()
    }
}
