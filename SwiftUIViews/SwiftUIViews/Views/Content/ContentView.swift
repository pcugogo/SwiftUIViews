//
//  ContentView.swift
//  SwiftUIViews
//
//  Created by ChanWook on 5/16/24.
//

import SwiftUI

struct ContentView: View {
    @State private var topOffsetControlScrollViewOffsetY: CGFloat = .zero
    
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
            
            Section {
                NavigationLink {
                    VStack(spacing: 0) {
                        Spacer()
                        
                        let array = 0...20
                        
                        OffsetControlScrollView(
                            targetOffsetY: nil,
                            onChangeScrollOffsetY: {
                                topOffsetControlScrollViewOffsetY = $0
                            },
                            contentView: {
                                VStack {
                                    ForEach(array, id: \.self) { int in
                                        Text("\(int)")
                                            .frame(height: 25)
                                    }
                                }
                            }
                        )
                        .background(.yellow)
                        
                        OffsetControlScrollView(
                            targetOffsetY: topOffsetControlScrollViewOffsetY,
                            onChangeScrollOffsetY: nil,
                            contentView: {
                                VStack {
                                    ForEach(array, id: \.self) { int in
                                        Text("\(int)")
                                            .frame(height: 25)
                                    }
                                }
                            }
                        )
                        .background(.green)
                    }
                } label: {
                    Text("OffsetControlScrollViewExample")
                }
            } header: {
                Text("ScrollableViews")
            }
        }
    }
}

#Preview {
    ContentView()
}
