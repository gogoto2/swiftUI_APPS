//
//  AppRow.swift
//   interviewiOS
//
//  Created by aa on 2022/5/4
//

import SwiftUI

struct AppRow: View {
    var appInfo: AppInfo
    let placeholderOne = UIImage(systemName: "arrow.2.circlepath.circle")
    
    @State private var remoteImage : UIImage? = nil
    @State private var imageColor: Color = .gray
    
    var body: some View {
        HStack {
            Image(uiImage: self.remoteImage ?? placeholderOne!)
                .border(Color.init(UIColor(red:0.902, green:0.902, blue:0.902, alpha:1.000)), width: 2)
                .cornerRadius(6)
                .onAppear(perform: fetchRemoteImage)
            
            VStack(alignment: .leading) {
                Text(verbatim: appInfo.trackName)
                    .font(Font.custom("PingFangSC-Regular", fixedSize: 18))
                    .bold()
                Spacer()
                Text(verbatim: appInfo.description)
                    .font(Font.custom("PingFangSC-Regular", fixedSize: 16))
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "heart")
                .imageScale(.medium)
                .foregroundColor(imageColor)
                .gesture(
                    TapGesture()
                        .onEnded { _ in
                            imageColor = imageColor == .red ? .gray : . red                            
                        }
                )
        }
    }
    func fetchRemoteImage()
    {
        guard let url = URL(string: self.appInfo.artworkUrl60) else { return }
        URLSession.shared.dataTask(with: url){ (data, response, error) in
            if let image = UIImage(data: data!){
                self.remoteImage = image
            }
            else{
                print(error ?? "")
            }
        }.resume()
    }
}

struct AppRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AppRow(appInfo: APPListInfo[0])
            AppRow(appInfo: APPListInfo[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
