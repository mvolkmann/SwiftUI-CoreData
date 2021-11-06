import SwiftUI

struct PeopleView: View {
    @StateObject var vm: ViewModel
    
    @State var editingPerson: PersonEntity? = nil
    @State var name: String = ""
    @State var nameFilter: String = ""
    
    /*
    func deleteAll() {
        PersonEntity.
    }
    */
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Person Name", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .disableAutocorrection(true)

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

                        name = ""
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(name.isEmpty)
                    
                    TextField("Filter", text: $nameFilter)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .onChange(of: nameFilter) {
                            vm.fetchPeople(filter: $0)
                        }
                    
                    //Button("Delete All") { deleteAll() }
                }
                .frame(maxWidth: .infinity, maxHeight: 150)

                // Is it required to use ForEach inside List
                // in order to specify onDelete?
                List {
                    ForEach(vm.people) { person in
                        HStack {
                            Text(person.name ?? "no name")
                            Spacer()
                            Image(systemName: "pencil")
                                .onTapGesture {
                                    editingPerson = person
                                    name = person.name ?? ""
                                }
                        }
                    }
                    .onDelete(perform: vm.deletePerson)
                }
                .listStyle(PlainListStyle())
            }.navigationTitle("Persons")
        }
    }
}
