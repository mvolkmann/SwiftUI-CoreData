import SwiftUI

struct ContentView: View {
    @StateObject var vm = ViewModel()
    @State var editingDog: Dog? = nil
    @State var breed: String = ""
    @State var name: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Dog Name", text: $name)
                        .textFieldStyle(.roundedBorder)
                    TextField("Dog Breed", text: $breed)
                        .textFieldStyle(.roundedBorder)

                    Button(editingDog == nil ? "Add" : "Update") {
                        if let dog = editingDog {
                            dog.name = name
                            dog.breed = breed
                            vm.saveDogs()
                            editingDog = nil
                        } else {
                            vm.addDog(name: name, breed: breed)
                        }

                        name = ""
                        breed = ""
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(name.isEmpty || breed.isEmpty)
                }

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
                
                Spacer()
            }.navigationTitle("Dogs")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
