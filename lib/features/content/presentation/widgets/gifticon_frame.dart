import 'package:flutter/material.dart';
import 'package:barcode/barcode.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';

/// 당첨된 기록을 기반으로 기프티콘 프레임을 생성하는 위젯
/// 
/// 캡쳐용으로 사용되며, 고정된 규격(약 400x750)으로 디자인되었습니다.
class GifticonFrame extends StatelessWidget {
  final String itemName;
  final String imageUrl;
  final String recipientName;
  final String issueDate;
  final String inviteCode;
  final String qrUrl;

  const GifticonFrame({
    super.key,
    required this.itemName,
    required this.imageUrl,
    required this.recipientName,
    required this.issueDate,
    required this.inviteCode,
    required this.qrUrl,
  });

  @override
  Widget build(BuildContext context) {
    // 기프티콘 표준 규격 (이미지 캡쳐용)
    const double canvasWidth = 400.0;
    const double canvasHeight = 750.0;

    return Container(
      width: canvasWidth,
      height: canvasHeight,
      // 배경은 짙은 그리드 느낌을 주기 위해 약간의 처리
      decoration: const BoxDecoration(
        color: AppColors.darkBg,
      ),
      child: Stack(
        children: <Widget>[
          // 1. 네온 테두리 디자인 (전체 캔버스 기준)
          Positioned(
            left: 20,
            top: 20,
            right: 20,
            bottom: 60, // 하단 여백
            child: CustomPaint(
              painter: _GifticonBorderPainter(color: AppColors.neonPurple),
            ),
          ),
          
          // 2. 내부 콘텐츠 배치
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 60),
                // 중앙 상품 이미지 영역 (흰색 배경 박스)
                Container(
                  width: 240,
                  height: 240,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 20,
                      )
                    ],
                  ),
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 50),
                
                // 정보 영역 리스트
                _buildInfoRow(
                  leftWidget: Text(
                    itemName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: 'WantedSans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  rightWidget: Image.asset(
                    'assets/images/title_logo.png',
                    height: 32,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 48),
                
                _buildInfoRow(
                  label: '받는이',
                  value: recipientName,
                  valueStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'WantedSans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 32),
                
                _buildInfoRow(
                  label: '발급기한',
                  value: issueDate,
                  valueStyle: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 15,
                    fontFamily: 'WantedSans',
                  ),
                ),
                const SizedBox(height: 32),
                
                _buildInfoRow(
                  label: '유효코드',
                  value: inviteCode,
                  valueStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'WantedSans',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                
                const Spacer(),
                
                // 하단 QR 코드 (테두리 하단 중앙에 위치하도록 배치)
                _buildQRCode(qrUrl),
                const SizedBox(height: 35),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 정보 한 행을 구성하는 헬퍼 함수
  Widget _buildInfoRow({
    String? label,
    String? value,
    Widget? leftWidget,
    Widget? rightWidget,
    TextStyle? valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        leftWidget ?? Text(
          label ?? '',
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 18,
            fontFamily: 'WantedSans',
          ),
        ),
        rightWidget ?? Flexible(
          child: Text(
            value ?? '',
            textAlign: TextAlign.end,
            style: valueStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// barcode 패키지를 사용하여 QR 코드를 생성하는 함수
  Widget _buildQRCode(String data) {
    final Barcode qrCode = Barcode.qrCode();
    final String svgString = qrCode.toSvg(
      data,
      width: 90,
      height: 90,
    );

    return Container(
      width: 100,
      height: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.neonPurple.withOpacity(0.4),
            blurRadius: 15,
          ),
        ],
      ),
      child: SvgPicture.string(svgString),
    );
  }
}

/// 기프티콘 외곽의 끊긴 네온 테두리를 그리는 Painter
class _GifticonBorderPainter extends CustomPainter {
  final Color color;

  _GifticonBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final Path path = Path();
    
    // 테두리 라인: 상단 좌측 -> 우측 -> 하단 우측 -> 하단 좌측 (가운데 끊김)
    path.moveTo(size.width * 0.35, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * 0.65, size.height);

    // 네온 글로우 효과
    canvas.drawPath(path, paint);
    
    final Paint glowPaint = Paint()
      ..color = color.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0);
    
    canvas.drawPath(path, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
