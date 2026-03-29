import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../model/quiz_setting_models.dart';

class QuizEditForm extends StatefulWidget {
  final QuizItemData item;
  final ValueChanged<QuizItemData> onSave;
  final bool isDesktop;

  const QuizEditForm({
    super.key,
    required this.item,
    required this.onSave,
    this.isDesktop = false,
  });

  @override
  State<QuizEditForm> createState() => _QuizEditFormState();
}

class _QuizEditFormState extends State<QuizEditForm> {
  late QuizItemData _editingItem;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _hintController = TextEditingController();

  // 객관식 답변들 컨트롤러 목록
  final List<TextEditingController> _optionControllers =
      <TextEditingController>[];
  // 정답을 다루기 위한 컨트롤러들
  final List<TextEditingController> _answerControllers =
      <TextEditingController>[];

  // 객관식 답변 다중 선택 인덱스
  final Set<int> _selectedMultipleChoiceAnswers = <int>{};

  @override
  void initState() {
    super.initState();
    _editingItem = widget.item;

    _titleController.text = _editingItem.title;
    _descController.text = _editingItem.description;
    _hintController.text = _editingItem.hint;

    if (_editingItem.type == QuizType.multipleChoice) {
      if (_editingItem.options.isEmpty) {
        _optionControllers.add(TextEditingController());
        _optionControllers.add(TextEditingController());
      } else {
        for (final String opt in _editingItem.options) {
          _optionControllers.add(TextEditingController(text: opt));
        }
      }
      for (final String ans in _editingItem.answer) {
        final int? idx = int.tryParse(ans);
        if (idx != null) {
          _selectedMultipleChoiceAnswers.add(idx);
        } else {
          // 기존 데이터 호환: 텍스트로 저장된 경우 인덱스를 찾음
          final int foundIdx = _editingItem.options.indexOf(ans);
          if (foundIdx != -1) {
            _selectedMultipleChoiceAnswers.add(foundIdx);
          }
        }
      }
    } else if (_editingItem.type == QuizType.subjective) {
      if (_editingItem.answer.isEmpty) {
        _answerControllers.add(TextEditingController());
      } else {
        for (final String ans in _editingItem.answer) {
          _answerControllers.add(TextEditingController(text: ans));
        }
      }
    } else if (_editingItem.type == QuizType.ox) {
      if (_editingItem.answer.isEmpty) {
        _editingItem.answer = <String>['O'];
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _hintController.dispose();
    for (final TextEditingController c in _optionControllers) {
      c.dispose();
    }
    for (final TextEditingController c in _answerControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    _editingItem.title = _titleController.text.trim();
    _editingItem.description = _descController.text.trim();
    _editingItem.hint = _hintController.text.trim();

    if (_editingItem.type == QuizType.multipleChoice) {
      _editingItem.options = _optionControllers
          .map((TextEditingController c) => c.text.trim())
          .where((String s) => s.isNotEmpty)
          .toList();
      _editingItem.answer = _selectedMultipleChoiceAnswers
          .map((int idx) => idx.toString())
          .toList();
    } else if (_editingItem.type == QuizType.subjective) {
      _editingItem.answer = _answerControllers
          .map((TextEditingController c) => c.text.trim())
          .where((String s) => s.isNotEmpty)
          .toList();
    }

    widget.onSave(_editingItem);
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _editingItem.imageFile = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: widget.isDesktop
          ? null
          : BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.darkBg,
        borderRadius: widget.isDesktop
            ? BorderRadius.zero
            : const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${_editingItem.typeName} 문제 설정',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('제목 (질문)'),
                  TextField(
                    controller: _titleController,
                    decoration: _inputDecoration('질문을 입력하세요'),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('이미지 (선택)'),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                        image: _editingItem.imageFile != null
                            ? DecorationImage(
                                image: NetworkImage(
                                  _editingItem.imageFile!.path,
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _editingItem.imageFile == null
                          ? const Center(
                              child: Icon(
                                Icons.add_photo_alternate,
                                size: 40,
                                color: Colors.white24,
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('설명'),
                  TextField(
                    controller: _descController,
                    decoration: _inputDecoration('문제에 대한 설명을 입력하세요'),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('힌트'),
                  TextField(
                    controller: _hintController,
                    decoration: _inputDecoration('문제에 대한 힌트를 입력하세요'),
                  ),
                  const SizedBox(height: 24),

                  if (_editingItem.type == QuizType.multipleChoice) ...<Widget>[
                    _buildSectionTitle('선택지'),
                    ..._optionControllers.asMap().entries.map((
                      MapEntry<int, TextEditingController> entry,
                    ) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: <Widget>[
                            Text('${entry.key + 1}. '),
                            Expanded(
                              child: TextField(
                                controller: entry.value,
                                decoration: _inputDecoration(
                                  '선택지 ${entry.key + 1}',
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  _optionControllers.removeAt(entry.key);
                                  // 선택된 인덱스들 갱신 로직
                                  if (_selectedMultipleChoiceAnswers.contains(
                                    entry.key,
                                  )) {
                                    _selectedMultipleChoiceAnswers.remove(
                                      entry.key,
                                    );
                                  }
                                  final Set<int> newAnswers = <int>{};
                                  for (final int ans
                                      in _selectedMultipleChoiceAnswers) {
                                    if (ans > entry.key) {
                                      newAnswers.add(ans - 1);
                                    } else {
                                      newAnswers.add(ans);
                                    }
                                  }
                                  _selectedMultipleChoiceAnswers.clear();
                                  _selectedMultipleChoiceAnswers.addAll(
                                    newAnswers,
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _optionControllers.add(TextEditingController());
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('선택지 추가'),
                    ),
                    const SizedBox(height: 16),
                    _buildSectionTitle('정답 선택 (복수 선택 가능)'),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: List<Widget>.generate(
                        _optionControllers.length,
                        (int index) {
                          final bool isSelected =
                              _selectedMultipleChoiceAnswers.contains(index);
                          return ChoiceChip(
                            label: Text('${index + 1}번'),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  _selectedMultipleChoiceAnswers.add(index);
                                } else {
                                  _selectedMultipleChoiceAnswers.remove(index);
                                }
                              });
                            },
                            selectedColor: AppColors.neonPurple,
                            labelStyle: TextStyle(
                              color:
                                  isSelected ? Colors.white : Colors.white38,
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.07),
                          );
                        },
                      ),
                    ),
                  ] else if (_editingItem.type ==
                      QuizType.subjective) ...<Widget>[
                    _buildSectionTitle('정답 목록 (유사 답변 포함)'),
                    ..._answerControllers.asMap().entries.map((
                      MapEntry<int, TextEditingController> entry,
                    ) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: entry.value,
                                decoration: _inputDecoration('정답 형태 입력'),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  _answerControllers.removeAt(entry.key);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _answerControllers.add(TextEditingController());
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('정답 형태 추가'),
                    ),
                  ] else if (_editingItem.type == QuizType.ox) ...<Widget>[
                    _buildSectionTitle('정답'),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  _editingItem.answer.first == 'O'
                                      ? AppColors.neonPurple
                                      : Colors.white.withValues(alpha: 0.07),
                              foregroundColor:
                                  _editingItem.answer.first == 'O'
                                      ? Colors.white
                                      : Colors.white38,
                            ),
                            onPressed: () => setState(() {
                              _editingItem.answer = <String>['O'];
                            }),
                            child: const Text(
                              'O',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  _editingItem.answer.first == 'X'
                                      ? AppColors.neonPurple
                                      : Colors.white.withValues(alpha: 0.07),
                              foregroundColor:
                                  _editingItem.answer.first == 'X'
                                      ? Colors.white
                                      : Colors.white38,
                            ),
                            onPressed: () => setState(() {
                              _editingItem.answer = <String>['X'];
                            }),
                            child: const Text(
                              'X',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neonPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '저장 완료',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.07),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.neonPurple),
      ),
    );
  }
}
