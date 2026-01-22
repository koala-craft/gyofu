import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  int _locationToIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/port-registration')) return 2;
    if (location.startsWith('/fish-convert')) return 1;
    // デフォルトは地域の魚情報ページ
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/fish-convert');
        break;
      case 2:
        context.go('/port-registration');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _locationToIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => _onTap(context, i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1E88E5),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: '魚の登録',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: '変換',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_rounded),
            label: '漁港登録',
          ),
        ],
      ),
    );
  }
}
