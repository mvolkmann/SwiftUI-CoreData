import CoreData
import Foundation

class ViewModel: ObservableObject {
    let container: NSPersistentContainer
    var context: NSManagedObjectContext { container.viewContext }
    
    @Published var dogs: [DogEntity] = []
    @Published var people: [PersonEntity] = []

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
    
    func addDog(name: String, breed: String, ownedBy: PersonEntity?) {
        let dog = DogEntity(context: context)
        dog.name = name
        dog.breed = breed
        dog.ownedBy = ownedBy
        saveDogs()
        dogs.append(dog)
        dogs.sort { ($0.name ?? "") < ($1.name ?? "") }
    }
    
    func addPerson(name: String) {
        let person = PersonEntity(context: context)
        person.name = name
        savePeople()
        people.append(person)
        people.sort { ($0.name ?? "") < ($1.name ?? "") }
    }
    
    func deleteDog(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        context.delete(dogs[index])
        saveDogs()
        dogs.remove(at: index)
    }
    
    func deletePerson(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        context.delete(people[index])
        savePeople()
        people.remove(at: index)
    }
    
    func fetchDogs() {
        let request = NSFetchRequest<DogEntity>(entityName: "DogEntity")
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        do {
            dogs = try context.fetch(request)
        } catch {
            print("fetchDogs error:", error)
        }
    }
    
    func fetchPeople(filter: String = "") {
        print("fetchPeople: filter =", filter)
        let request = NSFetchRequest<PersonEntity>(entityName: "PersonEntity")
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        if !filter.isEmpty {
            print("skipping filter")
            //TODO: Why does this cause a fatal error now?  It worked earlier.
            //request.predicate = NSPredicate(format: "name contains %@", filter)
        }
        
        do {
            people = try context.fetch(request)
        } catch {
            print("fetchPeople error:", error)
        }
    }
    
    func saveDogs() {
        do {
            try context.save()
        } catch {
            print("saveDogs error:", error)
        }
    }
    
    func savePeople() {
        do {
            try context.save()
        } catch {
            print("savePeople error:", error)
        }
    }
}
