import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../constants/app_colors.dart';

// -------------------------------------------------------
// 선물 오픈 플로우 전반에서 사용하는 이미지 렌더링 위젯
//
// 처리 우선순위:
//   1. imageUrl이 비어 있거나 공백인 경우 → default_box.png 표시
//   2. 네트워크 로딩 중 → Skeletonizer 스켈레톤 표시
//   3. 네트워크 에러 발생 시 → "이미지를 받아오지 못했습니다" 위젯 표시
// -------------------------------------------------------
class GiftImageWidget extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;

  const GiftImageWidget({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
  });

  bool get _isMissingUrl => imageUrl.trim().isEmpty;

  @override
  Widget build(BuildContext context) {
    // 서버에서 URL 필드가 공백으로 온 경우 → 대체 이미지 표시
    if (_isMissingUrl) {
      return _DefaultBoxImage(width: width, height: height, fit: fit);
    }

    return Image.network(
      imageUrl,
      fit: fit,
      width: width,
      height: height,
      loadingBuilder:
          (BuildContext context, Widget child, ImageChunkEvent? progress) {
            if (progress == null) return child;
            return Skeletonizer(
              enabled: true,
              child: Container(
                width: width ?? double.infinity,
                height: height ?? double.infinity,
                color: Colors.white10,
              ),
            );
          },
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
            return _ImageLoadError(width: width, height: height);
          },
    );
  }
}

// -------------------------------------------------------
// imageUrl이 빈 값일 때 렌더링되는 대체 이미지 위젯 (default_box.png)
// -------------------------------------------------------
class _DefaultBoxImage extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;

  const _DefaultBoxImage({this.width, this.height, required this.fit});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/default_box.png',
      width: width,
      height: height,
      fit: fit,
    );
  }
}

// -------------------------------------------------------
// 네트워크 이미지 로딩 실패 시 표시되는 오류 위젯
// -------------------------------------------------------
class _ImageLoadError extends StatelessWidget {
  final double? width;
  final double? height;

  const _ImageLoadError({this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF130E1F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neonPurple.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.image_not_supported_outlined,
            color: Colors.white.withValues(alpha: 0.3),
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            '이미지를 받아오지 못했습니다',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'WantedSans',
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.4),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
