import 'package:flutter/material.dart';
import 'package:gyofu/data/fish_repository.dart';
import 'package:gyofu/data/prefecture_data.dart';
import 'package:gyofu/data/city_port_data.dart';
import 'package:gyofu/data/regional_fish_mock.dart';

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
  List<RegionalFish> _multipleResults = []; // 複数結果を保持
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
      
      // 複数結果を取得
      final results = repo.convertMultiple(
        fishName,
        prefecture: prefecture,
        city: city,
        port: port,
      );
      
      setState(() {
        _multipleResults = results;
        
        // 結果に応じてメッセージを設定
        if (results.isEmpty) {
          _result = '該当する魚が見つかりません';
        } else if (results.length == 1) {
          _result = results.first.formalName;
        } else {
          // 複数件ヒット時は地域入力を促す
          _result = '';
        }
      });

      if (mounted) {
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
      color: isDark ? const Color(0xFF0A0E27) : Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // ヘッダー（一覧画面と同じスタイル）
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E293B).withOpacity(0.8)
                    : Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? Colors.white.withOpacity(0.1)
                        : const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E88E5).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.swap_horiz,
                      color: Color(0xFF1E88E5),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '魚名変換',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),

            // コンテンツ
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 魚名入力
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1E88E5).withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _fishNameController,
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                          decoration: InputDecoration(
                            labelText: '魚の名前',
                            hintText: 'ハマチ',
                            hintStyle: TextStyle(
                              color: isDark
                                  ? Colors.white38
                                  : const Color(0xFF94A3B8),
                              fontSize: 18,
                            ),
                            labelStyle: TextStyle(
                              color: isDark
                                  ? Colors.white70
                                  : const Color(0xFF1E88E5),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            filled: true,
                            fillColor: isDark
                                ? Colors.white.withOpacity(0.08)
                                : Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: isDark
                                    ? Colors.white.withOpacity(0.2)
                                    : const Color(0xFF1E88E5).withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: isDark
                                    ? Colors.white.withOpacity(0.2)
                                    : const Color(0xFF1E88E5).withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF1E88E5),
                                width: 2.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 18,
                            ),
                          ),
                          onChanged: (_) => _updateInputState(),
                          onSubmitted: (_) => _convertFishName(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // 地域情報の折りたたみセクション
                      Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : const Color(0xFFE5E7EB),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ExpansionTile(
                          key: ValueKey(_isRegionExpanded),
                          initiallyExpanded: _isRegionExpanded,
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          childrenPadding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                          title: Text(
                            '地域情報（任意）',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              _isRegionExpanded 
                                  ? '地域を指定して検索精度を上げる' 
                                  : _selectedPrefecture != null || _selectedCity != null || _selectedPort != null
                                      ? '${_selectedPrefecture ?? ''}${_selectedCity != null ? ' / ${_selectedCity}' : ''}${_selectedPort != null ? ' / ${_selectedPort}' : ''}'
                                      : 'タップして地域を選択',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: isDark
                                    ? Colors.white60
                                    : const Color(0xFF64748B),
                                height: 1.3,
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
                              Column(
                                children: [
                                  // 県名入力
                                  DropdownButtonFormField<String>(
                                    value: _selectedPrefecture,
                                    isDense: false,
                                    decoration: InputDecoration(
                                      labelText: '県名',
                                      hintText: '選択してください',
                                      hintStyle: TextStyle(
                                        color: isDark
                                            ? Colors.white38
                                            : const Color(0xFF94A3B8),
                                        fontSize: 17,
                                      ),
                                      labelStyle: TextStyle(
                                        color: isDark
                                            ? Colors.white70
                                            : const Color(0xFF64748B),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      filled: true,
                                      fillColor: isDark
                                          ? Colors.white.withOpacity(0.05)
                                          : const Color(0xFFF9FAFB),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: isDark
                                              ? Colors.white.withOpacity(0.1)
                                              : const Color(0xFFE5E7EB),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: isDark
                                              ? Colors.white.withOpacity(0.1)
                                              : const Color(0xFFE5E7EB),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF1E88E5),
                                          width: 2,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 20,
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5,
                                    ),
                                    dropdownColor: isDark
                                        ? const Color(0xFF1E293B)
                                        : Colors.white,
                                    iconEnabledColor: isDark
                                        ? Colors.white70
                                        : const Color(0xFF64748B),
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: null,
                                        child: Text(
                                          '選択してください',
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white60
                                                : const Color(0xFF64748B),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
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
                                  const SizedBox(height: 16),
                                  // 市区町村名入力
                                  DropdownButtonFormField<String>(
                                    value: _selectedCity,
                                    isDense: false,
                                    decoration: InputDecoration(
                                      labelText: '市区町村名',
                                      hintText: '選択してください',
                                      hintStyle: TextStyle(
                                        color: isDark
                                            ? Colors.white38
                                            : const Color(0xFF94A3B8),
                                        fontSize: 17,
                                      ),
                                      labelStyle: TextStyle(
                                        color: isDark
                                            ? Colors.white70
                                            : const Color(0xFF64748B),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      filled: true,
                                      fillColor: isDark
                                          ? Colors.white.withOpacity(0.05)
                                          : const Color(0xFFF9FAFB),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: isDark
                                              ? Colors.white.withOpacity(0.1)
                                              : const Color(0xFFE5E7EB),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: isDark
                                              ? Colors.white.withOpacity(0.1)
                                              : const Color(0xFFE5E7EB),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF1E88E5),
                                          width: 2,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 20,
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5,
                                    ),
                                    dropdownColor: isDark
                                        ? const Color(0xFF1E293B)
                                        : Colors.white,
                                    iconEnabledColor: isDark
                                        ? Colors.white70
                                        : const Color(0xFF64748B),
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: null,
                                        child: Text(
                                          '選択してください',
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white60
                                                : const Color(0xFF64748B),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
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
                                  const SizedBox(height: 16),
                                  // 漁港名入力
                                  DropdownButtonFormField<String>(
                                    value: _selectedPort,
                                    isDense: false,
                                    decoration: InputDecoration(
                                      labelText: '漁港名',
                                      hintText: '選択してください',
                                      hintStyle: TextStyle(
                                        color: isDark
                                            ? Colors.white38
                                            : const Color(0xFF94A3B8),
                                        fontSize: 17,
                                      ),
                                      labelStyle: TextStyle(
                                        color: isDark
                                            ? Colors.white70
                                            : const Color(0xFF64748B),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      filled: true,
                                      fillColor: isDark
                                          ? Colors.white.withOpacity(0.05)
                                          : const Color(0xFFF9FAFB),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: isDark
                                              ? Colors.white.withOpacity(0.1)
                                              : const Color(0xFFE5E7EB),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: isDark
                                              ? Colors.white.withOpacity(0.1)
                                              : const Color(0xFFE5E7EB),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF1E88E5),
                                          width: 2,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 20,
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5,
                                    ),
                                    dropdownColor: isDark
                                        ? const Color(0xFF1E293B)
                                        : Colors.white,
                                    iconEnabledColor: isDark
                                        ? Colors.white70
                                        : const Color(0xFF64748B),
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: null,
                                        child: Text(
                                          '選択してください',
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white60
                                                : const Color(0xFF64748B),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
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
                          ],
                        ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 変換ボタン
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _inputText.isEmpty ? null : _convertFishName,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E88E5),
                            disabledBackgroundColor: isDark
                                ? Colors.white.withOpacity(0.1)
                                : const Color(0xFFE5E7EB),
                            foregroundColor: Colors.white,
                            disabledForegroundColor: isDark
                                ? Colors.white38
                                : const Color(0xFF94A3B8),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            '変換する',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 結果表示
                      if (_result.isNotEmpty || _multipleResults.length > 1)
                        Column(
                          children: [
                  // 複数結果がある場合
                  if (_multipleResults.length > 1) ...[
                            // 注意メッセージ
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF4E6),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFFF9800).withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    color: const Color(0xFFFF9800),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'この名称は複数の魚を指す可能性があります',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFFE65100),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '地域を指定すると精度が上がります',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFFEF6C00),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            // 複数結果の一覧
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1E293B).withOpacity(0.6)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white.withOpacity(0.1)
                                      : const Color(0xFFE5E7EB),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '候補一覧 (${_multipleResults.length}件)',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ..._multipleResults.map((fish) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? Colors.white.withOpacity(0.05)
                                            : const Color(0xFFF9FAFB),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isDark
                                              ? Colors.white.withOpacity(0.1)
                                              : const Color(0xFFE5E7EB),
                                          width: 1,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            fish.formalName,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                              color: isDark
                                                  ? Colors.white
                                                  : const Color(0xFF0F172A),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on_outlined,
                                                size: 16,
                                                color: const Color(0xFF3B82F6),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${fish.prefecture} / ${fish.city}',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: isDark
                                                      ? Colors.white70
                                                      : const Color(0xFF64748B),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (fish.port != null && fish.port!.isNotEmpty) ...[
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.anchor_outlined,
                                                  size: 16,
                                                  color: const Color(0xFF3B82F6),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  fish.port!,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: isDark
                                                        ? Colors.white60
                                                        : const Color(0xFF94A3B8),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                          if (fish.notes != null && fish.notes!.isNotEmpty) ...[
                                            const SizedBox(height: 8),
                                            Text(
                                              fish.notes!,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: isDark
                                                    ? Colors.white54
                                                    : const Color(0xFF94A3B8),
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                  ],
                  
                  // 単一結果またはエラーの場合
                  if (_result.isNotEmpty && _multipleResults.length <= 1)
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _result == '該当する魚が見つかりません'
                                ? (isDark
                                    ? const Color(0xFF7F1D1D).withOpacity(0.3)
                                    : const Color(0xFFFEF2F2))
                                : (isDark
                                    ? const Color(0xFF1E293B).withOpacity(0.6)
                                    : const Color(0xFFF0F9FF)),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _result == '該当する魚が見つかりません'
                                  ? (isDark
                                      ? Colors.red.withOpacity(0.3)
                                      : const Color(0xFFFEE2E2))
                                  : (isDark
                                      ? Colors.white.withOpacity(0.1)
                                      : const Color(0xFFBFDBFE)),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _result == '該当する魚が見つかりません' ? '見つかりませんでした' : '正式名称',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: _result == '該当する魚が見つかりません'
                                      ? Colors.red
                                      : (isDark
                                          ? Colors.white70
                                          : const Color(0xFF64748B)),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _result,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: _result == '該当する魚が見つかりません'
                                      ? Colors.red
                                      : (isDark
                                          ? Colors.white
                                          : const Color(0xFF0F172A)),
                                ),
                              ),
                            ],
                          ),
                        ),
                          ],
                        ),
                    ],
                ),
              ),
            ),
          ],
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
