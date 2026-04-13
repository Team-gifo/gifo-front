import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/blocs/download/download_bloc.dart';
import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/grid_background_painter.dart';
import '../../../lobby/model/lobby_data.dart';
import '../../application/quiz/quiz_bloc.dart';
import '../result/result_view.dart';
import '../widgets/content_audio_toggle.dart';

class QuizView extends StatefulWidget {
  const QuizView({super.key});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  bool _showAnimation = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    // InitQuiz는 라우터에서 BLoC 생성 시 이미 발행되므로 여기서는 불필요
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _triggerAnswerAnimation(bool isCorrect) {
    if (!mounted) return;

    _textController.clear(); // 정답 제출 시 확실히 초기화

    setState(() {
      _showAnimation = true;
      _isCorrect = isCorrect;
    });

    _animationController.forward(from: 0.0).then((_) {
      if (mounted) {
        setState(() {
          _showAnimation = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isDesktop = size.width >= AppBreakpoints.desktop;

    return BlocConsumer<QuizBloc, QuizState>(
      listenWhen: (QuizState previous, QuizState current) =>
          previous.isLastAnswerCorrect != current.isLastAnswerCorrect &&
          current.isLastAnswerCorrect != null,
      listener: (BuildContext context, QuizState state) {
        // 제출 시 (정답/오답) 애니메이션 효과 실행
        if (state.isLastAnswerCorrect != null) {
          _triggerAnswerAnimation(state.isLastAnswerCorrect!);
        }
      },
      builder: (BuildContext context, QuizState state) {
        // 퀴즈 완료 시 URL 유지한 채 결과 화면을 인라인으로 렌더링
        if (state.isFinished && state.quizContent != null) {
          final RewardItem reward = state.isSuccess
              ? state.quizContent!.successReward
              : state.quizContent!.failReward;

          return BlocProvider<DownloadBloc>(
            create: (_) => DownloadBloc(),
            child: ResultView(
              itemName: reward.itemName,
              imageUrl: reward.imageUrl,
              userName: state.userName,
              inviteCode: state.inviteCode,
            ),
          );
        }

        if (state.quizContent == null) {
          return Title(
            title: 'Happy Birthday, ${state.userName} | Gifo',
            color: Colors.black,
            child: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (state.currentQuizIndex >= state.quizContent!.list.length) {
          return Title(
            title: 'Happy Birthday, ${state.userName} | Gifo',
            color: Colors.black,
            child: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final QuizItem currentQuiz =
            state.quizContent!.list[state.currentQuizIndex];

        return Title(
          title: 'Happy Birthday, ${state.userName} | Gifo',
          color: Colors.black,
          child: Scaffold(
            backgroundColor: AppColors.darkBg,
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: CustomPaint(painter: GridBackgroundPainter()),
                  ),
                  // 메인 콘텐츠 영역
                  Positioned.fill(
                    top: size.width < AppBreakpoints.tablet ? 64 : 72,
                    child: _buildBody(context, isDesktop, currentQuiz, state),
                  ),
                  // 상단 Custom AppBar
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: _buildAppBar(state, size),
                  ),
                  if (_showAnimation)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Center(
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: ScaleTransition(
                              scale: _scaleAnimation,
                              child: Text(
                                _isCorrect ? 'O' : 'X',
                                style: TextStyle(
                                  fontSize: 160,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'PFStardust',
                                  color: _isCorrect
                                      ? AppColors.neonBlue
                                      : Colors.redAccent,
                                  shadows: <Shadow>[
                                    Shadow(
                                      color:
                                          (_isCorrect
                                                  ? AppColors.neonBlue
                                                  : Colors.redAccent)
                                              .withValues(alpha: 0.5),
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(QuizState state, Size size) {
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
                    const TextSpan(text: ' 문제 맞추기'),
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
                        text: state.subTitle.isNotEmpty
                            ? state.subTitle
                            : '살 떨리는',
                        style: const TextStyle(color: AppColors.neonPurple),
                      ),
                      const TextSpan(text: ' 문제 맞추기'),
                    ],
                  ),
                ),
              ),
          ],
        ),
        actions: <Widget>[
          const ContentAudioToggle(),
          if (size.width >= AppBreakpoints.desktop)
            Padding(
              padding: const EdgeInsets.only(right: 32.0),
              child: Center(child: _buildProgress(state, isMobile: false)),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Text(
                  '${state.currentQuizIndex + 1} / ${state.quizContent!.list.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'WantedSans',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    bool isDesktop,
    QuizItem currentQuiz,
    QuizState state,
  ) {
    final Size size = MediaQuery.of(context).size;

    // 화면 크기별 이미지 사이즈 동적 할당
    double imgMaxWidth;
    double imgMaxHeight;

    if (size.width >= AppBreakpoints.desktop) {
      imgMaxWidth = 600;
      imgMaxHeight = 350;
    } else if (size.width >= AppBreakpoints.tablet) {
      imgMaxWidth = 500;
      imgMaxHeight = 280;
    } else {
      imgMaxWidth = double.infinity;
      imgMaxHeight = 220;
    }

    final String hintText = currentQuiz.hint.isEmpty
        ? '제공되지 않음'
        : currentQuiz.hint;

    final Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (isDesktop) const SizedBox(height: 64),
        Text(
          'Q. ${currentQuiz.title}',
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'WantedSans',
          ),
          textAlign: TextAlign.center,
        ),
        if (currentQuiz.imageUrl.isNotEmpty) ...<Widget>[
          const SizedBox(height: 32),
          Container(
            constraints: BoxConstraints(
              maxWidth: imgMaxWidth,
              maxHeight: imgMaxHeight,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.neonPurple.withValues(alpha: 0.3),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.neonPurple.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
            child: Image.network(
              currentQuiz.imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Skeletonizer(
                  enabled: true,
                  child: Container(
                    width: imgMaxWidth,
                    height: imgMaxHeight,
                    color: Colors.white10,
                  ),
                );
              },
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return SizedBox(
                  width: imgMaxWidth,
                  height: imgMaxHeight,
                  child: const Center(
                    child: Icon(Icons.broken_image, color: Colors.white24, size: 40),
                  ),
                );
              },
            ),
            ),
          ),
        ],
        if (!(size.width < AppBreakpoints.tablet &&
            currentQuiz.hint.isEmpty)) ...<Widget>[
          const SizedBox(height: 32),
          Text(
            'Hint : $hintText',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              fontFamily: 'WantedSans',
            ),
          ),
        ],
        const SizedBox(height: 16),
        Text(
          '남은 기회 : ${state.currentLives}번',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.neonBlue,
            fontFamily: 'PFStardust',
          ),
        ),
      ],
    );

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  child: content,
                ),
              ),
            ),
          ),
          Container(width: 1, color: Colors.white10, height: double.infinity),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  child: _buildInputArea(currentQuiz, isMobile: false),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 64),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: content,
          ),
          const SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: _buildInputArea(currentQuiz, isMobile: true),
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget _buildProgress(QuizState state, {required bool isMobile}) {
    final int total = state.quizContent!.list.length;
    final int solved = state.currentQuizIndex;
    final int remain = total - solved;
    final double progressValue = total == 0 ? 0.0 : solved / total;

    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      width: isMobile ? double.infinity : 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: isMobile
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            '맞힌 문제 : ${state.correctCount}  /  남은 문제 : $remain',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
              fontFamily: 'PFStardust',
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progressValue,
            backgroundColor: Colors.white10,
            color: AppColors.neonPurple,
            minHeight: 12,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(QuizItem quiz, {required bool isMobile}) {
    Widget content;

    if (quiz.type == 'multiple_choice') {
      content = BlocBuilder<QuizBloc, QuizState>(
        builder: (BuildContext context, QuizState state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: quiz.options.asMap().entries.map<Widget>((
              MapEntry<int, String> entry,
            ) {
              final int index = entry.key;
              final String opt = entry.value;
              final bool isSelected = state.userAnswer == opt;
              final String bullet = isSelected ? 'A.' : '${index + 1}.';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: SizedBox(
                  width: isMobile ? double.infinity : 400,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: state.isSubmitting ? null : () {
                      context.read<QuizBloc>().add(
                        SetUserAnswer(isSelected ? '' : opt),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? AppColors.neonPurple
                          : Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                        color: isSelected ? AppColors.neonPurple : Colors.grey,
                        width: 2,
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        if (isSelected) ...<Widget>[
                          const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          '$bullet $opt',
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontFamily: 'WantedSans',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      );
    } else if (quiz.type == 'ox') {
      content = BlocBuilder<QuizBloc, QuizState>(
        builder: (BuildContext context, QuizState state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildOXButton('O', state.userAnswer, state.isSubmitting),
              const SizedBox(width: 24),
              _buildOXButton('X', state.userAnswer, state.isSubmitting),
            ],
          );
        },
      );
    } else {
      content = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 400),
        child: BlocBuilder<QuizBloc, QuizState>(
          builder: (BuildContext context, QuizState state) {
            return TextField(
              controller: _textController,
              enabled: !state.isSubmitting,
              style: const TextStyle(color: Colors.white, fontFamily: 'WantedSans'),
              onChanged: (String v) =>
                  context.read<QuizBloc>().add(SetUserAnswer(v)),
              onSubmitted: (String _) {
                if (!state.isSubmitting) {
                  context.read<QuizBloc>().add(const SubmitAnswer());
                }
              },
              decoration: InputDecoration(
                filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white24),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white24),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.neonBlue),
            ),
            hintText: '정답을 입력하세요',
            hintStyle: const TextStyle(
              color: Colors.white38,
              fontFamily: 'WantedSans',
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        );
      },
      ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        content,
        const SizedBox(height: 32),
        SizedBox(
          width: isMobile ? double.infinity : 400,
          height: 60,
          child: BlocBuilder<QuizBloc, QuizState>(
            builder: (BuildContext context, QuizState state) {
              final bool canSubmit = state.userAnswer.trim().isNotEmpty && !state.isSubmitting;

              return ElevatedButton(
                onPressed: canSubmit
                    ? () {
                        context.read<QuizBloc>().add(const SubmitAnswer());
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.neonBlue,
                  disabledBackgroundColor: Colors.white12,
                  foregroundColor: Colors.black,
                  disabledForegroundColor: Colors.white38,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: state.isSubmitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: AppColors.neonBlue,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        '정답 제출',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'PFStardust',
                        ),
                      ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOXButton(String value, String currentAnswer, bool isSubmitting) {
    final bool isSelected = currentAnswer == value;
    final Color activeColor = value == 'O'
        ? AppColors.neonBlue
        : Colors.redAccent;

    return InkWell(
      onTap: isSubmitting ? null : () => context.read<QuizBloc>().add(SetUserAnswer(value)),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.2)
              : Colors.white10,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? activeColor : Colors.white24,
            width: 2,
          ),
          boxShadow: isSelected
              ? <BoxShadow>[
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          value,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            fontFamily: 'PFStardust',
            color: isSelected ? activeColor : Colors.white38,
          ),
        ),
      ),
    );
  }
}
