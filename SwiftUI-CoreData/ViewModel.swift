import CoreData
import Foundation

class ViewModel: ObservableObject {
    let container: NSPersistentContainer
    
    @Published var dogs: [Dog] = []
    @Published var people: [Person] = []
    var context: NSManagedObjectContext { container.viewContext }

    init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("error loading Core Data:", error)
            } else {
                print("loaded Core Data")
                self.fetchDogs()
                self.fetchPeople()
            }
        }
    }
    
    func addDog(name: String, breed: String) {
        let newDog = Dog(context: context)
        newDog.name = name
        newDog.breed = breed
        saveDogs()
    }
    
    func addPerson(name: String) {
        let newPerson = Person(context: context)
        newPerson.name = name
        savePeople()
    }
    
    func deleteDog(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        context.delete(dogs[index])
        saveDogs()
    }
    
    func deletePerson(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        context.delete(people[index])
        savePeople()
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
    
    func fetchPeople() {
        let request = NSFetchRequest<Person>(entityName: "Person")
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        do {
            people = try context.fetch(request)
        } catch {
            print("fetchPeople error:", error)
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
    
    func savePeople() {
        do {
            try context.save()
            // It seems very inefficient to fetch ALL the people again
            // every time one is added, deleted, or updated!
            fetchPeople()
        } catch {
            print("saveDogs error:", error)
        }
    }
}
