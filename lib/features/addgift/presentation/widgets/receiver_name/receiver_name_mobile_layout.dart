import 'package:flutter/material.dart';

import 'receiver_name_input_field.dart';

class ReceiverNameMobileLayout extends StatelessWidget {
  const ReceiverNameMobileLayout({
    super.key,
    required this.isMobile,
    required this.nameController,
  });

  final bool isMobile;
  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24.0 : 48.0,
        vertical: 32.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 24),
          Text(
            '선물 받는 분의\n닉네임을 알려주세요',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'PFStardustS',
              fontSize: isMobile ? 24 : 30,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: SizedBox(
              width: isMobile ? double.infinity : 400,
              child: ReceiverNameInputField(controller: nameController),
            ),
          ),
        ],
      ),
    );
  }
}
