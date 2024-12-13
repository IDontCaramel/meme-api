//
//  ViewController.swift
//  meme_api_frontend
//
//  Created by caramel on 11/12/2024.
//

import UIKit

class ViewController: UIViewController {

    // UI Components
    let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "exampleImage") // Replace with your image name in assets
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()

    let button1: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Alert", for: .normal)
        button.addTarget(self, action: #selector(button1Tapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let button2: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Print Message", for: .normal)
        button.addTarget(self, action: #selector(button2Tapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Add components to the view
        view.addSubview(imageView)
        view.addSubview(button1)
        view.addSubview(button2)

        // Set up Auto Layout constraints
        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            // ImageView Constraints
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),

            // Button 1 Constraints
            button1.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            button1.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Button 2 Constraints
            button2.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 20),
            button2.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // Button Actions
    @objc func button1Tapped() {
        let alert = UIAlertController(title: "Alert", message: "Button 1 was tapped!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @objc func button2Tapped() {
        print("Button 2 was tapped!")
    }
}
