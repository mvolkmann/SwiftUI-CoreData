import SwiftUI

struct DogsView: View {
    @StateObject var vm: ViewModel

    @State var editingDog: DogEntity? = nil
    @State var breed: String = ""
    @State var name: String = ""
    // @State var selectedPerson: PersonEntity? = nil
    @State var selectedPersonName: String = ""

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

                    // TODO: Allow an owner to be selected.
                    Picker("Owner", selection: $selectedPersonName) {
                        ForEach(vm.people) {
                            Text($0.name ?? "").tag($0.name ?? "")
                        }
                    }
                    //.pickerStyle(WheelPickerStyle())
                    Text("You selected \(selectedPersonName)")

                    Button(editingDog == nil ? "Add" : "Update") {
                        if let dog = editingDog {
                            dog.name = name
                            dog.breed = breed
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
