import CoreData
import Foundation

class ViewModel: ObservableObject {
    let container: NSPersistentContainer
    
    @Published var dogs: [Dog] = []
    var context: NSManagedObjectContext { container.viewContext }

    init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("error loading Core Data:", error)
            } else {
                print("loaded Core Data")
                self.fetchDogs()
            }
        }
    }
    
    func addDog(name: String, breed: String) {
        let newDog = Dog(context: context)
        newDog.name = name
        newDog.breed = breed
        saveDogs()
    }
    
    func deleteDog(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        context.delete(dogs[index])
        saveDogs()
    }
    
    func fetchDogs() {
        let request = NSFetchRequest<Dog>(entityName: "Dog")
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        do {
            dogs = try context.fetch(request)
        } catch {
            print("fetchDogs error:", error)
        }
    }
    
    func saveDogs() {
        do {
            try context.save()
            // It seems very inefficient to fetch ALL the dogs again
            // every time one is added, deleted, or updated!
            fetchDogs()
        } catch {
            print("saveDogs error:", error)
        }
    }
}
