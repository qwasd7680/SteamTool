//
//  EpicSaleView.swift
//  SteamTool Watch App
//
//  Created by 周敬博 on 10/3/24.
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI

struct EpicGame:Identifiable{
    var id = UUID()
    var name:String
    var deadline_date:String
    var inital_amount:String
    var score:String
    var image:String
//    var screenshots:[String]
}

struct EpicGameView: View {
    let game: EpicGame
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(game.name)
                    .font(.headline)
                Text(game.inital_amount)
                    .strikethrough()
                    .foregroundColor(.gray)
                Spacer()
                if game.deadline_date != "即将限免"{
                    Text(game.deadline_date)
                        .padding(5)
                        .background(Color.green)
                        .cornerRadius(5)
                }else{
                    Text("即将限免")
                        .padding(5)
                        .background(Color.red)
                        .cornerRadius(5)
                }
            }
            Spacer()
            Image(systemName: "star.fill")
            Text(game.score)
        }
    }
}

struct EpicdetailView:View {
    let game: EpicGame
    
    var body: some View {
        VStack{
            WebImage(url:URL(string:game.image))
                .resizable()
                .scaledToFit()
            EpicGameView(game: game)
        }
    }
}

struct EpicSaleView: View {
    @State var badNetwork = false
    @State var json:JSON? = nil
    @State var GameList:[EpicGame] = []
    @State var isGoToAbout = false
    var body: some View {
        ZStack{
            NavigationStack {
                List(GameList) { game in
                    NavigationLink(destination: EpicdetailView(game: game)){
                        EpicGameView(game: game)}
                }
                .navigationTitle("Epic限免")
                .navigationBarTitleDisplayMode(.large)
                .onAppear {
                    if GameList.isEmpty{
                        getSales()
                    }
                }
            }.alert(isPresented: $badNetwork, content: {
                Alert(title: Text("网络请求失败"),dismissButton: .cancel())
            })
            if GameList.isEmpty {
                ProgressView()
            }
        }
    }
    func getSales(){
        let url = "https://api.xiaoheihe.cn/mall/add_to_cart/?platform=epic"
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
                json = try! JSON(data: data)
                var games = json!["result"]["games"].arrayValue
                var will_be_free_games = json!["result"]["will_be_free_games"].arrayValue
                for game in games{
                    GameList.append(EpicGame(name: game["name"].stringValue, deadline_date: game["price"]["deadline_date"].stringValue, inital_amount: game["price"]["initial_amount"].stringValue, score: game["score"].stringValue, image: game["image"].stringValue))
                }
                for game in will_be_free_games{
                    GameList.append(EpicGame(name: game["name"].stringValue, deadline_date:"即将限免", inital_amount: game["price"]["initial_amount"].stringValue, score: game["score"].stringValue, image: game["image"].stringValue))
                }
            }
        }
        task.resume()
    }
}

#Preview {
    EpicSaleView()
}
