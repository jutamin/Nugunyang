//
//  NewCameraView.swift
//  Nugunyang
//
//  Created by 원주연 on 6/18/24.
//

import SwiftUI
import SwiftData

struct NewCameraView: View {
    @StateObject private var model = MosuDataModel()
    //    @ObservedObject var viewModel = CameraViewModel()
    private static let barHeightFactor = 0.15
    
    @State var isfounded = false
    
//    var modelContainer: ModelContainer = {
//        let schema = Schema([Cat.self])
//        let configuration
//    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                MosuViewfinderView(image: $model.viewfinderImage)
                //                    .gesture(MagnificationGesture()
                //                        .onChanged{ val in
                //                            model.zoom(factor: val)
                //                        }
                //                        .onEnded{ _ in
                //                            model.zoomInitialize()
                //                        }
                //                    )
                    .overlay(alignment: .bottom) {
                        if isfounded == true {
                            foundView()
                        } else {
                            buttonsView()
                                .frame(height: geometry.size.height * Self.barHeightFactor)
                                .background(.black)
                        }
                        
                    }
                    .background(.black)
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
                isfounded = true
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
                //                }
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
    
    private func foundView() -> some View {
        VStack{
            HStack {
                VStack(alignment: .leading){
                    Text("\(model.resultString)를 찾았어요!🎉🎉")
                        .foregroundStyle(.white)
                        .font(.title3)
                        .padding(.vertical)
                    Text("처음 만나는 냥이 안녕 👋")
                        .foregroundStyle(.white)
                }
                .padding(20)
                
                Spacer()
                
                Image(model.resultString)
                    .resizable()
                    .frame(width: 110, height: 110)
                    .padding(.vertical, 15)
                Spacer()

            }
//            Spacer()
            HStack(spacing: 10) {
                Button{
                    isfounded = false
                } label: {Text("취소")
                        .font(.title3)
                        .foregroundStyle(Color.white)
                        .frame(width: 120, height: 60)
                        .background(Color.secondary)
                        .cornerRadius(20)
                }
                
                Button{
                    isfounded.toggle()
                } label: {
                    Text("포냥도감에 추가하기!")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                        .frame(width: 220, height: 60)
                        .background(Color.accentColor)
                        .cornerRadius(20)
                }
            }
            Spacer().frame(height:20)
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: 200)
        .background(.thickMaterial)
        .cornerRadius(20, corners: [.topLeft, .topRight])
    }
    
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}

//#Preview {
//    NewCameraView()
//}
