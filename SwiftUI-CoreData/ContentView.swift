import SwiftUI

struct ContentView: View {
    // @StateObject var vm = ViewModel()
    var vm = ViewModel()

    var body: some View {
        TabView {
            DogsView(vm: vm).tabItem {
                //Image("comet-32")
                Image("dog-emoji")
                Text("Dogs").foregroundColor(.red)
            }
            PeopleView(vm: vm).tabItem {
                Image(systemName: "person.3.fill")
                Text("People")
            }
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = .systemGray5
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
