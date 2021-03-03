import UIKit

class AlbomsCVCell: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    func configure(with photo: Photos) {
        DispatchQueue.global().async {
            guard let image = photo.thumbnailUrl else { return }
            guard let imageUrl = URL(string: image) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            
            DispatchQueue.main.async {
                self.photoImage.image = UIImage(data: imageData)
            }
        }
    }
    
}
