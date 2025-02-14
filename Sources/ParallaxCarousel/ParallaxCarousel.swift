//
//  ParallaxCarousel.swift
//
//
//  Created by LinhND on 2025/02/11.
//
import SwiftUI
import SDWebImageSwiftUI

public struct ParallaxCarousel: View {
    /// Danh sách hình ảnh hiển thị trong carousel
    @Binding var images: [ParallaxCarouselModel]
    var axit: Axis.Set = .horizontal
    var animationType: AnimationType = .type01
    var cornerRadiusCard: CGFloat = 15.0
    var titleColor: Color = .white
    var isShowCardInfor: Bool = true
    var itemHeight: CGFloat = 600.0
    var contentMode:ContentMode = .fill
    var loadMore: () -> Void
    var isDefaultImage:Bool = false
    var defaultImageURL:String = ""
    var onParallaxItemClick:(_ index:Int) -> Void
    
    /// Hiển thị danh sách ảnh trong một Carousel.
    /// - Parameters:
    ///   - images: 📷 Danh sách hình ảnh hiển thị
    ///   - axit: 🔄 Hướng cuộn của carousel (ngang/dọc)
    ///   - animationType: 🎞️ Kiểu animation khi cuộn
    ///   - cornerRadiusCard: 🟦 Độ cong của góc card
    ///   - titleColor: 🎨 Màu chữ trên card
    ///   - isShowCardInfor: ℹ️ Có hiển thị thông tin trên card không
    ///   - itemHeight: 📏 Chiều cao của mỗi item
    ///   - contentMode: 🖼️ Kiểu hiển thị ảnh (`fill` hoặc `fit`)
    ///   - loadMore: ⏳ Callback khi cuộn đến cuối danh sách
    ///   - isDefaultImage: 🖼️ Có hiển thị ảnh mặc định không
    ///   - defaultImageURL:  URL của ảnh mặc định
    ///   -  onParallaxItemClick:  Callback khi click vào item với index tương ứng trong parallax carousel
    public init(
        images: Binding<[ParallaxCarouselModel]>,
        axit: Axis.Set = .horizontal,
        animationType: AnimationType = .type01,
        cornerRadiusCard: CGFloat = 15.0,
        titleColor: Color = .white,
        isShowCardInfor: Bool = true,
        itemHeight: CGFloat = 600.0,
        contentMode: ContentMode = .fill,
        loadMore: @escaping () -> Void,
        isDefaultImage:Bool = false,
        defaultImageURL:String = "default-image",
        onParallaxItemClick: @escaping (_ index:Int) -> Void
    ) {
        self._images = images
        self.axit = axit
        self.animationType = animationType
        self.cornerRadiusCard = cornerRadiusCard
        self.titleColor = titleColor
        self.isShowCardInfor = isShowCardInfor
        self.itemHeight = itemHeight
        self.contentMode = contentMode
        self.loadMore = loadMore
        self.isDefaultImage = isDefaultImage
        self.defaultImageURL = defaultImageURL
        self.onParallaxItemClick = onParallaxItemClick
    }
    
    public var body: some View {
        if #available(iOS 17.0, *) {
            VStack {
                GeometryReader { geometry in
                    let size = geometry.size
                    ScrollView(axit) {
                        LazyHStack(spacing: 5) {
                            Image(defaultImageURL)
                                .resizable()
                                .aspectRatio(contentMode: contentMode)
                                .frame(width: size.width, height: size.height)
                                .clipShape(RoundedRectangle(cornerRadius: cornerRadiusCard))
                                .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                            
                            ForEach(images.indices, id: \.self) { index in
                                
                                GeometryReader { proxy in
                                    let itemSize = proxy.size
                                    // Animation 01
                                    let minX01 = proxy.frame(in: .scrollView).minX
                                    // Animation 02
                                    let minX02 = min((proxy.frame(in: .scrollView).minX * 1.6), proxy.size.width * 1.6)
                                    
                                    WebImage(url: URL(string: images[index].imageUrl)) { image in
                                        image.resizable()
                                    } placeholder: {
                                        ZStack {
                                            Color.gray.opacity(0.1)
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle())
                                        }
                                    }
                                    .indicator(.activity)
                                    .aspectRatio(contentMode: contentMode)
                                    .offset(x: self.animationType == .type01 ? -minX01 : -minX02)
                                    .frame(width: itemSize.width, height: itemSize.height)
                                    .clipShape(RoundedRectangle(cornerRadius: cornerRadiusCard))
                                    .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                                    .overlay {
                                        if isShowCardInfor {
                                            CardInfor(item: images[index])
                                        }
                                    }
                                    .onTapGesture(perform: {
                                        onParallaxItemClick(index)
                                    })
                                    
                                    if index == images.count - 1 {
                                        Color.clear.onAppear {
                                            print("LAST ITEM - Index: \(index)")
                                            loadMore()
                                        }
                                    }
                                    
                                }
                                .frame(width: size.width - 80, height: size.height - 40)
                                .overlay( // Detect when the *last* item appears
                                    GeometryReader { overlayProxy in
                                        Color.clear
                                            .preference(key: LastItemPreferenceKey.self, value: index == images.count - 1 && overlayProxy.frame(in: .global).maxX > 0) // Check if it's the last item AND visible
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
                            ForEach(images.indices, id: \.self) { index in
                                GeometryReader { proxy in
                                    let itemSize = proxy.size
                                    let minX = proxy.frame(in: .global).minX
                                    let adjustedX = self.animationType == .type01 ? -minX : -minX * 1.4
                                    
                                    WebImage(url: URL(string: images[index].imageUrl)) { image in
                                        image.resizable()
                                    } placeholder: {
                                        ZStack {
                                            Color.gray.opacity(0.1) // Nền xám khi ảnh đang load
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle()) // Vòng quay ở giữa
                                        }
                                    }
                                    .indicator(.activity)
                                    .aspectRatio(contentMode: contentMode)
                                    .frame(width: itemSize.width, height: itemSize.height)
                                    .offset(x:adjustedX)
                                    .clipShape(RoundedRectangle(cornerRadius: cornerRadiusCard))
                                    .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                                    .overlay {
                                        if isShowCardInfor {
                                            CardInfor(item: images[index])
                                        }
                                    }
                                    .onTapGesture(perform: {
                                        onParallaxItemClick(index)
                                    })
                                }
                                .frame(width: size.width - 80, height: size.height - 40)
                                .overlay( // Detect when the *last* item appears
                                    GeometryReader { overlayProxy in
                                        Color.clear
                                            .preference(key: LastItemPreferenceKey.self, value: index == images.count - 1 && overlayProxy.frame(in: .global).maxX > 0)
                                    }
                                )
                                .onPreferenceChange(LastItemPreferenceKey.self) { isLastItemVisible in
                                    if isLastItemVisible {
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
    struct PreviewWrapper: View {
        @State private var images: [ParallaxCarouselModel] = ParallaxCarouselsSample
        
        var body: some View {
            ParallaxCarousel(
                images: $images,
                itemHeight: 400,
                loadMore: {
                },
                isDefaultImage: true,
                defaultImageURL: "default-image",
                onParallaxItemClick: { index in
                    print("onParallaxItemClick",index)
                } // Thêm callback mặc định
                
            )
        }
    }
    return PreviewWrapper()
}



// PreferenceKey to track the last item's visibility
struct LastItemPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

