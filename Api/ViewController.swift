import UIKit
import ProgressHUD
import iCarousel
import SkeletonView

struct Article: Decodable {
    let source: Source
    let author: String?
    let title: String
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    
    struct Source: Decodable {
        let id: String?
        let name: String?
    }
}

// Define the struct for the JSON response
struct NewsResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

class ViewController: UIViewController, UITableViewDelegate, SkeletonTableViewDataSource, iCarouselDataSource, iCarouselDelegate,UITabBarDelegate {
    @IBOutlet weak var tabBar: UITabBar!
    
    var newsArray = [Article]()
    var images: [UIImage] = []
    
    @IBOutlet weak var tabar: UITabBar!
    @IBOutlet weak var carouselView: iCarousel!
    @IBOutlet weak var tblNews: UITableView!
    @IBOutlet weak var lblLatestUpdates:UILabel!
    
    @IBOutlet weak var btnNavCategoryView: UIImageView!
    let headerView : UIView = {
        let headerView = UIView()
        
        return headerView
    }()
    
    let headerLabel : UILabel = {
        let label = UILabel()
        label.text = "Latest Updates"
        label.font = UIFont(name: "Rubik Bold Italic", size: 19)
        
        label.textColor = .black
        return label
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.frame = CGRect(x: 0, y: 0, width: tblNews.frame.width, height: 100)
        headerLabel.frame = CGRect(x: 25, y: -5, width: headerView.frame.width - 20, height: headerView.frame.height/2 - 10)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openProfile(_:)))
        btnNavCategoryView.addGestureRecognizer(tapGesture)
        images = [
            UIImage(named: "bannerImage1"),
            UIImage(named: "bannerImage2"),
            UIImage(named: "bannerImage3")
        ].compactMap { $0 }
        
//        tblNews.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
        tblNews.delegate = self
        tabBar.delegate = self
        tblNews.dataSource = self
        carouselView.dataSource = self
        carouselView.delegate = self
        carouselView.type = .linear
        carouselView.layer.masksToBounds = true
        tblNews.rowHeight = 250
        tblNews.estimatedRowHeight = 250
        self.tblNews.indicatorStyle = .black
        
        
        
        // This is the default style, you can also use .black or .white
//https://newsapi.org/v2/top-headlines?country=in&category=sports&apiKey=a7035a863f53470f8c10f791c26082d5
        let firstItem = UITabBarItem(title: "", image: UIImage(named: "globe"), selectedImage: UIImage(named: "globeSelected"))
        let secondItem = UITabBarItem(title: "", image: UIImage(named: "coding"), selectedImage: UIImage(named: "codingSelected"))

               // Set the items to the tab bar
               tabBar.items = [firstItem, secondItem]
        
        tblNews.addSubview(headerView)
        headerView.addSubview(headerLabel)
    }
    
    
    
    @objc func openProfile(_ sender:UITapGestureRecognizer){
        
        let vc = CategorySelectionViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        return 1.1
    }
    func numberOfItems(in carousel: iCarousel) -> Int {
        return images.count > 0 ? images.count : 1
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var containerView: UIView
        let imageViewTag = 100

        if let view = view {
            containerView = view
        } else {
            containerView = UIView(frame: CGRect(x: 0, y: 0, width: carousel.bounds.size.width, height: carousel.bounds.size.height))

            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: containerView.bounds.size.width, height: containerView.bounds.size.height))
            imageView.layer.cornerRadius = 10.0
            imageView.clipsToBounds = true
            imageView.tag = imageViewTag
            containerView.addSubview(imageView)
        }

        if let imageView = containerView.viewWithTag(imageViewTag) as? UIImageView {
            imageView.image = !images.isEmpty ? images[index] : UIImage(named: "bannerImage1")
        }

        return containerView
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        print("Selected item at index: \(index)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tblNews.isSkeletonable = true  // Mark the table view as skeletonable

        tblNews.showSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))
        getResponse()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count > 0 ? newsArray.count : 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return ArticleTableViewCell.identifier
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as? ArticleTableViewCell else {
            return UITableViewCell()
        }
        
        if newsArray.count > 0 {
            let articles = newsArray[indexPath.row]
            cell.lblArtcileDesc?.text = articles.title
     
            if(articles.publishedAt == "" || articles.publishedAt == nil){
                
            }else{
                 
                cell.lblPublisher?.text =  formatDateString(isoDateString: articles.publishedAt!)
                
                
            }
            
            if let imageUrlString = articles.urlToImage, let url = URL(string: imageUrlString) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        print("Error downloading image: \(error)")
                        return
                    }
                    
                    guard let data = data else {
                        print("No data found")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data) {
                            cell.customImageView.image = image
                            cell.customImageView.contentMode = .scaleAspectFill
                        } else {
                            print("Failed to create image from data")
                        }
                    }
                }.resume()
            } else {
                cell.customImageView.image = UIImage(named: "noPreview")
                cell.customImageView.contentMode = .center
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let news = newsArray[indexPath.row]
            if let urlString = news.url, let url = URL(string: urlString) {
                let detailVC = NewsDetailsViewController()
                detailVC.url = url
                navigationController?.pushViewController(detailVC, animated: true)
            } else {
                // Handle the case where the URL string is not valid
                print("Invalid URL or nil: \(String(describing: news.url))")
            }
        }
    
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
            print("Selected item: \(item.title ?? "")")
        navigateToCategorySelection()
        }
    
    
    func navigateToCategorySelection(){
        let vc = CategorySelectionViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getResponse() {
        DispatchQueue.main.async {
            ProgressHUD.animate()
            ProgressHUD.colorAnimation = .black
            ProgressHUD.colorBackground = .cyan
            ProgressHUD.animationType = .ballVerticalBounce
        }
        
        
        
        var request = URLRequest(url: URL(string: "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=a7035a863f53470f8c10f791c26082d5")!, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            
            let jsonString = String(data: data, encoding: .utf8)!
            
            if let jsonData = jsonString.data(using: .utf8) {
                let decoder = JSONDecoder()
                do {
                    let newsResponse = try decoder.decode(NewsResponse.self, from: jsonData)
                    let articles = newsResponse.articles
                    self.newsArray.append(contentsOf: articles)
                    
                    DispatchQueue.main.async {
                        self.tblNews.stopSkeletonAnimation()
                        self.tblNews.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(1.5))
                        self.tblNews.reloadData()
                        ProgressHUD.remove()
                    }
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        self.lblLatestUpdates.isHidden = true;
    }
    
    func formatDateString(isoDateString: String) -> String? {
        // Create a DateFormatter to parse the ISO 8601 date string
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withInternetDateTime]

        // Convert the ISO date string to a Date object
        guard let date = isoDateFormatter.date(from: isoDateString) else {
            print("Invalid date format")
            return nil
        }

        
        // Create another DateFormatter to format the date to the desired output
        let displayDateFormatter = DateFormatter()
        displayDateFormatter.dateFormat = "dd MMM yy hh:mm a"
        displayDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        displayDateFormatter.timeZone = TimeZone.current

        // Format the date to the desired string
        let formattedDate = displayDateFormatter.string(from: date)
        return formattedDate
    }

}

extension UIImageView {
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completion(UIImage(data: data))
            }
        }.resume()
    }
    

    


}
