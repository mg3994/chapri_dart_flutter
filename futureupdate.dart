



class _ChapriHorizSliderState extends State<ChapriHorizSlider>
    with SingleTickerProviderStateMixin {
  double scrollPercentage = 0;
  double trackbarPosition = 0; // New variable to track trackbar position
  bool isDragging = false; // Flag to indicate if the trackbar is being dragged

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (!isDragging) {
      setState(() {
        scrollPercentage = widget.scrollController!.position.pixels /
            widget.scrollController!.position.maxScrollExtent;
        trackbarPosition = scrollPercentage * (widget.sliderLength! - widget.trackbarLength!);
      });
    }
  }

  void _startDrag(details) {
    setState(() {
      isDragging = true;
    });
    _updateDrag(details);
  }

  void _updateDrag(details) {
    final trackbarWidth = widget.sliderLength! - widget.trackbarLength!;
    final newPosition = (details.globalPosition.dx - widget.trackbarLength! / 2).clamp(0.0, trackbarWidth);
    setState(() {
      trackbarPosition = newPosition;
      scrollPercentage = trackbarPosition / trackbarWidth;
    });
    final scrollPosition = scrollPercentage * widget.scrollController!.position.maxScrollExtent;
    widget.scrollController!.jumpTo(scrollPosition);
  }

  void _endDrag() {
    setState(() {
      isDragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // GestureDetector to handle trackbar dragging
      onHorizontalDragStart: _startDrag,
      onHorizontalDragUpdate: _updateDrag,
      onHorizontalDragEnd: (_) => _endDrag(),
      child: Container(
        width: widget.sliderLength!.toDouble(),
        height: widget.sliderHeight?.toDouble(),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(widget.sliderHeight!.toDouble() / 2),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: widget.animationDuration!,
              top: 0,
              bottom: 0,
              left: trackbarPosition,
              child: Container(
                width: widget.trackbarLength?.toDouble(),
                height: widget.sliderHeight?.toDouble(),
                decoration: BoxDecoration(
                  color: widget.trackbarColor,
                  borderRadius: BorderRadius.circular(widget.sliderHeight!.toDouble() / 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
