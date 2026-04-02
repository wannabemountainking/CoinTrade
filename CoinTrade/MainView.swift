//
//  MainView.swift
//  CoinTrade
//
//  Created by yoonie on 4/2/26.
//

import SwiftUI

struct MainView: View {
    
    @State private var vm: CoinTradeViewModel = .init()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Section {
                    HStack {
                        VStack(spacing: 10) {
                            Text("최고가 거래")
                            Text(vm.maxPriceTrade.symbol)
                            Text("$\(vm.maxPriceTrade.price?.formatted(.number) ?? "0")")
                            Spacer()
                        }
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        VStack(spacing: 10) {
                            Text("처음 3건 거래")
                            Text("vol.\(vm.sumOfFirstThreeTradeVolume)")
                            Spacer()
                        }
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                    }
                    .font(.title2)
                }
            } //:VSTACK
            .navigationTitle("코인 트레이드")
            .navigationBarTitleDisplayMode(.large)
        } //:NAVIGATION
        .padding()
    }//:body
}

#Preview {
    MainView()
}
