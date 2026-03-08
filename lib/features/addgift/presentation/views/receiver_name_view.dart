import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../application/gift_packaging_bloc.dart';

class ReceiverNameView extends StatefulWidget {
  const ReceiverNameView({super.key});

  @override
  State<ReceiverNameView> createState() => _ReceiverNameViewState();
}

class _ReceiverNameViewState extends State<ReceiverNameView> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // BLoC 상태 초기화 (새로운 선물 포장 시작)
    context.read<GiftPackagingBloc>().add(ResetPackaging());
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[_buildStepIndicator()],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 24),
              const Text(
                '선물 받는 분의\n닉네임을 알려주세요',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: '닉네임 입력',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _nameController,
                builder: (context, value, child) {
                  final bool isNameEmpty = value.text.trim().isEmpty;

                  return ElevatedButton(
                    onPressed: isNameEmpty
                        ? null
                        : () {
                            final String name = value.text.trim();
                            // BLoC에 수신자 이름 저장
                            context.read<GiftPackagingBloc>().add(
                              SetReceiverName(name),
                            );
                            context.push('/addgift/memory-decision');
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      disabledForegroundColor: Colors.grey.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      '다음',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildCircle(isActive: true, number: '1'),
          _buildLine(),
          _buildCircle(isActive: false, number: '2'),
          _buildLine(),
          _buildCircle(isActive: false, number: '3'),
        ],
      ),
    );
  }

  Widget _buildCircle({required bool isActive, required String number}) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.black : Colors.grey.shade200,
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey.shade500,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLine() {
    return Container(width: 16, height: 2, color: Colors.grey.shade200);
  }
}
