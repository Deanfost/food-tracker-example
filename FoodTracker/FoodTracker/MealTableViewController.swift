//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Dean  Foster on 1/20/19.
//  Copyright © 2019 Dean  Foster. All rights reserved.
//

import UIKit
import os.log

let cellIdentifier = "MealTableViewCell"

class MealTableViewController: UITableViewController {
    
    // MARK: Properties
    var meals = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add an "edit" button on the left side of the nav bar
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load the meals from memory
        if let savedMeals = loadMeals() {
            meals += savedMeals
        } else {
            loadSampleMeals()
        }
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source, persist the change
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        // Get the new meal from the previous controller, add it to the model and TableView
        if let sourceViewController = sender.source as? MealViewController,
            let meal = sourceViewController.meal {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Edit an existing meal in the table
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new meal to the table
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Update the stored table
            saveMeals()
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier ?? "" {
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? MealViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "")")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
        default:
            fatalError("Unexpected segue identifier: \(segue.identifier ?? "")")
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
    
    private func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadMeals() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }
}
