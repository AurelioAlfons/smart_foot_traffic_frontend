// ====================================================
// Forecast Chart View (Web Only)
// ----------------------------------------------------
// - Embeds HTML iframe to show forecast chart URL
// - Registers a unique view ID for each chart
// - Shows loader until iframe finishes loading
// ====================================================

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:ui_web' as ui;

class ForecastChartView extends StatefulWidget {
  final String url;

  const ForecastChartView({super.key, required this.url});

  @override
  State<ForecastChartView> createState() => _ForecastChartViewState();
}

class _ForecastChartViewState extends State<ForecastChartView> {
  bool _isLoaded = false;
  late String viewID;

  @override
  void initState() {
    super.initState();
    viewID = widget.url.hashCode.toString();
    _registerIframe(widget.url, viewID);
  }

  @override
  void didUpdateWidget(covariant ForecastChartView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.url != widget.url && kIsWeb) {
      final newViewID = widget.url.hashCode.toString();
      _registerIframe(widget.url, newViewID);

      setState(() {
        _isLoaded = false;
        viewID = newViewID;
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
        if (mounted) {
          setState(() => _isLoaded = true);
        }
      });

    ui.platformViewRegistry.registerViewFactory(id, (int viewId) => iframe);
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return const Center(
        child: Text('Forecast chart is only supported on Flutter Web'),
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
