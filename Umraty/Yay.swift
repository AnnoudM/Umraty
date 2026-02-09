//
//  Yay!.swift
//  Umraty
//
//  Created by Shatha Ghayath Aljabal  on 04/02/2026.

import SwiftUI
import AVFoundation // مكتبة الصوت

// تعريف مشغل الصوت خارج الـ Struct لضمان كفاءة الأداء
var audioPlayer: AVAudioPlayer?

func playYaySound() {
    if let path = Bundle.main.path(forResource: "yaysound", ofType: "mp3") { // تأكد أن الصيغة mp3 أو wav
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("خطأ: تعذر تشغيل ملف الصوت")
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
                // 1. الخلفية
                Image("background").resizable()
                Color(red: 0.85, green: 0.93, blue: 0.85)
                    .ignoresSafeArea()

                // 2. النص العلوي
                VStack {
                    Text("هناك هدية لك لحصولك على ٧ نجوم")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.top, 160)
                    Text("اضغط على هديتك لفتحها")                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.top, 30)
                    Spacer()
                }
                .zIndex(5)

                // 3. المفرقعات
                if isOpened {
                    ForEach(0..<15) { i in
                        Image("fire")
                            .resizable()
                            .frame(width: 300, height: 300)
                            .brightness(-0.5)
                            .contrast(1.5)
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

                // 4. منطقة الهدية و Open
                ZStack {
                    if !isOpened {
                        Image("open")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 400)
                            .onTapGesture {
                                // تشغيل الصوت فور الضغط
                                playYaySound()
                                
                                withAnimation(.spring()) {
                                    isOpened = true
                                }
                                withAnimation {
                                    startFalling = true
                                }
                            }
                    } else {
                        Image("هدية")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 450)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .frame(width: screenWidth, height: screenHeight)

            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    GiftView()
}
