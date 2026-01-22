import 'package:flutter/material.dart';
import 'package:gyofu/data/fish_repository.dart';

class FishConvertPage extends StatefulWidget {
  const FishConvertPage({super.key});

  @override
  State<FishConvertPage> createState() => _FishConvertPageState();
}

class _FishConvertPageState extends State<FishConvertPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _fishNameController = TextEditingController();
  final TextEditingController _prefectureController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String _inputText = '';
  String _result = '';
  final repo = FishRepository();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _fishNameController.dispose();
    _prefectureController.dispose();
    _cityController.dispose();
    _portController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String? _safeGetText(TextEditingController? controller) {
    try {
      if (controller == null) return null;
      return controller.text.trim();
    } catch (e) {
      debugPrint('Error accessing controller text: $e');
      return null;
    }
  }

  void _convertFishName() {
    if (!mounted) return;
    
    try {
      // コントローラーが有効かチェックしてからアクセス
      final fishName = _safeGetText(_fishNameController);
      if (fishName == null || fishName.isEmpty) return;

      // 県名・市区町村名・漁港名はオプションなので、空文字列の場合はnullにする
      final prefectureText = _safeGetText(_prefectureController);
      final prefecture = (prefectureText == null || prefectureText.isEmpty) 
          ? null 
          : prefectureText;
      
      final cityText = _safeGetText(_cityController);
      final city = (cityText == null || cityText.isEmpty) 
          ? null 
          : cityText;
      
      final portText = _safeGetText(_portController);
      final port = (portText == null || portText.isEmpty) 
          ? null 
          : portText;

      if (!mounted) return;
      
      setState(() {
        _result = repo.convert(
          fishName,
          prefecture: prefecture,
          city: city,
          port: port,
        );
      });

      if (_result.isNotEmpty && mounted) {
        _animationController.forward(from: 0);
      }
    } catch (e) {
      // コントローラーが初期化されていない場合のエラーハンドリング
      debugPrint('Error in _convertFishName: $e');
      return;
    }
  }

  void _updateInputState() {
    if (!mounted) return;
    
    try {
      // コントローラーが有効かチェックしてからアクセス
      final text = _safeGetText(_fishNameController);
      if (!mounted) return;
      
      setState(() {
        _inputText = text ?? '';
      });
    } catch (e) {
      // コントローラーが初期化されていない場合のエラーハンドリング
      debugPrint('Error in _updateInputState: $e');
      if (mounted) {
        setState(() {
          _inputText = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF0A0E27),
                  const Color(0xFF1A1F3A),
                ]
              : [
                  const Color(0xFFF8FAFC),
                  const Color(0xFFF1F5F9),
                ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.06,
            vertical: size.height * 0.04,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ヘッダー
              FadeIn(
                delay: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '魚名変換',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ローカル名から正式名称を検索',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? Colors.white70
                            : const Color(0xFF64748B),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.06),

              // 入力カード
              FadeIn(
                delay: 100,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B).withOpacity(0.6)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(0.3)
                            : Colors.black.withOpacity(0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: 0,
                      ),
                    ],
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.transparent,
                      width: 1,
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
                              color: isDark
                                  ? const Color(0xFF3B82F6).withOpacity(0.2)
                                  : const Color(0xFF3B82F6).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.search_rounded,
                              color: const Color(0xFF3B82F6),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '魚の情報を入力',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                              color: isDark
                                  ? Colors.white70
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // 魚名入力
                      TextField(
                        controller: _fishNameController,
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                        decoration: InputDecoration(
                          labelText: '魚名',
                          hintText: '例：ハマチ',
                          hintStyle: TextStyle(
                            color: isDark
                                ? Colors.white38
                                : const Color(0xFF94A3B8),
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          labelStyle: TextStyle(
                            color: isDark
                                ? Colors.white70
                                : const Color(0xFF64748B),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          filled: true,
                          fillColor: isDark
                              ? Colors.white.withOpacity(0.05)
                              : const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : const Color(0xFFE2E8F0),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF3B82F6),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                        ),
                        onChanged: (_) => _updateInputState(),
                        onSubmitted: (_) => _convertFishName(),
                      ),
                      const SizedBox(height: 16),
                      // 県名入力
                      TextField(
                        controller: _prefectureController,
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                        decoration: InputDecoration(
                          labelText: '県名',
                          hintText: '例：福岡県',
                          hintStyle: TextStyle(
                            color: isDark
                                ? Colors.white38
                                : const Color(0xFF94A3B8),
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          labelStyle: TextStyle(
                            color: isDark
                                ? Colors.white70
                                : const Color(0xFF64748B),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          filled: true,
                          fillColor: isDark
                              ? Colors.white.withOpacity(0.05)
                              : const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : const Color(0xFFE2E8F0),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF3B82F6),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                        ),
                        onSubmitted: (_) => _convertFishName(),
                      ),
                      const SizedBox(height: 16),
                      // 市区町村名入力
                      TextField(
                        controller: _cityController,
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                        decoration: InputDecoration(
                          labelText: '市区町村名',
                          hintText: '例：福岡市',
                          hintStyle: TextStyle(
                            color: isDark
                                ? Colors.white38
                                : const Color(0xFF94A3B8),
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          labelStyle: TextStyle(
                            color: isDark
                                ? Colors.white70
                                : const Color(0xFF64748B),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          filled: true,
                          fillColor: isDark
                              ? Colors.white.withOpacity(0.05)
                              : const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : const Color(0xFFE2E8F0),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF3B82F6),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                        ),
                        onSubmitted: (_) => _convertFishName(),
                      ),
                      const SizedBox(height: 16),
                      // 漁港名入力
                      TextField(
                        controller: _portController,
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                        decoration: InputDecoration(
                          labelText: '漁港名',
                          hintText: '例：博多港',
                          hintStyle: TextStyle(
                            color: isDark
                                ? Colors.white38
                                : const Color(0xFF94A3B8),
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          labelStyle: TextStyle(
                            color: isDark
                                ? Colors.white70
                                : const Color(0xFF64748B),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          filled: true,
                          fillColor: isDark
                              ? Colors.white.withOpacity(0.05)
                              : const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : const Color(0xFFE2E8F0),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF3B82F6),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                        ),
                        onSubmitted: (_) => _convertFishName(),
                      ),
                      const SizedBox(height: 20),

                      // 変換ボタン
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeOut,
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: _inputText.isEmpty
                              ? null
                              : LinearGradient(
                                  colors: [
                                    const Color(0xFF3B82F6),
                                    const Color(0xFF2563EB),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          color: _inputText.isEmpty
                              ? (isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : const Color(0xFFE2E8F0))
                              : null,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: _inputText.isEmpty
                              ? null
                              : [
                                  BoxShadow(
                                    color: const Color(0xFF3B82F6)
                                        .withOpacity(0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                    spreadRadius: 0,
                                  ),
                                ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _inputText.isEmpty ? null : _convertFishName,
                            borderRadius: BorderRadius.circular(16),
                            splashColor: Colors.white.withOpacity(0.2),
                            highlightColor: Colors.white.withOpacity(0.1),
                            child: Center(
                              child: Text(
                                '変換する',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                  color: _inputText.isEmpty
                                      ? (isDark
                                          ? Colors.white38
                                          : const Color(0xFF94A3B8))
                                      : Colors.white,
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

              const SizedBox(height: 24),

              // 結果カード
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  if (_result.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  final isError =
                      _result == '該当する魚が見つかりません';

                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(
                        0,
                        20 * (1 - _fadeAnimation.value),
                      ),
                      child: FadeIn(
                        delay: 0,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: isError
                                ? null
                                : LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFF3B82F6).withOpacity(0.1),
                                      const Color(0xFF2563EB).withOpacity(0.05),
                                    ],
                                  ),
                            color: isError
                                ? (isDark
                                    ? const Color(0xFF7F1D1D).withOpacity(0.3)
                                    : const Color(0xFFFEF2F2))
                                : null,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isError
                                  ? (isDark
                                      ? Colors.red.withOpacity(0.3)
                                      : const Color(0xFFFEE2E2))
                                  : (isDark
                                      ? const Color(0xFF3B82F6).withOpacity(0.3)
                                      : const Color(0xFFDBEAFE)),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black.withOpacity(0.2)
                                    : Colors.black.withOpacity(0.03),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                                spreadRadius: 0,
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
                                      color: isError
                                          ? Colors.red.withOpacity(0.2)
                                          : const Color(0xFF3B82F6)
                                              .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      isError
                                          ? Icons.error_outline_rounded
                                          : Icons.check_circle_outline_rounded,
                                      color: isError
                                          ? Colors.red
                                          : const Color(0xFF3B82F6),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    isError ? '見つかりませんでした' : '正式名称',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                      color: isError
                                          ? Colors.red
                                          : (isDark
                                              ? Colors.white70
                                              : const Color(0xFF64748B)),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _result,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  color: isError
                                      ? Colors.red
                                      : (isDark
                                          ? Colors.white
                                          : const Color(0xFF1E293B)),
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// フェードインアニメーション用のウィジェット
class FadeIn extends StatefulWidget {
  final Widget child;
  final int delay;

  const FadeIn({
    super.key,
    required this.child,
    this.delay = 0,
  });

  @override
  State<FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Transform.translate(
        offset: Offset(0, 20 * (1 - _animation.value)),
        child: widget.child,
      ),
    );
  }
}
