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
                        .font(.title)
                    Text("开发者")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            HStack{
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
            }
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
