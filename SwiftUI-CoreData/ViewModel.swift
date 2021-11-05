import CoreData
import Foundation

class ViewModel: ObservableObject {
    @Published var dogs: [Dog] = []
    let container: NSPersistentContainer

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
        let newDog = Dog(context: container.viewContext)
        newDog.name = name
        newDog.breed = breed
        saveDogs() // seems very inefficient to save ALL the dogs
    }
    
    func deleteDog(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        container.viewContext.delete(dogs[index])
        saveDogs()
    }
    
    func fetchDogs() {
        let request = NSFetchRequest<Dog>(entityName: "Dog")
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        do {
            dogs = try container.viewContext.fetch(request)
        } catch {
            print("fetchDogs error:", error)
        }
    }
    
    func saveDogs() {
        do {
            try container.viewContext.save()
            fetchDogs() // seems very inefficient to fetch ALL the dogs again
        } catch {
            print("saveDogs error:", error)
        }
    }
}
