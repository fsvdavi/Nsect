//
//  TabBar.swift
//  NsectFinalProject
//
//  Created by found on 22/07/25.
//

import SwiftUI

struct TabBar: View {
    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 2) {
                Image(systemName: "house.fill")
                    .font(.system(size: 28))
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.gray)

            NavigationLink(destination: CameraARView()) {
                VStack(spacing: 2) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.0, green: 0.4, blue: 0.2))
                            .frame(width: 70, height: 70)

                        Image(systemName: "camera")
                            .foregroundColor(.white)
                            .font(.system(size: 34))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .offset(y: -20)

            NavigationLink(destination: InventoryInsectView()) {
                VStack(spacing: 2) {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 32))
                }
                .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 1)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .opacity(0.75)
                .shadow(radius: 3)
        )
    }
}

#Preview {
    TabBar()
}
