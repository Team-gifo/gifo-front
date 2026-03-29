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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            '개봉 전',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: onPickImage,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: isMobile ? 200 : 280,
              height: isMobile ? 200 : 280,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 2,
                ),
                image: imageFile != null
                    ? DecorationImage(
                        image: NetworkImage(imageFile!.path),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imageFile == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.card_giftcard,
                          size: 64,
                          color: Colors.white38,
                        ),
                        SizedBox(height: 8),
                        Text(
                          '상자 이미지 변경',
                          style: TextStyle(
                            color: Colors.white38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 24),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '설명란 문구',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: descController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: '상자 하단에 보여질 설명을 입력해주세요.',
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: Colors.white12,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.pixelPurple),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
