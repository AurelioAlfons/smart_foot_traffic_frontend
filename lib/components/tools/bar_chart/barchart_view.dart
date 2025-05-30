// ====================================================
// Bar Chart View (Web Only)
// ----------------------------------------------------
// - Embeds HTML iframe to show bar chart URL
// - Registers a unique view ID for each chart
// - Shows loader until iframe finishes loading
// ====================================================

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// ✅ Use web-specific libraries for iframe
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:ui_web' as ui; // ✅ Updated from 'dart:ui' to 'dart:ui_web'

class BarChartView extends StatefulWidget {
  final String url;

  const BarChartView({super.key, required this.url});

  @override
  State<BarChartView> createState() => _BarChartViewState();
}

class _BarChartViewState extends State<BarChartView> {
  bool _isLoaded = false;
  late String viewID;

  @override
  void initState() {
    super.initState();
    viewID = widget.url.hashCode.toString();
    _registerIframe(widget.url, viewID); // ✅
  }

  @override
  void didUpdateWidget(covariant BarChartView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.url != widget.url && kIsWeb) { // ✅
      final newViewID = widget.url.hashCode.toString();
      _registerIframe(widget.url, newViewID); // ✅

      setState(() {
        _isLoaded = false;
        viewID = newViewID;
      });
    }
  }

  void _registerIframe(String url, String id) {
    if (!kIsWeb) return; // ✅ only for web

    final iframe = html.IFrameElement()
      ..src = url
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..allow = 'fullscreen'
      ..onLoad.listen((_) {
        html.window.dispatchEvent(html.Event('resize'));
        if (mounted) {
          setState(() => _isLoaded = true); // ✅ loader toggle
        }
      });

    // ✅ register the iframe element to be rendered in Flutter web
    ui.platformViewRegistry.registerViewFactory(id, (int viewId) => iframe); // ✅
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return const Center(
        child: Text('Bar chart is only supported on Flutter Web'),
      );
    }

    return Stack(
      children: [
        HtmlElementView(
          viewType: viewID,
          key: ValueKey(widget.url),
        ),
        if (!_isLoaded)
          const Positioned.fill(
            child: ColoredBox(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}