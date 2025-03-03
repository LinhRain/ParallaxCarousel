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
    @State private var currentIndex: Int = 0
    @State private var scrollOffset: CGFloat = 0
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
    @State private var scrollViewProxy: ScrollViewProxy?
    @Namespace private var animation
    @State private var isLoading: Bool = false
    
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
            VStack(spacing: 20) {
                ScrollViewReader { proxy in
                    GeometryReader { geometry in
                        let size = geometry.size
                        ScrollView(axit) {
                            LazyHStack(spacing: 15) {
                                if isDefaultImage {
                                    Image(defaultImageURL)
                                        .resizable()
                                        .aspectRatio(contentMode: contentMode)
                                        .frame(width: size.width, height: size.height)
                                        .clipShape(RoundedRectangle(cornerRadius: cornerRadiusCard))
                                        .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                                }
                                
                                ForEach(images.indices, id: \.self) { index in
                                    GeometryReader { proxy in
                                        let itemSize = proxy.size
                                        let minX01 = proxy.frame(in: .scrollView).minX
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
                                        .onChange(of: proxy.frame(in: .scrollView).minX) { newValue in
                                            let midX = proxy.frame(in: .global).midX
                                            let screenMidX = UIScreen.main.bounds.width / 2
                                            
                                            if abs(midX - screenMidX) < 50 {
                                                withAnimation(.easeInOut(duration: 0.2)) {
                                                    currentIndex = index
                                                }
                                            }
                                            
                                            if index == images.count - 1 && !isLoading {
                                                let screenWidth = UIScreen.main.bounds.width
                                                let endThreshold = screenWidth * 0.2
                                                
                                                if midX < screenWidth + endThreshold {
                                                    isLoading = true
                                                    loadMore()
                                                }
                                            }
                                        }
                                    }
                                    .frame(width: size.width - 10, height: size.height - 20)
                                }
                            }
                            .padding(.horizontal, 40)
                            .frame(height: size.height, alignment: .top)
                        }
                        .scrollIndicators(.hidden)
                        .onAppear {
                            scrollViewProxy = proxy
                        }
                    }
                    .frame(height: itemHeight)
                }
                
                HStack(spacing: 8) {
                    ForEach(0..<images.count, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(currentIndex == index ? Color.blue : Color.gray)
                            .frame(width: currentIndex == index ? 20 : 12, height: 4)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentIndex)
                            .id(index)
                            .onTapGesture {
                                scrollToItem(index: index)
                            }
                    }
                }
                .padding(.bottom, 10)
            }
        } else {
            // Fallback on earlier versions (iOS 15 and above)
            VStack(spacing: 20) {
                ScrollViewReader { proxy in
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
                                        .onChange(of: proxy.frame(in: .global).minX) { newValue in
                                            scrollOffset = newValue
                                            updateCurrentIndex(from: proxy)
                                        }
                                    }
                                    .frame(width: size.width - 10, height: size.height - 20)
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
                        .onAppear {
                            scrollViewProxy = proxy
                        }
                    }
                    .frame(height: itemHeight)
                    .padding(.horizontal, -15)
                }
                
                HStack(spacing: 8) {
                    ForEach(0..<images.count, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(currentIndex == index ? Color.blue : Color.gray)
                            .frame(width: currentIndex == index ? 20 : 12, height: 4)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentIndex)
                            .id(index)
                            .onTapGesture {
                                scrollToItem(index: index)
                            }
                    }
                }
                .padding(.bottom, 10)
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
    
    private func updateCurrentIndex(from proxy: GeometryProxy) {
        let midX = proxy.frame(in: .global).midX
        let screenWidth = UIScreen.main.bounds.width
        let screenMidX = screenWidth / 2
        let itemWidth = screenWidth - 80 // Chiều rộng của mỗi item
        
        // Tính toán index dựa trên vị trí scroll
        let estimatedIndex = Int(round((screenMidX - midX) / itemWidth))
        
        // Đảm bảo index nằm trong khoảng hợp lệ
        if estimatedIndex >= 0 && estimatedIndex < images.count {
            withAnimation(.easeInOut(duration: 0.2)) {
                currentIndex = estimatedIndex
            }
        }
    }
    
    private func scrollToItem(index: Int) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            currentIndex = index
            scrollViewProxy?.scrollTo(index, anchor: .center)
        }
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
                    print("loadnore")
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

// Thêm PreferenceKey để theo dõi scroll offset
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

