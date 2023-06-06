//
//  ProfileViewController.swift
//  GameInfo
//
//  Created by Djaka Permana on 03/06/23.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currentJobLabel: UILabel!
    @IBOutlet weak var descriptionAbout: UILabel!
    @IBOutlet weak var imageLoading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let data = loadJson(filename: "About"), let image = data.authorImage, let author = data.author, let currentJob = data.currentJob, let description = data.description {
            
            startDownloadImage(url: image) { [weak self] (image) in
                self?.profileImage.image = image
                self?.imageLoading.isHidden = true
                self?.imageLoading.stopAnimating()
            }
            
            nameLabel.text = author
            currentJobLabel.text = currentJob
            descriptionAbout.attributedText = description.htmlToAttributedString
            descriptionAbout.font = UIFont(name: "Arial", size: 14)
            descriptionAbout.textColor = UIColor(hex: "#18122B")
            descriptionAbout.textAlignment = .justified
        }
        
        configureImage()
        
    }

    private func loadJson(filename fileName: String) -> About? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                return jsonData.about
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    private func configureImage() {
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
    }
    
    private func startDownloadImage(url: String, completion: @escaping (UIImage?) -> Void) {
        let imageDownloader = ImageDownloader()
        Task {
            do {
                guard let gameImageUrl = URL(string: url) else {
                    return
                }
                let image = try await imageDownloader.downloadImage(url: gameImageUrl)
                completion(image)
            } catch {
                completion(nil)
            }
        }
    }

}
