import 'package:example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the IP country lookup action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const IpCountryLookupExampleApp());

    expect(find.text('IP Country Lookup'), findsOneWidget);
    expect(find.text('Get country data from IP'), findsOneWidget);
  });
}
