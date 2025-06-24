//
//  EpicSaleView.swift
//  SteamTool Watch App
//
//  Created by 周敬博 on 10/3/24.
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI // 用于异步加载网络图片

// MARK: - 1. 数据模型 (EpicGame)
// 使模型字段名称更贴近JSON，并包含所有相关信息
struct EpicGame: Identifiable {
    let id = UUID()
    let gameName: String          // 对应 JSON 的 gameName
    let gameDes: String           // 对应 JSON 的 gameDes
    let gameCover: String         // 对应 JSON 的 gameCover
    let gameStatus: String        // 对应 JSON 的 gameStatus
    let gameIsCodeRedemptionOnly: Bool // 对应 JSON 的 gameIsCodeRedemptionOnly
    let gameOriginalPrice: String // 对应 JSON 的 gameOriginalPrice
    let gameDiscountPrice: String // 对应 JSON 的 gameDiscountPrice (实际售价)
    let gameStartDate: String     // 对应 JSON 的 gameStartDate
    let gameEndDate: String       // 对应 JSON 的 gameEndDate
    let gameUrl: String           // 对应 JSON 的 gameUrl

    // 判断游戏是否免费
    var isFree: Bool {
        return gameDiscountPrice == "0" || gameDiscountPrice.lowercased() == "free"
    }
}

// MARK: - 2. 列表项视图 (EpicGameListItemView)
// 更名为 EpicGameListItemView 以清晰表明其作用是列表中的一项
struct EpicGameListItemView: View {
    let game: EpicGame

