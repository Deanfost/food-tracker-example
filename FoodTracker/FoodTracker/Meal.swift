//
//  Meal.swift
//  FoodTracker
//
//  Created by Dean  Foster on 1/19/19.
//  Copyright © 2019 Dean  Foster. All rights reserved.
//

import UIKit

class Meal {
    
    // MARK: Properties
    var name: String
    var photo: UIImage?
    var rating: Int
    
    // MARK: Initializiation
    init?(name: String, photo: UIImage?, rating: Int) {
        // Name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // Rating must be between 0 and 5 inclusive
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        // Initialize properties
        self.name = name
        self.photo = photo
        self.rating = rating
    }
}
