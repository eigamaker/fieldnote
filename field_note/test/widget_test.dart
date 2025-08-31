// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:field_note/main.dart';

void main() {
  testWidgets('FIELD NOTE app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FieldNoteApp());

    // Verify that the app title is displayed.
    expect(find.text('FIELD NOTE'), findsOneWidget);
    expect(find.text('野球スカウトゲーム'), findsOneWidget);
    
    // Verify that the new game button is displayed.
    expect(find.text('新規ゲーム開始'), findsOneWidget);
    
    // Verify that the settings button is displayed.
    expect(find.text('設定'), findsOneWidget);
  });
}
