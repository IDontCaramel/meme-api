//
//  ViewController.swift
//  meme_api_frontend
//
//  Created by caramel on 11/12/2024.
//

import UIKit

class ViewController: UIViewController {

    
    
    let progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.progress = 0.0 // Initial progress
        progressBar.trackTintColor = .lightGray
        progressBar.progressTintColor = .blue
        return progressBar
    }()

    // UI Components
    let imageViewMeme: UIImageView = {
        let maxWidth = UIScreen.main.bounds.width
        let imgView = UIImageView()
        imgView.image = UIImage(named: "placeholderImage") // Replace with the name of your default image
        imgView.isHidden = false
        imgView.layer.cornerRadius = 10
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.widthAnchor.constraint(equalToConstant: maxWidth - 10).isActive = true
        
            return imgView
        }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the background color to system background
        self.view.backgroundColor = UIColor(hex: "#202020FF")

        // Add components to the view
        view.addSubview(imageViewMeme)
        view.addSubview(btnNewMeme)
        view.addSubview(btnDownloadMeme)
        view.addSubview(progressBar)

        setupConstraints()
        loadMemeImage()
    }




    let btnNewMeme: UIButton = {
        let maxWidth = UIScreen.main.bounds.width

        let button = UIButton(type: .system)
        button.setTitle("New meme", for: .normal)
        button.addTarget(self, action: #selector(btnNewMemeTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(hex: "#0079ffFF")
        button.tintColor = .white
        return button
    }()

    let btnDownloadMeme: UIButton = {
        let maxWidth = UIScreen.main.bounds.width

        let button = UIButton(type: .system)
        button.setTitle("Download", for: .normal)
        button.addTarget(self, action: #selector(btnDownloadMemeTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(hex: "#00ff5eFF")
        button.tintColor = .darkGray
        return button
    }()



    
    func setupConstraints() {
        let maxWidth = UIScreen.main.bounds.width

        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: imageViewMeme.leadingAnchor, constant: 10),
            progressBar.trailingAnchor.constraint(equalTo: imageViewMeme.trailingAnchor, constant: -10),
            progressBar.centerXAnchor.constraint(equalTo: imageViewMeme.centerXAnchor),
            progressBar.centerYAnchor.constraint(equalTo: imageViewMeme.centerYAnchor),

            
            // Set the width of imageViewMeme to be 10 less than max width
            imageViewMeme.widthAnchor.constraint(equalToConstant: maxWidth - 10),
            imageViewMeme.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageViewMeme.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            // Set the height of imageViewMeme to fill the remaining height
            imageViewMeme.bottomAnchor.constraint(equalTo: btnNewMeme.topAnchor, constant: -20),

            // Set the width and positioning of btnNewMeme
            btnNewMeme.widthAnchor.constraint(equalToConstant: maxWidth - 10),
            btnNewMeme.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnNewMeme.heightAnchor.constraint(equalToConstant: 50),

            // Set the width and positioning of btnDownloadMeme
            btnDownloadMeme.widthAnchor.constraint(equalToConstant: maxWidth - 10),
            btnDownloadMeme.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnDownloadMeme.topAnchor.constraint(equalTo: btnNewMeme.bottomAnchor, constant: 20),
            btnDownloadMeme.heightAnchor.constraint(equalToConstant: 50),
            
            // Set the bottom constraint of btnDownloadMeme
            btnDownloadMeme.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            
        ])

    }
    
    
    func loadMemeImage() {
        self.imageViewMeme.isHidden = true
        progressBar.setProgress(0.1, animated: false)
        self.progressBar.isHidden = false

        // Delay the initial 50% progress update to allow for UI update
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.progressBar.setProgress(0.5, animated: true)
        }

        MemeAPI.shared.fetchImageFromAPI { result in
            DispatchQueue.main.async {
                // Simulate progress at 70% after fetch begins
                self.progressBar.setProgress(0.7, animated: true)

                // Add a small delay before final progress completion
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    switch result {
                    case .success(let image):
                        self.progressBar.setProgress(1.0, animated: true)
                        
                        // Delay before setting the image
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.progressBar.isHidden = true
                            self.imageViewMeme.isHidden = false
                            self.imageViewMeme.image = image
                        }

                    case .failure(let error):
                        // Handle error
                        print("Error fetching image: \(error)")
                        self.progressBar.setProgress(0.0, animated: true)
                        self.progressBar.isHidden = true
                    }
                }
            }
        }


    }

    // Button Actions
    @objc func btnNewMemeTapped() {
        loadMemeImage()
    }

    @objc func btnDownloadMemeTapped() {
        // Ensure the image is available before attempting to save it
        guard let image = imageViewMeme.image else {
            print("No image to download")
            return
        }
        
        // Convert the image to PNG data (you can use .jpegData(compressionQuality:) if you prefer JPEG format)
        if let imageData = image.pngData() {
            // Try to save the image to the photo library
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            print("Failed to convert image to data")
        }
    }

    // Callback method to handle the result of the save operation
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // Handle error (e.g., show an alert to the user)
            print("Error saving image: \(error.localizedDescription)")
        } else {
            // Image saved successfully
            print("Image saved to photo library!")
        }
    }
}
