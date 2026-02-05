import Foundation

enum ChildGender: String, Hashable, Identifiable {
    case boy
    case girl

    var id: String { rawValue }
}
