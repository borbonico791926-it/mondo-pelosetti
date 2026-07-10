import 'package:flutter_test/flutter_test.dart';
import 'package:mondo_pelosetti/main.dart';

void main() {
  testWidgets('Mondo Pelosetti si avvia', (WidgetTester tester) async {
    await tester.pumpWidget(const MondoPelosettiApp());

    expect(find.text('Mondo Pelosetti'), findsOneWidget);
  });
}