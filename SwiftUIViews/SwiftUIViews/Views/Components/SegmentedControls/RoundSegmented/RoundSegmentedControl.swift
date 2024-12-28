//
//  RoundSegmentedControl.swift
//  SwiftUIViews
//
//  Created by ChanWook on 5/16/24.
//

import SwiftUI

struct RoundSegmentedControl: View {
    private enum Constants {
        static let height: CGFloat = 57
        static let cornerRadius: CGFloat = 30
        static let horizontalPadding: CGFloat = 20
        static let focusRoundedRectanglePadding: CGFloat = 5
    }
    
    var items: [RoundItem]
    
    @Binding var selectedIndex: Int
    
    var body: some View {
        VStack {
            GeometryReader {
                let size = $0.size
                let tabWidth = size.width / CGFloat(items.count)
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .fill(.yellow)
                        .padding(Constants.focusRoundedRectanglePadding)
                        .frame(width: tabWidth)
                        .offset(x: tabWidth * CGFloat(selectedIndex), y: 0)
                        .animation(.interactiveSpring(duration: 0.3), value: selectedIndex)
                    
                    HStack(spacing: 0) {
                        ForEach(items.enumeratedArray(), id: \.element.id) { index, item in
                            Button(action: {
                                selectedIndex = index
                            }, label: {
                                Text(item.title)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            })
                            .foregroundStyle(selectedIndex == index ? .white : .gray)
                        }
                    }
                }
            }
            .background(Color(.gray.withAlphaComponent(0.3)))
            .cornerRadius(Constants.cornerRadius)
        }
        .frame(height: Constants.height)
        .padding(.horizontal, Constants.horizontalPadding)
    }
}

struct RoundItem: Identifiable, Equatable {
    let title: String
    
    var id: String {
        title
    }
}

#Preview {
    @State var selectedIndex = 0
    
    let tabs: [RoundItem] = [
        .init(title: "1"),
        .init(title: "2")
    ]
    
    return RoundSegmentedControl(
        items: tabs,
        selectedIndex: $selectedIndex
    )
}
