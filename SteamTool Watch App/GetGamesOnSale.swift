//
//  GetGamesOnSale.swift
//  SteamTool Watch App
//
//  Created by 周敬博 on 2023/9/15.
//

import Foundation
import SwiftSoup

let url = "https://store.steampowered.com/search/?supportedlang=schinese&category1=998&specials=1&hidef2p=1&ndl=1"

class GetData{
    
    func GetDataFromSteam(){
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            // 检查是否有错误
            if let error = error {
                print("网络请求失败：\(error.localizedDescription)")
                return
            }
            // 检查是否有数据
            guard let data = data else {
                print("没有获取到数据")
                return
            }
            // 处理数据
            do {
                // 将数据转换为字符串
                let html = String(data: data, encoding: .utf8)
                // 使用SwiftSoup解析HTML文档
                let doc = try SwiftSoup.parse(html ?? "")
                // 提取游戏列表的元素
                let games = try doc.select("div#search_resultsRows > a")
                // 遍历每个游戏元素，并提取相关信息
                for game in games {
                    // 提取游戏标题
                    let title = try game.select("span.title").text()
                    // 提取游戏原价
                    let originalPrice = try game.select("div.search_price > span > strike").text()
                    // 提取游戏折扣价
                    let discountPrice = try game.select("div.search_price > span").last()?.ownText()
                    // 提取游戏折扣比例
                    let discountPercent = try game.select("div.search_discount > span").text()
                    // 打印游戏信息
                    print("\(title) \(originalPrice) \(discountPrice ?? "") \(discountPercent)")
                }
            } catch {
                // 处理解析错误
                print("解析HTML失败：\(error.localizedDescription)")
            }
        }
        // 启动任务
        task.resume()
    }
}
