//
//  DataService.swift
//  CoinTrade
//
//  Created by yoonie on 4/2/26.
//

import Foundation
import Combine

struct CoinTrade {
    let symbol: String
    let price: Double?
    let volume: Int
}

final class DataService {
    let publisher = PassthroughSubject<CoinTrade, Error>()
    
    func streamingData() {
        let coinTrades = [
            CoinTrade(symbol: "XRP",  price: 0.8,    volume: 500),
            CoinTrade(symbol: "BTC",  price: 42000,  volume: 3),
            CoinTrade(symbol: "ETH",  price: nil,    volume: 0),
            CoinTrade(symbol: "BTC",  price: 43500,  volume: 5),
            CoinTrade(symbol: "ETH",  price: 2800,   volume: 12),
            CoinTrade(symbol: "XRP",  price: 0.75,   volume: 800),
            CoinTrade(symbol: "BTC",  price: 44000,  volume: 2),
            CoinTrade(symbol: "SOL",  price: 180,    volume: 45),
            CoinTrade(symbol: "ADA",  price: nil,    volume: 7),
            CoinTrade(symbol: "DOGE", price: 0.12,   volume: 300),
            CoinTrade(symbol: "SOL",  price: 195,    volume: 8),
            CoinTrade(symbol: "BNB",  price: 420,    volume: 22)
        ]
        for index in coinTrades.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index)) {
                self.publisher.send(coinTrades[index])
            }
        }
    }
}



