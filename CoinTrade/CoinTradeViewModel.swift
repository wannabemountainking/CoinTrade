//
//  CoinTradeViewModel.swift
//  CoinTrade
//
//  Created by yoonie on 4/2/26.
//

import Foundation
import Combine
import Observation


@Observable
final class CoinTradeViewModel {
    
    let ds: DataService
    var coinTrades: [CoinTrade] = []
    
    init() {
        ds = DataService()
        // 구독
        ds.streamingData()
    }
    
    private func firstSubscription(ds: DataService) {
        ds.publisher
            .drop { $0.volume < 10 }
            .map { $0.symbol }
            .sink
    }
}
