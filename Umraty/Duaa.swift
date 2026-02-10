

import SwiftUI
import AVFoundation

struct Duaa: View {

    enum DuaaType {
        case morning
        case evening
    }

    @State private var selectedType: DuaaType = .morning
    @State private var currentIndex = 0
    @State private var counter = 0
    @State private var audioPlayer: AVAudioPlayer?

    // MARK: - Morning Athkar
    let morningAthkar: [(String, Int)] = [
        (NSLocalizedString("dhikr_morning_1", comment: ""), 1),
        (NSLocalizedString("dhikr_morning_2", comment: ""), 1),
        (NSLocalizedString("dhikr_morning_3", comment: ""), 1),
        (NSLocalizedString("dhikr_morning_surah_1", comment: ""), 3),
        (NSLocalizedString("dhikr_morning_surah_2", comment: ""), 3),
        (NSLocalizedString("dhikr_morning_surah_3", comment: ""), 3)
    ]

    // MARK: - Evening Athkar
    let eveningAthkar: [(String, Int)] = [
        (NSLocalizedString("dhikr_evening_1", comment: ""), 1),
        (NSLocalizedString("dhikr_evening_2", comment: ""), 1),
        (NSLocalizedString("dhikr_evening_3", comment: ""), 1),
        (NSLocalizedString("dhikr_evening_surah_1", comment: ""), 3),
        (NSLocalizedString("dhikr_evening_surah_2", comment: ""), 3),
        (NSLocalizedString("dhikr_evening_surah_3", comment: ""), 3)
    ]

    var currentAthkar: [(String, Int)] {
        selectedType == .morning ? morningAthkar : eveningAthkar
    }

    // MARK: - Audio mapping (MORNING + EVENING)
    var currentAudioName: String? {
        switch selectedType {

        case .morning:
            switch currentIndex {
            case 0: return "morning_1"
            case 1: return "morning_2"
            case 2: return "morning_3"
            case 3: return "morning_surah_1"
            case 4: return "morning_surah_2"
            case 5: return "morning_surah_3"
            default: return nil
            }

        case .evening:
            switch currentIndex {
            case 0: return "dhikr_evening_1"
            case 1: return "dhikr_evening_2"
            case 2: return "dhikr_evening_3"
            case 3: return "evening_surah_1"
            case 4: return "evening_surah_2"
            case 5: return "evening_surah_3"
            default: return nil
            }
        }
    }

    // MARK: - UI
    var body: some View {
        ZStack {
            Color(red: 0.85, green: 0.93, blue: 0.85)
                .ignoresSafeArea()

            VStack(spacing: 30) {

                HStack(spacing: 30) {
                    Button {
                        selectedType = .morning
                        resetAll()
                        playAudio()
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
                        playAudio()
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
                    .foregroundColor(Color("Color1"))

                Button {
                    handleCounterTap()
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
                .buttonStyle(.plain)

                Spacer()
            }
            .padding()
        }
    }

    // MARK: - Counter logic (same for morning & evening)
    func handleCounterTap() {

        counter += 1

        if currentAthkar[currentIndex].1 > 1 && counter < currentAthkar[currentIndex].1 {
            playAudio()
            return
        }

        counter = 0
        if currentIndex < currentAthkar.count - 1 {
            currentIndex += 1
        } else {
            currentIndex = 0
        }
        playAudio()
    }

    func resetAll() {
        currentIndex = 0
        counter = 0
        stopAudio()
    }

    // MARK: - Audio
    func playAudio() {
        stopAudio()

        guard let name = currentAudioName,
              let url =
                Bundle.main.url(forResource: name, withExtension: "wav") ??
                Bundle.main.url(forResource: name, withExtension: "mp3")
        else { return }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Audio error:", error)
        }
    }

    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}

#Preview {
    Duaa()
}
