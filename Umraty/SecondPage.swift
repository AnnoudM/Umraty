//
//  SecondPage 2.swift
//  Umraty
//
//  Created by Ghaliah alsharif on 21/08/1447 AH.
//


import SwiftUI

struct SecondPage: View {

    let selectedGender: ChildGender

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            let circleSize = min(w, h) * 0.23
            let pillWidth  = circleSize * 1.7
            let pillHeight = circleSize * 1.05

            ZStack {
                Color(red: 0.94, green: 0.98, blue: 0.95)
                    .ignoresSafeArea()

                VStack(spacing: h * 0.08) {

                    HStack(spacing: w * 0.10) {

                        // ✅ Games → Quiz1_shatha
                        NavigationLink(destination: Quiz1_shatha()) {
                            SecondMenuCircleButton(
                                imageName: "image1 1",
                                title: "Games",
                                circleSize: circleSize,
                                pillWidth: pillWidth,
                                pillHeight: pillHeight,
                                imageScale: 1.20,
                                imageX: 3,
                                imageY: 0
                            )
                        }

                        NavigationLink(
                            destination: UmrahPathView(selectedGender: selectedGender)
                        ) {
                            SecondMenuCircleButton(
                                imageName: "image2",
                                title: "Umrah Education",
                                circleSize: circleSize,
                                pillWidth: pillWidth,
                                pillHeight: pillHeight,
                                imageScale: 1.90,
                                imageX: 3,
                                imageY: 0
                            )
                        }
                    }

                    NavigationLink(destination: Duaa()) {
                        SecondMenuCircleButton(
                            imageName: "image3",
                            title: "Supplication",
                            circleSize: circleSize,
                            pillWidth: pillWidth,
                            pillHeight: pillHeight,
                            imageScale: 1.90,
                            imageX: 3,
                            imageY: 0
                        )
                    }

                    Spacer()
                }
                .padding(.top, h * 0.12)
                .padding(.horizontal, w * 0.08)
            }
        }
    }
}


// MARK: - زر الدائرة
struct SecondMenuCircleButton: View {

    let imageName: String
    let title: LocalizedStringKey
    let circleSize: CGFloat
    let pillWidth: CGFloat
    let pillHeight: CGFloat

    let imageScale: CGFloat
    let imageX: CGFloat
    let imageY: CGFloat

    private var cleanName: String {
        imageName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: pillHeight / 2)
                    .fill(Color(red: 0.84, green: 0.93, blue: 0.86))
                    .frame(width: pillWidth, height: pillHeight)

                Circle()
                    .fill(Color(red: 0.86, green: 0.94, blue: 0.88))
                    .frame(width: circleSize, height: circleSize)

                Image(cleanName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: circleSize * 0.78, height: circleSize * 0.78)
                    .scaleEffect(imageScale)
                    .offset(x: imageX, y: imageY)
                    .allowsHitTesting(false)
            }

            Text(title)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(Color(red: 0.43, green: 0.59, blue: 0.57))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        SecondPage(selectedGender: .boy) // أو .girl حسب ChildGender عندك
    }
}
