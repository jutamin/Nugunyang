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
    @ObservedObject var viewModel = MosuCamera()
    private static let barHeightFactor = 0.15
    
    @State var isfounded = false
    @Environment(\.modelContext) private var modelContext
    @Query var cats: [Cat]
    var filteredCat: Cat? {
        return self.cats.filter({ $0.name == model.resultString }).first
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                MosuViewfinderView(image: $model.viewfinderImage)
//                    .gesture(MagnificationGesture()
//                        .onChanged { val in
//                            viewModel.zoom(factor: val)
//                        }
//                        .onEnded { _ in
//                            viewModel.zoomInitialize()
//                        })
                    .overlay(alignment: .bottom) {
                        // Unwrapping
                        if let foundCat = filteredCat { //filteredCat에 걸리는 고양이가 있으면 그걸 foundCat으로 담고, foundView에서 보여줌
                            foundView(cat: foundCat)
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
        .onAppear(){
            if cats.isEmpty {
                settingValue()}
        }
    }
    
    func settingValue() {
        modelContext.insert(Cat(name: "노벨이", name_0: "노벨이_0", meetCount: 1, index: 1))
        modelContext.insert(Cat(name: "치즈스틱", name_0: "치즈스틱_0", meetCount: 1, index: 2))
        modelContext.insert(Cat(name: "깜냥이1", name_0: "깜냥이1_0", meetCount: 1, index: 3))
        modelContext.insert(Cat(name: "깜냥이2", name_0: "깜냥이2_0", meetCount: 1, index: 4))
        modelContext.insert(Cat(name: "깜냥이3", name_0: "깜냥이3_0", meetCount: 1, index: 5))
        modelContext.insert(Cat(name: "삼색이", name_0: "삼색이_0", meetCount: 1, index: 6))
        modelContext.insert(Cat(name: "다크초코", name_0: "다크초코_0", meetCount: 1, index: 7))
        modelContext.insert(Cat(name: "인절미", name_0: "인절미_0", meetCount: 1, index: 8))
        modelContext.insert(Cat(name: "고등어", name_0: "고등어_0", meetCount: 1, index: 9))
    }
    
    func updateCount(cat: Cat) {
        filteredCat?.meetCount += 1
//        let cat = cats[index]
//        cat.meetCount += 1
    }
    
    private func buttonsView() -> some View {
        HStack {
            Spacer().frame(width: 145)
            // 사진 찍기 버튼
            Button {
                model.camera.takePhoto()
                model.resultString = ""
//                isfounded = true
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
    
    @ViewBuilder
    private func foundView(cat: Cat) -> some View {
        VStack{
            HStack {
                VStack(alignment: .leading){
//                    Text("\(model.resultString)를 찾았어요!🎉🎉")
                    Text("\(cat.name)를 찾았어요!🎉🎉")
                        .foregroundStyle(.white)
                        .font(.title3)
                        .padding(.vertical)
                    if cat.meetCount == 1 {
                        Text("처음 만나는 냥이 안녕 👋")
                            .foregroundStyle(.white)
                    } else {
                        Text("\(cat.meetCount)번째 만남이예요👋")
                            .foregroundStyle(.white)
                    }
                    
                }
                .padding(20)
                Spacer()
                Image(cat.name)
                    .resizable()
                    .frame(width: 110, height: 110)
                    .padding(.vertical, 15)
                Spacer()

            }
            HStack(spacing: 10) {
                Button{
                    isfounded.toggle()
                    model.resultString = ""
                } label: {Text("취소")
                        .font(.title3)
                        .foregroundStyle(Color.white)
                        .frame(width: 120, height: 60)
                        .background(Color.secondary)
                        .cornerRadius(20)
                }
                
                Button{
                    isfounded.toggle()
                    cat.meetCount += 1
                    model.resultString = ""
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
        .frame(maxWidth: .infinity, maxHeight: 210)
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
