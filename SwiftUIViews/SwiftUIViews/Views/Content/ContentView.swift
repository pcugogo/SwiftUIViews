//
//  ContentView.swift
//  SwiftUIViews
//
//  Created by ChanWook on 5/16/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        List {
            Section {
                NavigationLink {
                    let pages = PageType
                        .allCases
                        .map { SampleList(title: $0.rawValue) }
                    RoundSegmentedControlExampleView(pages: pages)
                } label: {
                    Text("RoundSegmentedControlExample")
                }
            } header: {
                Text("SegmentedControls")
            }   
        }
    }
}

#Preview {
    ContentView()
}
