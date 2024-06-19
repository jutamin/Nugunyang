//
//  NewCameraView.swift
//  Nugunyang
//
//  Created by 원주연 on 6/18/24.
//

import SwiftUI

struct NewCameraView: View {
    @StateObject private var model = MosuDataModel()
//    @ObservedObject var viewModel = CameraViewModel()
    private static let barHeightFactor = 0.15
    
    
    var body: some View {
            GeometryReader { geometry in
                VStack {
                    MosuViewfinderView(image: $model.viewfinderImage)
                        .overlay(alignment: .bottom) {
                            buttonsView()
                                .frame(height: geometry.size.height * Self.barHeightFactor)
                                .background(.black)
                        }
                        .background(.black)
                    
                    Text(model.resultString)
                        .font(.title)
                        .padding(.bottom, 24)
                }
            }
            .task {
                await model.camera.start()
        }
    }
    
    private func buttonsView() -> some View {
        HStack {

            Spacer().frame(width: 145)

            // 사진 찍기 버튼
            Button {
                model.camera.takePhoto()
            } label: {
                Circle()
                    .foregroundStyle(Color.secondary)
                    .frame(width: 80, height: 80)
                    .padding()
                    .overlay(
                        Circle()
                            .stroke(lineWidth: 2)
                            .foregroundColor(Color.white)
                            .frame(width: 40, height: 40)
                    )
            }
            
            Spacer()

            // 전후면 카메라 교체
            Button {
                model.camera.switchCaptureDevice()
            } label: {
                Image(systemName: "arrow.triangle.2.circlepath.camera")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color.white)
            }
            .frame(width: 75, height: 75)
            .padding()

        }
    }
    
    
}
//
//#Preview {
//    NewCameraView()
//}
