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
            VStack(spacing: 0) {
                
                // Cabeçalho
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color("DarkGreen"))
                        .frame(height: 100)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    
                    // Exemplo de conteúdo no cabeçalho
                    Text("Catálogo de Artrópodes")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .padding(.top, geometry.safeAreaInsets.top)

                Spacer(minLength: 20)
                
                // Imagem do Mapa
                Image("brazilMap")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: geometry.size.width * 0.95,
                           maxHeight: geometry.size.height * 0.5)
                    .padding()

                Spacer()

                // Barra Inferior
                HStack {
                    Spacer()
                    
                    Image(systemName: "house.fill")
                        .font(.system(size: 24))
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(Color("DarkGreen"))
                            .frame(width: 60, height: 60)
                            .shadow(radius: 4)
                        
                        Image(systemName: "camera")
                            .foregroundColor(.white)
                            .font(.system(size: 28))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 24))
                    
                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white)
                        .shadow(radius: 5)
                )
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color(.systemGray6))
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}

#Preview {
    HomeView()
}
