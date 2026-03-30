import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import '../../../lobby/model/lobby_data.dart';
import '../../application/quiz/quiz_bloc.dart';
import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/widgets/grid_background_painter.dart';
import '../../../../core/constants/app_colors.dart';

class QuizView extends StatefulWidget {
  final String code;

  const QuizView({super.key, required this.code});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<QuizBloc>().add(InitQuiz(widget.code));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isDesktop = size.width > 900;

    return BlocConsumer<QuizBloc, QuizState>(
      // 퀴즈 완료 시 결과 화면으로 이동
      listener: (BuildContext context, QuizState state) {
        if (state.isFinished && state.quizContent != null) {
          final RewardItem reward = state.isSuccess
              ? state.quizContent!.successReward
              : state.quizContent!.failReward;

          context.go(
            '/content/result',
            extra: <String, dynamic>{
              'itemName': reward.itemName,
              'imageUrl': reward.imageUrl,
              'userName': state.userName,
            },
          );
        }

        // 오답 시 토스트 표시 (기회가 남아있을 때만)
        if (state.isLastAnswerCorrect == false && !state.isFinished) {
          toastification.show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.flatColored,
            title: const Text('오답입니다!'),
            description: const Text('다시 한번 화면을 보고 도전해보세요.'),
            alignment: Alignment.topCenter,
            autoCloseDuration: const Duration(seconds: 3),
          );
        }
      },
      builder: (BuildContext context, QuizState state) {
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
                ],
              ),
            ),
            bottomNavigationBar: isDesktop
                ? null
                : SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      child: _buildInputArea(currentQuiz, isMobile: true),
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
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobileOrSmall ? 16.0 : 32.0,
          vertical: isMobileOrSmall ? 12.0 : 14.0,
        ),
        child: Row(
          children: <Widget>[
            Image.asset(
              'assets/images/title_logo.png',
              height: isMobileOrSmall ? 40 : 48,
              color: Colors.white,
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
              Expanded(
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
                        style: const TextStyle(color: AppColors.neonBlue),
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
            if (size.width >= AppBreakpoints.desktop) ...<Widget>[
              const Spacer(),
              _buildProgress(state, isMobile: false),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    bool isDesktop,
    QuizItem currentQuiz,
    QuizState state,
  ) {
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
            fontFamily: 'PFStardust',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Text(
          '힌트 : $hintText',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white70,
            fontWeight: FontWeight.w600,
            fontFamily: 'PFStardust',
          ),
        ),
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
        const SizedBox(height: 48),
        if (isDesktop) _buildInputArea(currentQuiz, isMobile: false),
      ],
    );

    return Column(
      children: <Widget>[
        if (!isDesktop)
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
            child: _buildProgress(state, isMobile: true),
          ),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: content,
              ),
            ),
          ),
        ),
      ],
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
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            '맞힌 문제: ${state.correctCount}  /  남은 문제: $remain',
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
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: quiz.options.map<Widget>((String opt) {
              final bool isSelected = state.userAnswer == opt;
              return ChoiceChip(
                label: Text(
                  opt,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'PFStardust',
                  ),
                ),
                selected: isSelected,
                onSelected: (bool selected) {
                  context.read<QuizBloc>().add(
                    SetUserAnswer(selected ? opt : ''),
                  );
                },
                selectedColor: AppColors.neonPurple,
                backgroundColor: Colors.white12,
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : Colors.white70,
                ),
                side: BorderSide(
                  color: isSelected ? AppColors.pixelPurple : Colors.white24,
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
              _buildOXButton('O', state.userAnswer),
              const SizedBox(width: 24),
              _buildOXButton('X', state.userAnswer),
            ],
          );
        },
      );
    } else {
      content = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 400),
        child: TextField(
          controller: _textController,
          style: const TextStyle(color: Colors.white, fontFamily: 'PFStardust'),
          onChanged: (String v) =>
              context.read<QuizBloc>().add(SetUserAnswer(v)),
          onSubmitted: (String _) =>
              context.read<QuizBloc>().add(const SubmitAnswer()),
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
            hintStyle: const TextStyle(color: Colors.white38),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
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
              final bool canSubmit = state.userAnswer.trim().isNotEmpty;

              return ElevatedButton(
                onPressed: canSubmit
                    ? () {
                        context.read<QuizBloc>().add(const SubmitAnswer());
                        _textController.clear();
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
                child: const Text(
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

  Widget _buildOXButton(String value, String currentAnswer) {
    final bool isSelected = currentAnswer == value;
    final Color activeColor = value == 'O'
        ? AppColors.neonBlue
        : Colors.redAccent;

    return InkWell(
      onTap: () => context.read<QuizBloc>().add(SetUserAnswer(value)),
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
