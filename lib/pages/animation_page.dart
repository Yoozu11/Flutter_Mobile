import 'package:flutter/material.dart';

const _background = Color(0xFF202957);
const _card = Color(0xFF29396D);
const _text = Color(0xFFF7F9FF);
const _muted = Color(0xFFC0CBEA);
const _yellow = Color(0xFFFFD166);

class AnimationPage extends StatefulWidget {
  const AnimationPage({super.key});

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  bool isVisible = true;
  bool showDetail = false;
  late final AnimationController controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulse = Tween<double>(
      begin: .82,
      end: 1.18,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void toggleSize() => setState(() => isExpanded = !isExpanded);

  void toggleVisibility() => setState(() => isVisible = !isVisible);

  void toggleDetail() => setState(() => showDetail = !showDetail);

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _background,
    appBar: AppBar(
      title: const Text('Animation Lab'),
      backgroundColor: _background,
      foregroundColor: _text,
    ),
    body: DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_background, Color(0xFF31577E), Color(0xFF563F78)],
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _section(
                    title: 'AnimatedContainer',
                    subtitle: 'Ubah ukuran dan warna dengan transisi halus.',
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 450),
                          curve: Curves.easeInOut,
                          width: isExpanded ? 220 : 110,
                          height: isExpanded ? 160 : 110,
                          decoration: BoxDecoration(
                            color: isExpanded
                                ? Colors.orange
                                : const Color(0xFFFF5C67),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (isExpanded
                                            ? Colors.orange
                                            : const Color(0xFFFF5C67))
                                        .withValues(alpha: .3),
                                blurRadius: 22,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: _text,
                            size: 44,
                          ),
                        ),
                        const SizedBox(height: 18),
                        FilledButton(
                          onPressed: toggleSize,
                          child: const Text('Ubah ukuran & warna'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _section(
                    title: 'AnimatedOpacity',
                    subtitle: 'Tampilkan atau sembunyikan ikon.',
                    child: Column(
                      children: [
                        AnimatedOpacity(
                          opacity: isVisible ? 1 : 0,
                          duration: const Duration(milliseconds: 500),
                          child: const Icon(
                            Icons.favorite_rounded,
                            color: Colors.redAccent,
                            size: 70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FilledButton.tonal(
                          onPressed: toggleVisibility,
                          child: const Text('Tampil / Sembunyi'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _section(
                    title: 'AnimatedCrossFade',
                    subtitle: 'Ganti tampilan detail dengan crossfade.',
                    child: Column(
                      children: [
                        AnimatedCrossFade(
                          firstChild: const Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              'Detail disembunyikan',
                              style: TextStyle(color: _muted),
                            ),
                          ),
                          secondChild: const Column(
                            children: [
                              Text('Nama: Mahasiswa'),
                              SizedBox(height: 6),
                              Text('Status: Aktif'),
                            ],
                          ),
                          crossFadeState: showDetail
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 350),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.tonal(
                          onPressed: toggleDetail,
                          child: const Text('Toggle Detail'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _section(
                    title: 'AnimationController & Hero',
                    subtitle:
                        'Controller menggerakkan ikon. Ketuk untuk membuka '
                        'halaman tujuan Hero.',
                    child: Column(
                      children: [
                        ScaleTransition(
                          key: const ValueKey('controller-pulse'),
                          scale: _pulse,
                          child: const Hero(
                            tag: 'animation-lab-school',
                            child: Icon(
                              Icons.school_rounded,
                              color: _yellow,
                              size: 72,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          runSpacing: 8,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {
                                setState(() {
                                  if (controller.isAnimating) {
                                    controller.stop();
                                  } else {
                                    controller.repeat(reverse: true);
                                  }
                                });
                              },
                              icon: Icon(
                                controller.isAnimating
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                              ),
                              label: Text(
                                controller.isAnimating ? 'Jeda' : 'Putar',
                              ),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const AnimationHeroDetail(),
                                ),
                              ),
                              child: const Text('Buka halaman Hero'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _section({
    required String title,
    required String subtitle,
    required Widget child,
  }) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: _card.withValues(alpha: .94),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: _text.withValues(alpha: .12)),
    ),
    child: Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _text,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _muted, fontSize: 12),
        ),
        const SizedBox(height: 18),
        child,
      ],
    ),
  );
}

class AnimationHeroDetail extends StatelessWidget {
  const AnimationHeroDetail({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _background,
    appBar: AppBar(
      title: const Text('Hero Detail'),
      backgroundColor: _background,
      foregroundColor: _text,
    ),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Hero(
            tag: 'animation-lab-school',
            child: Icon(Icons.school_rounded, color: _yellow, size: 180),
          ),
          const SizedBox(height: 24),
          const Text(
            'Hero animation berhasil!',
            style: TextStyle(
              color: _text,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Kembali'),
          ),
        ],
      ),
    ),
  );
}
