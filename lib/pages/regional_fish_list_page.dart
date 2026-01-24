import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyofu/data/regional_fish_mock.dart';

class RegionalFishListPage extends StatefulWidget {
  const RegionalFishListPage({super.key});

  @override
  State<RegionalFishListPage> createState() => _RegionalFishListPageState();
}

class _RegionalFishListPageState extends State<RegionalFishListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 文字列を正規化する（大文字小文字、ひらがな・カタカナの揺らぎを許容）
  String _normalizeString(String text) {
    // カタカナをひらがなに変換
    String normalized = text.replaceAllMapped(
      RegExp(r'[ァ-ヶ]'),
      (match) {
        final char = match.group(0)!;
        final code = char.codeUnitAt(0);
        // カタカナ（ァ-ヶ）をひらがな（ぁ-ゖ）に変換
        if (code >= 0x30A1 && code <= 0x30F6) {
          return String.fromCharCode(code - 0x60);
        }
        return char;
      },
    );
    // 大文字を小文字に変換（英数字の場合）
    normalized = normalized.toLowerCase();
    return normalized;
  }

  List<RegionalFish> get _filteredFish {
    if (_searchQuery.isEmpty) {
      return regionalFishMock;
    }
    final query = _normalizeString(_searchQuery);
    return regionalFishMock.where((fish) {
      final normalizedLocalName = _normalizeString(fish.localName);
      final normalizedFormalName = _normalizeString(fish.formalName);
      return normalizedLocalName.contains(query) ||
          normalizedFormalName.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: isDark ? const Color(0xFF0A0E27) : Colors.white,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // 検索バー
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.06,
                    vertical: 16,
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
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: '地域の魚名、正式名称で検索',
                      hintStyle: TextStyle(
                        color: isDark
                            ? Colors.white38
                            : const Color(0xFF94A3B8),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: isDark
                            ? Colors.white70
                            : const Color(0xFF64748B),
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
                        vertical: 16,
                      ),
                    ),
                  ),
                ),

                // リスト
                Expanded(
                  child: _filteredFish.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(size.width * 0.06),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 64,
                                  color: isDark
                                      ? Colors.white38
                                      : const Color(0xFF94A3B8),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '検索結果が見つかりません',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? Colors.white70
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: _filteredFish.length,
                          itemBuilder: (context, index) {
                            final fish = _filteredFish[index];
                            return _FishListItem(
                              fish: fish,
                              isDark: isDark,
                              onTap: () {
                                context.push('/regional-fish-detail/${fish.id}');
                              },
                            );
                          },
                        ),
                ),
              ],
            ),

            // 追加ボタン（右下）
            Positioned(
              right: size.width * 0.06,
              bottom: size.height * 0.04,
              child: FloatingActionButton(
                onPressed: () {
                  context.push('/regional-fish-edit');
                },
                backgroundColor: const Color(0xFF3B82F6),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FishListItem extends StatelessWidget {
  final RegionalFish fish;
  final bool isDark;
  final VoidCallback onTap;

  const _FishListItem({
    required this.fish,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1E293B).withOpacity(0.6)
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
              // アイコン
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF3B82F6).withOpacity(0.2)
                      : const Color(0xFF3B82F6).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.set_meal,
                  color: Color(0xFF3B82F6),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),

              // 情報
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fish.localName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '正式名称: ${fish.formalName}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? Colors.white70
                            : const Color(0xFF64748B),
                        letterSpacing: 0.2,
                      ),
                    ),
                      const SizedBox(height: 4),
                      Text(
                        '${fish.prefecture} ${fish.city}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? Colors.white60
                              : const Color(0xFF94A3B8),
                          letterSpacing: 0.2,
                        ),
                      ),
                      if (fish.notes != null && fish.notes!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          fish.notes!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? Colors.white.withOpacity(0.5)
                                : const Color(0xFF94A3B8),
                            letterSpacing: 0.1,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

              // 矢印アイコン
              Icon(
                Icons.chevron_right_rounded,
                color: isDark ? Colors.white38 : const Color(0xFFD1D5DB),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
