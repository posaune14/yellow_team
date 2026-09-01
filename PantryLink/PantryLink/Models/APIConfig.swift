import Foundation

/// Single source of truth for the backend base URL.
/// Point this at your Mac's IP (e.g. "http://192.168.1.x:3000") to test
/// against a local server instead of production.
enum API {
    static let baseURL = "https://yellow-team.onrender.com"
}
