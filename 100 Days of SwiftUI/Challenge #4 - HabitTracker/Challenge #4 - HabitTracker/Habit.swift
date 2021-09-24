//
//  Habit.swift
//  Challenge #4 - HabitTracker
//
//  Created by Bruno Benčević on 9/24/21.
//

import Foundation

struct Habit: Identifiable, Codable {
    let id = UUID()
    let name: String
    let description: String?
    let sfImageName: String?
    var hours: Float
    
    static func loadHabits() -> [Habit] {
        var loadedHabits = [Habit]()
        
        if let data = UserDefaults.standard.object(forKey: "habits") as? Data {
            if let habits = try? JSONDecoder().decode([Habit].self, from: data) {
                loadedHabits = habits
            }
        }
        
        return loadedHabits
    }
    
    static func saveHabits(habits: [Habit]) {
        
    }
}

class Habits: ObservableObject {
    @Published var items: [Habit] {
        didSet {
            if let jsonData = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(jsonData, forKey: "habits")
            }
        }
    }
    
    init() {
        if let data = UserDefaults.standard.object(forKey: "habits") as? Data {
            if let habits = try? JSONDecoder().decode([Habit].self, from: data) {
                self.items = habits
                return
            }
        }
        
        self.items = [Habit]()
    }
    
    init(items: [Habit]) {
        self.items = items
    }
}
