import 'dart:math' as math;

import 'package:flashcard/domain/models/flashcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/study_card_colors.dart';
import '../view_models/study_view_model.dart';
import 'session_complete_view.dart';
import 'widgets/card_back_content.dart';
import 'widgets/card_decorations.dart';
import 'widgets/card_front_content.dart';
import 'widgets/card_top_bar.dart';

class FlashcardView extends StatefulWidget {
  const FlashcardView({super.key});

  static const routeName = '/study';

  @override
  State<FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends State<FlashcardView>
    with SingleTickerProviderStateMixin {
  late final PageController _pageCtrl;
  late final AnimationController _flipCtrl;
  late final Animation<double> _flipAnim;

  bool _showingBack = false;
  bool _navigatingFromRating = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
    _pageCtrl = PageController();
    _flipCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flipAnim = CurvedAnimation(parent: _flipCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _flipCtrl.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  // -- Flip --------------------------------------------------------------------
  void _handleTap() {
    context.read<StudyViewModel>().flipCard();
    if (_showingBack) {
      _flipCtrl.reverse();
      setState(() => _showingBack = false);
    } else {
      _flipCtrl.forward(from: 0);
      setState(() => _showingBack = true);
    }
  }

  // -- Page-change from manual swipe ------------------------------------------
  void _onPageChanged(int index) {
    if (_navigatingFromRating) return;
    final vm = context.read<StudyViewModel>();
    vm.setIndex(index);
    _flipCtrl.reset();
    setState(() => _showingBack = false);
  }

  // -- Rating ? auto-advance page ---------------------------------------------
  Future<void> _onRate(int mp) async {
    final vm = context.read<StudyViewModel>();
    final isLast = vm.currentIndex == vm.totalCards - 1;
    vm.rate(mp);
    _flipCtrl.reset();
    setState(() => _showingBack = false);
    if (!isLast && mounted) {
      _navigatingFromRating = true;
      await _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      _navigatingFromRating = false;
    }
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
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          color: bgColor,
          child: Stack(
            children: [
              // Decorations — fixed behind everything
              const Positioned(top: -30, right: -30, child: CornerOrb(size: 200)),
              const Positioned(bottom: 100, left: -40, child: CornerOrb(size: 160)),
              const Positioned(top: 200, right: -10, child: CornerDots()),
              const Positioned(bottom: 220, left: 20, child: CornerDots()),

              SafeArea(
                child: Column(
                  children: [
                    // Fixed top bar — never flips or slides with cards
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 48, 32, 8),
                      child: CardTopBar(isReview: isReview),
                    ),
                    // Card list via PageView
                    Expanded(
                      child: PageView.builder(
                        controller: _pageCtrl,
                        onPageChanged: _onPageChanged,
                        itemCount: vm.totalCards,
                        itemBuilder: (ctx, index) {
                          final card = vm.cards[index];
                          final cardIsReview =
                              vm.isReviewAgainForCard(card.id);
                          final isCurrent = index == vm.currentIndex;
                          return GestureDetector(
                            onTap: isCurrent ? _handleTap : null,
                            behavior: HitTestBehavior.opaque,
                            child: _buildFlipCard(card, cardIsReview, isCurrent),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlipCard(Flashcard card, bool isReview, bool isCurrent) {
    // Adjacent (off-screen) pages just show the front
    if (!isCurrent) {
      return CardFrontContent(card: card, isReview: isReview);
    }
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
              ? CardBackContent(
                  card: card,
                  isReview: isReview,
                  onRate: _onRate,
                )
              : CardFrontContent(card: card, isReview: isReview),
        );
      },
    );
  }
}
