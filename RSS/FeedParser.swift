import Foundation

class FeedParser: NSObject, XMLParserDelegate {
    private var newsItems: [NewsItem] = []
    private var currentElement = ""
    
    private var currentTitle = ""
    private var currentSummary = ""
    private var currentPublished = ""
    private var currentLink = ""
    private var currentImageUrl = ""
    
    private var completionHandler: (([NewsItem]) -> Void)?

    func parseFeed(url: String, completion: @escaping ([NewsItem]) -> Void) {
        self.completionHandler = completion
        guard let feedUrl = URL(string: url) else { return }

        URLSession.shared.dataTask(with: feedUrl) { data, _, error in
            guard let data = data else {
                print("Veri alınamadı.")
                return
            }
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }.resume()
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?,
                qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName.lowercased()

        if currentElement == "entry" {
            currentTitle = ""
            currentSummary = ""
            currentPublished = ""
            currentLink = ""
            currentImageUrl = ""
        }

        // Atom feed'te <link href="..."> şeklinde
        if currentElement == "link", let href = attributeDict["href"] {
            currentLink = href
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
        case "summary", "content":
            currentSummary += string
        case "published":
            currentPublished += string
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?,
                qualifiedName qName: String?) {
        if elementName.lowercased() == "entry" {
            currentImageUrl = extractImageURL(from: currentSummary)

            let item = NewsItem(
                title: currentTitle.trimmingCharacters(in: .whitespacesAndNewlines),
                description: extractPlainText(from: currentSummary),
                pubDate: currentPublished,
                link: currentLink,
                imageUrl: currentImageUrl
            )
            newsItems.append(item)
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        print("Toplam haber: \(newsItems.count)")
        completionHandler?(newsItems)
    }

    // 📷 IMG src çekme (summary veya content içindeki <img>)
    private func extractImageURL(from html: String) -> String {
        if let range = html.range(of: "<img src=\"") {
            let afterImg = html[range.upperBound...]
            if let endQuote = afterImg.range(of: "\"") {
                return String(afterImg[..<endQuote.lowerBound])
            }
        }
        return ""
    }

    // 🧹 HTML etiketlerini temizle
    private func extractPlainText(from html: String) -> String {
        return html.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
