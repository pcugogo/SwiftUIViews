//
//  OffsetControlScrollView.swift
//  SwiftUIViews
//
//  Created by ChanWook on 12/28/24.
//

import SwiftUI

struct OffsetControlScrollView<Content: View>: View {
    @State private var scrollHeight: CGFloat? = .zero
    @State private var contentHeight: CGFloat? = .zero
    @State private var scrollMaxOffsetY: CGFloat = .zero
    @State private var currentScrollOffsetY: CGFloat = .zero

    let targetOffsetY: CGFloat?
    var onChangeScrollOffsetY: ((CGFloat) -> Void)?
    
    @ViewBuilder
    let contentView: Content
    
    private let scrollID = "ScrollID"

    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                ZStack {
                    Spacer()
                        .id(scrollID)
                    
                    contentView
                        .onChangeScrollOffset {
                            currentScrollOffsetY = $0.y
                            onChangeScrollOffsetY?($0.y)
                        }
                        .onChangeSize(perform: {
                            contentHeight = $0.height
                        })
                }
            }
            .onChangeSize(perform: {
                scrollHeight = $0.height
            })
            .onChange(of: scrollHeight) { _ in
                updateMaxOffsetY()
            }
            .onChange(of: contentHeight) { _ in
                updateMaxOffsetY()
            }
            .onChange(of: targetOffsetY) { targetOffsetY in
                guard let targetOffsetY else { return }
                guard targetOffsetY != currentScrollOffsetY else { return }
                let anchor = calculateAnchor(contentOffsetY: targetOffsetY)
                scrollProxy.scrollTo(scrollID, anchor: anchor)
            }
        }
    }
}

private extension OffsetControlScrollView {
    func updateMaxOffsetY() {
        guard let contentHeight, let scrollHeight else { return }
        scrollMaxOffsetY = max(contentHeight, contentHeight - scrollHeight)
    }
    
    func calculateAnchor(contentOffsetY: CGFloat) -> UnitPoint {
        let y = max(0, min(contentOffsetY / scrollMaxOffsetY, 1))
        let anchor = UnitPoint(x: 0.5, y: y)
        return anchor
    }
    
    struct ScrollOffsetPreferenceKey: SwiftUI.PreferenceKey {
        static var defaultValue: CGFloat { .zero }

        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
    }
}

private extension View {
    func onChangeSize(perform: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: perform)
    }
    
    func onChangeScrollOffset(
        coordinateSpace: CoordinateSpace = .named("onChangeScrollOffset"),
        perform: @escaping (CGPoint) -> Void
    ) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(
                        key: ScrollOffsetPreferenceKey.self,
                        value: CGPoint(
                            x: -geometryProxy.frame(in: coordinateSpace).minX,
                            y: -geometryProxy.frame(in: coordinateSpace).minY
                        )
                    )
            }
        )
        .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: perform)
    }
}

private struct SizePreferenceKey: PreferenceKey {
   public static var defaultValue: CGSize = .zero
   public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}
