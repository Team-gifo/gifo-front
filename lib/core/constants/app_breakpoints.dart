// ==========================================
// 반응형 레이아웃 breakpoint 상수
//
// 사용법:
//   final bool isMobile = screenWidth < AppBreakpoints.mobile;
//   final bool isTablet = screenWidth >= AppBreakpoints.mobile
//                      && screenWidth < AppBreakpoints.tablet;
//   final bool isDesktop = screenWidth >= AppBreakpoints.tablet;
// ==========================================
abstract final class AppBreakpoints {
  // 아이폰 15 Pro 기준 (논리 픽셀 약 393px, 여유를 두어 430 사용)
  static const double mobile = 430.0;

  // iPad mini 기준 (768px)
  static const double tablet = 768.0;

  // 데스크톱은 tablet 이상이므로 별도 상수 불필요하지만,
  // 명시적으로 참조하고 싶을 때 사용
  static const double desktop = 1024.0;
}
