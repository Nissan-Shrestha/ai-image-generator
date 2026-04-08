# AI Image Generator 🎨

A premium, state-of-the-art Flutter application that harnesses the power of **Cloudflare AI** to transform text prompts into stunning visual art. Designed with a modern, glassmorphic aesthetic and high-performance state management.

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Cloudflare](https://img.shields.io/badge/Cloudflare-F38020?style=for-the-badge&logo=Cloudflare&logoColor=white)

## ✨ Features

- **Prompt-to-Image**: Generate high-quality images from simple text descriptions.
- **Reference Image support**: (Planned/Experimental) Support for image-to-image generation.
- **Modern UI/UX**: 
  - Sleek dark mode design.
  - Vibrant gradients and glassmorphism.
  - Smooth micro-animations and physics-based scrolling.
- **Fast Performance**: Optimized image loading and processing.
- **Environment Security**: Sensitive API keys are managed through `.env` files.
- **Robust Error Handling**: Real-time feedback for network issues or API limits.

## 🚀 Tech Stack

- **Framework**: [Flutter](https://flutter.dev) (Channel Stable)
- **Language**: [Dart](https://dart.dev)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **AI Backend**: [Cloudflare Workers AI](https://developers.cloudflare.com/workers-ai/) (Stable Diffusion models)
- **Styling**: Vanilla Flutter with Custom Gradients & `google_fonts`
- **Other libraries**: `http`, `flutter_dotenv`, `image_picker`.

## 🛠️ Setup Instructions

### Prerequisites
- Flutter SDK installed on your machine.
- A Cloudflare account with Workers AI access.

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Nissan-Shrestha/ai-image-generator.git
   cd ai-image-generator
   ```

2. **Setup environment variables**:
   Create a `.env` file in the root directory and add your Cloudflare credentials:
   ```env
   CLOUDFLARE_API_TOKEN=your_token_here
   CLOUDFLARE_ACCOUNT_ID=your_id_here
   ```
   *Note: See `.env.example` for reference.*

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

4. **Run the application**:
   ```bash
   flutter run
   ```

## 📂 Project Structure

```
lib/
├── core/
│   ├── constants/    # Theme and color tokens
│   └── services/     # Cloudflare AI API integration
├── models/           # Data models
├── viewmodels/       # Provider state management logic
└── views/
    ├── dashboard/    # Main landing screen
    └── generation/   # Image generation interface
```

## 🤝 Contributing

Contributions are welcome! If you have any ideas to improve the UI or integrate more AI models, feel free to open a Pull Request.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---
*Built with ❤️ by Nissan Shrestha*
