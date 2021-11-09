import SwiftUI

struct PeopleView: View {
    @StateObject var vm: ViewModel
    
    @State private var dogNames: [String] = []
    @State private var editingPerson: PersonEntity? = nil
    @State private var name: String = ""
    @State private var nameFilter: String = ""
    
    func clear() {
        editingPerson = nil
        name = ""
        dogNames = []
    }
    
    func edit(person: PersonEntity) {
        editingPerson = person
        name = person.name ?? ""
        
        // Get an array of dog names owned by the selected person.
        let owns = person.owns as? Set<DogEntity> ?? []
        dogNames = owns.map() { $0.name ?? "" }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Person Name", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .disableAutocorrection(true)

                    HStack {
                        Button(editingPerson == nil ? "Add" : "Update") {
                            if let person = editingPerson {
                                person.name = name
                                vm.savePeople()
                                editingPerson = nil
                            } else {
                                withAnimation {
                                    vm.addPerson(name: name)
                                }
                            }

                            clear()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(name.isEmpty)

                        if editingPerson != nil {
                            Button("Cancel", action: clear)
                        }
                    }
                    
                    TextField("Filter", text: $nameFilter)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .onChange(of: nameFilter) {
                            vm.fetchPeople(filter: $0)
                        }
                    
                    if !dogNames.isEmpty {
                        Text("owns \(dogNames.joined(separator: " & "))")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 190)

                // Is it required to use ForEach inside List
                // in order to specify onDelete?
                List {
                    ForEach(vm.people, id: \.id) { person in
                        Text(person.name ?? "no name")
                            .onTapGesture {
                                edit(person: person)
                            }
                    }
                    .onDelete(perform: vm.deletePerson)
                }
                .listStyle(PlainListStyle())
            }.navigationTitle("Persons")
        }
    }
}
