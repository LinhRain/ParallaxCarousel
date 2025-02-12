//
//  ParallaxCarousel.swift
//
//
//  Created by LinhND on 2025/02/11.
//
import SwiftUI

public struct ParallaxCarousel: View {
    var Images: [ParallaxCarouselModel] // Danh sách các item cho carousel
    var axit: Axis.Set = .horizontal // Axis cho carousel (ngang hoặc dọc)
    var animationType: AnimationType = .type01 // Kiểu animation
    var cornerRadiusCard: CGFloat = 15.0 // Góc bo tròn cho các thẻ
    var titleColor: Color = .white // Màu sắc của tiêu đề
    var isShowCardInfor: Bool = true // Điều kiện hiển thị CardInfor
    var itemHeight: CGFloat = 600.0
    var contentMode:ContentMode = .fill
    var loadMore: () -> Void
    // Hàm khởi tạo có tham số cho các thuộc tính trên
    public init(Images: [ParallaxCarouselModel],
                axit: Axis.Set = .horizontal,
                animationType: AnimationType = .type01,
                cornerRadiusCard: CGFloat = 15.0,
                titleColor: Color = .white,
                isShowCardInfor: Bool = true,
                itemHeight: CGFloat = 600.0,
                contentMode:ContentMode = .fill,
                loadMore: @escaping () -> Void
    ) {
        self.Images = Images
        self.axit = axit
        self.animationType = animationType
        self.cornerRadiusCard = cornerRadiusCard
        self.titleColor = titleColor
        self.isShowCardInfor = isShowCardInfor
        self.itemHeight = itemHeight
        self.contentMode = contentMode
        self.loadMore = loadMore
    }
    
