import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/blocs/download/download_bloc.dart';
import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/grid_background_painter.dart';
import '../../application/unboxing/unboxing_bloc.dart';
import '../result/result_view.dart';

class UnboxingView extends StatefulWidget {
  final String code;

  const UnboxingView({super.key, required this.code});

  @override
  State<UnboxingView> createState() => _UnboxingViewState();
}

class _UnboxingViewState extends State<UnboxingView> {
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    context.read<UnboxingBloc>().add(InitUnboxing(widget.code));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isDesktop = size.width >= AppBreakpoints.desktop;

    return BlocConsumer<UnboxingBloc, UnboxingState>(
      listener: (BuildContext context, UnboxingState state) {
        // 수령 완료 상태는 builder에서 처리하므로 listener는 비워둔다
      },
      builder: (BuildContext context, UnboxingState state) {
        // URL 유지한 채 결과 화면을 인라인으로 렌더링
        if (state.isReceived && state.unboxingContent != null) {
          return BlocProvider<DownloadBloc>(
            create: (_) => DownloadBloc(),
            child: ResultView(
              itemName: state.unboxingContent!.afterOpen.itemName,
              imageUrl: state.unboxingContent!.afterOpen.imageUrl,
              userName: state.userName,
              inviteCode: widget.code,
            ),
          );
        }

        if (state.unboxingContent == null) {
          return Title(
            title: 'Happy Birthday, ${state.userName} | Gifo',
            color: AppColors.darkBg,
            child: const Scaffold(
              backgroundColor: AppColors.darkBg,
              body: Center(
                child: CircularProgressIndicator(color: AppColors.neonPurple),
              ),
            ),
          );
        }

        return Title(
          title: 'Happy Birthday, ${state.userName} | Gifo',
          color: AppColors.darkBg,
          child: Scaffold(
            backgroundColor: AppColors.darkBg,
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: CustomPaint(painter: GridBackgroundPainter()),
                  ),
                  Positioned.fill(
                    top: size.width < AppBreakpoints.tablet ? 64 : 72,
                    child: _buildBody(context, isDesktop, state, size),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: _buildAppBar(state, size),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(UnboxingState state, Size size) {
    final bool isMobileOrSmall = size.width < AppBreakpoints.tablet;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkBg.withValues(alpha: 0.8),
        border: Border(
          bottom: BorderSide(
            color: AppColors.neonPurple.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.neonPurple.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AppBar(
        toolbarHeight: isMobileOrSmall ? 64.0 : 72.0,
        primary: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: isMobileOrSmall ? 16.0 : 32.0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () async {
                  final Uri homeUri = Uri.base.resolve('/');
                  if (await canLaunchUrl(homeUri)) {
                    await launchUrl(homeUri, webOnlyWindowName: '_blank');
                  } else {
                    if (context.mounted) context.go('/');
                  }
                },
                child: Image.asset(
                  'assets/images/title_logo.png',
                  height: isMobileOrSmall ? 40 : 48,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            if (size.width >= AppBreakpoints.tablet)
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'WantedSans',
                  ),
                  children: <InlineSpan>[
                    TextSpan(
                      text: state.userName,
                      style: const TextStyle(color: AppColors.neonPurple),
                    ),
                    const TextSpan(text: '님의 '),
                    TextSpan(
                      text: state.subTitle.isNotEmpty ? state.subTitle : '',
                      style: const TextStyle(color: AppColors.neonPurple),
                    ),
                    const TextSpan(text: ' 선물상자'),
                  ],
                ),
              )
            else
              Flexible(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'WantedSans',
                    ),
                    children: <InlineSpan>[
                      TextSpan(
                        text: state.userName,
                        style: const TextStyle(color: AppColors.neonPurple),
                      ),
                      const TextSpan(text: '님의 '),
                      TextSpan(
                        text: state.subTitle.isNotEmpty ? state.subTitle : '',
                        style: const TextStyle(color: AppColors.neonPurple),
                      ),
                      const TextSpan(text: ' 선물상자'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    bool isDesktop,
    UnboxingState state,
    Size size,
  ) {
    double imgMaxWidth;
    double imgMaxHeight;
    double imgMinWidth;
    double imgMinHeight;

    if (size.width >= AppBreakpoints.desktop) {
      imgMaxWidth = 600;
      imgMaxHeight = 400;
      imgMinWidth = 300;
      imgMinHeight = 200;
    } else if (size.width >= AppBreakpoints.tablet) {
      imgMaxWidth = 500;
      imgMaxHeight = 350;
      imgMinWidth = 250;
      imgMinHeight = 150;
    } else {
      imgMaxWidth = double.infinity;
      imgMaxHeight = 300;
      imgMinWidth = 200;
      imgMinHeight = 150;
    }

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (isDesktop) const SizedBox(height: 64),
              Container(
                constraints: const BoxConstraints(maxWidth: 700),
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints(
                        minWidth: imgMinWidth,
                        minHeight: imgMinHeight,
                        maxWidth: imgMaxWidth,
                        maxHeight: imgMaxHeight,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: AppColors.neonPurple.withValues(alpha: 0.5),
                          width: 2,
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: AppColors.neonPurpleLight.withValues(
                              alpha: 0.2,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14.0),
                        child: Image.asset(
                          state.unboxingContent!.beforeOpen.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      state.unboxingContent!.beforeOpen.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'WantedSans',
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              _buildReceiveButton(isDesktop: isDesktop),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiveButton({required bool isDesktop}) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _isHovering ? -5 : 0, 0),
        width: isDesktop ? 400 : double.infinity,
        constraints: const BoxConstraints(maxWidth: 400),
        height: 60,
        child: ElevatedButton(
          onPressed: () =>
              context.read<UnboxingBloc>().add(const ReceiveGift()),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.neonBlue,
            foregroundColor: Colors.black,
            elevation: _isHovering ? 8 : 4,
            shadowColor: AppColors.neonBlue.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: const BorderSide(
                color: Colors.white,
                width: 2,
              ), // 네온 스타일 보더
            ),
          ),
          child: const Text(
            '🎁 선물 받기',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'WantedSans',
            ),
          ),
        ),
      ),
    );
  }
}
