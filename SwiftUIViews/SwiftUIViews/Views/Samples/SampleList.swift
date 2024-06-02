//
//  SampleList.swift
//  SwiftUIViews
//
//  Created by ChanWook on 5/16/24.
//

import SwiftUI

struct SampleList: View {
    let title: String
    private let list = Array(repeating: "0", count: 20)
    
    var body: some View {
        List {
            Section(title) {
                ForEach(list, id: \.self) { text in
                    Text(text)
                        .listRowSeparator(.hidden)
                }
            }   
        }
        .listStyle(.plain)
    }
}

#Preview {
    SampleList(title: "Test")
}
