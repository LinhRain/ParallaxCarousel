# ParallaxCarousel

[![Swift](https://img.shields.io/badge/Swift-5.5+-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-14.0+-blue.svg)](https://developer.apple.com/ios/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0+-brightgreen.svg)](https://developer.apple.com/xcode/swiftui/)
[![MIT](https://img.shields.io/badge/License-MIT-red.svg)](https://opensource.org/licenses/MIT)

ParallaxCarousel là một thư viện SwiftUI mạnh mẽ cho phép tạo carousel với hiệu ứng parallax mượt mà. Thư viện hỗ trợ tải thêm dữ liệu (infinite scroll) và có khả năng tùy biến cao.

## 📱 Demo

>
>
> https://github.com/user-attachments/assets/3604a059-2858-40a5-9715-c78852c9797f
>
>

## ✨ Tính năng

- 🎨 Hiệu ứng parallax mượt mà và đẹp mắt
- 🔄 Hỗ trợ infinite scroll với khả năng tải thêm dữ liệu
- 📐 Tùy chỉnh kích thước và hướng hiển thị (ngang/dọc)
- 🎯 Hai kiểu animation khác nhau
- 🎨 Tùy chỉnh màu sắc và giao diện
- 📱 Hỗ trợ đầy đủ cho SwiftUI và iOS 14.0+
- 🔧 Dễ dàng tích hợp và sử dụng

## 📦 Yêu cầu

- iOS 14.0+
- Swift 5.5+
- Xcode 13.0+

## ⚙️ Cài đặt

### Swift Package Manager

ParallaxCarousel có thể được cài đặt thông qua Swift Package Manager trong Xcode:

1. Mở Xcode project của bạn
2. Chọn File > Add Packages...
3. Nhập URL repository:
```
https://github.com/LinhRain/ParallaxCarousel
```
4. Chọn phiên bản phù hợp
5. Nhấn Add Package

## 🚀 Bắt đầu sử dụng

### 1. Import thư viện

```swift
import ParallaxCarousel
```

### 2. Chuẩn bị dữ liệu

```swift
let sampleData: [ParallaxCarouselModel] = [
    ParallaxCarouselModel(
        id: 1, 
        imageUrl: "https://example.com/image1.jpg", 
        title: "Title 1", 
        subTitle: "Subtitle 1"
    ),
    ParallaxCarouselModel(
        id: 2, 
        imageUrl: "https://example.com/image2.jpg", 
        title: "Title 2", 
        subTitle: "Subtitle 2"
    )
]
```

### 3. Triển khai trong SwiftUI View

```swift
struct ContentView: View {
    @State private var items = sampleData
    @State private var isLoading = false
    
    func loadMore() {
        guard !isLoading else { return }
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let newItems = [
                ParallaxCarouselModel(
                    id: 3,
                    imageUrl: "https://example.com/image3.jpg",
                    title: "Title 3",
                    subTitle: "Subtitle 3"
                ),
                ParallaxCarouselModel(
                    id: 4,
                    imageUrl: "https://example.com/image4.jpg",
                    title: "Title 4",
                    subTitle: "Subtitle 4"
                )
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

## 🎨 Tùy chỉnh

| Thuộc tính | Kiểu dữ liệu | Mặc định | Mô tả |
|------------|--------------|----------|--------|
| `images` | `[ParallaxCarouselModel]` | - | Danh sách các item hiển thị |
| `axis` | `Axis.Set` | `.horizontal` | Hướng hiển thị (ngang/dọc) |
| `animationType` | `AnimationType` | `.type01` | Kiểu animation |
| `cornerRadiusCard` | `CGFloat` | `12` | Bo góc của card |
| `titleColor` | `Color` | `.white` | Màu chữ tiêu đề |
| `isShowCardInfor` | `Bool` | `true` | Hiển thị thông tin card |
| `itemHeight` | `CGFloat` | `400` | Chiều cao của item |
| `contentMode` | `ContentMode` | `.fit` | Kiểu hiển thị ảnh |
| `onLoadMore` | `() -> Void` | - | Callback khi cần tải thêm dữ liệu |
| `onParallaxItemClick` | `(Int) -> Void` | - | Callback khi click vào item |

## 🌟 Ví dụ nâng cao

```swift
ParallaxCarousel(
    images: items,
    axis: .horizontal,
    animationType: .type02,
    cornerRadiusCard: 15,
    titleColor: .blue,
    isShowCardInfor: true,
    itemHeight: 450,
    contentMode: .fill,
    onLoadMore: loadMore
) { index in
    print("Clicked item at index: \(index)")
}
```

## 🤝 Đóng góp

Mọi đóng góp đều được chào đón! Nếu bạn muốn đóng góp:

1. Fork repository
2. Tạo branch mới (`git checkout -b feature/AmazingFeature`)
3. Commit thay đổi (`git commit -m 'Add some AmazingFeature'`)
4. Push lên branch (`git push origin feature/AmazingFeature`)
5. Mở Pull Request

## 📝 Giấy phép

ParallaxCarousel được phát hành dưới giấy phép MIT. Xem file [LICENSE](LICENSE) để biết thêm chi tiết.

## 📮 Liên hệ

Nếu bạn có bất kỳ câu hỏi hoặc góp ý nào, vui lòng:

- Mở issue trên GitHub
- Gửi pull request
- Liên hệ qua email: [your.email@example.com]

## ⭐️ Nếu bạn thích thư viện này

Hãy để lại một star trên GitHub để ủng hộ và giúp những người khác dễ dàng tìm thấy thư viện này!
