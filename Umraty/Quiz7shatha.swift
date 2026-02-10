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
    private let spaceName = "quiz7Space"

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

    @State private var dropFrames: [CGRect] = Array(repeating: .zero, count: 4)

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .topTrailing) {

                    // الخلفية
                    Color(red: 0.85, green: 0.93, blue: 0.85).ignoresSafeArea()
                    Image("background")
                        .resizable()
                        .opacity(0.2)
                        .ignoresSafeArea()

                    // النجوم الستة السابقة
                    ZStack {
                        ForEach(0..<6) { i in
                            Image("star")
                                .frame(width: 250, height: 250)
                                .scaleEffect(0.2)
                                .position(x: (geometry.size.width / 2) - 210 + CGFloat(i * 70), y: 230) // ✅ رفعناها شوي
                        }
                    }
                    .zIndex(10)

                    // اسم السؤال (يمين فوق)
                    Image("السؤال السابع")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                        .padding(.top, 35)
                        .padding(.trailing, 30)
                        .zIndex(20)

                    // المحتوى
                    VStack(spacing: 0) {

                        // الشعار + السؤال (نخليهم أعلى ومرتبين)
                        VStack(spacing: 18) {
                            Image("s")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 500)
                                .padding(.top, 90)

                            Text("رتب خطوات العمرة الصحيحة؟")
                                .font(.system(size: 32, weight: .bold))
                        }
                        .padding(.top, 40)   // ✅ نزّلناهم تحت النجوم بشكل واضح

                        Spacer(minLength: 25)

                        // ساحة السحب والإسقاط
                        HStack(spacing: 60) {

                            // الكلمات
                            VStack(spacing: 28) {
                                ForEach(items.indices, id: \.self) { index in
                                    if !items[index].isPlaced {
                                        Text(items[index].text)
                                            .font(.system(size: 42, weight: .bold))
                                            .foregroundColor(.black)
                                            .frame(width: 230, height: 85)
                                            .background(Color.white.opacity(0.25))
                                            .cornerRadius(18)
                                            .offset(items[index].offset)
                                            .zIndex(items[index].isDragging ? 100 : 1)
                                            .gesture(
                                                DragGesture(coordinateSpace: .named(spaceName))
                                                    .onChanged { value in
                                                        let multiplier: CGFloat = (layoutDirection == .rightToLeft) ? -1 : 1
                                                        items[index].offset = CGSize(
                                                            width: value.translation.width * multiplier,
                                                            height: value.translation.height
                                                        )
                                                        items[index].isDragging = true
                                                    }
                                                    .onEnded { value in
                                                        items[index].isDragging = false
                                                        handleDrop(index: index, value: value)
                                                    }
                                            )
                                    } else {
                                        Color.clear.frame(width: 230, height: 85)
                                    }
                                }
                            }

                            // صناديق الإسقاط
                            VStack(spacing: 22) {
                                ForEach(0..<4) { i in
                                    HStack(spacing: 15) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Color(red: 0.95, green: 0.7, blue: 0.6))
                                                .frame(width: 260, height: 95)

                                            if let placedText = targets[i] {
                                                Text(placedText)
                                                    .font(.system(size: 38, weight: .bold))
                                                    .foregroundColor(.black)
                                            }
                                        }
                                        .background(
                                            GeometryReader { boxGeo in
                                                Color.clear
                                                    .onAppear { dropFrames[i] = boxGeo.frame(in: .named(spaceName)) }
                                                    .onChange(of: boxGeo.size) { _ in
                                                        dropFrames[i] = boxGeo.frame(in: .named(spaceName))
                                                    }
                                            }
                                        )

                                        Image(numberImages[i])
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60)
                                    }
                                }
                            }
                        }

                        // ✅ هذا أهم سطر عشان الزر ما يلصق بالمربعات
                        Spacer(minLength: 140)
                    }
                    .frame(maxWidth: .infinity)

                    // النجمة السابعة
                    if showStar {
                        Image("star")
                            .frame(width: 250, height: 250)
                            .scaleEffect(starScale)
                            .rotationEffect(.degrees(starRotation))
                            .position(starPosition == .zero
                                      ? CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                      : starPosition)
                            .zIndex(500)
                            .onAppear {
                                playSound(named: "correctanswer")
                                starPosition = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                starScale = 2.0

                                withAnimation(.easeInOut(duration: 2.0)) { starRotation = 360 }

                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    withAnimation(.easeInOut(duration: 1.5)) {
                                        starPosition = CGPoint(x: (geometry.size.width / 2) + 210, y: 230) // ✅ نفس y النجوم
                                        starScale = 0.2
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        withAnimation { showNextButton = true }
                                    }
                                }
                            }
                    }

                }
                .coordinateSpace(name: spaceName)
                // ✅ زر الهدية تحت بشكل ثابت وبمسافة مريحة
                .safeAreaInset(edge: .bottom) {
                    if showNextButton {
                        NavigationLink(destination: GiftView()) {
                            Text("استلم هديتك")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 60)
                                .background(Color("Color1"))
                                .cornerRadius(20)
                                .shadow(radius: 5)
                        }
                        .padding(.bottom, 25) // ✅ مسافة عن حافة الشاشة
                        .padding(.top, 10)    // ✅ مسافة عن المربعات
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Drop Logic
    func handleDrop(index: Int, value: DragGesture.Value) {
        let correctIdx = items[index].correctOrder
        let dropPoint = value.location

        let hit = dropFrames.firstIndex { $0.insetBy(dx: -25, dy: -25).contains(dropPoint) }

        guard let hitBox = hit else {
            withAnimation(.spring()) { items[index].offset = .zero }
            return
        }

        if targets[hitBox] != nil {
            playSound(named: "incorrectanswer")
            withAnimation(.spring()) { items[index].offset = .zero }
            return
        }

        if hitBox == correctIdx {
            withAnimation(.spring()) {
                targets[correctIdx] = items[index].text
                items[index].isPlaced = true
                items[index].offset = .zero
            }

            if !targets.contains(nil) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation { showStar = true }
                }
            }
        } else {
            playSound(named: "incorrectanswer")
            withAnimation(.spring()) { items[index].offset = .zero }
        }
    }

    func playSound(named fileName: String) {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Sound Error")
            }
        }
    }
}

#Preview {
    Quiz7shathaView()
}
