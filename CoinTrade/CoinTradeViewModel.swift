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
    var errorMessage: String = ""
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
            .drop { $0.volume < 10 }
            .collect()
            .sink { _ in
            } receiveValue: { [weak self] trade in
                guard let self else {return}
                self.overTenAfterTrades = trade
            }
            .store(in: &cancellable)
    }
    
    private func secondSubscription() {
        ds.publisher
            .tryMax { trade1, trade2 in
                guard let first = trade1.price else { throw TradeError.priceError(symbol: trade1.symbol) }
                guard let second = trade2.price else { throw TradeError.priceError(symbol: trade2.symbol) }
                return first < second
            }
            .sink { [weak self] completion in
                guard let self else {return}
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    switch error as? TradeError {
                    case .priceError(let symbol):
                        self.errorMessage = "\(symbol) 시세 오류"
                    case .none:
                        break
                    }
                }
            } receiveValue: { [weak self] maxTrade in
                guard let self else {return}
                self.maxPriceTrade = maxTrade
            }
            .store(in: &cancellable)
    }
    
    private func thirdSubscription() {
        ds.publisher
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
