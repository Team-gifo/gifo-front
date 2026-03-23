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

## 3. 동적 SEO 태그 적용 로직 (`lib/features/home/presentation/views/home_view.dart`)

`universal_web/web.dart` 등을 통해서 `HomeView`의 `initState` 상에서 자바스크립트 DOM을 컨트롤하여 SEO 태그들을 다시 상태에 맞게 업데이트하는 코드가 들어가 있습니다. 
최신 구글 크롤러는 자바스크립트를 해석하여 렌더링된 메타 태그를 읽을 수 있으므로, 웹 환경 런타임에서도 태그를 갱신/지속하게 됩니다.
