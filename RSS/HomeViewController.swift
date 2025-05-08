import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var newsItems: [NewsItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        // RSS verisini çek
        let parser = FeedParser()
        parser.parseFeed(url: "https://www.ntv.com.tr/gundem.rss") { items in
            self.newsItems = items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - TableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomNewsCell", for: indexPath) as? CustomNewsCell else {
            return UITableViewCell()
        }

        let item = newsItems[indexPath.row]
        cell.titleLabel.text = item.title

        if let url = URL(string: item.imageUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        cell.newsImageView.image = UIImage(data: data)
                    }
                }
            }
        }

        // Detay butonu tıklanınca veriyi segue ile gönder
        cell.detailButtonTapped = { [weak self] in
            guard let self = self else { return }
            let selectedItem = self.newsItems[indexPath.row]
            print("Tıklanan başlık: \(selectedItem.title)")
            self.performSegue(withIdentifier: "showDetail", sender: selectedItem)
        }

        return cell
    }

    // MARK: - Segue ile veri aktarımı
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare çalıştı")

        if let s = sender {
            print("Sender tipi: \(type(of: s))")
        } else {
            print("Sender: nil")
        }

        if segue.identifier == "showDetail",
           let detailVC = segue.destination as? DetailViewController,
           let selectedNews = sender as? NewsItem {
            print("Veri geldi: \(selectedNews.title)")
            detailVC.newsItem = selectedNews
        } else {
            print("Veri aktarımı başarısız")
        }
    }
}
