import ArgumentParser

@main
@available(macOS 10.15, macCatalyst 13, iOS 13, tvOS 13, watchOS 6, *)
struct LGTVControllerEntryPoint {
    static func main() async {
        await LGTVControllerCLI.main()
    }
}
