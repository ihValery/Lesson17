import UIKit
import Alamofire
import SwiftyJSON

class AlbomsCollectionVC: UICollectionViewController {
    
    var user: User!
    var albomId: Int!
    var photos: [Photos] = []
    
    let itemsPerRow: CGFloat = 2
    let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let photoVS = segue.destination as! PhotoVC
    }
    
    func getData() {
        guard let albomId = albomId else { return }
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos?albumId=\(albomId)") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            do {
                self.photos = try JSONDecoder().decode([Photos].self, from: data)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            } catch let error {
                print("Error: ", error)
            }
        }.resume()
    }
    
//    fileprivate func isHiddenElements(bool: Bool) -> Void {
//        activityIndicator.isHidden = bool
//        loadingLabel.isHidden = bool
//        bool ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
//    }

    // MARK:  - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellAlboms", for: indexPath) as! AlbomsCVCell
        //cell.photoImage.image = photos
    
        let photo = photos[indexPath.item]
        cell.activityIndicator.startAnimating()
        cell.configure(with: photo)
        
        //Дизайн ячейки
//        cell.contentView.layer.cornerRadius = 9
//        cell.contentView.layer.borderWidth = 1
//        cell.contentView.layer.borderColor = UIColor.clear.cgColor
//        cell.contentView.layer.masksToBounds = true
//
//        cell.layer.shadowColor = UIColor.black.cgColor
//        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
//        cell.layer.shadowRadius = 4
//        cell.layer.shadowOpacity = 0.4
//        cell.layer.masksToBounds = false
//        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }

    // MARK: - UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension AlbomsCollectionVC: UICollectionViewDelegateFlowLayout {
    //Размер наших элементов
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddigWidht = sectionInserts.top * (itemsPerRow + 1)
        //Доступная ширина - относительно ширины рамки collectionView
        let availableWigth = collectionView.frame.width - paddigWidht
        let widhtPerItem = availableWigth / itemsPerRow
        return CGSize(width: widhtPerItem, height: widhtPerItem)
    }
    //Отступ от рамки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    //Горизонтальный отспут между элементами
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.top
    }
    //Вертикальный отступ между элементами
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.top
    }
}
