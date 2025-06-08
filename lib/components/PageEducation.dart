import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/pages/EducationScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';

class PageEducationScreen extends StatefulWidget {
  final String title;
  final String content;
  final String appBarTitle;

  final String? brandName;
  final String? highlightedQuestion;
  final String? buttonText;
  final Color backgroundColor;
  final bool showAudioButton;
  final bool showActionButton;
  final VoidCallback? onAudioPressed;
  final VoidCallback? onActionPressed;
  final VoidCallback? onBackPressed;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final TextStyle? questionStyle;
  final EdgeInsets contentPadding;
  final double? titleFontSize;
  final double? contentFontSize;
  final double? questionFontSize;
  final Widget? customHeader;
  final Widget? customFooter;
  final List<Widget>? additionalContent;

  final String language;
  final double speechRate;
  final double pitch;
  final double volume;

  const PageEducationScreen({
    Key? key,
    required this.title,
    required this.content,
    required this.appBarTitle,
    this.brandName,
    this.highlightedQuestion,
    this.buttonText,
    this.backgroundColor = AppColors.mainWhite,
    this.showAudioButton = true,
    this.showActionButton = true,
    this.onAudioPressed,
    this.onActionPressed,
    this.onBackPressed,
    this.titleStyle,
    this.contentStyle,
    this.questionStyle,
    this.contentPadding = const EdgeInsets.all(24.0),
    this.titleFontSize,
    this.contentFontSize,
    this.questionFontSize,
    this.customHeader,
    this.customFooter,
    this.additionalContent,
    this.language = "pt-BR",
    this.speechRate = 0.5,
    this.pitch = 1.0,
    this.volume = 0.8,
  }) : super(key: key);

  @override
  State<PageEducationScreen> createState() => _PageEducationScreenState();
}

