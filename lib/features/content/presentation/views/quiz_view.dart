import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../../../lobby/data/models/lobby_data.dart';

class QuizView extends StatefulWidget {
  final String code;

  const QuizView({super.key, required this.code});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  late LobbyData lobbyData;
  late QuizContent quizContent;

  int currentQuizIndex = 0;
  int currentLives = 0;
  int correctCount = 0;

  String _userAnswer = '';
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 라우터 로직을 통해 퀴즈 데이터가 보장된 상태라고 가정
    lobbyData = LobbyData.getDummyByCode(widget.code)!;
    quizContent = lobbyData.content!.quiz!;
    currentLives = quizContent.list[currentQuizIndex].playLimit;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // 정답 제출 이벤트 처리 로직
  void _submitAnswer() {
    if (_userAnswer.trim().isEmpty) return;

    final QuizItem currentQuiz = quizContent.list[currentQuizIndex];
    // 대소문자 구분 없이 입력받은 답변이 복수개의 정답 중 하나와 일치하는지 확인합니다.
    final bool isCorrect = currentQuiz.answer.any(
      (String ans) => ans.toLowerCase() == _userAnswer.trim().toLowerCase(),
    );

    if (isCorrect) {
      correctCount++;
      _moveToNextQuiz();
    } else {
      setState(() {
        currentLives--;
      });

      if (currentLives <= 0) {
        // 기회를 모두 소진하면 다음 문제로 넘어가거나 완료 처리
        _moveToNextQuiz();
      } else {
        // 오답 시 토스트 메시지를 중앙 상단에 노출
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
    }
  }

  // 다음 퀴즈 혹은 결과 화면으로 전환
  void _moveToNextQuiz() {
    setState(() {
      _userAnswer = '';
      _textController.clear();
      currentQuizIndex++;

      if (currentQuizIndex < quizContent.list.length) {
        currentLives = quizContent.list[currentQuizIndex].playLimit;
      }
    });

    if (currentQuizIndex >= quizContent.list.length) {
      _finishQuiz();
    }
  }

  // 결과 화면으로 이동
  void _finishQuiz() {
    final int requiredCount = quizContent.successReward.requiredCount ?? 0;

    // 맞춘 횟수가 기준 이상이라면 성공 보상, 아니라면 실패 보상 전달
    if (correctCount >= requiredCount) {
      context.go(
        '/content/result',
        extra: <String, String>{
          'itemName': quizContent.successReward.itemName,
          'imageUrl': quizContent.successReward.imageUrl,
        },
      );
    } else {
      context.go(
        '/content/result',
        extra: <String, String>{
          'itemName': quizContent.failReward.itemName,
          'imageUrl': quizContent.failReward.imageUrl,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentQuizIndex >= quizContent.list.length) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final Size size = MediaQuery.of(context).size;
    final bool isDesktop = size.width > 900;
    final QuizItem currentQuiz = quizContent.list[currentQuizIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              Image.asset('assets/images/title_logo.png', height: 50),
              const SizedBox(width: 16),
              // 모바일 환경에선 제목 텍스트 최소화 처리
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
                        text: lobbyData.user,
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
                    '${lobbyData.user}님의 문제 맞추기',
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
                _buildProgress(isMobile: false),
                const SizedBox(width: 16),
              ],
            ],
          ),
        ),
      ),
      body: SafeArea(child: _buildBody(context, isDesktop, currentQuiz)),
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
  }

  // 퀴즈 뷰 메인 바디 영역
  Widget _buildBody(
    BuildContext context,
    bool isDesktop,
    QuizItem currentQuiz,
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
          '남은 기회 : $currentLives번',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 48),

        // 데스크탑일 경우 하단 영역을 body 내부에서 그려줍니다.
        if (isDesktop) _buildInputArea(currentQuiz, isMobile: false),
      ],
    );

    return Column(
      children: <Widget>[
        if (!isDesktop)
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
            child: _buildProgress(isMobile: true),
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

  // 문제 진행 상태 프로그레스 표기 영역
  Widget _buildProgress({required bool isMobile}) {
    final int total = quizContent.list.length;
    final int solved = currentQuizIndex;
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
            '맞힌 문제: $correctCount  /  남은 문제: $remain',
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

  // 입력 혹은 조작 버튼 및 제출 활성화 영역
  Widget _buildInputArea(QuizItem quiz, {required bool isMobile}) {
    Widget content;

    // 문제 유형 별로 입력 폼을 분기하여 제공합니다.
    if (quiz.type == 'multiple_choice') {
      content = Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: quiz.options.map<Widget>((String opt) {
          final bool isSelected = _userAnswer == opt;
          return ChoiceChip(
            label: Text(opt, style: const TextStyle(fontSize: 16)),
            selected: isSelected,
            onSelected: (bool selected) {
              setState(() => _userAnswer = selected ? opt : '');
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
    } else if (quiz.type == 'ox') {
      content = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildOXButton('O'),
          const SizedBox(width: 24),
          _buildOXButton('X'),
        ],
      );
    } else {
      // 주관식 객체 (subjective 등)
      content = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 400),
        child: TextField(
          controller: _textController,
          onChanged: (String v) => _userAnswer = v,
          onSubmitted: (String _) => _submitAnswer(),
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
            onPressed: () => _submitAnswer(),
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

  // OX 버튼 컴포넌트 분리
  Widget _buildOXButton(String value) {
    final bool isSelected = _userAnswer == value;
    return InkWell(
      onTap: () => setState(() => _userAnswer = value),
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
