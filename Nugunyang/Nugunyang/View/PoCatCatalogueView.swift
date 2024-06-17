//
//  PoCatCatalogueView.swift
//  Nugunyang
//
//  Created by 원주연 on 6/17/24.
//

import SwiftUI

struct PoCatCatalogueView: View {
    let pocatsMain: [String] =  ["노벨이", "호박이"]
    let pocatJigok: [String] = ["치즈스틱", "검냥이1", "검냥이2", "검냥이3", "삼색냥", "브라운냥", "치즈냥2", "고등어냥"]
    let columns = [GridItem(.adaptive(minimum: 100))]
    let font = "NanumYeBbeunMinGyeongCe"
    
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                ZStack{
                    Color.black
                        .ignoresSafeArea(.all)
                }
                
                LazyVStack(pinnedViews: .sectionHeaders) {
                    Section(header: HeaderView()){
                        VStack(alignment: .leading) {
                            
                            Spacer().frame(height: 30)
                            
                            Text("📍 본관 정원")
                                .foregroundStyle(Color.gray)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(pocatsMain, id: \.self) { cat in
                                    Text(cat)
                                        .foregroundStyle(Color.white)
                                        .font(.custom(font, size: 20))
                                        .padding(.horizontal, 10)
                                }
                            }
                            
                            Spacer().frame(height: 30)
                            
                            Text("📍 지곡회관 1층 & 연못 근처")
                                .foregroundStyle(Color.gray)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(pocatJigok, id: \.self) { cat in
                                    Text(cat)
                                        .foregroundStyle(Color.white)
                                        .font(.custom(font, size: 20))
                                        .padding(.horizontal, 10)
                                }
                            }
                        }.padding(.horizontal)
                    }
                }
            }
            .clipped()
        }
    }
}

// Sticky Header
private struct HeaderView: View{
    let font = "NanumYeBbeunMinGyeongCe"
    
    fileprivate var body: some View {
        HStack {
            Spacer()
            Image("냥케치")
            Spacer().frame(width: 25)
            Text("포스텍 냥도감")
                .font(.custom(font, size: 40))
                .foregroundStyle(Color.white)
            Spacer()
        }
        .background(Color.black)
    }
}

private struct CellItemView: View {
    private var cat: String
    let font = "NanumYeBbeunMinGyeongCe"
    
    fileprivate init(cat: String) {
        self.cat = cat
    }
    
    fileprivate var body: some View {
        Text(cat)
            .foregroundStyle(Color.white)
            .font(.custom(font, size: 20))
    }
}

#Preview {
    PoCatCatalogueView()
}

