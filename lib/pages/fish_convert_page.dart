import 'package:flutter/material.dart';
import 'package:gyofu/data/fish_repository.dart';
import 'package:gyofu/data/prefecture_data.dart';
import 'package:gyofu/data/city_port_data.dart';

class FishConvertPage extends StatefulWidget {
  const FishConvertPage({super.key});

  @override
  State<FishConvertPage> createState() => _FishConvertPageState();
}

class _FishConvertPageState extends State<FishConvertPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _fishNameController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String? _selectedPrefecture;
  String? _selectedCity;
  String? _selectedPort;
  String _inputText = '';
  String _result = '';
  bool _isRegionExpanded = false; // 地域情報の折りたたみ状態
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
      final prefecture = (_selectedPrefecture == null || _selectedPrefecture!.isEmpty) 
          ? null 
          : _selectedPrefecture;
      
      final city = (_selectedCity == null || _selectedCity!.isEmpty) 
          ? null 
          : _selectedCity;
      
      final port = (_selectedPort == null || _selectedPort!.isEmpty) 
          ? null 
          : _selectedPort;

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
                      // 地域情報の折りたたみセクション
                      Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          childrenPadding: EdgeInsets.zero,
                          title: Text(
                            '地域情報（任意）',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white70
                                  : const Color(0xFF64748B),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              _isRegionExpanded 
                                  ? '地域を指定して検索精度を上げる' 
                                  : _selectedPrefecture != null || _selectedCity != null || _selectedPort != null
                                      ? '${_selectedPrefecture ?? ''}${_selectedCity != null ? ' / ${_selectedCity}' : ''}${_selectedPort != null ? ' / ${_selectedPort}' : ''}'
                                      : 'タップして地域を選択',
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white38
                                    : const Color(0xFF94A3B8),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          trailing: Icon(
                            _isRegionExpanded 
                                ? Icons.expand_less 
                                : Icons.expand_more,
                            color: isDark
                                ? Colors.white70
                                : const Color(0xFF64748B),
                          ),
                          onExpansionChanged: (bool expanded) {
                            setState(() {
                              _isRegionExpanded = expanded;
                            });
                          },
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                              child: Column(
                                children: [
                                  // 県名入力
                                  DropdownButtonFormField<String>(
                                    value: _selectedPrefecture,
                                    decoration: InputDecoration(
                                      labelText: '県名',
                                      hintText: '都道府県を選択',
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
                                    style: TextStyle(
                                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                    ),
                                    dropdownColor: isDark
                                        ? const Color(0xFF1E293B)
                                        : Colors.white,
                                    iconEnabledColor: isDark
                                        ? Colors.white70
                                        : const Color(0xFF64748B),
                                    items: [
                                      const DropdownMenuItem<String>(
                                        value: null,
                                        child: Text('選択してください'),
                                      ),
                                      ...getPrefecturesFromMock().map((String prefecture) {
                                        return DropdownMenuItem<String>(
                                          value: prefecture,
                                          child: Text(prefecture),
                                        );
                                      }),
                                    ],
                                    onChanged: (String? value) {
                                      setState(() {
                                        _selectedPrefecture = value;
                                        _selectedCity = null; // 県名が変わったら市区町村をリセット
                                        _selectedPort = null; // 県名が変わったら漁港名をリセット
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  // 市区町村名入力
                                  DropdownButtonFormField<String>(
                                    value: _selectedCity,
                                    decoration: InputDecoration(
                                      labelText: '市区町村名',
                                      hintText: '市区町村を選択',
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
                                    style: TextStyle(
                                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                    ),
                                    dropdownColor: isDark
                                        ? const Color(0xFF1E293B)
                                        : Colors.white,
                                    iconEnabledColor: isDark
                                        ? Colors.white70
                                        : const Color(0xFF64748B),
                                    items: [
                                      const DropdownMenuItem<String>(
                                        value: null,
                                        child: Text('選択してください'),
                                      ),
                                      ...getCitiesByPrefecture(_selectedPrefecture)
                                          .map((String city) {
                                        return DropdownMenuItem<String>(
                                          value: city,
                                          child: Text(city),
                                        );
                                      }),
                                    ],
                                    onChanged: _selectedPrefecture == null
                                        ? null
                                        : (String? value) {
                                            setState(() {
                                              _selectedCity = value;
                                              _selectedPort = null; // 市区町村が変わったら漁港名をリセット
                                            });
                                          },
                                  ),
                                  const SizedBox(height: 20),
                                  // 漁港名入力
                                  DropdownButtonFormField<String>(
                                    value: _selectedPort,
                                    decoration: InputDecoration(
                                      labelText: '漁港名',
                                      hintText: '漁港を選択',
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
                                    style: TextStyle(
                                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                    ),
                                    dropdownColor: isDark
                                        ? const Color(0xFF1E293B)
                                        : Colors.white,
                                    iconEnabledColor: isDark
                                        ? Colors.white70
                                        : const Color(0xFF64748B),
                                    items: [
                                      const DropdownMenuItem<String>(
                                        value: null,
                                        child: Text('選択してください'),
                                      ),
                                      ...getPortsByPrefectureAndCity(_selectedPrefecture, _selectedCity)
                                          .map((String port) {
                                        return DropdownMenuItem<String>(
                                          value: port,
                                          child: Text(port),
                                        );
                                      }),
                                    ],
                                    onChanged: (_selectedPrefecture == null || _selectedCity == null)
                                        ? null
                                        : (String? value) {
                                            setState(() {
                                              _selectedPort = value;
                                            });
                                          },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
