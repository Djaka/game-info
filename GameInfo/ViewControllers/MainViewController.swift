//
//  MainViewController.swift
//  GameInfo
//
//  Created by Djaka Permana on 02/06/23.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var refreshView: UIView!
    
    private var gameModels: [GameModel] = []
    private var service: GamesService
    private var isLoading = false
    private var page = 1
    private var pageSize = 10
    private var onType = false
    
    init(service: GamesService = GamesService()) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTable()
        getDataGames(page: self.page)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupUI() {
        searchView.layer.cornerRadius = 10
        searchView.clipsToBounds = true
        
        refreshView.layer.cornerRadius = 10
        searchView.clipsToBounds = true
        
        searchTextField.delegate = self
    }
    
    private func setupTable() {
        gameTableView.dataSource = self
        gameTableView.delegate = self
        gameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCell")
        gameTableView.register(UINib(nibName: "LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: "LoadingTableViewCell")
        gameTableView.separatorStyle = .none
    }
    
    private func fetchData(page: Int, completion: @escaping (Result<GameResponseModel, HTTPError>) -> Void) {
        Task(priority: .background) {
            let result = await service.getGames(page: page, pageSize: self.pageSize, search: searchTextField.text ?? "")
            completion(result)
        }
    }
    
    private func getDataGames(page: Int) {
        fetchData(page: page, completion: { [weak self] result in
            switch result {
            case .success(let success):
                let items = self?.createItems(with: success.results ?? []) ?? []
                self?.gameModels += items
                self?.gameTableView.reloadData()
                self?.isLoading = false
            case .failure(let failure):
                self?.showAlertError(message: failure.message)
                self?.gameTableView.reloadData()
                self?.isLoading = false
            }
        })
    }
    
    private func showAlertError(message: String) {
        let refresh = UIAlertAction(title: "Refresh", style: .default) { [weak self] (_) in
            self?.getDataGames(page: self?.page ?? 1)
        }
        
        let alert = UIAlertController(title: "Error message", message: message, preferredStyle: .alert)
        
        alert.addAction(refresh)
        
        self.present(alert, animated: true)
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
                self.gameTableView.reloadRows(at: [indexPath], with: .automatic)
            } catch {
                game.downloadState = .failed
                game.image = nil
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
    
    fileprivate func createItems(with games: [Game]) -> [GameModel] {
        return games.map { result in
            return GameModel(
                id: result.id,
                name: result.name,
                released: result.released,
                backgroundImage: result.backgroundImage,
                rating: result.rating,
                parentPlatforms: result.parentPlatforms)
        }
    }
    
    private func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            self.page += 1
            
            DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                self.getDataGames(page: self.page)
            })
        }
    }
    
    private func refreshData() {
        gameModels.removeAll()
        gameTableView.reloadData()
        if !self.isLoading {
            self.isLoading = true
            self.page = 1
            
            DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                self.getDataGames(page: self.page)
            })
        }
    }
    
    @IBAction func buttonRefreshAction(_ sender: Any) {
        searchTextField.text = ""
        refreshData()
    }
    
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return gameModels.count
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as? GameTableViewCell {
                let game = gameModels[indexPath.row]
                cell.selectionStyle = .none
                
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
                
                if game.downloadState == .new {
                    cell.loadingImage.isHidden = false
                    cell.loadingImage.startAnimating()
                    startDownloadImage(game: game, indexPath: indexPath)
                } else {
                    cell.loadingImage.isHidden = true
                    cell.loadingImage.stopAnimating()
                }
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell", for: indexPath) as? LoadingTableViewCell {
                cell.loadMoreIndicator.startAnimating()
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == gameModels.count - 1, !isLoading {
            loadMoreData()
        }
    }
}

extension MainViewController: UITableViewDelegate {
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

extension UIStackView {
    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }
}

extension MainViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        refreshData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
}
