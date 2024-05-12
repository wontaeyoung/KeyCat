//
//  HomeView.swift
//  KeyCat
//
//  Created by 원태영 on 5/10/24.
//

import SwiftUI

struct HomeView: View {
  
  @StateObject private var viewModel = HomeViewModel()
  
  var body: some View {
    
    ScrollView {
      VStack(spacing: 60) {
        bannerView()
        section(title: "보글보글 소리가 좋은 무접점 키보드", posts: viewModel.state.capacitivePosts)
        section(title: "장시간 업무에 적합한 인체공학 키보드", posts: viewModel.state.ergonomicPosts)
        gridSection(title: "사무용으로 좋은 펜타그래프 키보드", posts: viewModel.state.scissorSwitchPosts)
      }
    }
    .task {
      viewModel.act(.viewOnAppear)
    }
  }
  
  private func bannerView() -> some View {
    
    TabView {
      ForEach(Banner.allCases, id: \.rawValue) { banner in
        banner.bannerView()
          .frame(height: 200)
          .background(banner.color)
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .always))
    .frame(height: 200)
  }
  
  private func section(title: String, posts: [CommercialPost]) -> some View {
    
    VStack(alignment: .leading) {
      
      Text(title)
        .font(.bold(size: 18))
        .padding(.horizontal, 20)
        .padding(.top, 20)
      
      ScrollView(.horizontal, showsIndicators: false) {
        
        LazyHStack(spacing: 20) {
          ForEach(posts, id: \.postID) {
            ProductCell(post: $0)
          }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
      }
    }
  }
  
  private func gridSection(title: String, posts: [CommercialPost]) -> some View {
    
    let columns: [GridItem] = .init(repeating: GridItem(.flexible(minimum: 0, maximum: .infinity)), count: 2)
    
    return VStack(alignment: .leading) {
      
      Text(title)
        .font(.bold(size: 18))
        .padding(.horizontal, 20)
        .padding(.top, 20)
      
      LazyVGrid(columns: columns, spacing: 30) {
        ForEach(posts, id: \.postID) {
          ProductCell(post: $0)
        }
      }
      .padding(.vertical, 10)
    }
  }
}

extension HomeView {
  
  enum Banner: Int, CaseIterable {
    
    case timedeal
    case logitech
    case razer
    
    @ViewBuilder
    func bannerView() -> some View {
      switch self {
        case .timedeal:
          LazyVStack(spacing: 10) {
            Text("매일 오후 3시")
              .font(.bold(size: 16))
            Text("한정 수량 타임딜")
              .font(.bold(size: 20))
            Text("타임딜 이벤트는 평일에만 진행됩니다.")
              .font(.medium(size: 12))
              .foregroundStyle(Color.lightGrayBackground)
          }
          
        case .logitech:
          LazyVStack(spacing: 10) {
            Text("Logitech | TRADERS")
              .font(.bold(size: 18))
            Text("로지텍, 트레이더스 21개 지점 할인")
              .font(.medium(size: 14))
          }
          
        case .razer:
          LazyVStack(spacing: 10) {
            Text("RAZER 이벤트")
              .font(.bold(size: 18))
            Text("EVENT 1. 리뷰쓰고 선물 받기")
              .font(.medium(size: 14))
            Text("EVENT 2. 새해맞이 특별 할인")
              .font(.medium(size: 14))
          }
      }
    }
    
    var color: Color {
      switch self {
        case .timedeal:
          return .pastelRed
        case .logitech:
          return .pastelBlue
        case .razer:
          return .pastelGreen
      }
    }
  }
}
