import UIKit
import SkeletonView

class ArticleTableViewCell: UITableViewCell {
    static let identifier = "ArticleTableViewCell"
    
    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var lblArtcileDesc: UILabel?
    @IBOutlet weak var lblPublisher:UILabel?
    @IBOutlet weak var customLikeButton:UIButton!
    @IBOutlet weak var customShareButton:UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        isSkeletonable = true
        customImageView.isSkeletonable = true
        lblArtcileDesc?.isSkeletonable = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(with urlString: String) {
        guard let url = URL(string: urlString) else {
            customImageView.image = nil
            return
        }
        
        customImageView.loadImage(from: url) { image in
            self.customImageView.image = image
        }
    }
}
