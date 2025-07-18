//
//  ContentView.swift
//  NsectFinalProject
//
//  Created by Nsect Equipe on 04/07/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
              
                Image("forestBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .opacity(0.8)
                    .ignoresSafeArea()

             
                GeometryReader { geometry in
                    ZStack {
                        
//                        // deixar esbranquicado
//                        Color(.systemGray6)
//                            .opacity(0.5)
//                            .ignoresSafeArea()

                        VStack(spacing: 0) {
                            // Topo
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color(red: 0.0, green: 0.4, blue: 0.2))
                                    .frame(height: 110)
                                    .shadow(radius: 5)
                                    .padding(.horizontal)

                                Image("nsectTitle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                    .padding(.horizontal, 30)
                            }

                            Spacer()

                            // Mapa
                            
                            Image("brazilMap")
                                .resizable()
                                .scaledToFit()
                                .scaleEffect(1.35)
                                .shadow(radius: 20)
                            

                            Spacer()
                        }

                        // Barra inferior
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()

                                VStack(spacing: 2) {
                                    Image(systemName: "house.fill")
                                        .font(.system(size: 22))
                                    Text("Home")
                                        .font(.caption2)
                                }
                                .foregroundColor(.gray)

                                Spacer()

                                NavigationLink(destination: CameraARView()) {
                                    VStack(spacing: 2) {
                                        ZStack {
                                            Circle()
                                                .fill(Color(red: 0.0, green: 0.4, blue: 0.2))
                                                .frame(width: 55, height: 55)

                                            Image(systemName: "camera")
                                                .foregroundColor(.white)
                                                .font(.system(size: 26))
                                        }
                                        Text("Find New")
                                            .font(.caption2)
                                            .foregroundColor(.primary)
                                    }
                                }

                                Spacer()

                                NavigationLink(destination: InventoryInsectView()) {
                                    VStack(spacing: 2) {
                                        Image(systemName: "person.crop.circle")
                                            .font(.system(size: 22))
                                        Text("Profile")
                                            .font(.caption2)
                                    }
                                    .foregroundColor(.gray)
                                }

                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(
                                Color.white
                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                                    .shadow(radius: 3)
                            )
                        }
                        .ignoresSafeArea(.all, edges: .bottom)
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}

