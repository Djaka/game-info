//
//  EditProfileViewController.swift
//  GameInfo
//
//  Created by Djaka Permana on 17/06/23.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var currentJobTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var imageLoading: UIActivityIndicatorView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backView.layer.cornerRadius = 10
        backView.clipsToBounds = true
        
        defaultProfile()
    }

    @IBAction func updateAccount(_ sender: Any) {
        if let name = nameTextField.text, let email = emailTextField.text, let currentJob = currentJobTextField.text {
            
            if name.isEmpty {
                fieldEmpty("Name")
            } else if email.isEmpty {
                fieldEmpty("Email")
            } else if currentJob.isEmpty {
                fieldEmpty("Current Job")
            } else {
                updateProfile(name, email, currentJob)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func resetAction(_ sender: Any) {
        defaultProfile()
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func fieldEmpty(_ field: String) {
        let action = UIAlertAction(title: "OK", style: .default)
        let alert = UIAlertController(title: "Alert", message: "\(field) is empty", preferredStyle: .alert)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    private func updateProfile(_ name: String, _ email: String, _ currentJob: String) {
        AboutPreference.authorDefault = name
        AboutPreference.emailDefault = email
        AboutPreference.currentJobDefault = currentJob
    }
    
    private func defaultProfile() {
        startDownloadImage(url: AboutPreference.imageProfileDefault) { [weak self] (image) in
            self?.profileImage.image = image
            self?.imageLoading.isHidden = true
            self?.imageLoading.stopAnimating()
        }
        configureImage()
        
        nameTextField.text = AboutPreference.authorDefault
        emailTextField.text = AboutPreference.emailDefault
        currentJobTextField.text = AboutPreference.currentJobDefault
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
    
    private func configureImage() {
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }
}
