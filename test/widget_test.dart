// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:minipokedex/pages/animation_page.dart';
import 'package:minipokedex/main.dart';

void main() {
  testWidgets('Pokédex Noir displays its explore screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NoirApp());

    expect(find.text('POKÉDEX'), findsOneWidget);
    expect(find.text('Pokémon,\nreimagined.'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Animation Lab demonstrates animated widgets', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AnimationPage()));

    expect(find.text('Animation Lab'), findsOneWidget);
    expect(find.byType(AnimatedContainer), findsOneWidget);

    await tester.tap(find.text('Ubah ukuran & warna'));
    await tester.pump();

    expect(
      tester
          .widget<AnimatedContainer>(find.byType(AnimatedContainer))
          .constraints
          ?.maxWidth,
      220,
    );
    expect(find.byType(AnimatedOpacity), findsOneWidget);
    expect(find.byType(AnimatedCrossFade), findsOneWidget);
    expect(find.byKey(const ValueKey('controller-pulse')), findsOneWidget);
  });
}
