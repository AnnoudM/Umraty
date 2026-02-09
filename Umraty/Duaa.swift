

import SwiftUI

struct Duaa: View {
    
    enum DuaaType {
        case morning
        case evening
    }
    
    @State private var selectedType: DuaaType = .morning
    @State private var currentIndex = 0
    @State private var counter = 0
    
    // أذكار الصباح
    var morningAthkar: [(String, Int)] {
        [
            (NSLocalizedString("dhikr_morning_1", comment: ""), 1),
            (NSLocalizedString("dhikr_morning_2", comment: ""), 1),
            (NSLocalizedString("dhikr_morning_3", comment: ""), 1),
            (NSLocalizedString("dhikr_morning_surah_1", comment: ""), 3),
            (NSLocalizedString("dhikr_morning_surah_2", comment: ""), 3),
            (NSLocalizedString("dhikr_morning_surah_3", comment: ""), 3)
        ]
    }
    
    // أذكار المساء
    var eveningAthkar: [(String, Int)] {
        [
            (NSLocalizedString("dhikr_evening_1", comment: ""), 1),
            (NSLocalizedString("dhikr_evening_2", comment: ""), 3),
            (NSLocalizedString("dhikr_evening_3", comment: ""), 3),
            (NSLocalizedString("dhikr_evening_surah_1", comment: ""), 3),
            (NSLocalizedString("dhikr_evening_surah_2", comment: ""), 3),
            (NSLocalizedString("dhikr_evening_surah_3", comment: ""), 3)
        ]
    }
    
    var currentAthkar: [(String, Int)] {
        selectedType == .morning ? morningAthkar : eveningAthkar
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.85, green: 0.93, blue: 0.85)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                HStack(spacing: 30) {
                    Button {
                        selectedType = .morning
                        resetAll()
                    } label: {
                        VStack {
                            Image(systemName: "sun.max.fill")
                                .font(.largeTitle)
                            Text("أذكار الصباح")
                                .font(.title2)
                        }
                        .foregroundColor(Color(red: 0.35, green: 0.45, blue: 0.25))
                    }
                    
                    Button {
                        selectedType = .evening
                        resetAll()
                    } label: {
                        VStack {
                            Image(systemName: "moon.fill")
                                .font(.largeTitle)
                            Text("أذكار المساء")
                                .font(.title2)
                        }
                        .foregroundColor(Color(red: 0.35, green: 0.45, blue: 0.25))
                    }
                }
                
                Spacer()
                
                Image(selectedType == .morning ? "Butterfly" : "Bird")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                
                // النصوص الآن تأخذ اللون من ملف الألوان color1
                Text(currentAthkar[currentIndex].0)
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .foregroundColor(Color("Color1"))
                
                Button {
                    if counter < currentAthkar[currentIndex].1 {
                        counter += 1
                    }
                    
                    if counter == currentAthkar[currentIndex].1 {
                        counter = 0
                        if currentIndex < currentAthkar.count - 1 {
                            currentIndex += 1
                        } else {
                            currentIndex = 0
                        }
                    }
                    
                } label: {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.7, green: 0.85, blue: 0.7))
                        .frame(width: 180, height: 80)
                        .overlay(
                            Text("\(counter) / \(currentAthkar[currentIndex].1)")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Color(red: 0.35, green: 0.45, blue: 0.25))
                        )
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    func resetAll() {
        currentIndex = 0
        counter = 0
    }
}

#Preview {
    Duaa()
}
