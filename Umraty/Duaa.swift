//
//  Duaa.swift
//  Umraty
//
//  Created by Noura Alghamdi on 15/08/1447 AH.
//

import SwiftUI

struct Duaa: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.green.opacity(0.2)
                    .ignoresSafeArea()

                HStack(spacing: 40) {

                    NavigationLink {
                        GirlsDuaView()
                    } label: {
                        Image("Noura2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150)
                    }

                    NavigationLink {
                        BoysDuaView()
                    } label: {
                        Image("Mohammed2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150)
                    }
                }
            }
            .navigationTitle("الأدعية")
        }
    }
}

struct GirlsDuaView: View {
    var body: some View {
        ZStack {
            Color.pink.opacity(0.2)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {

                    SectionView(title: "🌸 الأذكار", items: [
                        "سبحان الله",
                        "الحمد لله",
                        "الله أكبر"
                    ])

                    SectionView(title: "🛡️ التحصين", items: [
                        "أعوذ بكلمات الله التامات من شر ما خلق"
                    ])

                    SectionView(title: "🤲 الأدعية", items: [
                        "اللهم احفظ نورة من كل سوء"
                    ])
                }
                .padding()
            }
        }
        .navigationTitle("أدعية البنات")
    }
}

struct BoysDuaView: View {
    var body: some View {
        ZStack {
            Color.blue.opacity(0.2)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {

                    SectionView(title: "💙 الأذكار", items: [
                        "سبحان الله",
                        "الحمد لله",
                        "الله أكبر"
                    ])

                    SectionView(title: "🛡️ التحصين", items: [
                        "أعوذ بكلمات الله التامات من شر ما خلق"
                    ])

                    SectionView(title: "🤲 الأدعية", items: [
                        "اللهم احفظ محمد من كل سوء"
                    ])
                }
                .padding()
            }
        }
        .navigationTitle("أدعية الأولاد")
    }
}

struct SectionView: View {
    let title: String
    let items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)

            ForEach(items, id: \.self) { item in
                Text("• \(item)")
                    .font(.body)
            }
        }
        .padding()
        .background(Color.white.opacity(0.85))
        .cornerRadius(15)
    }
}
#Preview {
    Duaa()
}