class _PageEducationScreenState extends State<PageEducationScreen>
    with TickerProviderStateMixin {
  late FlutterTts flutterTts;
  bool isSpeaking = false;
  bool isPaused = false;
  bool isInitialized = false;

  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  late AnimationController _progressController;
  String currentText = '';
  int currentWordIndex = 0;
  List<String> words = [];
  String? currentSpeechType; // 'full', 'content', 'question'
  
  // Timer para simular progresso quando não há callback de progresso real
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(vsync: this);
    _initializeTts();
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    flutterTts.stop();
    _progressController.dispose();
    super.dispose();
  }

  Future<void> _initializeTts() async {
    try {
      flutterTts = FlutterTts();

      // Configurações básicas primeiro
      await flutterTts.setLanguage(widget.language);
      await flutterTts.setSpeechRate(widget.speechRate);
      await flutterTts.setPitch(widget.pitch);
      await flutterTts.setVolume(widget.volume);
      await flutterTts.awaitSpeakCompletion(true);

      // Configurações dos handlers com verificação de mounted
      flutterTts.setStartHandler(() {
        if (mounted) {
          setState(() {
            isSpeaking = true;
            isPaused = false;
          });
          _startProgressTimer();
        }
      });

      flutterTts.setCompletionHandler(() {
        if (mounted) {
          setState(() {
            isSpeaking = false;
            isPaused = false;
            currentPosition = Duration.zero;
            currentWordIndex = 0;
            currentSpeechType = null;
          });
          _stopProgressTimer();
          _progressController.reset();
        }
      });

      flutterTts.setErrorHandler((msg) {
        if (mounted) {
          setState(() {
            isSpeaking = false;
            isPaused = false;
            currentSpeechType = null;
          });
          _stopProgressTimer();
          _progressController.reset();
          _showErrorMessage('Erro no áudio: $msg');
        }
      });

      flutterTts.setProgressHandler((String text, int start, int end, String word) {
        if (mounted && words.isNotEmpty) {
          final newIndex = _findWordIndex(word);
          if (newIndex != currentWordIndex) {
            setState(() {
              currentWordIndex = newIndex;
            });
          }
        }
      });

      if (mounted) {
        setState(() {
          isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isInitialized = false;
        });
        _showErrorMessage('Erro ao inicializar áudio: ${e.toString()}');
      }
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  int _findWordIndex(String word) {
    if (words.isEmpty || word.isEmpty) return currentWordIndex;
    
    final cleanWord = word.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '').trim();
    if (cleanWord.isEmpty) return currentWordIndex;
    
    // Procura a partir do índice atual
    for (int i = currentWordIndex; i < words.length; i++) {
      final cleanCurrentWord = words[i].toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '').trim();
      if (cleanCurrentWord.isNotEmpty && 
          (cleanCurrentWord == cleanWord || 
           cleanCurrentWord.contains(cleanWord) || 
           cleanWord.contains(cleanCurrentWord))) {
        return i;
      }
    }
    
    // Se não encontrou, procura do início
    for (int i = 0; i < currentWordIndex; i++) {
      final cleanCurrentWord = words[i].toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '').trim();
      if (cleanCurrentWord.isNotEmpty && 
          (cleanCurrentWord == cleanWord || 
           cleanCurrentWord.contains(cleanWord) || 
           cleanWord.contains(cleanCurrentWord))) {
        return i;
      }
    }
    
    return currentWordIndex;
  }

  Duration _calculateEstimatedDuration(String text) {
    if (text.trim().isEmpty) return Duration.zero;
    
    final wordsPerMinute = 150 * widget.speechRate;
    final wordCount = text.trim().split(RegExp(r'\s+')).length;
    final minutes = wordCount / wordsPerMinute;
    return Duration(milliseconds: (minutes * 60 * 1000).round());
  }

  void _startProgressTimer() {
    _stopProgressTimer();
    
    if (totalDuration.inMilliseconds > 0 && words.isNotEmpty) {
      final intervalMs = (totalDuration.inMilliseconds / words.length).round();
      
      _progressTimer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
        if (!mounted || !isSpeaking || isPaused) {
          timer.cancel();
          return;
        }
        
        setState(() {
          if (currentWordIndex < words.length - 1) {
            currentWordIndex++;
          } else {
            timer.cancel();
          }
        });
      });
    }
  }

  void _stopProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = null;
  }

  Future<void> _speakText() async {
    if (!isInitialized) {
      _showErrorMessage('Sistema de áudio não inicializado');
      return;
    }

    try {
      if (isSpeaking && !isPaused) {
        await _pauseSpeech();
      } else if (isPaused) {
        await _resumeSpeech();
      } else {
        await _startSpeech();
      }
    } catch (e) {
      _handleTtsError('Erro ao reproduzir áudio: ${e.toString()}');
    }
  }

  Future<void> _startSpeech() async {
    String textToSpeak = widget.title;

    if (widget.highlightedQuestion != null && widget.highlightedQuestion!.isNotEmpty) {
      textToSpeak += ". ${widget.highlightedQuestion}";
    }

    textToSpeak += ". ${widget.content}";

    setState(() {
      currentText = textToSpeak;
      words = textToSpeak.trim().split(RegExp(r'\s+'));
      totalDuration = _calculateEstimatedDuration(textToSpeak);
      currentPosition = Duration.zero;
      currentWordIndex = 0;
      currentSpeechType = 'full';
    });

    await flutterTts.speak(textToSpeak);
  }

  Future<void> _pauseSpeech() async {
    try {
      await flutterTts.pause();
      if (mounted) {
        setState(() {
          isPaused = true;
          isSpeaking = false;
        });
        _stopProgressTimer();
      }
    } catch (e) {
      // Flutter TTS não suporta pause em algumas plataformas
      await _stopSpeech();
    }
  }

  Future<void> _resumeSpeech() async {
    if (!mounted || words.isEmpty) return;

    try {
      setState(() {
        isPaused = false;
        isSpeaking = true;
      });

      // Retoma da palavra atual
      String remainingText;
      if (currentSpeechType == 'content') {
        final contentWords = widget.content.trim().split(RegExp(r'\s+'));
        if (currentWordIndex < contentWords.length) {
          remainingText = contentWords.skip(currentWordIndex).join(' ');
        } else {
          remainingText = widget.content;
        }
      } else {
        if (currentWordIndex < words.length) {
          remainingText = words.skip(currentWordIndex).join(' ');
        } else {
          remainingText = currentText;
        }
      }

      if (remainingText.trim().isNotEmpty) {
        await flutterTts.speak(remainingText);
      }
    } catch (e) {
      _handleTtsError('Erro ao retomar áudio: ${e.toString()}');
    }
  }

  Future<void> _stopSpeech() async {
    try {
      await flutterTts.stop();
      if (mounted) {
        setState(() {
          isSpeaking = false;
          isPaused = false;
          currentPosition = Duration.zero;
          currentWordIndex = 0;
          currentSpeechType = null;
        });
        _stopProgressTimer();
        _progressController.reset();
      }
    } catch (e) {
      _handleTtsError('Erro ao parar áudio: ${e.toString()}');
    }
  }

  void _handleTtsError(String message) {
    if (mounted) {
      setState(() {
        isSpeaking = false;
        isPaused = false;
        currentSpeechType = null;
      });
      _stopProgressTimer();
      _showErrorMessage(message);
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget _buildAudioPlayer() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Barra de progresso
          Row(
            children: [
              Text(
                _formatDuration(Duration(
                    milliseconds: words.isNotEmpty 
                        ? (totalDuration.inMilliseconds * (currentWordIndex / words.length)).round()
                        : 0)),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: LinearProgressIndicator(
                    value: words.isNotEmpty ? (currentWordIndex / words.length).clamp(0.0, 1.0) : 0,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.main),
                    minHeight: 4,
                  ),
                ),
              ),
              Text(
                _formatDuration(totalDuration),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Controles de áudio
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Botão Stop
              IconButton(
                onPressed: (isSpeaking || isPaused) ? _stopSpeech : null,
                icon: Icon(
                  Icons.stop,
                  color: (isSpeaking || isPaused) ? Colors.red : Colors.grey,
                  size: 28,
                ),
              ),
              
              // Botão Play/Pause principal
              Container(
                decoration: BoxDecoration(
                  color: isInitialized ? AppColors.main : Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: isInitialized ? _speakText : null,
                  icon: Icon(
                    isPaused
                        ? Icons.play_arrow
                        : isSpeaking
                            ? Icons.pause
                            : Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
              
              // Indicador de velocidade
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${widget.speechRate}x',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
          
          // Status do player
          if (isSpeaking || isPaused)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isPaused ? Icons.pause_circle : Icons.play_circle_filled,
                    size: 16,
                    color: isPaused ? Colors.orange : AppColors.main,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isPaused ? 'Pausado' : 'Reproduzindo...',
                    style: TextStyle(
                      fontSize: 12,
                      color: isPaused ? Colors.orange : AppColors.main,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _speakOnlyContent() async {
    if (!isInitialized) {
      _showErrorMessage('Sistema de áudio não inicializado');
      return;
    }
    
    try {
      await flutterTts.stop();
      
      if (mounted) {
        setState(() {
          currentWordIndex = 0;
          words = widget.content.trim().split(RegExp(r'\s+'));
          totalDuration = _calculateEstimatedDuration(widget.content);
          currentSpeechType = 'content';
          currentText = widget.content;
        });
      }
      
      await flutterTts.speak(widget.content);
    } catch (e) {
      _handleTtsError('Erro ao reproduzir conteúdo: ${e.toString()}');
    }
  }

  Future<void> _speakOnlyQuestion() async {
    if (widget.highlightedQuestion == null || 
        widget.highlightedQuestion!.isEmpty || 
        !isInitialized) {
      return;
    }
      
    try {
      await flutterTts.stop();
      
      if (mounted) {
        setState(() {
          currentSpeechType = 'question';
          words = widget.highlightedQuestion!.trim().split(RegExp(r'\s+'));
          totalDuration = _calculateEstimatedDuration(widget.highlightedQuestion!);
          currentWordIndex = 0;
          currentText = widget.highlightedQuestion!;
        });
      }
      
      await flutterTts.speak(widget.highlightedQuestion!);
    } catch (e) {
      _handleTtsError('Erro ao reproduzir pergunta: ${e.toString()}');
    }
  }

  Widget _buildHighlightedText() {
    if (!isSpeaking && !isPaused) {
      return Text(
        widget.content,
        style: widget.contentStyle ??
            TextStyle(
              fontSize: widget.contentFontSize ?? 16,
              height: 1.6,
              color: AppColors.invertMode,
            ),
      );
    }

    // Só destaca palavras se estiver reproduzindo o conteúdo
    if (currentSpeechType != 'content') {
      return Text(
        widget.content,
        style: widget.contentStyle ??
            TextStyle(
              fontSize: widget.contentFontSize ?? 16,
              height: 1.6,
              color: AppColors.invertMode,
            ),
      );
    }

    final contentWords = widget.content.trim().split(RegExp(r'\s+'));
    
    return RichText(
      text: TextSpan(
        children: contentWords.asMap().entries.map((entry) {
          final index = entry.key;
          final word = entry.value;
          final isCurrentWord = index == currentWordIndex && isSpeaking;

          return TextSpan(
            text: "$word ",
            style: TextStyle(
              fontSize: widget.contentFontSize ?? 16,
              height: 1.6,
              color: isCurrentWord ? AppColors.main : AppColors.invertMode,
              backgroundColor: isCurrentWord ? AppColors.main.withOpacity(0.2) : null,
              fontWeight: isCurrentWord ? FontWeight.bold : FontWeight.normal,
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.themeColor,
      appBar: CustomAppBar(
        title: widget.appBarTitle,
        scaffoldKey: scaffoldKey,
        onBackPressed: widget.onBackPressed ??
            () {
              _stopSpeech(); // Para o áudio ao sair
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const EducationScreen()),
              );
            },
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: widget.contentPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho customizado
              if (widget.customHeader != null) ...[
                widget.customHeader!,
                const SizedBox(height: 20),
              ],
              
              // Título
              Text(
                widget.title,
                style: widget.titleStyle ??
                    TextStyle(
                      fontSize: widget.titleFontSize ?? 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.invertMode,
                    ),
              ),
              const SizedBox(height: 20),
              
              // Player de áudio
              if (widget.showAudioButton) _buildAudioPlayer(),
              const SizedBox(height: 20),
              
              // Pergunta destacada
              if (widget.highlightedQuestion != null && widget.highlightedQuestion!.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.highlightedQuestion!,
                          style: widget.questionStyle ??
                              TextStyle(
                                fontSize: widget.questionFontSize ?? 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondary,
                              ),
                        ),
                      ),
                      IconButton(
                        onPressed: isInitialized ? _speakOnlyQuestion : null,
                        icon: Icon(
                          Icons.play_circle_outline,
                          color: isInitialized ? AppColors.secondary : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              
              // Conteúdo principal
              GestureDetector(
                onTap: isInitialized ? _speakOnlyContent : null,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Conteúdo Principal",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.mainGray
                              ),
                            ),
                          ),
                          if (isInitialized) ...[
                            Icon(Icons.touch_app, size: 16, color: Colors.grey[400]),
                            const SizedBox(width: 4),
                            Text(
                              "Toque para ouvir",
                              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildHighlightedText(),
                      
                      // Conteúdo adicional
                      if (widget.additionalContent != null) ...[
                        const SizedBox(height: 16),
                        ...widget.additionalContent!,
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Rodapé customizado ou botão de ação
              if (widget.customFooter != null)
                widget.customFooter!
              else if (widget.showActionButton)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.onActionPressed ?? () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.main,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      widget.buttonText ?? "Ação Principal",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}