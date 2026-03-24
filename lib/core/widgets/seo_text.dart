import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_web/web.dart' as web;

/// 검색 엔진 크롤러(SEO)가 웹 DOM 트리에서 직접 읽을 수 있도록,
/// 플러터 캔버스 위젯 위에 보이지 않는 실제 HTML 텍스트 태그를 주입하는 위젯입니다.
class SeoText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final String tag;

  const SeoText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.tag = 'p',
  });

  @override
  State<SeoText> createState() => _SeoTextState();
}

class _SeoTextState extends State<SeoText> {
  web.Element? _element;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      // 지정된 HTML 태그(h1, h2, p 등)를 생성하여 숨긴 채로 body에 부착
      _element = web.document.createElement(widget.tag);
      _element!.textContent = widget.text;
      _element!.setAttribute('style', 'display: none;');
      web.document.body?.append(_element!);
    }
  }

  @override
  void didUpdateWidget(covariant SeoText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (kIsWeb && oldWidget.text != widget.text) {
      _element?.textContent = widget.text;
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
    return Text(
      widget.text,
      style: widget.style,
      textAlign: widget.textAlign,
    );
  }
}
