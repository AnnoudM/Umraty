//
//  Sai.swift
//  Umraty
//
//  Created by Noura Alghamdi on 14/08/1447 AH.
//



internal import Combine
import SwiftUI
import AVFoundation

struct Sai: View {
    
    // الرجل
    @State private var manProgress: CGFloat = 0
    @State private var manRounds = 0
    @State private var manGoingForward = true
    @State private var manAuto = false
    @State private var manFinished = false
    @State private var manSpoken = false   // لمنع تكرار الصوت
    
    // المرأة
    @State private var womanProgress: CGFloat = 0
    @State private var womanRounds = 0
    @State private var womanGoingForward = true
    @State private var womanAuto = false
    @State private var womanFinished = false
    @State private var womanSpoken = false // لمنع تكرار الصوت
    
    // الصوت
    let speaker = AVSpeechSynthesizer()
    
    // اللون الزيتي الفاتح
    let lightOlive = Color(red: 0.6, green: 0.65, blue: 0.4)
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(red: 0.93, green: 0.99, blue: 0.93)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("السعي بين الصفا والمروة")
                        .font(.system(size: geo.size.width * 0.06, weight: .bold))
                        .foregroundColor(lightOlive)
                    
                    HStack(spacing: geo.size.width * 0.1) {
                        VStack {
                            Text("الرجل")
                                .font(.system(size: geo.size.width * 0.045, weight: .bold))
                                .foregroundColor(lightOlive)
                            Text(manFinished ? "تم السعي" : "الأشواط: \(manRounds)")
                                .foregroundColor(lightOlive)
                        }
                        
                        VStack {
                            Text("المرأة")
                                .font(.system(size: geo.size.width * 0.045, weight: .bold))
                                .foregroundColor(lightOlive)
                            Text(womanFinished ? "تم السعي" : "الأشواط: \(womanRounds)")
                                .foregroundColor(lightOlive)
                        }
                    }
                    
                    ZStack {
                        VStack {
                            Text("الصفا")
                                .font(.system(size: geo.size.width * 0.055, weight: .bold))
                                .foregroundColor(lightOlive)
                            Image("mountain")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 0.3)
                        }
                        .position(x: geo.size.width * 0.07, y: geo.size.height * 0.28)
                        
                        VStack {
                            Text("المروة")
                                .font(.system(size: geo.size.width * 0.055, weight: .bold))
                                .foregroundColor(lightOlive)
                            Image("mountain")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 0.3)
                        }
                        .position(x: geo.size.width * 0.93, y: geo.size.height * 0.28)
                        
                        Rectangle()
                            .fill(Color.green.opacity(0.5))
                            .frame(width: geo.size.width * 0.85, height: geo.size.height * 0.1)
                            .position(x: geo.size.width * 0.5, y: geo.size.height * 0.32)
                        
                        Image("manWalk")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width * 0.11)
                            .scaleEffect(x: manGoingForward ? 1 : -1, y: 1)
                            .position(
                                x: lerp(start: geo.size.width * 0.14, end: geo.size.width * 0.86, progress: manProgress),
                                y: geo.size.height * 0.4
                            )
                        
                        Image("womanWalk")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width * 0.11)
                            .scaleEffect(x: womanGoingForward ? 1 : -1, y: 1)
                            .position(
                                x: lerp(start: geo.size.width * 0.14, end: geo.size.width * 0.86, progress: womanProgress),
                                y: geo.size.height * 0.5
                            )
                    }
                    .frame(height: geo.size.height * 0.55)
                    
                    HStack(spacing: geo.size.width * 0.15) {
                        VStack {
                            Button {
                                if !manFinished { manAuto.toggle() }
                            } label: {
                                Text(manAuto ? "إيقاف الرجل" : "ابدأ الرجل")
                                    .foregroundColor(lightOlive)
                                    .padding()
                                    .frame(width: geo.size.width * 0.4)
                                    .background(Color.black.opacity(0.2))
                            }
                            
                            Button {
                                if !womanFinished { womanAuto.toggle() }
                            } label: {
                                Text(womanAuto ? "إيقاف المرأة" : "ابدأ المرأة")
                                    .foregroundColor(lightOlive)
                                    .padding()
                                    .frame(width: geo.size.width * 0.4)
                                    .background(Color.black.opacity(0.2))
                            }
                        }
                    }
                    
                    HStack(spacing: geo.size.width * 0.15) {
                        VStack {
                            Text("تحريك الرجل")
                                .foregroundColor(lightOlive)
                            HStack {
                                Button { moveMan(by: -0.05) } label: {
                                    Image(systemName: "arrow.left")
                                        .foregroundColor(lightOlive)
                                        .frame(width: 60, height: 50)
                                        .background(Color.black.opacity(0.2))
                                }
                                Button { moveMan(by: 0.05) } label: {
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(lightOlive)
                                        .frame(width: 60, height: 50)
                                        .background(Color.black.opacity(0.2))
                                }
                            }
                        }
                        
                        VStack {
                            Text("تحريك المرأة")
                                .foregroundColor(lightOlive)
                            HStack {
                                Button { moveWoman(by: -0.05) } label: {
                                    Image(systemName: "arrow.left")
                                        .foregroundColor(lightOlive)
                                        .frame(width: 60, height: 50)
                                        .background(Color.black.opacity(0.2))
                                }
                                Button { moveWoman(by: 0.05) } label: {
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(lightOlive)
                                        .frame(width: 60, height: 50)
                                        .background(Color.black.opacity(0.2))
                                }
                            }
                        }
                    }
                }
            }
            .onReceive(Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()) { _ in
                if manAuto && !manFinished {
                    let manSpeed: CGFloat = isInGreenZone(progress: manProgress) ? 0.012 : 0.006
                    moveMan(by: manSpeed)
                }
                if womanAuto && !womanFinished {
                    moveWoman(by: 0.003)
                }
            }
        }
    }
    
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ar-SA")
        utterance.rate = 0.5
        speaker.speak(utterance)
    }
    
    func lerp(start: CGFloat, end: CGFloat, progress: CGFloat) -> CGFloat {
        start + (end - start) * progress
    }
    
    func isInGreenZone(progress: CGFloat) -> Bool {
        progress > 0.3 && progress < 0.7
    }
    
    func moveMan(by amount: CGFloat) {
        manProgress += manGoingForward ? amount : -amount
        
        if manProgress >= 1 || manProgress <= 0 {
            manProgress = 0
            manGoingForward.toggle()
            manRounds += 1
        }
        
        if manRounds >= 7 && !manSpoken {
            manFinished = true
            manAuto = false
            speak("تم الانتهاء من السعي للرجل")
            manSpoken = true
        }
    }
    
    func moveWoman(by amount: CGFloat) {
        womanProgress += womanGoingForward ? amount : -amount
        
        if womanProgress >= 1 || womanProgress <= 0 {
            womanProgress = 0
            womanGoingForward.toggle()
            womanRounds += 1
        }
        
        if womanRounds >= 7 && !womanSpoken {
            womanFinished = true
            womanAuto = false
            speak("تم الانتهاء من السعي للمرأة")
            womanSpoken = true
        }
    }
}

#Preview {
    Sai()
}
