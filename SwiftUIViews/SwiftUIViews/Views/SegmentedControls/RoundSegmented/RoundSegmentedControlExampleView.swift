//
//  RoundSegmentedControlExampleView.swift
//  SwiftUIViews
//
//  Created by ChanWook on 5/16/24.
//

import Combine
import SwiftUI

enum PageType: String, CaseIterable {
    case first
    case second
}

final class PageViewModel: ObservableObject {
    @Published var currentPage = 0
}

struct RoundSegmentedControlExampleView<Page: View>: View {
    var pages: [Page]
    
    @ObservedObject private var pageViewModel = PageViewModel()
    
    private let viewControllers = PageType
        .allCases
        .map { SampleList(title: $0.rawValue) }
    
    var body: some View {
        VStack {
            RoundSegmentedControl(
                items: PageType.allCases.map { .init(title: $0.rawValue) },
                selectedIndex: $pageViewModel.currentPage
            )
            
            PageView(
                pages: viewControllers,
                currentPage: $pageViewModel.currentPage
            )
        }
    }
}

#Preview {
    RoundSegmentedControlExampleView(
        pages: PageType.allCases.map { SampleList(title: $0.rawValue) }
    )
}
