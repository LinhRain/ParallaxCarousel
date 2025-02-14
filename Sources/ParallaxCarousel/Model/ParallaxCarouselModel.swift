//
//  File.swift
//  
//
//  Created by LinhND on 2025/02/11.
//

import SwiftUI

let ParallaxCarouselsSample: [ParallaxCarouselModel] = [
    .init(imageUrl: "https://deelay.me/5000/https://via.placeholder.com/600x400", title: "Image 01", subTitle: "https://picsum.photos/id/1/200/300"),
    .init(imageUrl: "https://picsum.photos/id/2/200/300", title: "Image 02", subTitle: "https://picsum.photos/id/2/200/300"),
    .init(imageUrl: "https://picsum.photos/id/3/200/300", title: "Image 03", subTitle: "https://picsum.photos/id/3/200/300"),
    .init(imageUrl: "https://picsum.photos/id/4/200/300", title: "Image 04", subTitle: "https://picsum.photos/id/4/200/300"),
    .init(imageUrl: "https://picsum.photos/id/5/200/300", title: "Image 05", subTitle: "https://picsum.photos/id/5/200/300")
]


public struct ParallaxCarouselModel: Identifiable,Equatable {
    public var id: UUID = UUID()
    public var imageUrl: String
    public var title: String
    public var subTitle: String
    
    // Khởi tạo của ParallaxCarouselModel
    public init(imageUrl: String, title: String, subTitle: String) {
        self.imageUrl = imageUrl
        self.title = title
        self.subTitle = subTitle
    }
}

// Đảm bảo AnimationType được khai báo là public nếu nó có sử dụng
public enum AnimationType {
    case type01
    case type02
}


extension View {
    func applyScrollIndicators() -> some View {
        if #available(iOS 16.0, *) {
            return self.scrollIndicators(.hidden)
        } else {
            return self
        }
    }
}
