import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../view_models/study_view_model.dart';
import 'session_complete_view.dart';
import 'study_card_colors.dart';
import 'widgets/card_back_content.dart';
import 'widgets/card_decorations.dart';
import 'widgets/card_front_content.dart';

// -----------------------------------------------------------------------------
class FlashcardView extends StatefulWidget {
  const FlashcardView({super.key});

  static const routeName = '/study';

  @override
  State<FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends State<FlashcardView>
    with TickerProviderStateMixin {
  late AnimationController _flipCtrl;
  late Animation<double> _flipAnim;
  bool _showingBack = false;

  late AnimationController _slideCtrl;
  late Animation<Offset> _slideOut;
  late Animation<Offset> _slideIn;
  int _slideDirection = 1;

  @override
  void initState() {
    super.initState();
    _flipCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flipAnim = CurvedAnimation(parent: _flipCtrl, curve: Curves.easeInOut);
    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      value: 1.0, // start at end so content is visible immediately
    );
    _buildSlideAnimations();
  }

  void _buildSlideAnimations() {
    _slideOut = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-_slideDirection.toDouble(), 0),
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeIn));
    _slideIn = Tween<Offset>(
      begin: Offset(_slideDirection.toDouble(), 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _flipCtrl.dispose();
    _slideCtrl.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_showingBack) return;
    context.read<StudyViewModel>().flipCard();
    _flipCtrl.forward(from: 0);
    setState(() => _showingBack = true);
  }

  Future<void> _handleSwipeLeft() async {
    _slideDirection = 1;
    _buildSlideAnimations();
    await _slideCtrl.forward(from: 0);
    if (!mounted) return;
    context.read<StudyViewModel>().goNext();
    _flipCtrl.reset();
    setState(() => _showingBack = false);
    _slideCtrl.reset();
  }

  Future<void> _handleSwipeRight() async {
    final vm = context.read<StudyViewModel>();
    if (!vm.canGoBack) return;
    _slideDirection = -1;
    _buildSlideAnimations();
    await _slideCtrl.forward(from: 0);
    if (!mounted) return;
    vm.goBack();
    _flipCtrl.reset();
    setState(() => _showingBack = false);
    _slideCtrl.reset();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StudyViewModel>();

    if (vm.sessionState == StudySessionState.complete) {
      return SessionCompleteView(earnedMp: vm.earnedMp);
    }

    final isReview = vm.isCurrentReviewAgain;
    final bgColor = isReview
        ? kCardColorReview
        : (_showingBack ? kCardColorBack : kCardColorFront);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        extendBodyBehindAppBar: true,
        body: GestureDetector(
          onTap: _handleTap,
          onHorizontalDragEnd: (d) {
            if ((d.primaryVelocity ?? 0) < -300) _handleSwipeLeft();
            if ((d.primaryVelocity ?? 0) > 300) _handleSwipeRight();
          },
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            color: bgColor,
            child: Stack(
              children: [
                const Positioned(top: -30, right: -30, child: CornerOrb(size: 200)),
                const Positioned(bottom: 100, left: -40, child: CornerOrb(size: 160)),
                const Positioned(top: 200, right: -10, child: CornerDots()),
                const Positioned(bottom: 220, left: 20, child: CornerDots()),
                SafeArea(
                  child: SlideTransition(
                    position: _slideIn,
                    child: _buildCard(vm, isReview),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(StudyViewModel vm, bool isReview) {
    return AnimatedBuilder(
      animation: _flipAnim,
      builder: (context, _) {
        final angle = _flipAnim.value * math.pi;
        final showBack = angle > math.pi / 2;
        final displayAngle = showBack ? angle - math.pi : angle;
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(displayAngle),
          alignment: Alignment.center,
          child: showBack
              ? CardBackContent(isReview: isReview)
              : CardFrontContent(isReview: isReview),
        );
      },
    );
  }
}
