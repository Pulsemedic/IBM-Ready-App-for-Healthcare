/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit
import XCTest
import CoreData
@testable import Healthcare

class PainDataTests: XCTestCase {
    
    var model: NSManagedObjectModel!
    var coordinator: NSPersistentStoreCoordinator!
    var store: NSPersistentStore!
    var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        // work around from using the main core data stack in the app target
        model = NSManagedObjectModel.mergedModelFromBundles(NSBundle.allBundles())
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        do {
            store = try coordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
        } catch _ {
            store = nil
        }
        context = NSManagedObjectContext()
        context.persistentStoreCoordinator = coordinator

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // Method tests the data model, PainData utility methods wouldn't work (casting issue)
    func testCreateAndRead() {
        
        for index in 1...10 {
            let newItem: AnyObject = NSEntityDescription.insertNewObjectForEntityForName(painDataName, inManagedObjectContext: context)
            newItem.setValue(index, forKey: "painRating")
            newItem.setValue("I'm doing well", forKey: "painDescription")
            newItem.setValue(NSDate(), forKey: "timeStamp")

        }
        
        let fetchRequest = NSFetchRequest(entityName: painDataName)
        do {
            let fetchResults = try context.executeFetchRequest(fetchRequest)
            for result in fetchResults {
                let rating: Int? = result.valueForKey("painRating") as? Int
                let description: AnyObject? = result.valueForKey("painDescription")
                XCTAssertTrue(rating > 0 && rating < 11, "Object rating is out of range")
                XCTAssertNotNil(description, "Object descripion is empty")
                print("desc: \(rating!) and \(description!)")
            }
        } catch _ {
        }
    }
    
    func testPerformanceExample() {
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
   
}
