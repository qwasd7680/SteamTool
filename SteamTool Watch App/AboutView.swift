//
//  AboutView.swift
//  SteamTool Watch App
//
//  Created by 周敬博 on 2023/9/15.
//

import SwiftUI
import SDWebImageSwiftUI
import AuthenticationServices

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
                    NavigationLink(destination: SettingView()){
                        HStack {
                            Image(systemName: "gear")
                                .foregroundColor(.blue)
                            Text(" 设置")
                        }
                    }
                }
                Section(header: Text("联系我们")) {
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.blue)
                        Link("sjbstudio233@gmail.com", destination: URL(string: "mailto:$sjbstudio233@gmail.com")!)
                    }
                }
                Section(header: Text("备案号")) {
                    Button(action:{icp()}){
                        Text("浙ICP备2024071295号-16A")
                    }
                }

            }
        }
    }
    func icp(){
        let session = ASWebAuthenticationSession(
          url: URL(string: "https://beian.miit.gov.cn")!,
          callbackURLScheme: nil
        ) { _, _ in
          
        }
        session.prefersEphemeralWebBrowserSession = true
        session.start()
    }
}

#Preview {
    AboutView()
}

struct TeamView: View{
    let url = Bundle.main.url(forResource: "qwasd头像", withExtension: "gif")
    var body: some View{
        Form{
            HStack {
                WebImage(url: url)
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
                
                 - SDWebImageSwiftUI -
                Licensed under MIT license
                -----------------------
                
                --- Cepheus ---
                Licensed under Apache-2.0 license
                -----------------
                
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
                    Text("大师救救😭")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct SettingView:View {
    @AppStorage("useCepheus") var useCepheus:Bool = true
    var body: some View {
        Toggle(isOn: $useCepheus){
            Text("使用Cephues键盘")
        }
    }
}
