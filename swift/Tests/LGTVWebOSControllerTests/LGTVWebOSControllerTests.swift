import XCTest
@testable import LGTVWebOSController

final class LGTVWebOSControllerTests: XCTestCase {
    func testPingDoesNotCrash() {
        let client = LGTVWebOSClient()
        client.ping()
    }
}
