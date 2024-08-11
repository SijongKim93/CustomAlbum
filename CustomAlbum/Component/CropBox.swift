//
//  CropBox.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/11/24.
//

import Foundation
import SwiftUI

public struct CropBox: View {
    @Binding public var rect: CGRect
    public let minSize: CGSize

    @State private var initialRect: CGRect? = nil
    @State private var frameSize: CGSize = .zero
    @State private var draggedCorner: UIRectCorner? = nil

    public init(
        rect: Binding<CGRect>,
        minSize: CGSize = .init(width: 100, height: 100)
    ) {
        self._rect = rect
        self.minSize = minSize
    }

    private var rectDrag: some Gesture {
        DragGesture()
            .onChanged { gesture in
                if initialRect == nil {
                    initialRect = rect
                    draggedCorner = closestCorner(point: gesture.startLocation, rect: rect)
                }

                if let draggedCorner {
                    self.rect = dragResize(
                        initialRect: initialRect!,
                        draggedCorner: draggedCorner,
                        frameSize: frameSize,
                        translation: gesture.translation
                    )
                } else {
                    self.rect = drag(
                        initialRect: initialRect!,
                        frameSize: frameSize,
                        translation: gesture.translation
                    )
                }
            }
            .onEnded { _ in
                initialRect = nil
                draggedCorner = nil
            }
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            overlayOutsideCropBox
            box // 내부 격자 및 크롭박스
        }
        .background {
            GeometryReader { geometry in
                Color.clear
                    .onAppear { self.frameSize = geometry.size }
                    .onChange(of: geometry.size) { _, newSize in
                        self.frameSize = newSize
                    }
            }
        }
    }

    private var overlayOutsideCropBox: some View {
        ZStack {
            Color.white.opacity(0.001)
                .frame(width: rect.width, height: rect.height)
                .position(x: rect.midX, y: rect.midY)
        }
        .compositingGroup()
        .blendMode(.destinationOut)
    }

    private var box: some View {
        ZStack {
            grid
            pins
        }
        .border(Color.blue, width: 2)
        .background(Color.white.opacity(0.001))
        .frame(width: rect.width, height: rect.height)
        .position(x: rect.midX, y: rect.midY)
        .gesture(rectDrag)
    }

    private var pins: some View {
        VStack {
            HStack {
                pin(corner: .topLeft)
                Spacer()
                pin(corner: .topRight)
            }
            Spacer()
            HStack {
                pin(corner: .bottomLeft)
                Spacer()
                pin(corner: .bottomRight)
            }
        }
    }

    private func pin(corner: UIRectCorner) -> some View {
        var offX = 1.0
        var offY = 1.0

        switch corner {
        case .topLeft:      offX = -1; offY = -1
        case .topRight:     offY = -1
        case .bottomLeft:   offX = -1
        case .bottomRight: break
        default: break
        }

        return Circle()
            .fill(Color.blue)
            .frame(width: 16, height: 16)
            .offset(x: offX * 8, y: offY * 8)
    }

    private var grid: some View {
        ZStack {
            HStack {
                Spacer()
                Rectangle()
                    .frame(width: 1)
                    .frame(maxHeight: .infinity)
                Spacer()
                Rectangle()
                    .frame(width: 1)
                    .frame(maxHeight: .infinity)
                Spacer()
            }
            VStack {
                Spacer()
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                Spacer()
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                Spacer()
            }
        }
        .foregroundColor(.gray)
    }

    private func closestCorner(point: CGPoint, rect: CGRect, distance: CGFloat = 16) -> UIRectCorner? {
        let ldX = abs(rect.minX.distance(to: point.x)) < distance
        let rdX = abs(rect.maxX.distance(to: point.x)) < distance
        let tdY = abs(rect.minY.distance(to: point.y)) < distance
        let bdY = abs(rect.maxY.distance(to: point.y)) < distance

        guard (ldX || rdX) && (tdY || bdY) else { return nil }

        return if ldX && tdY { .topLeft }
        else if rdX && tdY { .topRight }
        else if ldX && bdY { .bottomLeft }
        else if rdX && bdY { .bottomRight }
        else { nil }
    }

    private func dragResize(initialRect: CGRect, draggedCorner: UIRectCorner, frameSize: CGSize, translation: CGSize) -> CGRect {
        var offX = 1.0
        var offY = 1.0

        switch draggedCorner {
        case .topLeft:      offX = -1; offY = -1
        case .topRight:     offY = -1
        case .bottomLeft:   offX = -1
        case .bottomRight: break
        default: break
        }

        // 새로운 폭과 높이 계산
        let idealWidth = initialRect.size.width + offX * translation.width
        var newWidth = max(idealWidth, minSize.width)

        let idealHeight = initialRect.size.height + offY * translation.height
        var newHeight = max(idealHeight, minSize.height)

        // 새로운 X, Y 위치 계산
        var newX = initialRect.minX
        var newY = initialRect.minY

        if offX < 0 {
            let widthChange = newWidth - initialRect.width
            newX = max(newX - widthChange, 0)
            newWidth = min(newWidth, initialRect.maxX)
        } else {
            newWidth = min(newWidth, frameSize.width - initialRect.minX)
        }

        if offY < 0 {
            let heightChange = newHeight - initialRect.height
            newY = max(newY - heightChange, 0)
            newHeight = min(initialRect.maxY, newHeight)
        } else {
            newHeight = min(newHeight, frameSize.height - initialRect.minY)
        }

        // 크롭 박스가 프레임 크기를 넘어가지 않도록 제한
        newWidth = min(newWidth, frameSize.width - newX)
        newHeight = min(newHeight, frameSize.height - newY)

        return CGRect(origin: CGPoint(x: newX, y: newY), size: CGSize(width: newWidth, height: newHeight))
    }

    private func drag(initialRect: CGRect, frameSize: CGSize, translation: CGSize) -> CGRect {
        let maxX = frameSize.width - initialRect.width
        let newX = min(max(initialRect.origin.x + translation.width, 0), maxX)
        let maxY = frameSize.height - initialRect.height
        let newY = min(max(initialRect.origin.y + translation.height, 0), maxY)

        return .init(origin: .init(x: newX, y: newY), size: initialRect.size)
    }
}
