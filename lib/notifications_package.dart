import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class NotificationWidget {
  static final List<OverlayEntry> _overlayEntries = [];
  static final List<Timer> _timers = [];

  static void showNotification({
    required BuildContext context,
    required Widget title,
    required Widget message,
    double? width,
    double? height = 150,
    Alignment alignment = Alignment.bottomRight,
    double? radius,
    Color? backgroundColor,
    Color textColor = Colors.black,
    Color? borderColor,
    double? borderWidth,
    Duration showDuration = const Duration(seconds: 5),
    String? tooltip,
    double? cardOpacity,
    bool? cardWithBlur = false,
    EdgeInsetsGeometry? padding,
  }) {
    late final OverlayEntry overlayEntry;
    final double bottomOffset = _overlayEntries.length *
        (height! + 10); // +10 para un pequeño espacio entre notificaciones

    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
          bottom: bottomOffset,
          left: 0,
          right: 0,
          child: Align(
            alignment: alignment,
            child: Material(
              color: Colors.transparent,
              child: Container(
                key: const Key('notificationContainer'),
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 500),
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  curve: Curves.easeInOut,
                  builder: (BuildContext context, double value, Widget? child) {
                    return Transform.translate(
                      offset: Offset(100 * (1 - value), 0),
                      child: Opacity(
                        opacity: value,
                        child: cardWithBlur == true
                            ? ClipRRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 1.0, sigmaY: 1.0),
                                  child: Container(
                                    height: height,
                                    width: width,
                                    padding:
                                        padding ?? const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: backgroundColor?.withOpacity(
                                              cardOpacity ?? 0.7) ??
                                          Colors.grey
                                              .withOpacity(cardOpacity ?? 0.7),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(radius ?? 10),
                                      ),
                                      border: Border.all(
                                        width: borderWidth ?? 0.0,
                                        color:
                                            borderColor ?? Colors.transparent,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 8.0),
                                                    child: Icon(Icons.alarm),
                                                  ),
                                                  title,
                                                ],
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: IconButton(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                onPressed: () {
                                                  _removeNotification(
                                                      overlayEntry);
                                                },
                                                icon: const Icon(Icons.close),
                                                tooltip: tooltip,
                                              ),
                                            ),
                                          ],
                                        ),
                                        message,
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                height: height,
                                width: width,
                                padding: padding ?? const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: backgroundColor ?? Colors.grey,
                                  border: Border.all(
                                    width: borderWidth ?? 0.0,
                                    color: borderColor ?? Colors.transparent,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(radius ?? 10),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: title),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                            padding: const EdgeInsets.all(0.0),
                                            onPressed: () {
                                              _removeNotification(overlayEntry);
                                            },
                                            icon: const Icon(Icons.close),
                                            tooltip: tooltip,
                                          ),
                                        ),
                                      ],
                                    ),
                                    message,
                                  ],
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Overlay.of(context).insert(overlayEntry);
      _overlayEntries.add(overlayEntry);

      final timer = Timer(showDuration, () {
        _removeNotification(overlayEntry);
      });
      _timers.add(timer);
    });
  }

  static void _removeNotification(OverlayEntry overlayEntry) {
    overlayEntry.remove();
    int index = _overlayEntries.indexOf(overlayEntry);
    if (index != -1) {
      _overlayEntries.removeAt(index);
      _timers[index].cancel();
      _timers.removeAt(index);
    }

    // Ajustar las posiciones de las notificaciones restantes
    for (int i = 0; i < _overlayEntries.length; i++) {
      _overlayEntries[i].markNeedsBuild();
    }
  }

  static void cancelAllTimers() {
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();
  }
}
