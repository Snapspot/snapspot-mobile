import 'dart:async';
import 'package:flutter/material.dart';

/// A customizable, auto-playing carousel widget built from scratch.
///
/// This widget displays a set of items in a horizontally scrollable `PageView`
/// that automatically transitions between pages. It also includes page indicators.
class CustomCarousel extends StatefulWidget {
  /// The total number of items in the carousel.
  final int itemCount;

  /// A builder function that creates the widget for each item in the carousel.
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// The height of the carousel widget.
  final double height;

  /// Whether the carousel should automatically play. Defaults to `true`.
  final bool autoPlay;

  /// The duration for the auto-play transition. Defaults to 5 seconds.
  final Duration autoPlayDuration;

  /// Whether to show the page indicator dots. Defaults to `true`.
  final bool showIndicator;

  /// The color of the active indicator dot. Defaults to `Colors.white`.
  final Color activeIndicatorColor;

  /// The color of inactive indicator dots. It's nullable for a default.
  final Color? indicatorColor;

  const CustomCarousel({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.height,
    this.autoPlay = true,
    this.autoPlayDuration = const Duration(seconds: 5),
    this.showIndicator = true,
    this.activeIndicatorColor = Colors.white,
    this.indicatorColor,
  });

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  late final PageController _pageController;
  Timer? _carouselTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Only start the timer if autoPlay is enabled and there's more than one item
    if (widget.autoPlay && widget.itemCount > 1) {
      _startCarouselTimer();
    }
  }

  void _startCarouselTimer() {
    _carouselTimer?.cancel(); // Cancel any existing timer
    _carouselTimer = Timer.periodic(widget.autoPlayDuration, (timer) {
      if (_pageController.hasClients) {
        // Calculate the next page, looping back to the start if at the end
        int nextPage = (_currentPage + 1) % widget.itemCount;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount == 0) {
      return SizedBox(height: widget.height); // Return empty container if no items
    }

    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.itemCount,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: widget.itemBuilder,
          ),
          if (widget.showIndicator && widget.itemCount > 1)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.itemCount, (i) {
                  return GestureDetector(
                    // Allow tapping on dots to change page
                    onTap: () => _pageController.animateToPage(
                      i,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      height: 8,
                      width: _currentPage == i ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == i
                            ? widget.activeIndicatorColor
                            : widget.indicatorColor ?? Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}