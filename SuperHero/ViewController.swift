//
//  ViewController.swift
//  SuperHero
//
//  Created by Akimbek Orazgaliev on 27.11.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchAllHeroes()
    }

    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var intelligenceLabel: UILabel!
    @IBOutlet weak var strengthLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var durabilityLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var combatLabel: UILabel!
    @IBOutlet weak var raceLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var randomizeButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var allHeroes: [SuperHero] = []
        
       
    private func setupUI() {
        randomizeButton.layer.cornerRadius = 10
        heroImageView.layer.cornerRadius = 15
        heroImageView.clipsToBounds = true
        
        // Set default state
        setLoadingState(true)
    }
    
    private func fetchAllHeroes() {
        NetworkManager.shared.fetchAllHeroes { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let heroes):
                    self.allHeroes = heroes
                    self.fetchRandomHero()
                case .failure(let error):
                    self.showError(message: error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func randomizeButtonTapped(_ sender: Any) {
        fetchRandomHero()
    }
    
    private func fetchRandomHero() {
        guard !allHeroes.isEmpty else { return }
        
        setLoadingState(true)
        
        let randomHero = allHeroes.randomElement()!
        updateUI(with: randomHero)
        
        // Fetch hero image
        NetworkManager.shared.downloadImage(from: randomHero.images.lg) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let imageData):
                    UIView.transition(with: self.heroImageView,
                                    duration: 0.3,
                                    options: .transitionCrossDissolve,
                                    animations: {
                        self.heroImageView.image = UIImage(data: imageData)
                    })
                case .failure(let error):
                    self.showError(message: error.localizedDescription)
                }
                
                self.setLoadingState(false)
            }
        }
    }
    
    private func updateUI(with hero: SuperHero) {
        nameLabel.text = hero.name
        fullNameLabel.text = "Full Name: \(hero.biography.fullName)"
        intelligenceLabel.text = "Intelligence: \(hero.powerstats.intelligence)"
        strengthLabel.text = "Strength: \(hero.powerstats.strength)"
        speedLabel.text = "Speed: \(hero.powerstats.speed)"
        durabilityLabel.text = "Durability: \(hero.powerstats.durability)"
        powerLabel.text = "Power: \(hero.powerstats.power)"
        combatLabel.text = "Combat: \(hero.powerstats.combat)"
        raceLabel.text = "Race: \(hero.appearance.race ?? "Unknown")"
        genderLabel.text = "Gender: \(hero.appearance.gender)"
    }
    
    private func setLoadingState(_ loading: Bool) {
        randomizeButton.isEnabled = !loading
        if loading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error",
                                    message: message,
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        setLoadingState(false)
    }

}

