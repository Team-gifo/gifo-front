# 검색 엔진 최적화 (SEO)

> 이 문서의 목적: 웹 크롤러가 쉽게 접근할 수 있게 프로젝트에 적용된 SEO 구성(`robots.txt`, `sitemap.xml`, `메타 태그`)을 설명한다.

## 1. 정적 파일 구성 (web 디렉터리)

Flutter Web의 특성상 캔버스로 렌더링되지만, 기본 진입점이 되는 검색 크롤러 봇에 지시를 내릴 수 있도록 기본 정적 파일을 세팅했습니다.

### robots.txt (`web/robots.txt`)
`web` 폴더 내에 배치되어 모든 검색 엔진의 크롤링을 허용하고(`Allow: /`), Sitemap의 주소를 알려주는 역할을 합니다.

```txt
User-agent: *
Allow: /

Sitemap: https://gifo.co.kr/sitemap.xml
```

### sitemap.xml (`web/sitemap.xml`)
Google 등 메인 검색엔진에 어떤 페이지들을 긁어가야 하는지(목록) 알려주는 파일입니다.
우리가 외부에 노출해야 하는(검색해야 하는) 홈 엔드포인트 두 곳만 등록합니다.

- **메인 페이지** (`/`): `changefreq`를 `weekly`로 설정해 주 단위로 갱신 
- **포장하기 페이지** (`/addgift`): `changefreq`를 `monthly`로 설정해 한 번씩 갱신 여부 체크

*(`gift/code/:code` 같은 동적 수신자 페이지는 무작위 공유 링크이므로 Sitemap에 등록하지 않습니다.)*

## 2. 기본 html 메타 속성 (`web/index.html`)

페이지가 렌더링되기 전, 기본적으로 HTML 내의 `<meta>`와 `<head>` 속성이 읽힙니다. 이 구역에 초기 메타 정보를 기입해둡니다.

- **`description`**: 서비스의 핵심 요약 설명.
- **`keywords`**: 'Gifo', '선물', '포장', '생일', '웹사이트 선물' 등 검색용 키워드.
- **웹 오픈 그래프 (`og:`) 태그**: 소셜 미디어(카카오톡 썸네일, 페이스북, X 등) 공유 시 보이는 제목, 이미지, 설명을 삽입.
  - `og:image`는 대표 이미지인 `assets/images/title_logo.png`로 지정했습니다.
- **`title`**: 브라우저 탭 및 검색 엔진 기본 이름.
- **`canonical`**: 대표 URL 지정 (`https://gifo.co.kr/`).

## 3. SEO 전용 컴포넌트 (`lib/core/widgets/`)

Flutter Web의 CanvasKit 렌더링 한계를 극복하기 위해, 런타임에 실제 HTML DOM 요소를 보이지 않게 주입하는 전용 위젯을 사용합니다.

### SeoText (`seo_text.dart`)
- **역할**: Flutter `Text` 위젯과 동일하게 화면에 그리면서, 상응하는 HTML 태그(`h1`, `h2`, `p`, `span` 등)를 생성해 브라우저 DOM 트리에 주입합니다.
- **사용 예시**: 
  ```dart
  SeoText('제목입니다', tag: 'h1', style: ...)
  ```

### SeoImage (`seo_image.dart`)
- **역할**: `Image.asset` 기능을 수행함과 동시에, 크롤러가 읽을 수 있는 `<img>` 태그와 `alt` 속성을 DOM에 주입합니다.
- **특징**: `alignment`, `color`, `fit` 등 기존 이미지 프로퍼티를 지원합니다.

## 4. 메타 태그 중앙 관리

기존에 `HomeView`의 `initState`에서 자바스크립트로 직접 컨트롤하던 방식에서, **`web/index.html` 정적 파일 관리 방식**으로 통일했습니다. 
- 중복 태그 생성을 방지하고 일관된 검색 엔진 정보를 제공합니다.
- 정적인 정보(제목, 설명, 키워드, OG 태그)는 `index.html`에서 관리하고, 본문의 구체적인 내용은 `SeoText`/`SeoImage`가 보완합니다.
