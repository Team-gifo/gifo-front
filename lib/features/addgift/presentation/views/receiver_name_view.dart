import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../application/gift_packaging_bloc.dart';
import '../widgets/addgift_scaffold.dart';
import '../widgets/receiver_name/receiver_name_bottom_button.dart';
import '../widgets/receiver_name/receiver_name_desktop_layout.dart';
import '../widgets/receiver_name/receiver_name_mobile_layout.dart';
import '../widgets/step_indicator.dart';

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
    context.read<GiftPackagingBloc>().add(ResetPackaging());
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isMobile = screenWidth < AppBreakpoints.mobile;
    final bool isDesktop = screenWidth >= AppBreakpoints.desktop;

    return Title(
      title: '선물 포장하기 - Gifo',
      color: AppColors.darkBg,
      child: AddgiftScaffold(
        appBar: AppBar(
          toolbarHeight: 68,
          backgroundColor: AppColors.darkBg,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: const <Widget>[StepIndicator(activeStep: 1)],
        ),
        bottomNavigationBar: ReceiverNameBottomButton(
          nameController: _nameController,
          onNext: _handleNext,
        ),
        body: SafeArea(
          child: isDesktop
              ? ReceiverNameDesktopLayout(nameController: _nameController)
              : ReceiverNameMobileLayout(
                  isMobile: isMobile,
                  nameController: _nameController,
                ),
        ),
      ),
    );
  }

  void _handleNext(String name) {
    context.read<GiftPackagingBloc>().add(SetReceiverName(name));
    context.push('/addgift/memory-decision');
  }
}
