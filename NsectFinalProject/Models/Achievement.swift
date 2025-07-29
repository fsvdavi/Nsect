//
//  Untitled.swift
//  NsectFinalProject
//
//  Created by found on 29/07/25.
//

import Foundation

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let isUnlocked: Bool
}
