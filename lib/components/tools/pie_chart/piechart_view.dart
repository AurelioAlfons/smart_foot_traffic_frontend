// ====================================================
// Pie Chart View (Web Only)
// ----------------------------------------------------
// - Embeds HTML iframe to show pie chart URL
// - Registers a unique view ID for each chart
// - Shows loader until iframe finishes loading
// ====================================================

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

// ✅ Correct import for web-only platformViewRegistry
import 'dart:ui_web' as ui; // ✅

class PieChartView extends StatefulWidget {
  final String url;

  const PieChartView({super.key, required this.url});

  @override
  State<PieChartView> createState() => _PieChartViewState();
}

class _PieChartViewState extends State<PieChartView> {
  bool _isLoaded = false;
  late String viewID;

  @override
  void initState() {
    super.initState();
    viewID = widget.url.hashCode.toString();
    _registerIframe(widget.url, viewID);

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && !_isLoaded) {
        print("[PieChartView] Fallback: iframe didn't load in time.");
        setState(() => _isLoaded = true);
      }
    });
  }

  @override
  void didUpdateWidget(covariant PieChartView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.url != widget.url && kIsWeb) {
      final newViewID = widget.url.hashCode.toString();
      _registerIframe(widget.url, newViewID);

      setState(() {
        _isLoaded = false;
        viewID = newViewID;
      });

      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && !_isLoaded) {
          print("[PieChartView] Fallback: updated iframe didn't load in time.");
          setState(() => _isLoaded = true);
        }
      });
    }
  }

  void _registerIframe(String url, String id) {
    if (!kIsWeb) return;

    final iframe = html.IFrameElement()
      ..src = url
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..allow = 'fullscreen'
      ..onLoad.listen((_) {
        html.window.dispatchEvent(html.Event('resize'));
        print("[PieChartView] Iframe loaded successfully.");
        if (mounted) {
          setState(() => _isLoaded = true);
        }
      });

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(id, (int viewId) => iframe);
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return const Center(
        child: Text('Pie chart is only supported on Flutter Web'),
      );
    }

    return Stack(
      children: [
        HtmlElementView(
          viewType: viewID,
          key: ValueKey(widget.url),
        ),
        if (!_isLoaded)
          Positioned.fill(
            child: ColoredBox(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.yellow[700],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
