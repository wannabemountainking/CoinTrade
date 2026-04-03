//
//  CoinTradeViewModel.swift
//  CoinTrade
//
//  Created by yoonie on 4/2/26.
//

import Foundation
import Combine
import Observation


enum TradeError: Error {
    case priceError(symbol: String)
}

@Observable
final class CoinTradeViewModel {
    let ds = DataService()
    var overTenAfterTrades: [CoinTrade] = []
    var maxPriceTrade: CoinTrade = CoinTrade(symbol: "", price: nil, volume: 0)
    var errorMessages: [String] = []
    var totalSumOfFirstThreeTradeVolume: Int = 0
    
    var cancellable = Set<AnyCancellable>()
    
    func runSubscriptions() {
        firstSubscription()
        secondSubscription()
        thirdSubscription()
        ds.streamingData()
    }
    
    private func firstSubscription() {
        ds.publisher
            .compactMap { result -> CoinTrade? in
                if case .success(let trade) = result {
                    return trade
                }
                return nil
            }
            .drop { $0.volume < 10 }
            .collect()
            .sink { [weak self] trades in
                guard let self else {return}
                self.overTenAfterTrades = trades
            }
            .store(in: &cancellable)
    }
    
    private func secondSubscription() {
        ds.publisher
            .compactMap { [weak self] result -> CoinTrade? in
                guard let self else {return nil}
                switch result {
                case .success(let trade):
                    return trade
                case .failure(let error):
                    switch error {
                    case .priceError(let symbol):
                        self.errorMessages.append("⚠️ \(symbol) 시세 오류")
                        return nil
                    }
                }
            }
            .max { $0.price ?? 0 < $1.price ?? 0 }
            .sink { [weak self] maxTrade in
                guard let self else {return}
                self.maxPriceTrade = maxTrade
            }
            .store(in: &cancellable)
    }
    
    private func thirdSubscription() {
        ds.publisher
            .compactMap({ result -> CoinTrade? in
                if case .success(let trade) = result {
                    return trade
                }
                return nil
            })
            .prefix(3)
            .collect()
            .sink { _ in
            } receiveValue: { [weak self] trades in
                guard let self else {return}
                self.totalSumOfFirstThreeTradeVolume = trades.reduce(0, { $0 + $1.volume })
            }
            .store(in: &cancellable)
    }
}
