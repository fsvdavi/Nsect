//
//  TabView.swift
//  NsectFinalProject
//
//  Created by found on 17/07/25.
//

import SwiftUI

struct TabBarView: View{
    var body: some View{
        
        TabView {
            Text("Home")
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            Text("Find New")
                .tabItem {
                    Image(systemName: "camera")
                    Text("Find New")
                }
        }
        
        
    }
}



#Preview {
    TabBarView()
}
