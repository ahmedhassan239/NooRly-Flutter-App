import 'dart:convert';
import 'dart:math' show min;
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/core/config/api_config.dart';
import 'package:flutter_app/core/utils/content_icon_mapper.dart';
import 'package:flutter_app/features/ramadan_guide/data/ramadan_guide_models.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renders a Ramadan guide item icon from [RamadanGuideItemModel.iconUrl] when set
/// (SVG or raster), otherwise falls back to bundled SVG / Lucide via [iconKey].
///
/// Network SVG uses [Dio] + [SvgPicture.string] instead of [SvgPicture.network],
/// because on Flutter Web the latter often stays on [placeholderBuilder] forever
/// when CORS or fetch fails (no error path to the placeholder).
class RamadanGuideItemIcon extends StatelessWidget {
  const RamadanGuideItemIcon({
    required this.item,
    required this.tint,
    super.key,
    this.size = 28,
  });

  final RamadanGuideItemModel item;
  final Color tint;
  final double size;

  @override
  Widget build(BuildContext context) {
    final resolved = ApiConfig.resolvePublicUrl(item.iconUrl);
    if (resolved != null && resolved.isNotEmpty) {
      return _RamadanResolvedNetworkIcon(
        url: resolved,
        item: item,
        tint: tint,
        size: size,
      );
    }

    final assetPath = ramadanSvgAssetFromKey(item.iconKey);
    if (assetPath != null) {
      return SvgPicture.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(tint, BlendMode.srcIn),
      );
    }
    return _lucideFallback(item.iconKey, size, tint);
  }
}

Widget _lucideFallback(String iconKey, double size, Color tint) {
  return Icon(
    ramadanGuideLucideFromKey(iconKey),
    size: size,
    color: tint,
  );
}

class _LoadedRemoteIcon {
  _LoadedRemoteIcon._({this.svg, this.bytes})
      : assert(svg != null || bytes != null);

  final String? svg;
  final Uint8List? bytes;

  factory _LoadedRemoteIcon.svg(String s) => _LoadedRemoteIcon._(svg: s);
  factory _LoadedRemoteIcon.raster(Uint8List b) => _LoadedRemoteIcon._(bytes: b);
}

/// Fetches icon bytes with a timeout; shows Lucide while loading or on failure.
class _RamadanResolvedNetworkIcon extends StatefulWidget {
  const _RamadanResolvedNetworkIcon({
    required this.url,
    required this.item,
    required this.tint,
    required this.size,
  });

  final String url;
  final RamadanGuideItemModel item;
  final Color tint;
  final double size;

  @override
  State<_RamadanResolvedNetworkIcon> createState() =>
      _RamadanResolvedNetworkIconState();
}

class _RamadanResolvedNetworkIconState extends State<_RamadanResolvedNetworkIcon> {
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
      responseType: ResponseType.bytes,
      validateStatus: (status) => status != null && status < 500,
      headers: const {'Accept': '*/*'},
    ),
  );

  late Future<_LoadedRemoteIcon?> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetch(widget.url);
  }

  @override
  void didUpdateWidget(covariant _RamadanResolvedNetworkIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      setState(() {
        _future = _fetch(widget.url);
      });
    }
  }

  static Future<_LoadedRemoteIcon?> _fetch(String url) async {
    try {
      final res = await _dio
          .get<List<int>>(url)
          .timeout(const Duration(seconds: 10));
      if (res.statusCode != 200 || res.data == null) return null;
      final bytes = Uint8List.fromList(res.data!);
      final lower = url.toLowerCase();
      final treatAsSvg =
          lower.contains('.svg') || _bytesLookLikeSvg(bytes);
      if (treatAsSvg) {
        final s = utf8.decode(bytes, allowMalformed: true);
        if (s.trim().isEmpty) return null;
        return _LoadedRemoteIcon.svg(s);
      }
      return _LoadedRemoteIcon.raster(bytes);
    } catch (_) {
      return null;
    }
  }

  static bool _bytesLookLikeSvg(Uint8List b) {
    if (b.length < 4) return false;
    final take = min(256, b.length);
    final head = String.fromCharCodes(b.sublist(0, take)).trimLeft();
    return head.startsWith('<svg') ||
        head.startsWith('<?xml') ||
        head.contains('<svg');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_LoadedRemoteIcon?>(
      future: _future,
      builder: (context, snap) {
        // While loading: show Lucide (no endless spinner — matches final fallback).
        if (snap.connectionState != ConnectionState.done) {
          return _lucideFallback(widget.item.iconKey, widget.size, widget.tint);
        }

        final loaded = snap.data;
        if (loaded == null) {
          return _lucideFallback(widget.item.iconKey, widget.size, widget.tint);
        }

        if (loaded.svg != null) {
          return SvgPicture.string(
            loaded.svg!,
            width: widget.size,
            height: widget.size,
            fit: BoxFit.contain,
            allowDrawingOutsideViewBox: true,
          );
        }

        return Image.memory(
          loaded.bytes!,
          width: widget.size,
          height: widget.size,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
          isAntiAlias: true,
          errorBuilder: (_, __, ___) =>
              _lucideFallback(widget.item.iconKey, widget.size, widget.tint),
        );
      },
    );
  }
}
