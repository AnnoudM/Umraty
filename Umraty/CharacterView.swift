




import SwiftUI

struct CharacterSelectionView: View {

    @AppStorage("selected_gender") private var savedGender: String = ""

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
                            .foregroundColor(Color("Color1"))
                            .minimumScaleFactor(0.7)

                        Spacer(minLength: geo.size.height * 0.08)

                        HStack(spacing: geo.size.width * 0.08) {

                            NavigationLink {
                                SecondPage(selectedGender: .boy)
                                    .onAppear {
                                        savedGender = ChildGender.boy.rawValue
                                    }
                            } label: {
                                VStack(spacing: 8) {
                                    Image("boy")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(
                                            width: geo.size.width * 0.35,
                                            height: geo.size.height * 0.45
                                        )
                                        .shadow(radius: 4)

                                    Text("محمد")
                                        .font(.system(size: geo.size.width * 0.045, weight: .medium))
                                        .foregroundColor(Color("Color1"))
                                }
                            }

                            NavigationLink {
                                SecondPage(selectedGender: .girl)
                                    .onAppear {
                                        savedGender = ChildGender.girl.rawValue
                                    }
                            } label: {
                                VStack(spacing: 8) {
                                    Image("girl")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(
                                            width: geo.size.width * 0.35,
                                            height: geo.size.height * 0.45
                                        )
                                        .shadow(radius: 4)

                                    Text("نورة")
                                        .font(.system(size: geo.size.width * 0.045, weight: .medium))
                                        .foregroundColor(Color("Color1"))
                                }
                            }
                        }

                        Spacer()
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    CharacterSelectionView()
}
