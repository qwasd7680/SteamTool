//
//  AboutView.swift
//  SteamTool Watch App
//
//  Created by 周敬博 on 2023/9/15.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("关于我们")) {
                    NavigationLink(destination: About()){
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                            Text(" 应用信息")
                        }
                    }
                    NavigationLink(destination: TeamView()){
                        HStack {
                            Image(systemName: "person.2")
                                .foregroundColor(.blue)
                            Text("开发团队")
                        }
                    }
                    NavigationLink(destination: Xuke()){
                        HStack {
                            Image(systemName: "shippingbox")
                                .foregroundColor(.blue)
                            Text(" 开源组件许可")
                        }
                    }
//                    HStack {
//                        Image(systemName: "star")
//                            .foregroundColor(.blue)
//                        Text("给我们评分")
//                    }
                }
                Section(header: Text("联系我们")) {
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.blue)
                            Link("sjbstudio233@gmail.com", destination: URL(string: "mailto:$sjbstudio233@gmail.com")!)
                        }
                }
                Section(header: Text("Cepheus Keyboard")) {
                        HStack {
                            Image(systemName: "keyboard")
                                .foregroundColor(.blue)
                            Text("Powered by Cepheus Keyboard")
                                .font(.footnote)
                                .foregroundColor(.blue)
                                .multilineTextAlignment(.center)
                        }
                }
            }
        }
    }
}
    
#Preview {
    AboutView()
}

struct TeamView: View{
    var body: some View{
        Form{
            HStack {
                Image("qwasd头像")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text("qwasd")
                        .font(.title3)
                    Text("开发者")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            HStack {
                Image("幼雾酱头像")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text("幼雾酱")
                        .font(.title3)
                    Text("图标设计")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            HStack {
                Image("785头像")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text("ThreeManager785")
                        .font(.title3)
                    Text("英文翻译")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            NavigationLink(destination: TebiemingxieView()){
                HStack {
                    Image(systemName: "fireworks")
                        .foregroundColor(.red)
                    Text("特别鸣谢")
                }
            }
/*            HStack{
                Image("缈姚头像")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text("缈姚")
                        .font(.title)
                    Text("qwasdの女朋友")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }*/
        }
    }
}

struct About:View {
    var body: some View {
        List{
            Section{
                Text("开发者是一名高中生，因为在学校里常年不知道Steam促销的信息而经常错过打折，于是写了这款软件，方便在学校里查看Steam的促销信息")
                Text("希望它也能帮助您不落下每一次促销")
                Text("使用愉快🌹🌹")
            }
        }
    }
}

struct Xuke:View {
    let openSourceTexts = """
                --- SwiftSoup ---
                Licensed under MIT license
                -----------------
                
                 --- SFSymbol ---
                Licensed under MIT license
                -----------------
                
                 -- CachedAsyncImage --
                Licensed under MIT license
                -----------------------
                
                 - CepheusKeyboardKit -
                Licensed under Apache-2.0 license
                -----------------------

                """
    var body: some View {
        ScrollView{
            Text(openSourceTexts)
        }
    }
}

struct TebiemingxieView:View {
    var body: some View {
        Form{
            HStack {
                Image("MEMZ头像")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text("WindowsMEMZ")
                    Text("提了很多建议")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
