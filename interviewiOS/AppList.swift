//
//  AppList.swift
//   interviewiOS
//
//  Created by aa on 2022/5/4
//

import SwiftUI

func kAppDelegate() -> UIApplicationDelegate { UIApplication.shared.delegate! }

struct AppList: View {
    @ObservedObject var viewModel: ViewModel = .init()
    @State var refresh = Refresh(started: false, released: false)
    @State var  showAnimator = true
    var body: some View {
        NavigationView{
            ZStack {
                Color.init(UIColor(red:0.956, green:0.954, blue:0.971, alpha:1.000)).edgesIgnoringSafeArea(.all)
                ScrollView(showsIndicators: false){
                    GeometryReader { reader -> AnyView in
                        DispatchQueue.main.async {
                            if refresh.startOffset == 0 {
                                refresh.startOffset = reader.frame(in: .global).minY
                            }
                            refresh.offset = reader.frame(in: .global).minY
                            if refresh.offset - refresh.startOffset > 80 && !refresh.started {
                                refresh.started = true
                            }
                            if refresh.startOffset == refresh.offset && refresh.started && !refresh.released {
                                withAnimation(Animation.linear) {
                                    refresh.released = true
                                }
                                updateData()
                            }
                            if refresh.startOffset == refresh.offset && refresh.started && refresh.released && refresh.invalid {
                                
                                refresh.invalid = false
                                updateData()
                            }
                        }
                        return AnyView(Color.black.frame(width: 0, height: 0))
                    }
                    .frame(width: 0, height: 0)
                    ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                        if refresh.started && !refresh.released {
                            ProgressView()
                                .offset(y : -35)
                                .controlSize(.large)
                        }
                        else {
                        }
                        LazyVStack{
                            ForEach.init(self.viewModel.items, id: \.self) { value in
                                AppRow(appInfo: value)
                                    .padding()
                                    .background(Color.white)
                                    .contentShape(Rectangle())
                                    .cornerRadius(5.0)
                                    .padding([.trailing, .leading], 10)
                            }
                            
                            if self.viewModel.canLoadMore {
                                if self.viewModel.items.count == 0 {
                                    ActivityIndicator(startAnimating: self.$showAnimator)
                                        .padding()
                                        .onAppear {
                                            debugPrint("onAppear")
                                            self.loadMore()
                                        }
                                }else {
                                    Text("Loading ...")
                                        .padding()
                                        .onAppear {
                                            debugPrint("onAppear")
                                            self.loadMore()
                                        }
                                    
                                }
                                
                            }else {
                                Text("No more data.")
                                    .padding()
                            }
                        }
                    }
                }
                .navigationBarTitle(Text("APP"))
            }
        }
        
    }
    
    func loadMore() {
//        self.showAnimator = false
        self.viewModel.loadMore()
    }
    
    func updateData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(Animation.linear) {
                if refresh.startOffset == refresh.offset {
                    viewModel.items.removeAll()
                    //                        arrayData.append("Updated Data")
                    refresh.released = false
                    refresh.started = false
                }
                else {
                    refresh.invalid = true
                }
            }
        }
    }
}



struct Refresh {
    var startOffset : CGFloat = 0
    var offset : CGFloat = 0
    var started : Bool
    var released : Bool
    var invalid : Bool = false
}

struct ActivityIndicator: UIViewRepresentable {
    @Binding var startAnimating: Bool
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView()
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView,
                      context: Context) {
        if self.startAnimating {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}

struct AppInfosList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE", "iPhone XS Max"], id: \.self) { deviceName in
            AppList()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
        .environmentObject(UserData())
    }
}
