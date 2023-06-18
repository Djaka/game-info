//
//  FavoriteGameViewController.swift
//  GameInfo
//
//  Created by Djaka Permana on 12/06/23.
//

import UIKit

class FavoriteGameViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var emptyFavoriteLabel: UILabel!
    
    private var gameProvider: GameProvider
    private var gameModels: [GameModel] = []
    
    init(gameProvider: GameProvider = GameProvider()) {
        self.gameProvider = gameProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadFavoriteGames()
    }
    
    private func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCell")
        tableView.separatorStyle = .none
    }
    
    private func loadFavoriteGames() {
        
        loading.isHidden = false
        
        gameProvider.getAllFavorite(completion: { (games: [GameModel]) in
            
            DispatchQueue.main.async {
                self.loading.isHidden = true
                self.gameModels = games
                self.tableView.reloadData()
                self.emptyFavoriteLabel.isHidden = games.count > 0
            }
        })
    }
    
    private func setFavorite(game: GameModel, indexPath: IndexPath) {
        gameProvider.getFavorite(game.id ?? 0) { (gameFavorite: GameModel?) in
            if let gameId = gameFavorite?.id {
                game.isFavorite = game.id == gameId
            } else {
                game.isFavorite = false
            }
        }
    }
    
    private func setPlatformImage(game: GameModel, indexPath: IndexPath) {
        
        var imageNames: [String] = []
        var imageViews: [UIImageView] = []
        
        if let parentPlatforms = game.parentPlatforms {
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
            
            game.platformImages = imageViews
        }
    }
    
    fileprivate func startDownloadImage(game: GameModel, indexPath: IndexPath) {
        let imageDownloader = ImageDownloader()
        Task {
            do {
                guard let gameImageUrl = URL(string: game.backgroundImage ?? "") else {
                    return
                }
                let image = try await imageDownloader.downloadImage(url: gameImageUrl)
                game.downloadState = .downloaded
                game.image = image
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            } catch {
                game.downloadState = .failed
                game.image = nil
            }
        }
    }
    
    private func removeFavorite(with gameModel: GameModel, indexPath: IndexPath) {
        
        gameProvider.deleteFavorite(gameModel.id ?? 0) {
            DispatchQueue.main.async {
                gameModel.isFavorite = false
                
                self.gameModels.remove(at: indexPath.row)
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.endUpdates()
                self.tableView.reloadData()
                
                if self.gameModels.count < 1 {
                    self.loadFavoriteGames()
                }
            }
        }
    }
}

extension FavoriteGameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as? GameTableViewCell {
            let game = gameModels[indexPath.row]
            cell.selectionStyle = .none
            
            cell.configureCell(gameModel: game)
            cell.gameImage.image = game.image
            cell.titleGameLabel.text = game.name
            cell.ratingLabel.text = String(game.rating ?? 0.0)
            cell.releaseDateLabel.text = game.released
            cell.ratingLogo.image = {
                guard let rating = game.rating else {
                    return UIImage(systemName: "star.fill")
                }
                
                switch rating {
                case 4.0 ... 5.0:
                    return UIImage(systemName: "star.fill")
                case 2.5 ... 3.9:
                    return UIImage(systemName: "star.leadinghalf.filled")
                default:
                    return UIImage(systemName: "star")
                }
            }()
            
            cell.platformStackView.removeFullyAllArrangedSubviews()
            if let images = game.platformImages {
                for imagePlatform in images {
                    cell.platformStackView.addArrangedSubview(imagePlatform)
                }
            }
            
            setPlatformImage(game: game, indexPath: indexPath)
            setFavorite(game: game, indexPath: indexPath)
            
            if game.downloadState == .new {
                cell.loadingImage.isHidden = false
                cell.loadingImage.startAnimating()
                startDownloadImage(game: game, indexPath: indexPath)
            } else {
                cell.loadingImage.isHidden = true
                cell.loadingImage.stopAnimating()
            }
            
            let imageFavorited = game.isFavorite ?? false ? UIImage(systemName: "heart.fill"): UIImage(systemName: "heart")
            cell.favoriteButton.setImage(imageFavorited, for: .normal)
            
            cell.removeGame = {[weak self] in
                self?.removeFavorite(with: game, indexPath: indexPath)
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}

extension FavoriteGameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gameModel = gameModels[indexPath.row]
        guard let gameId = gameModel.id else {
            return
        }
        
        GameParameter.shared.setGameId(id: gameId)
        let detailViewController = DetailGameViewController()
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
