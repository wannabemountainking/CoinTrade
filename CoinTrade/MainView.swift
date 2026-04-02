//
//  MainView.swift
//  CoinTrade
//
//  Created by yoonie on 4/2/26.
//

import SwiftUI

struct MainView: View {
    
    @State private var vm: CoinTradeViewModel = .init()
    @State private var hasStarted: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 35) {
                
                // MARK: - maxTrade, totalOffirstThreeTrades
                Section {
                    HStack {
                        ZStack(alignment: .top) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.3))
                            VStack(spacing: 10) {
                                Text("최고가 거래")
                                Text(vm.maxPriceTrade.symbol)
                                Text("$\(vm.maxPriceTrade.price?.formatted(.number) ?? "0")")
                            }
                            .padding(.top, 30)
                        }
                        ZStack(alignment: .top) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.3))
                            VStack(alignment: .center, spacing: 10) {
                                Text("처음 3건 거래")
                                Text("vol.\(vm.totalSumOfFirstThreeTradeVolume)")
                            }
                            .padding(.top, 30)
                        }
                    }
                    .font(.title2)
                    .frame(height: 150)
                    .frame(maxWidth: .infinity)
                }
                // MARK: - Start Stream
                Button("스트림 시작") {
                    //action
                    hasStarted = true
                    vm.runSubscriptions()
                }
                .font(.title2)
                .foregroundStyle(.white)
                .padding(10)
                .background(hasStarted ? Color.gray.opacity(0.7) : .blue.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .disabled(hasStarted)
                
                // MARK: - overTenTrades
                Section("거래량 10 이상의 거래 이후") {
                    ForEach(vm.overTenAfterTrades, id: \.id) { trade in
                        HStack(spacing: 50) {
                            Text(trade.symbol)
                            Text("vol.\(trade.volume)")
                        }
                        .font(.title2)
                    }
                }
                
                // MARK: - Error


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
