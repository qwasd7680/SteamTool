//
//  ContentView.swift
//  SteamTool Watch App
//
//  Created by Maverick Charmer on 2023/9/15.
//

import SwiftUI
import SwiftSoup
import SDWebImageSwiftUI
import Cepheus

struct Game: Identifiable {
    let id = UUID()
    let title: String
    let originalPrice: String
    let discountPrice: String
    let discountPercent: String
    let picurl: String
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
            if game.discountPercent != ""{
                Text(game.discountPercent)
                    .padding(5)
                    .background(Color.green)
                    .cornerRadius(5)
            }
        }
    }
}

struct ContentView: View {
    var body: some View{
        TabView{
            MainView()
                .tag(1)
            EpicSaleView()
                .tag(2)
            AboutView()
                .tag(3)
        }
    }
}

struct searchView:View {
    @State var content:String = ""
    @State private var badNetwork = false
    @State var games:[Game] = []
    @State var isNotSearched = true
    @State var num = 1
    @AppStorage("useCepheus") var useCepheus:Bool = true
    
    var body: some View {
        ZStack{
            if isNotSearched {
                CepheusKeyboard(input: $content,
                                prompt: "请输入游戏名",
                                CepheusIsEnabled:useCepheus,allowEmojis: false
                    ,onSubmit: {
                        searchGame(content: content)
                        isNotSearched.toggle()
                  })
            }else{
                    NavigationView {
                        ZStack{
                            List(games) { game in
                                NavigationLink(destination: detailView(game: game)){
                                    GameView(game: game)}
                            }
                            if games.isEmpty && !badNetwork{
                                ProgressView()
                            }
                            if badNetwork{
                                Button{
                                    num += 1
                                }label: {
                                    Image(systemName:"network.slash")
                                        .symbolEffect(.bounce.up.byLayer,value:num)
                                        .font(.largeTitle)
                                }.buttonStyle(PlainButtonStyle())
                            }
                        }
                        }
                        .onAppear {
                            searchGame(content: content )
                        }
                    }
                }
        }
    func searchGame(content:String){
        let baseurl = "https://store.steampowered.com/search/?term="
        let content = content
        
        let url = baseurl + content
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            if let error = error {
                badNetwork = true
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
                    let imgTag: Element = try! game.select("img").first()!
                    // 提取游戏图片
                    let pic = try imgTag.attr("src")
                    let game = Game(title: title, originalPrice: originalPrice, discountPrice: discountPrice , discountPercent: discountPercent,picurl: pic)
                    gamesArray.append(game)
                }
                DispatchQueue.main.async {
                    self.games = gamesArray
                }
            } catch {
                print("解析HTML失败：\(error.localizedDescription)")
            }
        }
        task.resume()
    }
}

struct detailView:View {
    let game: Game
    
    var body: some View {
        ScrollView{
            VStack{
                WebImage(url:URL(string:game.picurl))
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                    .shadow(radius: 5) // 添加阴影效果
                    .padding(.bottom, 5)
                GameView(game: game)
            }
        }
    }
}

struct MainView: View {
    @State var games:[Game] = []
    @State var isGoToAbout = false
    @State var badNetwork = false
    
    var body: some View {
            ZStack{
                NavigationStack {
                    List(games) { game in
                        NavigationLink(destination: detailView(game: game)){
                            GameView(game: game)}
                    }
                    .navigationTitle("Steam特惠游戏")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(action: {
                                isGoToAbout = true
                            }, label: {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                            })
                            .sheet(isPresented: $isGoToAbout, content: {searchView()})
                        }
                    }
                    .onAppear {
                        if games.isEmpty{
                            getGames()
                        }
                        print("Init")
                    }
                }.alert(isPresented: $badNetwork, content: {
                    Alert(title: Text("网络请求失败"),dismissButton: .cancel())
                })
                if games.isEmpty {
                    ProgressView()
                }
            }
        }
    
    func getGames(){
        let url = "https://store.steampowered.com/search/?filter=topsellers&specials=1"
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            if let error = error {
                badNetwork = true
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
                    // 获取img对象
                    let imgTag: Element = try! game.select("img").first()!
                    // 提取游戏图片
                    let pic = try imgTag.attr("src")
                    let game = Game(title: title, originalPrice: originalPrice, discountPrice: discountPrice , discountPercent: discountPercent,picurl: pic)
                    gamesArray.append(game)
                }
                DispatchQueue.main.async {
                    self.games = gamesArray
                }
            } catch {
                print("解析HTML失败：\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    
    
}

#Preview {
    ContentView()
}
