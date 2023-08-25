//
//  ContentView.swift
//  VenusWeatherMac
//
//  Created by Ibrahima Ciss on 19/08/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var searchText = ""


    var body: some View {
        NavigationSplitView {
            Text("Sidebar")
                .navigationSplitViewColumnWidth(min: 240, ideal: 260, max: 320)
                .navigationSplitViewStyle(.prominentDetail)
        } detail: {
            VStack {
                MainContentView(model: .init())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(Color.clear)
            // .background(.ultraThinMaterial)
            .background(BlurWindow())
        }

        .searchable(text: $searchText, prompt: Text("Search for location"))
        /* .toolbar {
         ToolbarItem {
         Button(action: addItem) {
         Label("Add Item", systemImage: "plus")
         }
         }
         }*/
    }


}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct BlurWindow: NSViewRepresentable {

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = .fullScreenUI
        view.blendingMode = .behindWindow
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {

    }
}
