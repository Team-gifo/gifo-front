import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/constants/app_colors.dart';

class BeforeOpenCard extends StatelessWidget {
  const BeforeOpenCard({
    super.key,
    required this.isMobile,
    required this.imageFile,
    required this.descController,
    required this.onPickImage,
  });

  final bool isMobile;
  final XFile? imageFile;
  final TextEditingController descController;
  final VoidCallback onPickImage;

  @override
  Widget build(BuildContext context) {
    const Color accent = AppColors.neonPurple;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            '개봉 전',
            style: TextStyle(
              fontFamily: 'WantedSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          // 이미지 영역 — 액센트 색상 적용
          Stack(
            children: <Widget>[
              InkWell(
                onTap: onPickImage,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: isMobile ? 200 : 280,
                  height: isMobile ? 200 : 280,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: accent.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: accent.withValues(alpha: 0.1),
                        blurRadius: 16,
                        spreadRadius: 1,
                      ),
                    ],
                    image: imageFile != null
                        ? DecorationImage(
                            image: NetworkImage(imageFile!.path),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: imageFile == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.card_giftcard,
                              size: 56,
                              color: accent.withValues(alpha: 0.4),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '개봉 전 이미지\n(선택)',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'WantedSans',
                                color: Colors.white.withValues(alpha: 0.6),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        )
                      : null,
                ),
              ),
              if (imageFile != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _showFullImage(context, imageFile!),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.open_in_full,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '설명란 문구',
              style: TextStyle(
                fontFamily: 'WantedSans',
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: descController,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'WantedSans',
            ),
            cursorColor: accent,
            decoration: InputDecoration(
              hintText: '상자 하단에 보여질 설명을 입력해주세요.',
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.06),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: accent.withValues(alpha: 0.6)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showFullImage(BuildContext context, XFile imageFile) {
  showDialog<void>(
    context: context,
    builder: (BuildContext ctx) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Stack(
        children: <Widget>[
          InteractiveViewer(
            child: Image.network(imageFile.path, fit: BoxFit.contain),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () => Navigator.of(ctx).pop(),
              icon: const Icon(Icons.close, color: Colors.white),
              style: IconButton.styleFrom(backgroundColor: Colors.black54),
            ),
          ),
        ],
      ),
    ),
  );
}