    var body: some View {
        HStack(spacing: 8) { // 增加间距
            // 游戏封面图
            WebImage(url: URL(string: game.gameCover))
                .resizable()
                .indicator(.activity) // 添加加载指示器
                .transition(.fade(duration: 0.5)) // 淡入效果
                .scaledToFill() // 填充而不是适应
                .frame(width: 50, height: 50) // 固定尺寸
                .cornerRadius(8) // 圆角
                .clipped() // 裁剪超出部分

            VStack(alignment: .leading, spacing: 4) { // 增加垂直间距
                Text(game.gameName)
                    .font(.headline)
                    .lineLimit(2) // 限制两行
                    .foregroundColor(.white)

                // 价格显示逻辑
                HStack(alignment: .lastTextBaseline) {
                    if game.isFree {
                        Text("免费")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    } else if game.gameOriginalPrice != game.gameDiscountPrice {
                        Text(game.gameDiscountPrice) // 折扣价
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        Text(game.gameOriginalPrice) // 原价划线
                            .font(.caption)
                            .strikethrough()
                            .foregroundColor(.gray)
                    } else {
                        Text(game.gameOriginalPrice) // 无折扣原价
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
            }
            Spacer() // 推开右侧内容
            
            // 截止日期 (可以考虑更友好的格式，这里为了简洁先保留原字符串)
            VStack(alignment: .trailing) {
                Text("截止")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text(game.gameEndDate.split(separator: " ").first ?? "") // 只显示日期部分
                    .font(.caption)
                    .foregroundColor(.white)
                Text(game.gameEndDate.split(separator: " ").last ?? "") // 只显示时间部分
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4) // 给列表项增加一些垂直内边距
    }
}

// MARK: - 3. 详情页视图 (EpicGameDetailView)
// 更名为 EpicGameDetailView 以清晰表明其作用是游戏详情页
struct EpicGameDetailView: View {
    let game: EpicGame
    @Environment(\.openURL) var openURL // 用于在watchOS打开URL

    var body: some View {
        ScrollView { // 确保内容可滚动
            VStack(alignment: .leading, spacing: 10) { // 增加整体垂直间距
                // 游戏封面
                WebImage(url: URL(string: game.gameCover))
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                    .shadow(radius: 5) // 添加阴影效果
                    .padding(.bottom, 5)

                // 游戏名称
                Text(game.gameName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(2)

                // 价格信息
                HStack(alignment: .lastTextBaseline) {
                    if game.isFree {
                        Text("免费领取")
                            .font(.title3)
                            .fontWeight(.heavy)
                            .foregroundColor(.green)
                    } else if game.gameOriginalPrice != game.gameDiscountPrice {
                        Text(game.gameDiscountPrice)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        Text(game.gameOriginalPrice)
                            .font(.subheadline)
                            .strikethrough()
                            .foregroundColor(.gray)
                    } else {
                        Text(game.gameOriginalPrice)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    Spacer()
                }

                // 游戏描述
                Text(game.gameDes)
                    .font(.callout)
                    .foregroundColor(.white.opacity(0.85))
                    .lineLimit(nil) // 不限制行数
                    .padding(.vertical, 4)

                Divider() // 分隔线

                // 详细信息区域
                VStack(alignment: .leading, spacing: 5) {
                    GameInfoRow(label: "开始时间", value: game.gameStartDate)
                    GameInfoRow(label: "结束时间", value: game.gameEndDate)
                    GameInfoRow(label: "状态", value: game.gameStatus, valueColor: game.gameStatus == "ACTIVE" ? .green : .red)
                    GameInfoRow(label: "仅兑换码", value: game.gameIsCodeRedemptionOnly ? "是" : "否", valueColor: game.gameIsCodeRedemptionOnly ? .orange : .white.opacity(0.85))
                }
                .font(.footnote) // 统一信息行字体大小

            }
            .padding() // 整个VStack的内边距
        }
        .navigationTitle("") // 隐藏默认导航标题
        .navigationBarTitleDisplayMode(.inline) // 可以调整为.inline或.large
        // .navigationBarHidden(true) // 如果你不想显示返回按钮和时间，可以隐藏导航栏
    }
}

// 辅助视图：用于显示一行信息（标签和值）
struct GameInfoRow: View {
    let label: String
    let value: String
    var valueColor: Color = .white.opacity(0.85)

    var body: some View {
        HStack {
            Text("\(label):")
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .foregroundColor(valueColor)
                .multilineTextAlignment(.trailing) // 值靠右对齐
        }
    }
}


// MARK: - 4. 主视图 (EpicSaleView)
struct EpicSaleView: View {
    @State var badNetwork = false
    @State var GameList: [EpicGame] = []
    @State var isLoading = true // 新增加载状态

    var body: some View {
        ZStack {
            NavigationStack {
                List(GameList) { game in
                    NavigationLink(destination: EpicGameDetailView(game: game)) { // 使用新的详情页视图
                        EpicGameListItemView(game: game) // 使用新的列表项视图
                    }
                }
                .navigationTitle("Epic限免")
                .navigationBarTitleDisplayMode(.large)
                .onAppear {
                    // 只有在数据为空时才触发请求，避免重复请求
                    if GameList.isEmpty && isLoading {
                        getSales()
                    }
                }
                // 错误提示
                .alert("网络请求失败", isPresented: $badNetwork) {
                    Button("确定", role: .cancel) { }
                }
            }
            
            // 加载指示器，只有在加载中且列表为空时显示
            if isLoading && GameList.isEmpty {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
    }

    // MARK: - 5. 网络请求和数据解析
    func getSales() {
        isLoading = true // 开始加载
        let url = "https://www.52api.cn/api/epicgame?key=0HMROVL1JG9XirCRFyobixsh9P"

        guard let requestURL = URL(string: url) else {
            print("URL 无效")
            Task { @MainActor in // 确保在主线程更新状态
                self.badNetwork = true
                self.isLoading = false
            }
            return
        }

        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            Task { @MainActor in // 使用 @MainActor 确保 UI 更新在主线程
                self.isLoading = false // 停止加载指示器

                if let error = error {
                    print("网络请求失败：\(error.localizedDescription)")
                    self.badNetwork = true
                    return
                }

                guard let data = data else {
                    print("没有获取到数据")
                    self.badNetwork = true // 同样认为是网络问题
                    return
                }

                do {
                    let json = try JSON(data: data)
                    // 检查API返回的code，只有成功才解析数据
                    if json["code"].intValue == 200, let gameList = json["data"]["list"].array {
                        var tempGames: [EpicGame] = []
                        for game in gameList {
                            let gameName = game["gameName"].stringValue
                            let gameDes = game["gameDes"].stringValue
                            let gameCover = game["gameCover"].stringValue
                            let gameStatus = game["gameStatus"].stringValue
                            let gameIsCodeRedemptionOnly = game["gameIsCodeRedemptionOnly"].boolValue
                            let gameOriginalPrice = game["gameOriginalPrice"].stringValue
                            let gameDiscountPrice = game["gameDiscountPrice"].stringValue // 使用这个作为实际价格
                            let gameStartDate = game["gameStartDate"].stringValue
                            let gameEndDate = game["gameEndDate"].stringValue
                            let gameUrl = game["gameUrl"].stringValue

                            tempGames.append(EpicGame(
                                gameName: gameName,
                                gameDes: gameDes,
                                gameCover: gameCover,
                                gameStatus: gameStatus,
                                gameIsCodeRedemptionOnly: gameIsCodeRedemptionOnly,
                                gameOriginalPrice: gameOriginalPrice,
                                gameDiscountPrice: gameDiscountPrice,
                                gameStartDate: gameStartDate,
                                gameEndDate: gameEndDate,
                                gameUrl: gameUrl
                            ))
                        }
                        self.GameList = tempGames
                    } else {
                        print("API 返回错误或数据结构不符: \(json["msg"].stringValue)")
                        self.badNetwork = true // 认为API返回错误也是一种网络问题
                    }
                } catch {
                    print("JSON 解析失败: \(error.localizedDescription)")
                    self.badNetwork = true
                }
            }
        }.resume()
    }
}

// MARK: - 预览
#Preview {
    EpicSaleView()
}
