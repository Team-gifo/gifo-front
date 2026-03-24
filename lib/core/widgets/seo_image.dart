import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_web/web.dart' as web;

/// 검색 엔진 크롤러(SEO)가 웹 DOM 트리에서 이미지 및 대체 텍스트(alt)를
/// 직접 읽을 수 있도록 플러터 Image 컴포넌트 렌더링 시 보이지 않는 HTML <img src="..."/>를 주입하는 위젯입니다.
class SeoImage extends StatefulWidget {
  final String imagePath;
  final String alt;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final AlignmentGeometry alignment;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const SeoImage({
    super.key,
    required this.imagePath,
    required this.alt,
    this.width,
    this.height,
    this.fit,
    this.color,
    this.alignment = Alignment.center,
    this.errorBuilder,
  });

  @override
  State<SeoImage> createState() => _SeoImageState();
}

class _SeoImageState extends State<SeoImage> {
  web.Element? _element;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _element = web.document.createElement('img');
      _element!.setAttribute('src', widget.imagePath);
      _element!.setAttribute('alt', widget.alt);
      _element!.setAttribute('style', 'display: none;'); // 화면 표시는 원래 플러터가 처리
      web.document.body?.append(_element!);
    }
  }

  @override
  void didUpdateWidget(covariant SeoImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (kIsWeb) {
      if (oldWidget.imagePath != widget.imagePath) {
        _element?.setAttribute('src', widget.imagePath);
      }
      if (oldWidget.alt != widget.alt) {
        _element?.setAttribute('alt', widget.alt);
      }
    }
  }

  @override
  void dispose() {
    if (kIsWeb) {
      _element?.remove();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      widget.imagePath,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      color: widget.color,
      alignment: widget.alignment,
      errorBuilder: widget.errorBuilder,
    );
  }
}
