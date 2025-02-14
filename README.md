# ParallaxCarousel
🚀 Video

>
>
> https://github.com/user-attachments/assets/3604a059-2858-40a5-9715-c78852c9797f
>
>


ParallaxCarousel

ParallaxCarousel là một thư viện SwiftUI giúp bạn tạo một carousel với hiệu ứng parallax mượt mà. Hỗ trợ load more khi kéo đến cuối danh sách và có thể hiển thị vòng lặp vô hạn.

🚀 Cài đặt

Thêm thư viện vào dự án của bạn bằng cách sử dụng Swift Package Manager (SPM):

Mở Xcode, vào File > Add Packages...
```
https://github.com/LinhRain/ParallaxCarousel
```

Thêm URL của repository vào trường tìm kiếm.

Chọn phiên bản phù hợp và nhấn Add Package.

📌 Sử dụng

1. Import thư viện
```
import ParallaxCarousel
```
2. Khai báo danh sách dữ liệu
```
let sampleData: [ParallaxCarouselModel] = [
    ParallaxCarouselModel(id: 1, imageUrl: "https://example.com/image1.jpg", title: "Title 1", subTitle: "Subtitle 1"),
    ParallaxCarouselModel(id: 2, imageUrl: "https://example.com/image2.jpg", title: "Title 2", subTitle: "Subtitle 2")
]
```
3. Sử dụng ParallaxCarousel
```
struct ContentView: View {
    @State private var items = sampleData
    @State private var isLoading = false

    func loadMore() {
        guard !isLoading else { return }
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let newItems = [
                ParallaxCarouselModel(id: 3, imageUrl: "https://example.com/image3.jpg", title: "Title 3", subTitle: "Subtitle 3"),
                ParallaxCarouselModel(id: 4, imageUrl: "https://example.com/image4.jpg", title: "Title 4", subTitle: "Subtitle 4")
            ]
            items.append(contentsOf: newItems)
            isLoading = false
        }
    }
    
    var body: some View {
        ParallaxCarousel(
            images: items,
            itemHeight: 400,
            contentMode: .fit,
            onLoadMore: loadMore
        )
    }
}
```

🎨 Tùy chỉnh

| Thuộc tính | Kiểu Dữ Liệu    | Mô Tả    |
| :-----: | :---: | :---: |
| images | [ParallaxCarouselModel] | Danh sách các item hiển thị trong carousel | 
| axit | Axis.Set | Hướng hiển thị (.horiroltal hoặc .vertical) | 
| animationType | AnimationType | Kiểu animation (.type01 or.type02) | 
| cornerRadiusCard | CGFloat |Bo góc thẻ | 
| titleColor | Color | Màu sắc tiêu đề | 
| isShowCardInfor | Bool | Hiển thị thông tin card | 
| itemHeight | CGFloat | Chiều cao item | 
| contentMode | ContentMode | Kiểu hiển thị ảnh (.fill or .fit) | 
| onLoadMore | () -> Void | Hàm gọi khi cần load thêm dữ liệu | 
| onParallaxItemClick | (index) -> Void | Callback khi click vào item với index tương ứng trong parallax carousel | 

📜 Giấy phép

ParallaxCarousel được phát hành theo giấy phép MIT. Bạn có thể sử dụng miễn phí trong mọi dự án cá nhân hoặc thương mại.

🚀 Chúc bạn sử dụng vui vẻ! Nếu bạn có bất kỳ câu hỏi nào, hãy mở một issue hoặc đóng góp vào repository! 😊
