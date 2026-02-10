//
//  Quiz7-shatha.swift
//  Umraty
//
//  Created by Shatha Ghayath Aljabal  on 03/02/2026.
//

import SwiftUI
import AVFoundation

// MARK: - Model
struct DraggableItemQuiz7shatha: Identifiable {
    let id = UUID()
    let text: String
    let correctOrder: Int
    var offset: CGSize = .zero
    var isPlaced: Bool = false
    var isDragging: Bool = false
}

// MARK: - Quiz 7 View
struct Quiz7shathaView: View {
    @Environment(\.layoutDirection) var layoutDirection
    
    @State private var audioPlayer: AVAudioPlayer?
    @State private var items = [
        DraggableItemQuiz7shatha(text: "الطواف", correctOrder: 1),
        DraggableItemQuiz7shatha(text: "التحلل", correctOrder: 3),
        DraggableItemQuiz7shatha(text: "الإحرام", correctOrder: 0),
        DraggableItemQuiz7shatha(text: "السعي", correctOrder: 2)
    ].shuffled()
    
    @State private var targets: [String?] = [nil, nil, nil, nil]
    let numberImages = ["n1", "n2", "n3", "n4"]
    
    @State private var showStar = false
    @State private var starRotation = 0.0
    @State private var starScale = 1.0
    @State private var starPosition: CGPoint = .zero
    @State private var showNextButton = false

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .topTrailing) {
                    
                    // 1. الخلفية
                    Image("background").resizable().ignoresSafeArea()
                    Color(red: 0.85, green: 0.93, blue: 0.85).ignoresSafeArea()

                    // 2. النجوم الستة السابقة (الآن عند y: 260)
                    ZStack {
                        ForEach(0..<6) { i in
                            Image("star")
                                .frame(width: 250, height: 250)
                                .scaleEffect(0.2)
                                .position(x: (geometry.size.width / 2) - 210 + CGFloat(i * 70), y: 260)
                        }
                    }

                    // 3. محتوى السؤال الرئيسي
                    VStack {
                        HStack {
                            Spacer()
                            Image("s").resizable().scaledToFit().frame(width: 500)
                            Spacer()
                        }.padding(.horizontal).padding(.top, 100)

                        Text("رتب خطوات العمرة الصحيحة؟")
                            .font(.system(size: 30, weight: .bold))
                            .padding(.top, 220)

                        HStack(spacing: 60) {
                            // قطع السحب (الكلمات)
                            VStack(spacing: 40) {
                                ForEach(items.indices, id: \.self) { index in
                                    if !items[index].isPlaced {
                                        Text(items[index].text)
                                            .font(.system(size: 45, weight: .bold))
                                            .foregroundColor(.black)
                                            .frame(width: 230, height: 85)
                                            .background(Color.white.opacity(0.1)) // خلفية شفافة لسهولة اللمس
                                            .offset(items[index].offset)
                                            .zIndex(items[index].isDragging ? 100 : 1)
                                            .gesture(DragGesture(coordinateSpace: .global)
                                                .onChanged { value in
                                                    let multiplier: CGFloat = (layoutDirection == .rightToLeft) ? -1 : 1
                                                    items[index].offset = CGSize(width: value.translation.width * multiplier, height: value.translation.height)
                                                    items[index].isDragging = true
                                                }
                                                .onEnded { value in
                                                    items[index].isDragging = false
                                                    handleDrop(index: index, value: value, geometry: geometry)
                                                }
                                            )
                                    } else {
                                        Color.clear.frame(width: 230, height: 85)
                                    }
                                }
                            }
                            
                            // صناديق الإسقاط (الأرقام)
                            VStack(spacing: 30) {
                                ForEach(0..<4) { i in
                                    HStack(spacing: 15) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Color(red: 0.95, green: 0.7, blue: 0.6))
                                                .frame(width: 260, height: 95)
                                            if let placedText = targets[i] {
                                                Text(placedText).font(.system(size: 40, weight: .bold))
                                            }
                                        }
                                        Image(numberImages[i]).resizable().scaledToFit().frame(width: 60, height: 60)
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    
                    // صورة اسم المرحلة
                    Image("السؤال السابع")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                        .padding(.top, 40)
                        .padding(.trailing, 30)

                    // 4. النجمة السابعة (تظهر عند الحل الصحيح)
                    if showStar {
                        Image("star")
                            .frame(width: 250, height: 250)
                            .scaleEffect(starScale)
                            .rotationEffect(.degrees(starRotation))
                            .position(starPosition == .zero ? CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2) : starPosition)
                            .zIndex(500)
                            .onAppear {
                                playSound(named: "correctanswer")
                                starPosition = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                starScale = 2.0
                                withAnimation(.easeInOut(duration: 2.0)) { starRotation = 360 }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    withAnimation(.easeInOut(duration: 1.5)) {
                                        // الموضع الجديد بجانب النجوم الستة عند y: 260
                                        starPosition = CGPoint(x: (geometry.size.width / 2) + 210, y: 260)
                                        starScale = 0.2
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        withAnimation { showNextButton = true }
                                    }
                                }
                            }
                    }

                    // 5. زر استلام الهدية
                    if showNextButton {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                NavigationLink(destination: GiftView()) {
                                    Text("استلم هديتك")
                                        .font(.system(size: 30, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.vertical, 15)
                                        .padding(.horizontal, 40)
                                        .background(Color.orange)
                                        .cornerRadius(20)
                                        .shadow(radius: 5)
                                }
                                .padding(.trailing, 50).padding(.bottom, 50)
                            }
                        }
                        .zIndex(501)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // منطق الإسقاط والتحقق
    func handleDrop(index: Int, value: DragGesture.Value, geometry: GeometryProxy) {
        let correctIdx = items[index].correctOrder
        let dropLocation = value.location
        let screenWidth = geometry.size.width
        let screenHeight = geometry.size.height
        
        let isRightToLeft = layoutDirection == .rightToLeft
        // تحديد منطقة الإسقاط بناءً على اتجاه اللغة
        let isInDropZone = isRightToLeft ? (dropLocation.x < screenWidth * 0.5) : (dropLocation.x > screenWidth * 0.5)

        if isInDropZone {
            var targetIndex: Int? = nil
            // تقسيم الشاشة طولياً لتحديد الصندوق
            if dropLocation.y < screenHeight * 0.45 { targetIndex = 0 }
            else if dropLocation.y < screenHeight * 0.58 { targetIndex = 1 }
            else if dropLocation.y < screenHeight * 0.72 { targetIndex = 2 }
            else { targetIndex = 3 }

            if targetIndex == correctIdx {
                withAnimation(.spring()) {
                    targets[correctIdx] = items[index].text
                    items[index].isPlaced = true
                }
                if !targets.contains(nil) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation { showStar = true }
                    }
                }
            } else {
                playSound(named: "incorrectanswer")
                withAnimation(.spring()) { items[index].offset = .zero }
            }
        } else {
            withAnimation(.spring()) { items[index].offset = .zero }
        }
    }
    
    func playSound(named fileName: String) {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch { print("Sound Error") }
        }
    }
}
#Preview {
    Quiz7shathaView()
}
