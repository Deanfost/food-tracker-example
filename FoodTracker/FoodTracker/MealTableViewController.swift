//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Dean  Foster on 1/20/19.
//  Copyright © 2019 Dean  Foster. All rights reserved.
//

import UIKit

let cellIdentifier = "MealTableViewCell"

class MealTableViewController: UITableViewController {
    
    // MARK: Properties
    var meals = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleMeals()
    }
    
    // MARK: UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Request an old/new cell from the TableView for use
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as? MealTableViewCell else {
            fatalError("Dequeued instance is not an instance of MealTableViewCell.")
        }
        
        // Fetch the correct meal
        let meal = meals[indexPath.row]
        
        // Configure the cell
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        return cell
    }
    
    // MARK: Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        // Get the new meal from the previous controller, add it to the model and TableView
        if let sourceViewController = sender.source as? MealViewController,
            let meal = sourceViewController.meal {
            let newIndexPath = IndexPath(row: meals.count, section: 0)
            meals.append(meal)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    // MARK: Private Methods
    private func loadSampleMeals() {
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        let photo4 = UIImage(named: "meal4")
        
        guard let meal1 = Meal(name: "Meal1", photo: photo1, rating: 4) else {
            fatalError("Could not instantiate meal1")
        }
        
        guard let meal2 = Meal(name: "Meal2", photo: photo2, rating: 1) else {
            fatalError("Could not instantiate meal2")
        }
        
        guard let meal3 = Meal(name: "Meal3", photo: photo3, rating: 2) else {
            fatalError("Could not instantiate meal3")
        }
        
        guard let meal4 = Meal(name: "Meal4", photo: photo4, rating: 5) else {
            fatalError("Could not instantiate meal4")
        }
        
        // Add the new meals to the list
        meals += [meal1, meal2, meal3, meal4]
    }
}
