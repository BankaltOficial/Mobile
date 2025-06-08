import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/pages/EducationScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';

class PageEducationScreen extends StatefulWidget {
  // Propriedades obrigatórias
  final String title;
  final String content;
  final String appBarTitle;

  // Propriedades opcionais para customização
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

  //audio
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
    this.language = "pt-BR", // Português brasileiro
    this.speechRate = 0.5, // Velocidade da fala (0.0 - 1.0)
    this.pitch = 1.0, // Tom da voz (0.5 - 2.0)
    this.volume = 0.8, // Volume (0.0 - 1.0)
  }) : super(key: key);

  @override
  State<PageEducationScreen> createState() => _PageEducationScreenState();
}

class _PageEducationScreenState extends State<PageEducationScreen> {
  late FlutterTts flutterTts;
  bool isSpeaking = false;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  // Inicializar o TTS
  Future<void> _initializeTts() async {
    flutterTts = FlutterTts();

    // Configurar callbacks
    flutterTts.setStartHandler(() {
      setState(() {
        isSpeaking = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        isSpeaking = false;
      });
      debugPrint("TTS Error: $msg");
    });

    // Configurar parâmetros
    await flutterTts.setLanguage(widget.language);
    await flutterTts.setSpeechRate(widget.speechRate);
    await flutterTts.setPitch(widget.pitch);
    await flutterTts.setVolume(widget.volume);

    setState(() {
      isInitialized = true;
    });
  }

  // Função para falar o texto completo
  Future<void> _speakText() async {
    if (!isInitialized) return;

    if (isSpeaking) {
      // Se já está falando, para a reprodução
      await flutterTts.stop();
      setState(() {
        isSpeaking = false;
      });
    } else {
      // Combina título, pergunta destacada e conteúdo
      String textToSpeak = widget.title;

      if (widget.highlightedQuestion != null) {
        textToSpeak += ". ${widget.highlightedQuestion}";
      }

      textToSpeak += ". ${widget.content}";

      await flutterTts.speak(textToSpeak);
    }
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const EducationScreen()),
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
              // Título da seção
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: widget.titleStyle ??
                          TextStyle(
                            fontSize: widget.titleFontSize ?? 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.invertMode,
                          ),
                    ),
                  ),
                  if (widget.showAudioButton)
                    Container(
                      decoration: BoxDecoration(
                        color: isSpeaking
                            ? Colors.red.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: IconButton(
                        onPressed: widget.onAudioPressed ??
                            (isInitialized ? _speakText : null),
                        icon: Icon(
                          isSpeaking ? Icons.stop : Icons.volume_up,
                          color: isSpeaking ? Colors.red : Colors.grey,
                          size: 28,
                        ),
                        tooltip: isSpeaking
                            ? 'Parar reprodução'
                            : 'Reproduzir áudio',
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // Pergunta em destaque (opcional)
              if (widget.highlightedQuestion != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.secondary.withOpacity(0.3),
                      width: 1,
                    ),
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
                      // Botão para falar apenas a pergunta
                      IconButton(
                        onPressed:
                            isInitialized ? () => _speakOnlyQuestion() : null,
                        icon: Icon(
                          Icons.play_circle_outline,
                          color: AppColors.secondary,
                          size: 24,
                        ),
                        tooltip: 'Reproduzir pergunta',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Texto explicativo
              GestureDetector(
                onTap: () => _speakOnlyContent(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Conteúdo Principal",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Icon(
                            Icons.touch_app,
                            size: 16,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Toque para ouvir",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.content,
                        style: widget.contentStyle ??
                            TextStyle(
                              fontSize: widget.contentFontSize ?? 16,
                              height: 1.6,
                              color: AppColors.invertMode,
                            ),
                      ),
                      if (widget.additionalContent != null) ...[
                        const SizedBox(height: 16),
                        ...widget.additionalContent!,
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Footer customizável
              if (widget.customFooter != null)
                widget.customFooter!
              else if (widget.showActionButton)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.onActionPressed ??
                        () {
                          // Implementar ação padrão do botão
                          debugPrint('Botão de ação pressionado');
                        },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.main,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      widget.buttonText ?? 'Ação Principal',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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

  // Função para falar apenas a pergunta
  Future<void> _speakOnlyQuestion() async {
    if (widget.highlightedQuestion != null) {
      await flutterTts.speak(widget.highlightedQuestion!);
    }
  }

  // Função para falar apenas o conteúdo
  Future<void> _speakOnlyContent() async {
    await flutterTts.speak(widget.content);
  }
}
