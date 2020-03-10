
import Foundation

struct Transaction: Codable {
    let sender: String
    let recipient: String
    let amount: Int
}
