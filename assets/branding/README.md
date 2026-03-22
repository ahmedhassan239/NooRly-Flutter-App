# NOORly branding assets

## `app_icon.png`

- **Purpose:** Source image for **launcher icons** (`flutter_launcher_icons`) and **native splash** (`flutter_native_splash`).
- **Format:** True **PNG** (RGB/RGBA). AVIF/WebP files renamed as `.png` will **fail** icon/splash generation — convert first (e.g. `ffmpeg -i input.avif app_icon.png`).
- **Size:** At least **1024×1024** recommended.
- **In-app circular avatars:** The Flutter UI uses [`AppBrandLogoCircular`](../../lib/design_system/widgets/app_brand_logo.dart) and `BoxFit.contain` so the full wordmark stays inside the circle. If the artwork still looks **shifted or cropped**, the PNG likely has **uneven transparent padding** around the logo—re-export with equal margins or trim the canvas in Figma/Photoshop.

## Regenerate icons & splash

From the `Flutter-App` directory:

```bash
flutter pub get
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

`flutter_native_splash` updates `web/index.html` and `web/splash/`. If you customize `index.html`, merge carefully after re-running the tool.
