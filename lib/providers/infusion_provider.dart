import 'package:flutter/foundation.dart';
import '../models/infusion_log.dart';
import '../models/infusion_type.dart';
import '../services/database_service.dart';

class InfusionProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService.instance;

  List<InfusionLog> _allLogs = [];
  bool _isLoading = false;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  List<InfusionLog> get allLogs => _allLogs;
  bool get isLoading => _isLoading;
  DateTime get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;

  List<InfusionLog> get logsForSelectedDay {
    return _allLogs.where((log) {
      return log.dateTime.year == _selectedDay.year &&
          log.dateTime.month == _selectedDay.month &&
          log.dateTime.day == _selectedDay.day;
    }).toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  Map<DateTime, List<InfusionLog>> get eventsMap {
    final Map<DateTime, List<InfusionLog>> map = {};
    for (var log in _allLogs) {
      final normalizedDate = DateTime(log.dateTime.year, log.dateTime.month, log.dateTime.day);
      if (map[normalizedDate] == null) {
        map[normalizedDate] = [];
      }
      map[normalizedDate]!.add(log);
    }
    return map;
  }

  List<InfusionLog> getEventsForDay(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    return eventsMap[normalized] ?? [];
  }

  // --- Statistics ---
  int get totalCount => _allLogs.length;
  int get mateCount => _allLogs.where((l) => l.category == InfusionCategory.mate).length;
  int get cafeCount => _allLogs.where((l) => l.category == InfusionCategory.cafe).length;
  int get teCount => _allLogs.where((l) => l.category == InfusionCategory.te).length;

  double get averageTemperature {
    if (_allLogs.isEmpty) return 0.0;
    final sum = _allLogs.map((e) => e.temperatureCelsius).reduce((a, b) => a + b);
    return sum / _allLogs.length;
  }

  double get averageWeight {
    if (_allLogs.isEmpty) return 0.0;
    final sum = _allLogs.map((e) => e.weightGrams).reduce((a, b) => a + b);
    return sum / _allLogs.length;
  }

  double get averageRating {
    if (_allLogs.isEmpty) return 0.0;
    final sum = _allLogs.map((e) => e.rating).reduce((a, b) => a + b);
    return sum / _allLogs.length;
  }

  // Category specific helpers
  List<InfusionLog> logsForCategory(InfusionCategory category) {
    return _allLogs.where((l) => l.category == category).toList();
  }

  double averageTempForCategory(InfusionCategory category) {
    final list = logsForCategory(category);
    if (list.isEmpty) return 0.0;
    return list.map((e) => e.temperatureCelsius).reduce((a, b) => a + b) / list.length;
  }

  double averageWeightForCategory(InfusionCategory category) {
    final list = logsForCategory(category);
    if (list.isEmpty) return 0.0;
    return list.map((e) => e.weightGrams).reduce((a, b) => a + b) / list.length;
  }

  double averageRatingForCategory(InfusionCategory category) {
    final list = logsForCategory(category);
    if (list.isEmpty) return 0.0;
    return list.map((e) => e.rating).reduce((a, b) => a + b) / list.length;
  }

  InfusionType? favoriteTypeForCategory(InfusionCategory category) {
    final list = logsForCategory(category);
    if (list.isEmpty) return null;
    final Map<InfusionType, int> counts = {};
    for (var log in list) {
      counts[log.type] = (counts[log.type] ?? 0) + 1;
    }
    InfusionType? fav;
    int max = -1;
    counts.forEach((t, c) {
      if (c > max) {
        max = c;
        fav = t;
      }
    });
    return fav;
  }

  Map<InfusionType, int> get typeDistribution {
    final Map<InfusionType, int> counts = {};
    for (var type in InfusionType.values) {
      counts[type] = 0;
    }
    for (var log in _allLogs) {
      counts[log.type] = (counts[log.type] ?? 0) + 1;
    }
    return counts;
  }

  InfusionType? get favoriteType {
    if (_allLogs.isEmpty) return null;
    final dist = typeDistribution;
    InfusionType? fav;
    int maxCount = -1;
    dist.forEach((type, count) {
      if (count > maxCount) {
        maxCount = count;
        fav = type;
      }
    });
    return fav;
  }

  // --- Actions ---
  Future<void> loadLogs() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allLogs = await _db.getAllLogs();
    } catch (e) {
      if (kDebugMode) print('Error loading logs: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedDay(DateTime selected, DateTime focused) {
    _selectedDay = selected;
    _focusedDay = focused;
    notifyListeners();
  }

  void setFocusedDay(DateTime focused) {
    _focusedDay = focused;
    notifyListeners();
  }

  Future<bool> addLog(InfusionLog log) async {
    try {
      await _db.insertLog(log);
      await loadLogs();
      return true;
    } catch (e) {
      if (kDebugMode) print('Error adding log: $e');
      return false;
    }
  }

  Future<bool> updateLog(InfusionLog log) async {
    try {
      await _db.updateLog(log);
      await loadLogs();
      return true;
    } catch (e) {
      if (kDebugMode) print('Error updating log: $e');
      return false;
    }
  }

  Future<bool> deleteLog(String id) async {
    try {
      await _db.deleteLog(id);
      await loadLogs();
      return true;
    } catch (e) {
      if (kDebugMode) print('Error deleting log: $e');
      return false;
    }
  }

  Future<bool> duplicateLog(InfusionLog log) async {
    final newLog = log.copyWith(
      id: 'log_${DateTime.now().millisecondsSinceEpoch}',
      dateTime: DateTime.now(),
      createdAt: DateTime.now(),
    );
    return await addLog(newLog);
  }
}