    public var body: some View {
        if #available(iOS 17.0, *) {
            VStack {
                GeometryReader { geometry in
                    let size = geometry.size
                    ScrollView(axit) {
                        LazyHStack(spacing: 5) {
                            ForEach(Images.indices, id: \.self) { index in // Iterate over indices
                                GeometryReader { proxy in
                                    let itemSize = proxy.size
                                    // Animation 01
                                    let minX01 = proxy.frame(in: .scrollView).minX
                                    // Animation 02
                                    let minX02 = min((proxy.frame(in: .scrollView).minX * 1.4), proxy.size.width * 1.4)

                                    AsyncImage(url: URL(string: Images[index].imageUrl)) { phase in // Use index to access the correct item
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: contentMode)
                                                .offset(x: self.animationType == .type01 ? -minX01 : -minX02)
                                                .frame(width: itemSize.width)
                                                .frame(width: itemSize.width, height: itemSize.height)
                                                .clipShape(RoundedRectangle(cornerRadius: cornerRadiusCard))
                                                .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                                                .overlay {
                                                    if isShowCardInfor {
                                                        CardInfor(item: Images[index]) // Use index here as well
                                                    }
                                                }
                                        case .failure:
                                            Color.gray
                                                .frame(width: itemSize.width, height: itemSize.height)
                                                .clipShape(RoundedRectangle(cornerRadius: cornerRadiusCard))
                                        case .empty:
                                            Color.gray
                                                .frame(width: itemSize.width, height: itemSize.height)
                                                .clipShape(RoundedRectangle(cornerRadius: cornerRadiusCard))
                                        @unknown default:
                                            Color.gray
                                                .frame(width: itemSize.width, height: itemSize.height)
                                                .clipShape(RoundedRectangle(cornerRadius: cornerRadiusCard))
                                        }
                                    }

                                    if index == Images.count - 1 { // Now you have the correct index
                                        Color.clear.onAppear {
                                            print("LAST ITEM - Index: \(index)") // Print the index
                                            loadMore()
                                        }
                                    }
                                }
                                .frame(width: size.width - 80, height: size.height - 40)
                                .overlay( // Detect when the *last* item appears
                                    GeometryReader { overlayProxy in
                                        Color.clear
                                            .preference(key: LastItemPreferenceKey.self, value: index == Images.count - 1 && overlayProxy.frame(in: .global).maxX > 0) // Check if it's the last item AND visible
                                    }
                                )
                                .onPreferenceChange(LastItemPreferenceKey.self) { isLastItemVisible in
                                    if isLastItemVisible { // This will now print every time the last item becomes visible
                                        print("LAST ITEM - Index: \(index)")
                                    }
                                }
                                .scrollTargetLayout()
                                .scrollTransition(.interactive, axis: .horizontal) { view, phase in
                                    view.scaleEffect(phase.isIdentity ? 1 : 0.95)
                                }
                            }                        }
                        .padding(.horizontal, 30)
                        .frame(height: size.height, alignment: .top)
                    }
                    .scrollIndicators(.hidden)
                }
                .frame(height: itemHeight)
                .padding(.horizontal, -15)
            }
        } else {
            // Fallback on earlier versions (iOS 15 and above)
            VStack {
                GeometryReader { geometry in
                    let size = geometry.size
                    ScrollView(axit) {
                        LazyHStack(spacing: 5) {
                            ForEach(Images.indices, id: \.self) { index in
                                GeometryReader { proxy in
                                    let itemSize = proxy.size
                                    let minX = proxy.frame(in: .global).minX
                                    let adjustedX = self.animationType == .type01 ? -minX : -minX * 1.4
                                    
                                    AsyncImage(url: URL(string: Images[index].imageUrl)) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .offset(x: adjustedX)
                                                .frame(width: itemSize.width, height: itemSize.height)
                                                .clipShape(RoundedRectangle(cornerRadius: cornerRadiusCard))
                                                .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                                                .overlay {
                                                    if isShowCardInfor {
                                                        CardInfor(item: Images[index])
                                                    }
                                                }
                                        case .failure:
                                            Color.gray
                                                .frame(width: itemSize.width, height: itemSize.height)
                                                .clipShape(RoundedRectangle(cornerRadius: cornerRadiusCard))
                                        case .empty:
                                            Color.gray
                                                .frame(width: itemSize.width, height: itemSize.height)
                                                .clipShape(RoundedRectangle(cornerRadius: cornerRadiusCard))
                                        @unknown default:
                                            Color.gray
                                                .frame(width: itemSize.width, height: itemSize.height)
                                                .clipShape(RoundedRectangle(cornerRadius: cornerRadiusCard))
                                        }
                                    }
                                }
                                .frame(width: size.width - 80, height: size.height - 40)
                                .overlay( // Detect when the *last* item appears
                                    GeometryReader { overlayProxy in
                                        Color.clear
                                            .preference(key: LastItemPreferenceKey.self, value: index == Images.count - 1 && overlayProxy.frame(in: .global).maxX > 0) // Check if it's the last item AND visible
                                    }
                                )
                                .onPreferenceChange(LastItemPreferenceKey.self) { isLastItemVisible in
                                    if isLastItemVisible { // This will now print every time the last item becomes visible
                                        print("LAST ITEM - Index: \(index)")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                        .frame(height: size.height, alignment: .top)
                    }
                    .applyScrollIndicators()
                }
                .frame(height: itemHeight)
                .padding(.horizontal, -15)
            }
        }
    }
    
    @ViewBuilder
    func CardInfor(item: ParallaxCarouselModel) -> some View {
        ZStack(alignment: .bottomLeading, content: {
            LinearGradient(colors: [
                .clear,
                .clear,
                .clear,
                .clear,
                .clear,
                .black.opacity(0.1),
                .black.opacity(0.5),
                .black
            ], startPoint: .top, endPoint: .bottom)
            VStack(alignment: .leading, spacing: 4, content: {
                Text(item.title)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundStyle(titleColor)
                
                Text(item.subTitle)
                    .font(.callout)
                    .fontWeight(.black)
                    .foregroundStyle(titleColor.opacity(0.8))
            })
            .padding(20)
        })
        .cornerRadius(cornerRadiusCard)
    }
}

#Preview {
    ParallaxCarousel(Images: ParallaxCarouselsSample,itemHeight: 400,contentMode: .fit, loadMore: {
        print("LOAD MORRE")
    })
}

// PreferenceKey to track the last item's visibility
struct LastItemPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}
