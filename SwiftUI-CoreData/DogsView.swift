import SwiftUI

struct DogsView: View {
    @StateObject var vm: ViewModel

    @State private var editingDog: DogEntity? = nil
    @State private var breed: String = ""
    @State private var name: String = ""
    @State private var selectedPersonId: UUID? = nil

    private var selectedPerson: PersonEntity? {
        //selectedPersonIndex == -1 ? nil : vm.people[selectedPersonIndex]
        vm.people.first(where: { $0.id == selectedPersonId})
    }

    func clear() {
        editingDog = nil
        name = ""
        breed = ""
        selectedPersonId = nil
    }

    func edit(dog: DogEntity) {
        editingDog = dog
        name = dog.name ?? ""
        breed = dog.breed ?? ""
        let selectedPerson = vm.people.first(
            where: { $0.name == dog.ownedBy?.name }
        )
        selectedPersonId = selectedPerson?.id
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Dog Name", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .disableAutocorrection(true)
                    TextField("Dog Breed", text: $breed)
                        .textFieldStyle(.roundedBorder)
                    Picker("Owner", selection: $selectedPersonId) {
                        ForEach(vm.people) { person in
                            Text(person.name ?? "").tag(person.id)
                        }
                    }

                    HStack {
                        Button(editingDog == nil ? "Add" : "Update") {
                            if let dog = editingDog {
                                dog.name = name
                                dog.breed = breed
                                if let owner = selectedPerson {
                                    dog.ownedBy = owner
                                }
                                vm.saveDogs()
                            } else {
                                withAnimation {
                                    vm.addDog(
                                        name: name,
                                        breed: breed,
                                        ownedBy: selectedPerson
                                    )
                                }
                            }

                            clear()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(name.isEmpty || breed.isEmpty)

                        if editingDog != nil {
                            Button("Cancel", action: clear)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 180)

                // Is it required to use ForEach inside List
                // in order to specify onDelete?
                List {
                    ForEach(vm.dogs, id: \.id) { dog in
                        HStack {
                            Text(dog.name ?? "no name")
                            Spacer()
                            Text(dog.breed ?? "no breed")
                        }
                        .onTapGesture {
                            edit(dog: dog)
                        }
                    }
                    .onDelete(perform: vm.deleteDog)
                }
                .listStyle(PlainListStyle())
            }.navigationTitle("Dogs")
        }
    }
}
