//
//  CoinTradeViewModel.swift
//  CoinTrade
//
//  Created by yoonie on 4/2/26.
//

import Foundation
import Combine
import Observation


enum TradeError: String, Error {
    case priceError = "거래 가격 정보가 없습니다"
}

@Observable
final class CoinTradeViewModel {
    
    let ds: DataService
    var symbolsOfOverTenAfterTrades: [String] = []
    var maxPriceTrade: CoinTrade = CoinTrade(symbol: "", price: nil, volume: 0)
    var errorMessage: String = ""
    var sumOfFirstThreeTradeVolume: Int = 0
    
    var cancellable = Set<AnyCancellable>()
    
    init() {
        ds = DataService()
        firstSubscription()
        secondSubscription()
        thirdSubscription()
        ds.streamingData()
    }
    
    private func firstSubscription() {
        ds.publisher
            .drop { $0.volume < 10 }
            .map { $0.symbol }
            .collect()
            .sink { _ in
            } receiveValue: { [weak self] tradeSymbols in
                guard let self else {return}
                self.symbolsOfOverTenAfterTrades = tradeSymbols
            }
            .store(in: &cancellable)
    }
    
    private func secondSubscription() {
        ds.publisher
            .tryMax { trade1, trade2 in
                guard let first = trade1.price,
                      let second = trade2.price else {
                    throw TradeError.priceError
                }
                return first < second
            }
            .sink { [weak self] completion in
                guard let self else {return}
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Error: \(error)"
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
                self.sumOfFirstThreeTradeVolume = trades.reduce(0, { $0 + $1.volume })
            }
            .store(in: &cancellable)

    }
}
