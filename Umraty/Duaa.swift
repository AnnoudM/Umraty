//
//  Duaa.swift
//  Umraty
//
//  Created by Noura Alghamdi on 16/08/1447 AH.
//

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
    let morningAthkar: [(String, Int)] = [
        ("أصبحنا وأصبح الملك لله", 1),
        ("اللهم بك أصبحنا وبك أمسينا وبك نحيا وبك نموت وإليك النشور", 1),
        ("رضيت بالله ربًا وبالإسلام دينًا وبمحمد ﷺ نبيًا", 1),

        ("""
بِسْمِ اللهِ الرَّحْمنِ الرَّحِيم
قُلْ هُوَ ٱللَّهُ أَحَدٌ،
ٱللَّهُ ٱلصَّمَدُ،
لَمْ يَلِدْ وَلَمْ يُولَدْ،
وَلَمْ يَكُن لَّهُۥ كُفُوًا أَحَدٌ
""", 3),

        ("""
بِسْمِ اللهِ الرَّحْمنِ الرَّحِيم
قُلْ أَعُوذُ بِرَبِّ ٱلْفَلَقِ،
مِن شَرِّ مَا خَلَقَ،
وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ،
وَمِن شَرِّ ٱلنَّفَّٰثَٰتِ فِى ٱلْعُقَدِ،
وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ
""", 3),

        ("""
بِسْمِ اللهِ الرَّحْمنِ الرَّحِيم
قُلْ أَعُوذُ بِرَبِّ ٱلنَّاسِ،
مَلِكِ ٱلنَّاسِ،
إِلَٰهِ ٱلنَّاسِ،
مِن شَرِّ ٱلْوَسْوَاسِ ٱلْخَنَّاسِ،
ٱلَّذِى يُوَسْوِسُ فِى صُدُورِ ٱلنَّاسِ،
مِنَ ٱلْجِنَّةِ وَٱلنَّاسِ
""", 3),

        ("""
اللَّهُ لا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ
لا تَأْخُذُهُ سِنَةٌ وَلا نَوْمٌ
لَهُ مَا فِي السَّمَوَاتِ وَمَا فِي الأَرْضِ
مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ
يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ
وَلا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ
وَسِعَ كُرْسِيُّهُ السَّمَوَاتِ وَالأَرْضَ
وَلا يَئُودُهُ حِفْظُهُمَا
وَهُوَ الْعَلِيُّ الْعَظِيمُ
""", 1)
    ]
    
    // أذكار المساء (الأذكار مختلفة – السور نفسها)
    let eveningAthkar: [(String, Int)] = [
        ("اللهم بك أمسينا وبك أصبحنا وبك نحيا وبك نموت وإليك النشور", 1),
        ("أعوذ بكلمات الله التامات من شر ما خلق", 3),
        ("بسم الله الذي لا يضر مع اسمه شيء في الأرض ولا في السماء وهو السميع العليم", 3),
        ("اللهم ما أمس بي من نعمة أو بأحد من خلقك فمنك وحدك لا شريك لك فلك الحمد ولك الشكر", 1),

        ("""
بِسْمِ اللهِ الرَّحْمنِ الرَّحِيم
قُلْ هُوَ ٱللَّهُ أَحَدٌ،
ٱللَّهُ ٱلصَّمَدُ،
لَمْ يَلِدْ وَلَمْ يُولَدْ،
وَلَمْ يَكُن لَّهُۥ كُفُوًا أَحَدٌ
""", 3),

        ("""
بِسْمِ اللهِ الرَّحْمنِ الرَّحِيم
قُلْ أَعُوذُ بِرَبِّ ٱلْفَلَقِ،
مِن شَرِّ مَا خَلَقَ،
وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ،
وَمِن شَرِّ ٱلنَّفَّٰثَٰتِ فِى ٱلْعُقَدِ،
وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ
""", 3),

        ("""
بِسْمِ اللهِ الرَّحْمنِ الرَّحِيم
قُلْ أَعُوذُ بِرَبِّ ٱلنَّاسِ،
مَلِكِ ٱلنَّاسِ،
إِلَٰهِ ٱلنَّاسِ،
مِن شَرِّ ٱلْوَسْوَاسِ ٱلْخَنَّاسِ،
ٱلَّذِى يُوَسْوِسُ فِى صُدُورِ ٱلنَّاسِ،
مِنَ ٱلْجِنَّةِ وَٱلنَّاسِ
""", 3),

        ("""
اللَّهُ لا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ
لا تَأْخُذُهُ سِنَةٌ وَلا نَوْمٌ
لَهُ مَا فِي السَّمَوَاتِ وَمَا فِي الأَرْضِ
مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ
يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ
وَلا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ
وَسِعَ كُرْسِيُّهُ السَّمَوَاتِ وَالأَرْضَ
وَلا يَئُودُهُ حِفْظُهُمَا
وَهُوَ الْعَلِيُّ الْعَظِيمُ
""", 1)
    ]
    
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
                
                Text(currentAthkar[currentIndex].0)
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .foregroundColor(Color(red: 0.35, green: 0.45, blue: 0.25))
                
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
