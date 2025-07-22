//
//  TabBar.swift
//  NsectFinalProject
//
//  Created by found on 22/07/25.
//

import SwiftUI

struct TabBar: View {
    @Binding var selectedTab: Tab

    var body: some View {
        HStack(spacing: 0) {
            Button {
                selectedTab = .home
            } label: {
                VStack {
                    Image(systemName: "house.fill")
                        .font(.system(size: 28))
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(selectedTab == .home ? .green : .gray)
            }

            Button {
                selectedTab = .camera
            } label: {
                VStack {
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

            Button {
                selectedTab = .inventory
            } label: {
                VStack {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 32))
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(selectedTab == .inventory ? .green : .gray)
            }
        }
        .padding(.vertical, 1)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .opacity(0.85)
                .shadow(radius: 3)
        )
    }
}

#Preview {
    TabBar(selectedTab: .constant(.home))
}
