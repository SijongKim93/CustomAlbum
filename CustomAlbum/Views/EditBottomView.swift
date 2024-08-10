//
//  EditBottomView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/10/24.
//

import SwiftUI

struct EditBottomView: View {
    @ObservedObject var viewModel: EditImageViewModel

    var body: some View {
        VStack {
            if $viewModel.selectedAction != nil {
                EditActionView(selectedAction: $viewModel.selectedAction, editViewModel: viewModel)
            }
            HStack {
                Button(action: {
                    withAnimation {
                        viewModel.applyFilter()
                    }
                }) {
                    VStack {
                        Image(systemName: "camera.filters")
                            .font(.system(size: 24))
                            .foregroundColor(.black)
                    }
                }
                .padding()
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        viewModel.applyCrop()
                    }
                }) {
                    VStack {
                        Image(systemName: "crop")
                            .font(.system(size: 24))
                            .foregroundColor(.black)
                    }
                }
                .padding()
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        viewModel.applyCollage()
                    }
                }) {
                    VStack {
                        Image(systemName: "rectangle.3.offgrid")
                            .font(.system(size: 24))
                            .foregroundColor(.black)
                    }
                }
                .padding()
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        viewModel.togglePortraitMode()
                    }
                }) {
                    VStack {
                        Image(systemName: "person.crop.rectangle")
                            .font(.system(size: 24))
                            .foregroundColor(.black)
                    }
                }
                .padding()
            }
            .background(Color(UIColor.systemGray6))
            .ignoresSafeArea()
        }
    }
}
