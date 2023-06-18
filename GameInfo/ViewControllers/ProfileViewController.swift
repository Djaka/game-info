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
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var currentJobLabel: UILabel!
    @IBOutlet weak var descriptionAbout: UILabel!
    @IBOutlet weak var imageLoading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        loadProfile()
    }
    
    private func loadProfile() {
        startDownloadImage(url: AboutPreference.imageProfileDefault) { [weak self] (image) in
            self?.profileImage.image = image
            self?.imageLoading.isHidden = true
            self?.imageLoading.stopAnimating()
        }
            
        nameLabel.text = AboutPreference.authorDefault
        currentJobLabel.text = AboutPreference.currentJobDefault
        emailLabel.text = AboutPreference.emailDefault
        descriptionAbout.attributedText = AboutPreference.descriptionDefault.htmlToAttributedString
        descriptionAbout.font = UIFont(name: "Arial", size: 14)
        descriptionAbout.textColor = UIColor(hex: "#18122B")
        descriptionAbout.textAlignment = .justified
        
        configureImage()
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

    @IBAction func changeProfile(_ sender: Any) {
        let editProfileViewController = EditProfileViewController()
        navigationController?.pushViewController(editProfileViewController, animated: true)
    }
}
