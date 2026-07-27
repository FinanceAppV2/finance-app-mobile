import 'package:flutter/material.dart';

class ShimmerLoading extends StatefulWidget {
  final Widget child;

  const ShimmerLoading({super.key, required this.child});

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, child) => ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) {
          final w = bounds.width;
          final dx = _animation.value * w;
          final s0 = ((dx - 80) / w).clamp(0.0, 1.0);
          final s1 = (dx / w).clamp(0.0, 1.0);
          final s2 = ((dx + 80) / w).clamp(0.0, 1.0);
          return LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: const [
              Color(0xFF3A3D3A),
              Color(0xFF7A7D7A),
              Color(0xFF3A3D3A),
            ],
            stops: [s0, s1, s2],
          ).createShader(bounds);
        },
        child: child!,
      ),
      child: widget.child,
    );
  }
}

class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class SkeletonSummaryCard extends StatelessWidget {
  const SkeletonSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: const Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _SkeletonMainInfo()),
                SizedBox(width: 12),
                Expanded(child: _SkeletonMainInfo()),
              ],
            ),
            SizedBox(height: 12),
            _SkeletonProgress(),
          ],
        ),
      ),
    );
  }
}

class _SkeletonMainInfo extends StatelessWidget {
  const _SkeletonMainInfo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 50, height: 10),
          SizedBox(height: 10),
          SkeletonBox(width: 80, height: 18),
        ],
      ),
    );
  }
}

class _SkeletonProgress extends StatelessWidget {
  const _SkeletonProgress();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SkeletonBox(width: 16, height: 16),
                  SizedBox(width: 6),
                  SkeletonBox(width: 100, height: 10),
                ],
              ),
              SkeletonBox(width: 30, height: 10),
            ],
          ),
          SizedBox(height: 8),
          SkeletonBox(width: double.infinity, height: 6, borderRadius: 4),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonBox(width: 80, height: 9),
              SkeletonBox(width: 80, height: 9),
              SkeletonBox(width: 80, height: 9),
            ],
          ),
        ],
      ),
    );
  }
}

class SkeletonExpenseTile extends StatelessWidget {
  const SkeletonExpenseTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
          child: Row(
            children: [
              const SkeletonBox(width: 40, height: 40, borderRadius: 10),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(width: 140, height: 13),
                    SizedBox(height: 9),
                    Row(
                      children: [
                        SkeletonBox(width: 60, height: 9),
                        SizedBox(width: 8),
                        SkeletonBox(width: 50, height: 9),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SkeletonBox(width: 65, height: 13),
                  SizedBox(height: 7),
                  SkeletonBox(width: 55, height: 9),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SkeletonScreen extends StatelessWidget {
  const SkeletonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
          child: Column(
            children: const [
              SkeletonSummaryCard(),
              SizedBox(height: 36),
              _SkeletonExpensesHeader(),
              SizedBox(height: 16),
              SkeletonExpenseTile(),
              SkeletonExpenseTile(),
              SkeletonExpenseTile(),
              SkeletonExpenseTile(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonExpensesHeader extends StatelessWidget {
  const _SkeletonExpensesHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        SkeletonBox(width: 140, height: 16),
        SkeletonBox(width: 36, height: 36, borderRadius: 10),
      ],
    );
  }
}

class SkeletonCardsPage extends StatelessWidget {
  const SkeletonCardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 50, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              SkeletonBox(width: 120, height: 18),
              SkeletonBox(width: 80, height: 28, borderRadius: 20),
            ],
          ),
          const SizedBox(height: 16),
          const _SkeletonCard(),
          const _SkeletonCard(),
        ],
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SkeletonBox(width: 24, height: 24, borderRadius: 6),
                  SizedBox(width: 8),
                  SkeletonBox(width: 100, height: 16),
                ],
              ),
              SkeletonBox(width: 20, height: 20, borderRadius: 10),
            ],
          ),
          SizedBox(height: 20),
          SkeletonBox(width: 160, height: 16),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(width: 40, height: 9),
                  SizedBox(height: 4),
                  SkeletonBox(width: 80, height: 11),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SkeletonBox(width: 70, height: 9),
                  SizedBox(height: 4),
                  SkeletonBox(width: 85, height: 11),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonBox(width: 65, height: 9),
              SkeletonBox(width: 65, height: 9),
              SkeletonBox(width: 50, height: 9),
            ],
          ),
        ],
      ),
    );
  }
}
