import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/EducationScreen.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/pages/InicialScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:video_player/video_player.dart';

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

  // Configurações de TTS
  final String language;
  final double speechRate;
  final double pitch;
  final double volume;

  // Configurações de vídeo
  final String? videoUrl;
  final String? videoAssetPath;
  final bool autoPlayVideo;
  final bool loopVideo;
  final bool showVideoControls;

  // Configurações visuais dinâmicas
  final List<Color>? gradientColors;
  final String? backgroundImageUrl;
  final String? iconUrl;
  final List<String>? tags;

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
    this.speechRate = 1,
    this.pitch = 1.8,
    this.volume = 1,
    this.videoUrl,
    this.videoAssetPath,
    this.autoPlayVideo = false,
    this.loopVideo = false,
    this.showVideoControls = true,
    this.gradientColors,
    this.backgroundImageUrl,
    this.iconUrl,
    this.tags,
  }) : super(key: key);

  @override
  State<PageEducationScreen> createState() => _PageEducationScreenState();
}

class _PageEducationScreenState extends State<PageEducationScreen>
    with TickerProviderStateMixin {
  late FlutterTts flutterTts;
  bool isSpeaking = false;
  bool isInitialized = false;
  VideoPlayerController? _videoController;
  bool isVideoInitialized = false;

  // Animações
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _bounceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _initializeTts();
    _initializeVideo();
    _initializeAnimations();
  }

  @override
  void dispose() {
    flutterTts.stop();
    _videoController?.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  // Inicializar animações
  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));

    // Iniciar animações
    _fadeController.forward();
    _slideController.forward();
    _bounceController.forward();
  }

  // Inicializar vídeo
  Future<void> _initializeVideo() async {
    if (widget.videoUrl != null || widget.videoAssetPath != null) {
      if (widget.videoUrl != null) {
        _videoController = VideoPlayerController.network(widget.videoUrl!);
      } else {
        _videoController = VideoPlayerController.asset(widget.videoAssetPath!);
      }

      await _videoController!.initialize();
      
      if (widget.loopVideo) {
        _videoController!.setLooping(true);
      }

      if (widget.autoPlayVideo) {
        _videoController!.play();
      }

      setState(() {
        isVideoInitialized = true;
      });
    }
  }

  // Inicializar o TTS
  Future<void> _initializeTts() async {
    flutterTts = FlutterTts();

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

    await flutterTts.setLanguage(widget.language);
    await flutterTts.setSpeechRate(widget.speechRate);
    await flutterTts.setPitch(widget.pitch);
    await flutterTts.setVolume(widget.volume);

    setState(() {
      isInitialized = true;
    });
  }

  // Função para falar o texto
  Future<void> _speakText() async {
    if (!isInitialized) return;

    if (isSpeaking) {
      await flutterTts.stop();
      setState(() {
        isSpeaking = false;
      });
    } else {
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
      backgroundColor: AppColors.theme,
      appBar: CustomAppBar(
        title: widget.appBarTitle,
        scaffoldKey: scaffoldKey,
        onBackPressed: widget.onBackPressed ?? () => _defaultBackAction(context),
      ),
      drawer: const CustomDrawer(),
      body: Container(
        decoration: _buildBackgroundDecoration(),
        child: SingleChildScrollView(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Vídeo opcional no início
                if (widget.videoUrl != null || widget.videoAssetPath != null)
                  _buildVideoSection(),
                
                // Header customizável
                if (widget.customHeader != null) ...[
                  SlideTransition(
                    position: _slideAnimation,
                    child: widget.customHeader!,
                  ),
                  const SizedBox(height: 16),
                ],
                
                Padding(
                  padding: widget.contentPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Seção do título com animação
                      ScaleTransition(
                        scale: _bounceAnimation,
                        child: _buildTitleSection(),
                      ),
                      
                      const SizedBox(height: 24),

                      // Tags dinâmicas
                      if (widget.tags != null) _buildTagsSection(),

                      // Pergunta em destaque (opcional)
                      if (widget.highlightedQuestion != null) 
                        SlideTransition(
                          position: _slideAnimation,
                          child: _buildHighlightedQuestion(),
                        ),

                      // Conteúdo principal
                      SlideTransition(
                        position: _slideAnimation,
                        child: _buildMainContent(),
                      ),

                      // Estatísticas visuais
                      _buildStatsSection(),

                      // Conteúdo adicional (opcional)
                      if (widget.additionalContent != null) 
                        _buildAdditionalContent(),

                      const SizedBox(height: 24),

                      // Footer com botão de ação
                      _buildFooterSection(),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  // Construir decoração de fundo
  BoxDecoration _buildBackgroundDecoration() {
    if (widget.gradientColors != null) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: widget.gradientColors!,
        ),
      );
    }
    
    if (widget.backgroundImageUrl != null) {
      return BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(widget.backgroundImageUrl!),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
      );
    }
    
    return const BoxDecoration();
  }

  // Construir seção de vídeo
  Widget _buildVideoSection() {
    if (!isVideoInitialized) {
      return Container(
        height: 200,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            ),
            if (widget.showVideoControls)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildVideoControls(),
              ),
          ],
        ),
      ),
    );
  }

  // Construir controles de vídeo
  Widget _buildVideoControls() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _videoController!.value.isPlaying
                    ? _videoController!.pause()
                    : _videoController!.play();
              });
            },
            icon: Icon(
              _videoController!.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: VideoProgressIndicator(
              _videoController!,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Colors.white,
                bufferedColor: Colors.white60,
                backgroundColor: Colors.white30,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _videoController!.setVolume(
                  _videoController!.value.volume == 0 ? 1 : 0,
                );
              });
            },
            icon: Icon(
              _videoController!.value.volume == 0
                  ? Icons.volume_off
                  : Icons.volume_up,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Construir seção de tags
  Widget _buildTagsSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: widget.tags!.map((tag) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.main.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.main.withOpacity(0.3),
              ),
            ),
            child: Text(
              tag,
              style: TextStyle(
                color: AppColors.main,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Construir seção de estatísticas
  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.schedule,
            label: "Tempo",
            value: "${(widget.content.length / 200).ceil()} min",
          ),
          _buildStatItem(
            icon: Icons.text_fields,
            label: "Palavras",
            value: "${widget.content.split(' ').length}",
          ),
          _buildStatItem(
            icon: Icons.lightbulb,
            label: "Nível",
            value: "Básico",
          ),
        ],
      ),
    );
  }

  // Construir item de estatística
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.main.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.main,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.invertMode,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.invertMode.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  // Método para construir a seção do título
  Widget _buildTitleSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.main.withOpacity(0.1),
            AppColors.main.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.main.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (widget.iconUrl != null)
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.iconUrl!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: widget.titleStyle ??
                      TextStyle(
                        fontSize: widget.titleFontSize ?? 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.invertMode,
                      ),
                ),
                if (widget.brandName != null)
                  Text(
                    widget.brandName!,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.main,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          if (widget.showAudioButton)
            Container(
              decoration: BoxDecoration(
                color: isSpeaking ? Colors.red.withOpacity(0.1) : AppColors.main.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: IconButton(
                onPressed: isInitialized ? _speakText : null,
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    isSpeaking ? Icons.stop : Icons.volume_up,
                    color: isSpeaking ? Colors.red : AppColors.main,
                    size: 28,
                    key: ValueKey(isSpeaking),
                  ),
                ),
                tooltip: isSpeaking ? 'Parar reprodução' : 'Reproduzir áudio',
              ),
            ),
        ],
      ),
    );
  }

  // Método para construir a pergunta em destaque
  Widget _buildHighlightedQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF2563EB).withOpacity(0.1),
                const Color(0xFF2563EB).withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF2563EB).withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.help_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Pergunta Chave",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.highlightedQuestion!,
                style: widget.questionStyle ??
                    TextStyle(
                      fontSize: widget.questionFontSize ?? 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2563EB),
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Método para construir o conteúdo principal
  Widget _buildMainContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.main.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.menu_book,
                  color: AppColors.main,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Conteúdo Principal",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.main,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _speakOnlyContent(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.main.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        size: 16,
                        color: AppColors.main,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Ouvir",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.main,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.content,
            style: widget.contentStyle ??
                TextStyle(
                  fontSize: widget.contentFontSize ?? 16,
                  height: 1.6,
                  color: AppColors.invertMode,
                ),
            textAlign: TextAlign.justify,
          ),
        ],
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

  // Método para construir conteúdo adicional
  Widget _buildAdditionalContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        ...widget.additionalContent!,
      ],
    );
  }

  // Método para construir a seção do footer
  Widget _buildFooterSection() {
    if (widget.customFooter != null) {
      return widget.customFooter!;
    }
    
    if (widget.showActionButton) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.main, AppColors.main.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.main.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: widget.onActionPressed ?? _defaultActionButtonAction,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.buttonText ?? 'Próxima Lição',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      );
    }
    
    return const SizedBox.shrink();
  }

  // Construir botão flutuante
  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        // Scroll para o topo
        // ou qualquer outra ação
      },
      backgroundColor: AppColors.main,
      child: const Icon(
        Icons.keyboard_arrow_up,
        color: Colors.white,
      ),
    );
  }

  // Ações padrão
  void _defaultBackAction(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const EducationScreen()),
    );
  }

  void _defaultActionButtonAction() {
    debugPrint('Botão de ação pressionado para: ${widget.title}');
  }
}