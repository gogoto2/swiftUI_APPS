//
//  ViewModel.swift
//  LoadMoreSample
//
//  Created by Yusuke Hasegawa on 2020/12/05.
//

import Foundation

class ViewModel: ObservableObject {
//    @ObservedObject var viewModel: ViewModel = .init()
    
    @Published var items: [AppInfo] = []
    
    private let max: Int = 50
    private let countPerPage: Int = 8
    var appList = APPListInfo
    
    init() {
//        let slice:ArraySlice=appList[0...7]
//        items.append(contentsOf: slice)
        print("items.count = \(items.count)")
        
    }
    
}

extension ViewModel {
    
    var canLoadMore: Bool {
        return items.count < max
    }
    
    func loadMore() {        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.appendItems()
        }
        
    }
    
}

private extension ViewModel {
    
    func appendItems() {
        let currentCount = items.count
        let lastItemIndex = appList.count - currentCount >= 8 ? 8 : appList.count - currentCount
        
        let slice:ArraySlice=appList[currentCount...(currentCount + lastItemIndex - 1)]
        items.append(contentsOf: slice)
    }
    
}
