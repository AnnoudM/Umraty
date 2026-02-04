//
//  FirstSai.swift
//  Umraty
//
//  Created by Noura Alghamdi on 14/08/1447 AH.
//

import SwiftUI

struct FirstSai: View {
    // الحوارات
    let dialogues: [(speaker: String, text: String)] = [
        ("محمد", "يا نورة، هل تعرفين لماذا نسعى بين الصفا والمروة؟"),
        ("نورة", "لا يا محمد، لماذا؟"),
        ("محمد", "لأن السعي قصة جميلة بدأت مع السيدة هاجر. كانت تبحث عن الماء لابنها إسماعيل."),
        ("نورة", "وماذا فعلت؟"),
        ("محمد", "مشت بين جبل الصفا وجبل المروة سبع مرات. ثم ظهر ماء زمزم."),
        ("نورة", "إذن نحن نسعى مثلها؟"),
        ("محمد", "نعم يا نورة، نسعى مثلها في الحج والعمرة لنطيع الله ونتذكر قصتها الجميلة")
    ]
    
    @State private var currentIndex = 0
    @State private var stage: Int = 0 // 0=حوار, 1=زر اللعبة, 2=اللعبة
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.green.opacity(0.2).edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    Text("تعلم السعي")
                        .font(.system(size: geo.size.width * 0.08, weight: .bold))
                        .foregroundColor(.olive)
                    
                    // المرحلة 0: الحوار
                    if stage == 0 {
                        HStack(spacing: geo.size.width * 0.1) { // مسافة متساوية
                            // محمد
                            VStack(alignment: .leading, spacing: 10) {
                                Image("Mohammed")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: geo.size.height * 0.3)
                                
                                if currentIndex < dialogues.count && dialogues[currentIndex].0 == "محمد" {
                                    Text(dialogues[currentIndex].1)
                                        .foregroundColor(.olive)
                                        .font(.system(size: 28, weight: .semibold)) // تكبير الخط
                                        .padding()
                                        .background(Color.green.opacity(0.1))
                                        .cornerRadius(10)
                                        .frame(maxWidth: geo.size.width * 0.45, alignment: .leading) // التوسع حسب الشاشة
                                        .minimumScaleFactor(0.5) // لتصغير النص إذا طويل جدًا
                                        .lineLimit(nil) // السماح لأكثر من سطر
                                        .transition(.opacity)
                                        .animation(.easeInOut(duration: 0.5), value: currentIndex)
                                }
                            }
                            
                            Spacer() // يساعد على تساوي المسافات
                            
                            // نورة
                            VStack(alignment: .trailing, spacing: 10) {
                                Image("Noura")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: geo.size.height * 0.3)
                                
                                if currentIndex < dialogues.count && dialogues[currentIndex].0 == "نورة" {
                                    Text(dialogues[currentIndex].1)
                                        .foregroundColor(.olive)
                                        .font(.system(size: 28, weight: .semibold)) // تكبير الخط
                                        .padding()
                                        .background(Color.green.opacity(0.1))
                                        .cornerRadius(10)
                                        .frame(maxWidth: geo.size.width * 0.45, alignment: .trailing) // التوسع حسب الشاشة
                                        .minimumScaleFactor(0.5) // لتصغير النص إذا طويل جدًا
                                        .lineLimit(nil)
                                        .transition(.opacity)
                                        .animation(.easeInOut(duration: 0.5), value: currentIndex)
                                }
                            }
                        }
                        .frame(width: geo.size.width * 0.95)
                    }
                    
                    // المرحلة 1: زر بدء اللعبة
                    if stage == 1 {
                        Button(action: { stage = 2 }) {
                            Text("ابدأ السعي")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding()
                                .background(Color.olive)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .transition(.opacity)
                        .animation(.easeInOut, value: stage)
                    }
                    
                    // المرحلة 2: اللعبة
                    if stage == 2 {
                        Sai()
                            .frame(height: geo.size.height * 0.75)
                            .transition(.opacity)
                            .animation(.easeInOut, value: stage)
                    }
                }
                .padding()
            }
            .onAppear { showNextDialogue() }
        }
    }
    
    func showNextDialogue() {
        if currentIndex < dialogues.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) { // مدة أطول لكل جملة
                currentIndex += 1
                if currentIndex < dialogues.count {
                    showNextDialogue()
                } else {
                    stage = 1 // بعد انتهاء الحوار → زر اللعبة
                }
            }
        }
    }
}

// اللون الزيتوني
extension Color {
    static let olive = Color(red: 128/255, green: 128/255, blue: 0/255)
}

struct FirstSai_Previews: PreviewProvider {
    static var previews: some View {
        FirstSai()
    }
}
