//
//  ContentView.swift
//  NsectFinalProject
//
//  Created by Nsect Equipe on 04/07/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
//                // Fundo com imagem de floresta e cor base
//                Image("florestaFundo") // nome da imagem de fundo
//                    .resizable()
//                    .scaledToFill()
//                    .opacity(0.15)
//                    .ignoresSafeArea()
//                
//                Color(.systemGray6)
//                    .ignoresSafeArea()
//                
                VStack(spacing: 0) {

                
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color(red: 0.0, green: 0.4, blue: 0.2))
                            .frame(height: 110)
                            .shadow(radius: 5)
                            .padding(.horizontal)

                        Image("nsectTitle")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 80)
                            .padding(.horizontal, 30)
                    }
//                    .padding(.top, geometry.safeAreaInsets.top + 5)
//                    .padding(.bottom, 10)

                    Spacer()

                    // Imagem do mapa do Brasil maior
                    Image("brazilMap")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: geometry.size.width * 1.25,
                               maxHeight: geometry.size.height * 1.1)
                        .clipped()
                        .padding(.horizontal)

                    Spacer()

                    // Barra inferior mais fina e rente ao fundo
                    HStack {
                        Spacer()

                        Image(systemName: "house.fill")
                            .font(.system(size: 24))

                        Spacer()

                        ZStack {
                            Circle()
                                .fill(Color(red: 0.0, green: 0.4, blue: 0.2))
                                .frame(width: 55, height: 55)

                            Image(systemName: "camera")
                                .foregroundColor(.white)
                                .font(.system(size: 26))
                        }

                        Spacer()

                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 24))

                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.white)
                            .shadow(radius: 3)
                            .edgesIgnoringSafeArea(.bottom)
                    )
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

#Preview {
    HomeView()
}
