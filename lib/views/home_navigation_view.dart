import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/theme_provider.dart';
import 'calendar/calendar_view.dart';
import 'home/home_view.dart';
import 'ranking/ranking_view.dart';
import 'stats/stats_view.dart';

class HomeNavigationView extends StatefulWidget {
  const HomeNavigationView({super.key});

  @override
  State<HomeNavigationView> createState() => _HomeNavigationViewState();
}

class _HomeNavigationViewState extends State<HomeNavigationView> {
  int _currentIndex = 0;

  void _navigateToIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final isEn = settings.languageCode == 'en';

    final List<Widget> screens = [
      HomeView(
        onNavigateToAgenda: () => _navigateToIndex(1),
        onNavigateToLista: () => _navigateToIndex(2),
      ),
      const CalendarView(),
      const RankingView(),
      const StatsView(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        backgroundColor: theme.mantleColor,
        indicatorColor: theme.surface1Color,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: isEn ? 'Home' : 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded),
            label: isEn ? 'Calendar' : 'Agenda',
          ),
          NavigationDestination(
            icon: Icon(Icons.format_list_bulleted_rounded),
            selectedIcon: Icon(Icons.format_list_numbered_rounded),
            label: isEn ? 'List' : 'Lista',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: isEn ? 'Statistics' : 'Estadísticas',
          ),
        ],
      ),
    );
  }
}
