import SwiftUI

struct CharacterSelectionView: View {
    
    @State private var path: [ChildGender] = []
    
    var body: some View {
        NavigationStack(path: $path) {
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
                            Button {
                                path.append(.boy)
                            } label: {
                                Image("boy")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(
                                        width: geo.size.width * 0.35,
                                        height: geo.size.height * 0.45
                                    )
                                    .shadow(radius: 4)
                                    .scaleEffect(0.97)
                            }
                            
                            Button {
                                path.append(.girl)
                            } label: {
                                Image("girl")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(
                                        width: geo.size.width * 0.35,
                                        height: geo.size.height * 0.45
                                    )
                                    .shadow(radius: 4)
                                    .scaleEffect(0.97)
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
            .navigationDestination(for: ChildGender.self) { gender in
                UmrahPathView(selectedGender: gender)
            }
        }
    }
}

#Preview {
    CharacterSelectionView()
}
