import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../application/gift_packaging_bloc.dart';
import '../../model/curate_models.dart';
import '../../model/gift_content.dart';
import '../../repository/curate_api.dart';

class AiTemplateSurveyView extends StatefulWidget {
  const AiTemplateSurveyView({super.key});

  @override
  State<AiTemplateSurveyView> createState() => _AiTemplateSurveyViewState();
}

class _AiTemplateSurveyViewState extends State<AiTemplateSurveyView> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _relationshipOptions = <String>['연인', '친구', '가족', '동료'];
  final List<String> _situationOptions = <String>[
    '생일',
    '축하',
    '위로',
    '응원',
    '사과',
  ];
  final List<String> _toneOptions = <String>['장난', '감동', '담백'];

  String? _selectedRelationship;
  String? _selectedSituation;
  String? _selectedTone;
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _generateGalleryImages = false;

  bool _isLoading = false;
  final Random _random = Random();
  final List<String> _loadingMessagesWithImage = <String>[
    '추억을 만들고 있어요...',
    '예쁜 추억 이미지를 그리고 있어요...',
    '선물 페이지를 예쁘게 꾸미는 중이에요...',
    '잠시만요, 거의 다 됐어요...',
  ];
  final List<String> _loadingMessagesTextOnly = <String>[
    '추억을 만들고 있어요...',
    '두근두근 추천을 고르고 있어요...',
    '선물 페이지를 예쁘게 꾸미는 중이에요...',
    '잠시만요, 거의 다 됐어요...',
  ];
  static const String _longWaitMessageWithImage =
      '조금만 더 기다려주세요. 예쁜 이미지와 큐레이션을 만들고 있어요...';
  static const String _longWaitMessageTextOnly =
      '조금만 더 기다려주세요. 큐레이션을 정성껏 만들고 있어요...';
  String _loadingMessage = '큐레이션을 생성하는 중이에요...';
  Timer? _loadingMessageTimer;
  DateTime? _loadingStartedAt;

  @override
  void dispose() {
    _loadingMessageTimer?.cancel();
    _ageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'AI 추천 - Gifo',
      color: Colors.black,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          toolbarHeight: 68,
          backgroundColor: const Color(0xFFF8F9FA),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 8),
                  const Text(
                    'AI 추천을\n사용해볼까요?',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '몇 가지 정보를 알려주시면,\nAI가 선물 페이지 구성을 도와드려요.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 28),
                  DropdownButtonFormField<String>(
                    value: _selectedRelationship,
                    decoration: const InputDecoration(
                      labelText: '대상과의 관계',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: _relationshipOptions
                        .map(
                          (value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRelationship = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '관계를 선택해주세요.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedSituation,
                    decoration: const InputDecoration(
                      labelText: '상황',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: _situationOptions
                        .map(
                          (value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSituation = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '상황을 선택해주세요.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedTone,
                    decoration: const InputDecoration(
                      labelText: '톤',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: _toneOptions
                        .map(
                          (value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTone = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '톤을 선택해주세요.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(
                      labelText: '대상 연령대 (예: 60대)',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '연령대를 입력해주세요.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: '대상을 부를 이름 (선택)',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _generateGalleryImages,
                    onChanged: (bool? value) {
                      setState(() {
                        _generateGalleryImages = value ?? false;
                      });
                    },
                    title: const Text(
                      '추억 이미지도 생성하기',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8, bottom: 4),
                    child: Text(
                      '이미지 생성은 시간이 오래 걸릴 수 있어요.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (_isLoading)
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2.4),
                          ),
                          const SizedBox(width: 12),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              _loadingMessage,
                              key: ValueKey<String>(_loadingMessage),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: _onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'AI 추천 받기',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final CurateSurveyRequest request = CurateSurveyRequest(
      relationship: _selectedRelationship!,
      situation: _selectedSituation!,
      tone: _selectedTone!,
      targetAge: _ageController.text.trim(),
      targetName:
          _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
    );

    setState(() {
      _isLoading = true;
      _loadingMessage = (_generateGalleryImages
              ? _loadingMessagesWithImage
              : _loadingMessagesTextOnly)
          .first;
    });
    _loadingStartedAt = DateTime.now();
    _startRandomLoadingMessages();

    try {
      final GiftPackagingBloc bloc = context.read<GiftPackagingBloc>();
      bloc.add(ResetPackaging());

      final Dio dio = Dio(
        BaseOptions(
          baseUrl: dotenv.env['url'] ?? '',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(minutes: 5),
        ),
      );
      final CurateApi api = CurateApi(dio);
      final Map<String, dynamic> payload = request.toJson();
      payload['generateGalleryImages'] = _generateGalleryImages;
      final res = await api.createCurate(payload);
      final Map<String, dynamic> body =
          (res.data as Map).cast<String, dynamic>();

      final CurateApiEnvelope envelope = CurateApiEnvelope.fromJson(body);
      final CurateResponseData data = envelope.data;

      bloc.add(SetReceiverName(data.user));
      bloc.add(SetSubTitle(data.subTitle));
      bloc.add(SetBgm(data.bgm));
      bloc.add(SetGalleryItems(data.gallery));

      final GiftContent content = data.content;
      if (content.quiz != null) {
        bloc.add(SetContentType(ContentType.quiz));
        bloc.add(SetQuizContent(content.quiz!));
      } else if (content.gacha != null) {
        bloc.add(SetContentType(ContentType.gacha));
        bloc.add(SetGachaContent(content.gacha!));
      } else if (content.unboxing != null) {
        bloc.add(SetContentType(ContentType.unboxing));
        bloc.add(SetUnboxingContent(content.unboxing!));
      }

      if (!mounted) return;
      context.push('/addgift/final-review?fromAi=true');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('AI 추천 생성에 실패했어요. 잠시 후 다시 시도해주세요.')),
      );
    } finally {
      _loadingMessageTimer?.cancel();
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _startRandomLoadingMessages() {
    _loadingMessageTimer?.cancel();
    _loadingMessageTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_isLoading) return;
      setState(() {
        final DateTime? startedAt = _loadingStartedAt;
        final List<String> loadingMessages = _generateGalleryImages
            ? _loadingMessagesWithImage
            : _loadingMessagesTextOnly;
        if (startedAt != null &&
            DateTime.now().difference(startedAt) >=
                const Duration(seconds: 25)) {
          _loadingMessage = _generateGalleryImages
              ? _longWaitMessageWithImage
              : _longWaitMessageTextOnly;
          return;
        }
        final String current = _loadingMessage;
        String next = loadingMessages[_random.nextInt(loadingMessages.length)];
        if (loadingMessages.length > 1) {
          while (next == current) {
            next = loadingMessages[_random.nextInt(loadingMessages.length)];
          }
        }
        _loadingMessage = next;
      });
    });
  }
}

