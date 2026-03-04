import 'package:flutter/foundation.dart';

/// Simple model for a network request log.
class NetworkLogEntry {
  final String id;
  final String method;
  final String url;
  final int? statusCode;
  final DateTime timestamp;
  final String? requestBodySummary;
  final String? responseBodySummary;
  final String environment;

  NetworkLogEntry({
    required this.id,
    required this.method,
    required this.url,
    this.statusCode,
    required this.timestamp,
    this.requestBodySummary,
    this.responseBodySummary,
    required this.environment,
  });
}

/// Service to store recent network logs in memory.
class NetworkLogService {
  final List<NetworkLogEntry> _logs = [];
  static const int _maxLogs = 50;

  List<NetworkLogEntry> get logs => List.unmodifiable(_logs.reversed);

  void addLog(NetworkLogEntry entry) {
    _logs.add(entry);
    if (_logs.length > _maxLogs) {
      _logs.removeAt(0);
    }
  }

  void clearLogs() {
    _logs.clear();
  }
}
