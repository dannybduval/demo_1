import Foundation

class Foo: NSObject {

    @objc static let sharedInstance = Foo()
    private var data: [String: [String: Bool]] = Dictionary()

    override init() {
        guard let url = Bundle.main.url(forResource: "Foo", withExtension: ".plist"),
            let pages = NSDictionary(contentsOf: url) else { return }
        for page in pages.allKeys {
            guard let pageString = page as? String,
            let allKeys = (pages[pageString] as AnyObject).allKeys  else { continue }
            data[pageString] = [String: Bool]()
            for pageItem in allKeys {
                guard let pageItemString = pageItem as? String,
                    let dict = pages[pageString] as? [String: Bool],
                    let val = dict[pageItemString],
                    var dataDict = data[pageString] else { continue }
                dataDict[pageItemString] = val
                data[pageString] = dataDict
            }
        }
    }

    @objc func set(toggles: [String: [String: Bool]]) {
        data = toggles
    }

    @objc func pageItemEnabled(_ page: String, pageItem: String) -> Bool {
        guard let dict = data[page],
            let bool = dict[pageItem],
            dict.keys.contains(pageItem),
            data.keys.contains(page) else { return true }
        return bool
    }

}

