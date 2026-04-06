import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/grid_background_painter.dart';

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
      decoration: const BoxDecoration(color: AppColors.darkBg),
      child: Stack(
        children: <Widget>[
          // 0. 그리드 배경 적용
          Positioned.fill(
            child: CustomPaint(
              painter: GridBackgroundPainter(),
            ),
          ),
          // 1. 네온 테두리 디자인 (전체 캔버스 기준)
          Positioned(
            left: 20,
            top: 40,
            right: 20,
            bottom: 40, // 상단(40)과 하단(40)의 여백을 동일하게 맞춤
            child: CustomPaint(
              painter: _GifticonBorderPainter(color: AppColors.neonPurple),
            ),
          ),

          // 2. 내부 콘텐츠 배치 (프레임 내부에 정렬)
          Positioned.fill(
            top: 40,
            bottom: 60, // 하단 QR 공간 확보를 위해 여백 증대
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 60), // 상단 여백 확대 (50->60)
                  // 중앙 상품 이미지 영역
                  Container(
                    width: 250,
                    height: 250,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.white.withOpacity(0.05),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Skeletonizer(
                          enabled: true,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.white10,
                          ),
                        );
                      },
                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                        return const Center(
                          child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 60), // 이미지와 이름 사이 간격 확대 (50->60)
                  // 정보 영역 리스트 (간격 및 가독성 조정)
                  _buildInfoRow(
                    leftWidget: Text(
                      itemName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'WantedSans',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    rightWidget: _buildQRCode(
                      qrUrl,
                      size: 60,
                    ), // QR 코드를 이름 우측으로 이동 (사이즈 축소)
                  ),
                  const SizedBox(height: 60), // 경품 이름과 아래 정보 간격 확대

                  _buildInfoRow(
                    label: '받는이',
                    value: recipientName,
                    valueStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontFamily: 'WantedSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 28),

                  _buildInfoRow(
                    label: '당첨일시',
                    value: issueDate,
                    valueStyle: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                      fontFamily: 'WantedSans',
                    ),
                  ),
                  const SizedBox(height: 28),

                  _buildInfoRow(
                    label: '유효코드',
                    value: inviteCode,
                    valueStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontFamily: 'WantedSans',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. 하단 브랜드 로고 (프레임 하단 경계선 중앙에 배치)
          Positioned(
            left: 0,
            right: 0,
            bottom: 15, // 50px 높이 로고의 중앙(25px)이 하단 선(40px)에 일치하도록 조정 (15 + 25 = 40)
            child: Center(
              child: Image.asset(
                'assets/images/title_logo.png',
                height: 50,
                color: Colors.white.withOpacity(0.9),
              ),
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
        leftWidget ??
            Text(
              label ?? '',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 18,
                fontFamily: 'WantedSans',
              ),
            ),
        rightWidget ??
            Flexible(
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
  Widget _buildQRCode(String data, {double size = 80}) {
    final Barcode qrCode = Barcode.qrCode();
    final double svgSize = size * 0.9;
    final String svgString = qrCode.toSvg(
      data,
      width: svgSize,
      height: svgSize,
      color: 0xFFFFFFFF, // QR 코드를 화이트 색상으로 변경
    );

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.transparent, // 배경 제거
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
