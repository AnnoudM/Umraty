import SwiftUI

struct CharacterSelectionView: View {

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    Color(red: 0.85, green: 0.93, blue: 0.85)
                        .ignoresSafeArea()

                    VStack {
                        Spacer(minLength: geo.size.height * 0.08)

                        Text("اختر شخصيتك")
                            .font(.system(size: geo.size.width * 0.07, weight: .bold))
                            .foregroundColor(.black)
                            .minimumScaleFactor(0.7)

                        Spacer(minLength: geo.size.height * 0.08)

                        HStack(spacing: geo.size.width * 0.08) {

                            NavigationLink(value: ChildGender.boy) {
                                Image("boy")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geo.size.width * 0.35,
                                           height: geo.size.height * 0.45)
                                    .shadow(radius: 4)
                            }

                            NavigationLink(value: ChildGender.girl) {
                                Image("girl")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geo.size.width * 0.35,
                                           height: geo.size.height * 0.45)
                                    .shadow(radius: 4)
                            }
                        }

                        Spacer()
                    }
                }
            }
            .navigationDestination(for: ChildGender.self) { gender in
                SecondPage(selectedGender: gender)
            }
        }
    }
}

#Preview {
    CharacterSelectionView()
}
