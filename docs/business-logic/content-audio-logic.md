# 전역 BGM (Content Audio) 비즈니스 로직

해당 문서는 수신자(선물 개봉자) 환경에서 재생되는 배경음악(BGM)의 재생 정책과 상태 관리 및 브라우저 자동 재생 차단 회피를 위한 아키텍처 결정을 기록합니다.

## 1. 아키텍처 제약 및 구조 (Browser Autoplay Policy)

현대 브라우저(Chrome, Safari 등)는 사용자의 명시적인 인터랙션(Click, 터치 등)이 발생하기 전 배포 환경에서 미디어를 자동 재생하는 것을 엄격히 차단합니다. 이를 우회하거나 준수하기 위해 BGM 로직이 완전히 "수동 제어" 기반으로 설계되었습니다.

### 주요 설계 원칙
- **더 이상 페이지 진입 시 자동 재생을 시도하지 않음:** `LobbyView`, `MemoryGalleryView` 등 어디에 진입하더라도 `InitContentAudio`를 강제로 트리거하여 소리를 재생시키지 않습니다.
- **철저한 수동 토글(ON / OFF):** 오직 사용자가 우측 상단의 `ContentAudioToggle` 위젯(BGM 버튼)을 '클릭(터치)' 했을 때만 BGM이 켜지고 꺼집니다.
- **전역 상태 유지 (ShellRoute):** 로비(`/lobby` 또는 `/gift/code/:code`) 하위에 있는 모든 콘텐츠 라우트(갤러리, 가챠, 퀴즈, 오픈, 결과 뷰)는 `app_router.dart`에서 `ShellRoute`로 묶여 동일한 `ContentAudioBloc` 인스턴스를 공유합니다.
  - 사용자가 도중에 페이지를 이동해도 노래가 중간에 끊기거나 다시 시작되지 않으며 지속 재생됩니다.

---

## 2. 상태 관리 구조 (ContentAudioBloc)

BGM의 오디오 스트림 및 UI 상태를 동기화하기 위한 코어 비즈니스 로직입니다. 라이브러리는 `just_audio`를 사용합니다.

### 1) 주요 상태 (ContentAudioState)
```dart
class ContentAudioState {
  final bool isPlaying;   // 'UI' 및 '시스템 상' 현재 재생 중이라고 인지되는 완전한 상태 (ON의 기준)
  final String? currentUrl;
  final bool isMuted;     // 사용자가 '수동'으로 꺼서 음악 재생을 멈췄음을 명시하는 플래그 (중요)
}
```
- **`isOn`의 판단 기준:** 앱바 토글 UI의 ON 표기는 오직 `state.isPlaying == true`일 때만 참이 됩니다. `isMuted`나 다른 부가 속성을 조합하지 않아 직관적입니다.

### 2) 핵심 파이프라인 방어 로직 (비동기 덮어쓰기 방지)
오디오 패키지의 내장 스트림(`playerStateStream`)에서 넘어오는 지연된 비동기 콜백이, 사용자가 직접 누른 `OFF`(`ToggleContentAudio`의 `isMuted = true`) 상태를 무시하고 과거의 찌꺼기 재생 이벤트로 화면을 다시 `ON`으로 덮어버리는 이슈가 있었습니다.

**해결 방안 (`_playerStateSubscription`):**
```dart
// 사용자가 수동으로 OFF 시킨 상태(isMuted == true)라면, 
// 예상치 못한 오디오 스트림의 재생(playing) 잔여 이벤트를 무시하여 엄격하게 OFF를 유지
if (!state.isMuted && state.isPlaying != isPlaying) {
  add(_UpdatePlayingStatus(isPlaying));
}
```

### 3) 렌더링 즉시성 확보 (`_onToggle`)
Web Audio API의 특성상 `pause()` 실행이 완료되기까지 수십 밀리초의 딜레이가 발생합니다. 클릭하자마자 즉시 피드백을 주기 위해 상태 반영 로직 순서를 최적화했습니다.
```dart
// [전]
await _audioPlayer.pause();
emit(state.copyWith(isPlaying: false, isMuted: true)); // <-- 멈칫하는 현상 발생

// [후]
emit(state.copyWith(isPlaying: false, isMuted: true)); // <-- 1. 즉시 UI OFF 변경
await _audioPlayer.pause();                            // <-- 2. 백그라운드에서 여유롭게 일시 정지 지시
```

---

## 3. UI 렌더링 위젯 (ContentAudioToggle)

애니메이션 로직이 잔존할 시 퍼포먼스가 낮아지고 `AnimatedContainer` 특성상 상태 기반 리빌드 중 꼬임 현상이 빈번히 발생했습니다.
현재는 가장 순수하고 직관적인 방향으로 변경되었습니다.

- **위젯 타입:** 네이티브 `OutlinedButton` 사용. 터치 리플 이펙트가 프레임워크 차원에서 보장됨.
- **스트림 구독 방식:** 보일러플레이트 제거를 위해 `BlocBuilder` 대신 `context.watch<ContentAudioBloc>().state` 방식을 채택하여 최상위 빌드 타임에서 가장 강력하게 Bloc State 변경을 추적합니다.
- **마진 레이아웃:** 토글 버튼 우측에 `const SizedBox(width: 8)`을 주어 다른 컨트롤(다운로드, 히스토리, 진행률)과의 간격을 일관되게 규정합니다.

---

## 4. 정리된 Flow

1. **로비 진입 시 (`_onPreload`):** BGM URL 리소스를 미리 캐싱합니다. (사용자 제스처 없음 - 소리 안남)
2. **최초 버튼 클릭 (`_onToggle: else`):** `isMuted`를 풀고, 브라우저가 사용자 인터랙션을 확인했으므로 정상적으로 `play()` 됩니다. (UI: ON)
3. **재 클릭 시 (`_onToggle: if`):** UI를 즉시 `isPlaying: false, isMuted: true` 상태로 만들고 라이브러리에 `pause()`를 요청하여 스트림 비동기 간섭을 완벽히 차단합니다. (UI: OFF) 
4. **페이지 이동 시 (`ShellRoute`):** `isPlaying` 및 `isMuted` 정보가 유지된 Bloc이 하위 위젯들로 그대로 상속되어 음악이 스무스하게 연결되고 UI ON/OFF 상태 표기도 동일하게 유지됩니다.
