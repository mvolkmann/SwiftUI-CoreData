import SwiftUI

struct DogsView: View {
    @StateObject var vm: ViewModel

    @State private var editingDog: DogEntity? = nil
    @State private var breed: String = ""
    @State private var name: String = ""
    @State private var selectedPersonIndex: Int = -1

    private var selectedPerson: PersonEntity? {
        selectedPersonIndex == -1 ? nil : vm.people[selectedPersonIndex]
    }

    /*
     func deleteMe() {
         if let dog = editingDog {
             dog.ownedBy.
         }
     }
     */

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Dog Name", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .disableAutocorrection(true)
                    TextField("Dog Breed", text: $breed)
                        .textFieldStyle(.roundedBorder)

                    Picker("Owner", selection: $selectedPersonIndex) {
                        ForEach(vm.people.indices) { index in
                            Text(vm.people[index].name ?? "").tag(index)
                        }
                    }

                    Button(editingDog == nil ? "Add" : "Update") {
                        if let dog = editingDog {
                            dog.name = name
                            dog.breed = breed
                            if let owner = selectedPerson {
                                dog.ownedBy = owner
                            }
                            vm.saveDogs()
                            editingDog = nil
                        } else {
                            withAnimation {
                                vm.addDog(name: name, breed: breed)
                            }
                        }

                        name = ""
                        breed = ""
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(name.isEmpty || breed.isEmpty)
                }
                .frame(maxWidth: .infinity, maxHeight: 180)

                // Is it required to use ForEach inside List
                // in order to specify onDelete?
                List {
                    ForEach(vm.dogs) { dog in
                        HStack {
                            Text(dog.name ?? "no name")
                            Text(dog.breed ?? "no breed")
                            Spacer()
                            Image(systemName: "pencil")
                                .onTapGesture {
                                    editingDog = dog
                                    name = dog.name ?? ""
                                    breed = dog.breed ?? ""
                                    selectedPersonIndex = vm.people.firstIndex(
                                        where: { $0.name == dog.ownedBy?.name }
                                    ) ?? -1
                                }
                        }
                    }
                    .onDelete(perform: vm.deleteDog)
                }
                .listStyle(PlainListStyle())
            }.navigationTitle("Dogs")
        }
    }
}
