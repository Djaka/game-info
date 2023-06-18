//
//  DetailGameViewController.swift
//  GameInfo
//
//  Created by Djaka Permana on 05/06/23.
//

import UIKit

class DetailGameViewController: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var platformsStackView: UIStackView!
    @IBOutlet weak var subBannerImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingLogo: UIImageView!
    @IBOutlet weak var loadingBannerImage: UIActivityIndicatorView!
    @IBOutlet weak var loadingSubBannerImage: UIActivityIndicatorView!
    @IBOutlet weak var scrollDetail: UIScrollView!
    @IBOutlet weak var favoriteView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var service: GamesService
    private var gameId: Int
    private var gameProvider: GameProvider
    private var gameDetailModel: GameDetailModel?
    
    init(service: GamesService = GamesService(), provider: GameProvider = GameProvider()) {
        self.service = service
        self.gameProvider = provider
        self.gameId = GameParameter.shared.getGameId()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollDetail.delegate = self
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor(hex: "#635985")
        self.navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor(hex: "#635985")]
        
        setupUI()
        getDataGames()
    }
    
    @objc func favoriteAction() {
        favoriteActionTap()
    }

    private func setupUI() {
        backView.layer.cornerRadius = 10
        backView.clipsToBounds = true
        
        favoriteView.layer.cornerRadius = 10
        favoriteView.clipsToBounds = true
        
        subBannerImage.layer.cornerRadius = 10
        subBannerImage.clipsToBounds = true
        
    }
    
    private func getDataGames() {
        fetchData(completion: { [weak self] result in
            switch result {
            case .success(let response):
                guard let data = self?.mapResponse(with: response) else {
                    return
                }
                self?.gameDetailModel = data
                self?.updateUI(with: data)
                self?.checkFavorite()
            case .failure(let failure):
                self?.showAlertError(message: failure.message)
            }
        })
    }
    
    private func fetchData(completion: @escaping (Result<GameDetailResponse, HTTPError>) -> Void) {
        Task(priority: .background) {
            let result = await service.getGamesDetail(with: gameId)
            completion(result)
        }
    }
    
    fileprivate func mapResponse(with response: GameDetailResponse) -> GameDetailModel {
        return GameDetailModel(
            id: response.id,
            name: response.name,
            released: response.released,
            backgroundImage: response.backgroundImage,
            backgroundImageAdditional: response.backgroundImageAdditional,
            rating: response.rating,
            parentPlatforms: response.parentPlatforms,
            description: response.description
        )
    }
    
    private func updateUI(with data: GameDetailModel) {
        
        bannerImage.image = data.image
        let view = UIView(frame: bannerImage.frame)
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [UIColor.clear.cgColor, UIColor(hex: "#18122B").cgColor]
        gradient.locations = [0.0, 1.0]
        view.layer.insertSublayer(gradient, at: 0)
        bannerImage.addSubview(view)
        bannerImage.bringSubviewToFront(view)
        
        titleLabel.text = data.name
        ratingLabel.text = String(data.rating ?? 0.0)
        ratingLogo.image = {
            guard let rating = data.rating else {
                return UIImage(systemName: "star.fill")
            }
            
            switch rating {
            case 4.0 ... 5.0:
                return UIImage(systemName: "star.fill")
            case 2.59 ... 3.99:
                return UIImage(systemName: "star.leadinghalf.filled")
            default:
                return UIImage(systemName: "star")
            }
        }()
        
        platformsStackView.removeFullyAllArrangedSubviews()
        if let images = setPlatformImage(gameDetailModel: data) {
            for imagePlatform in images {
                platformsStackView.addArrangedSubview(imagePlatform)
            }
        }
        
        startDownloadImage(url: data.backgroundImage ?? "") { [weak self] (downloadState, image) in
            switch downloadState {
            case .new:
                self?.loadingBannerImage.isHidden = false
                self?.loadingBannerImage.startAnimating()
            default:
                self?.loadingBannerImage.isHidden = true
                self?.loadingBannerImage.stopAnimating()
                self?.bannerImage.image = image
            }
            
        }
        
        startDownloadImage(url: data.backgroundImageAdditional ?? "") { [weak self] (downloadState, image) in
            switch downloadState {
            case .new:
                self?.loadingSubBannerImage.isHidden = false
                self?.loadingSubBannerImage.startAnimating()
            default:
                self?.loadingSubBannerImage.isHidden = true
                self?.loadingSubBannerImage.stopAnimating()
                self?.subBannerImage.image = image
            }
        }
        
        releaseLabel.text = data.released
        descriptionLabel.attributedText = data.description?.htmlToAttributedString
        descriptionLabel.font = UIFont(name: "Arial", size: 14)
        descriptionLabel.textColor = UIColor.white
        descriptionLabel.textAlignment = .justified
        
    }
    
    private func showAlertError(message: String) {
        let refresh = UIAlertAction(title: "Refresh", style: .default) { [weak self] (_) in
            self?.getDataGames()
        }
        
        let alert = UIAlertController(title: "Error message", message: message, preferredStyle: .alert)
        
        alert.addAction(refresh)
        
        self.present(alert, animated: true)
    }
    
    private func showAlertSuccess(message: String) {
        let okay = UIAlertAction(title: "Ok", style: .default)
        
        let alert = UIAlertController(title: "Success message", message: message, preferredStyle: .alert)
        
        alert.addAction(okay)
        
        self.present(alert, animated: true)
    }
    
    private func setPlatformImage(gameDetailModel: GameDetailModel) -> [UIImageView]? {
        
        var imageNames: [String] = []
        var imageViews: [UIImageView] = []
        
        if let parentPlatforms = gameDetailModel.parentPlatforms {
            for parentPlatform in parentPlatforms where !imageNames.contains(parentPlatform.platform?.imageName.rawValue ?? "") {
                let imageName = parentPlatform.platform?.imageName.rawValue ?? ""
                imageNames.append(imageName)
                
                let image = UIImage(systemName: imageName) ?? UIImage()
                let imageView = UIImageView(image: image)
                imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
                imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
                imageView.contentMode = .center
                imageView.tintColor = UIColor(hex: "#DFE6E9")
                imageViews.append(imageView)
            }
            
            return imageViews
        }
        
        return imageViews
    }
    
    private func startDownloadImage(url: String, completion: @escaping (DownloadState, UIImage?) -> Void) {
        let imageDownloader = ImageDownloader()
        Task {
            do {
                guard let gameImageUrl = URL(string: url) else {
                    return
                }
                let image = try await imageDownloader.downloadImage(url: gameImageUrl)
                completion(.downloaded, image)
            } catch {
                completion(.failed, nil)
            }
        }
    }
    
    private func checkFavorite() {
        guard let gameDetailModel = gameDetailModel else {
            return
        }
        gameProvider.getFavorite(gameDetailModel.id ?? 0) { (game: GameModel?) in
            
            DispatchQueue.main.async {
                if game != nil {
                    gameDetailModel.isFavorite = true
                    self.setFavoriteUI(isFavorite: true)
                } else {
                    gameDetailModel.isFavorite = false
                    self.setFavoriteUI(isFavorite: false)
                }
            }
        }
    }
    
    private func setFavoriteGame(with gameDetailModel: GameDetailModel) {
        
        gameProvider.createFavorite(
            gameDetailModel.id ?? 0,
            gameDetailModel.name ?? "",
            gameDetailModel.released ?? "",
            gameDetailModel.backgroundImage ?? "",
            gameDetailModel.rating ?? 0.0,
            gameDetailModel.parentPlatforms ?? []) {
                DispatchQueue.main.async {
                    self.gameDetailModel?.isFavorite = true
                    self.setFavoriteUI(isFavorite: true)
                    self.showAlertSuccess(message: " \(self.gameDetailModel?.name ?? "") now is favorite")
                }
            }
    }
    
    private func removeFavoriteGame(with id: Int) {
        gameProvider.deleteFavorite(id) {
            DispatchQueue.main.async {
                self.gameDetailModel?.isFavorite = false
                self.setFavoriteUI(isFavorite: false)
                self.showAlertSuccess(message: " \(self.gameDetailModel?.name ?? "") now is not favorite")
            }
        }
    }
    
    private func setFavoriteUI(isFavorite: Bool) {
        if isFavorite {
            self.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(favoriteAction))
        } else {
            self.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(favoriteAction))
        }
    }
    
    private func favoriteActionTap() {
        guard let gameDetailModel = gameDetailModel else {
            return
        }
        if gameDetailModel.isFavorite ?? false {
            removeFavoriteGame(with: gameDetailModel.id ?? 0)
        } else {
            setFavoriteGame(with: gameDetailModel)
        }
    }
    
    @IBAction func favoriteButtonAction(_ sender: Any) {
        favoriteActionTap()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension DetailGameViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let gameDetailModel = gameDetailModel else {
            return
        }
        
        if scrollView.contentOffset.y > 50 && scrollView.contentOffset.y < 350 {
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationItem.title = ""
        } else if scrollView.contentOffset.y > 350 {
            navigationController?.setNavigationBarHidden(false, animated: false)
            navigationItem.title = gameDetailModel.name ?? ""
            self.navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor(hex: "#635985")]
        } else {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
}
