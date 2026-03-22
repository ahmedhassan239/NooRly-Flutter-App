import 'dart:convert';
import 'dart:math' show min;
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/core/config/api_config.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Loads an icon from [url] (SVG or raster) with timeout; shows [fallback] on failure.
/// Resolves relative URLs against [ApiConfig.apiOrigin] (same as Ramadan guide icons).
class BackendRemoteIcon extends StatefulWidget {
  const BackendRemoteIcon({
    required this.url,
    required this.size,
    required this.fallback,
    super.key,
  });

  final String url;
  final double size;
  final Widget fallback;

  @override
  State<BackendRemoteIcon> createState() => _BackendRemoteIconState();
}

class _BackendRemoteIconState extends State<BackendRemoteIcon> {
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
      responseType: ResponseType.bytes,
      validateStatus: (status) => status != null && status < 500,
      headers: const {'Accept': '*/*'},
    ),
  );

  late Future<_Payload?> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetch(ApiConfig.resolvePublicUrl(widget.url) ?? widget.url);
  }

  @override
  void didUpdateWidget(covariant BackendRemoteIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      setState(() {
        _future = _fetch(ApiConfig.resolvePublicUrl(widget.url) ?? widget.url);
      });
    }
  }

  static Future<_Payload?> _fetch(String url) async {
    try {
      final res = await _dio
          .get<List<int>>(url)
          .timeout(const Duration(seconds: 10));
      if (res.statusCode != 200 || res.data == null) return null;
      final bytes = Uint8List.fromList(res.data!);
      final lower = url.toLowerCase();
      final asSvg = lower.contains('.svg') || _looksLikeSvg(bytes);
      if (asSvg) {
        final s = utf8.decode(bytes, allowMalformed: true);
        if (s.trim().isEmpty) return null;
        return _Payload.svg(s);
      }
      return _Payload.raster(bytes);
    } catch (_) {
      return null;
    }
  }

  static bool _looksLikeSvg(Uint8List b) {
    if (b.length < 4) return false;
    final take = min(256, b.length);
    final head = String.fromCharCodes(b.sublist(0, take)).trimLeft();
    return head.startsWith('<svg') ||
        head.startsWith('<?xml') ||
        head.contains('<svg');
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    return FutureBuilder<_Payload?>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return SizedBox(width: s, height: s, child: widget.fallback);
        }
        final loaded = snap.data;
        if (loaded == null) {
          return SizedBox(width: s, height: s, child: widget.fallback);
        }
        if (loaded.svg != null) {
          return SvgPicture.string(
            loaded.svg!,
            width: s,
            height: s,
            fit: BoxFit.contain,
            allowDrawingOutsideViewBox: true,
          );
        }
        return Image.memory(
          loaded.bytes!,
          width: s,
          height: s,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
          isAntiAlias: true,
          errorBuilder: (_, __, ___) =>
              SizedBox(width: s, height: s, child: widget.fallback),
        );
      },
    );
  }
}

class _Payload {
  _Payload._({this.svg, this.bytes})
      : assert(svg != null || bytes != null);

  final String? svg;
  final Uint8List? bytes;

  factory _Payload.svg(String s) => _Payload._(svg: s);
  factory _Payload.raster(Uint8List b) => _Payload._(bytes: b);
}
