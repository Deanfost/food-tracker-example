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
        // Fail if invalid values were given
        if (name.isEmpty || rating < 0) {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.rating = rating
    }
}
