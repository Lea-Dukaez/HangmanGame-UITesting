//
//  HomeTableViewController.swift
//  hangmanGame
//
//  Created by Léa Dukaez on 12/10/2021.
//

import UIKit

class HomeTableViewController: UITableViewController {

    let reuseThemeCell = "reuseThemeCell"
    var themes = ["espace", "animaux"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Jeu du pendu"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return themes.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseThemeCell, for: indexPath)
        
        var content = cell.defaultContentConfiguration()

        content.image = UIImage(named: themes[indexPath.row])
        content.text = themes[indexPath.row]
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let gameVC = storyboard?.instantiateViewController(withIdentifier: "gameVC") as? GameViewController {
            gameVC.selectedTheme = themes[indexPath.row]
            
            let backItem = UIBarButtonItem()
            backItem.title = "Thèmes"
            navigationItem.backBarButtonItem = backItem
            
            navigationController?.pushViewController(gameVC, animated: true)
        }
    }

}
