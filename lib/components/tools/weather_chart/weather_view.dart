import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:ui' as ui;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class WeatherChartView extends StatefulWidget {
  final String url;

  const WeatherChartView({super.key, required this.url});

  @override
  State<WeatherChartView> createState() => _WeatherChartViewState();
}

class _WeatherChartViewState extends State<WeatherChartView> {
  bool _isLoaded = false;
  late String viewID;

  @override
  void initState() {
    super.initState();
    viewID = widget.url.hashCode.toString();
    _registerIframe(widget.url, viewID);

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && !_isLoaded) {
        print("[WeatherChartView] Fallback: iframe didn't load in time.");
        setState(() => _isLoaded = true);
      }
    });
  }

  @override
  void didUpdateWidget(covariant WeatherChartView oldWidget) {
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
          print(
              "[WeatherChartView] Fallback: updated iframe didn't load in time.");
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
        print("[WeatherChartView] Iframe loaded successfully.");
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
        child: Text('Weather chart is only supported on Flutter Web'),
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
