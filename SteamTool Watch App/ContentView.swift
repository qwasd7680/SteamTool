//
//  ContentView.swift
//  SteamTool Watch App
//
//  Created by 周敬博 on 2023/9/15.
//

import SwiftUI
import SwiftSoup

struct Game: Identifiable {
    let id = UUID()
    let title: String
    let originalPrice: String
    let discountPrice: String
    let discountPercent: String
}

struct GameView: View {
    let game: Game
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(game.title)
                    .font(.headline)
                Text(game.originalPrice)
                    .strikethrough()
                    .foregroundColor(.gray)
                Text(game.discountPrice)
                    .foregroundColor(.red)
            }
            Spacer()
            Text(game.discountPercent)
                .padding(5)
                .background(Color.green)
                .cornerRadius(5)
        }
    }
}

struct ContentView: View {
    @State var games:[Game] = []
    @State var isGoToAbout = false
    @State var isLoading = true
    
    var body: some View {
        ZStack{
            NavigationView {
                List(games) { game in
                    GameView(game: game)
                }
                .navigationTitle("Steam特惠游戏")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            isGoToAbout = true
                        }, label: {
                            Image(systemName: "info")
                                .foregroundColor(.gray)
                        })
                        .sheet(isPresented: $isGoToAbout, content: {AboutView()})
                        .accessibilityIdentifier("Infomation")
                    }
                }
                .onAppear {
                    let url = "https://store.steampowered.com/search/?filter=topsellers&specials=1"
                    let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
                        if let error = error {
                            print("网络请求失败：\(error.localizedDescription)")
                            return
                        }
                        guard let data = data else {
                            print("没有获取到数据")
                            return
                        }
                        do {
                            let html = String(data: data, encoding: .utf8)
                            let doc = try SwiftSoup.parse(html ?? "")
                            // 提取游戏列表的元素
                            let games = try doc.select("div#search_resultsRows > a")
                            // 创建一个空数组来存储游戏对象
                            var gamesArray:[Game] = []
                            // 遍历每个游戏元素，并提取相关信息
                            for game in games {
                                // 提取游戏标题
                                let title = try game.select("span.title").text()
                                // 提取游戏原价
                                let originalPrice = try game.select("div.discount_original_price").text()
                                // 提取游戏折扣价
                                let discountPrice = try game.select("div.discount_final_price").text()
                                // 提取游戏折扣比例
                                let discountPercent = try game.select("div.discount_pct").text()
                                let game = Game(title: title, originalPrice: originalPrice, discountPrice: discountPrice , discountPercent: discountPercent)
                                gamesArray.append(game)
                            }
                            DispatchQueue.main.async {
                                self.games = gamesArray
                                isLoading.toggle()
                            }
                        } catch {
                            print("解析HTML失败：\(error.localizedDescription)")
                        }
                    }
                    task.resume()
                }
            }
            if isLoading{
                ProgressView()
            }
        }
    }
}
#Preview {
    ContentView()
}
