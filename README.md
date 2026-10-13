# maker-KK/homebrew-tap

[Mac Ram Pulse](https://github.com/maker-KK/Mac-Ram-Pulse)를 설치하는 Homebrew tap입니다. Apple Silicon Mac용 메뉴바 메모리·스왑 모니터입니다.

```bash
brew install maker-KK/tap/mac-ram-pulse
mac-ram-pulse                          # 바로 실행
brew services start mac-ram-pulse      # 로그인할 때마다 자동 실행
```

설치할 때 소스를 내려받아 이 Mac에서 직접 빌드합니다. Xcode 16 이상이 필요하며, 빌드는 약 20초 걸립니다. 직접 빌드하기 때문에 서명되지 않은 앱이어도 Gatekeeper 경고가 뜨지 않습니다.
