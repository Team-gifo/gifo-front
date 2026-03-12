import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../../../lobby/model/lobby_data.dart';
import '../../application/quiz/quiz_bloc.dart';

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
      listener: (context, state) {
        if (state.isFinished && state.quizContent != null) {
          final reward = state.isSuccess
              ? state.quizContent!.successReward
              : state.quizContent!.failReward;

          context.go(
            '/content/result',
            extra: <String, String>{
              'itemName': reward.itemName,
              'imageUrl': reward.imageUrl,
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
      builder: (context, state) {
        if (state.quizContent == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.currentQuizIndex >= state.quizContent!.list.length) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final QuizItem currentQuiz =
            state.quizContent!.list[state.currentQuizIndex];

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(state, size, isDesktop),
          body: SafeArea(
            child: _buildBody(context, isDesktop, currentQuiz, state),
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
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(QuizState state, Size size, bool isDesktop) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Image.asset('assets/images/title_logo.png', height: 50),
            const SizedBox(width: 16),
            if (size.width > 600)
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <InlineSpan>[
                    TextSpan(
                      text: state.userName,
                      style: const TextStyle(color: Colors.blue),
                    ),
                    const TextSpan(text: '님의 '),
                    const TextSpan(
                      text: '살 떨리는',
                      style: TextStyle(color: Colors.blue),
                    ),
                    const TextSpan(text: ' 문제 맞추기'),
                  ],
                ),
              )
            else
              Expanded(
                child: Text(
                  '${state.userName}님의 문제 맞추기',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (isDesktop) ...<Widget>[
              const Spacer(),
              _buildProgress(state, isMobile: false),
              const SizedBox(width: 16),
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
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Text(
          '힌트 : $hintText',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '남은 기회 : ${state.currentLives}번',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progressValue,
            backgroundColor: Colors.grey.shade300,
            color: Colors.greenAccent,
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
        builder: (context, state) {
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: quiz.options.map<Widget>((String opt) {
              final bool isSelected = state.userAnswer == opt;
              return ChoiceChip(
                label: Text(opt, style: const TextStyle(fontSize: 16)),
                selected: isSelected,
                onSelected: (bool selected) {
                  context.read<QuizBloc>().add(
                    SetUserAnswer(selected ? opt : ''),
                  );
                },
                selectedColor: const Color(0xFFC7DEFF),
                backgroundColor: Colors.grey.shade100,
                labelStyle: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.black : Colors.black87,
                ),
              );
            }).toList(),
          );
        },
      );
    } else if (quiz.type == 'ox') {
      content = BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
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
          onChanged: (String v) =>
              context.read<QuizBloc>().add(SetUserAnswer(v)),
          onSubmitted: (String _) =>
              context.read<QuizBloc>().add(const SubmitAnswer()),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            hintText: '정답을 입력하세요',
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
          child: ElevatedButton(
            onPressed: () {
              context.read<QuizBloc>().add(const SubmitAnswer());
              _textController.clear();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC7DEFF),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              '정답 제출',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOXButton(String value, String currentAnswer) {
    final bool isSelected = currentAnswer == value;
    return InkWell(
      onTap: () => context.read<QuizBloc>().add(SetUserAnswer(value)),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: isSelected
              ? (value == 'O' ? Colors.blue.shade100 : Colors.red.shade100)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? (value == 'O' ? Colors.blue : Colors.red)
                : Colors.grey.shade300,
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          value,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? (value == 'O' ? Colors.blue : Colors.red)
                : Colors.black45,
          ),
        ),
      ),
    );
  }
}
