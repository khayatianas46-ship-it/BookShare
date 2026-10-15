
import 'package:flutter_test/flutter_test.dart';
import 'package:devmob_bookshare/main.dart';

void main() {
  testWidgets('BookShare affiche son application', (WidgetTester tester) async {
    await tester.pumpWidget(const BookShareApp());

    expect(find.text('BookShare'), findsWidgets);
  });
}
