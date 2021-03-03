import UIKit

class ImageViewController: UIViewController {

    private let imageUrl = "https://cdn.wallscloud.net/converted/1199453145-priroda-Lw1p-7680x4320-MM-100.jpg"

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
        isHiddenElements(bool: false)
//        activityIndicator.hidesWhenStopped = true // будет скрываться после остановки
    }
    
    fileprivate func isHiddenElements(bool: Bool) -> Void {
        activityIndicator.isHidden = bool
        loadingLabel.isHidden = bool
        bool ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
    }

    fileprivate func fetchImage() -> Void {
        guard let url = URL(string: imageUrl) else { return }

        let session = URLSession.shared // синглтон
        
        //Будет сделан запрос и вернеться три объекта { замыкание и не забываем использовать self. }
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let response = response {
                print(response)
            }
            if let data = data, let image = UIImage(data: data) {
                //Выход из фонового режима в основной поток, и все это делать в асинхронном режиме
                DispatchQueue.main.async {
                    self.isHiddenElements(bool: true)
                    self.imageView.image = image
                }
            }
        //Находиться в подвешенном состоянии, и не выполниться пока не получит команду .resume()
        }.resume()
    }
}

