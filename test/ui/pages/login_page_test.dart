import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:vibe/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  late LoginPresenter presenter;
  late StreamController<String?> emailErrorController;
  late StreamController<String?> passwordErrorController;
  late StreamController<bool?> isFormValidController;
  late StreamController<bool?> isLoadingController;
  late StreamController<String?> mainErrorController;

  void initStreams() {
    emailErrorController = StreamController<String?>();
    passwordErrorController = StreamController<String?>();
    isFormValidController = StreamController<bool?>();
    isLoadingController = StreamController<bool?>();
    mainErrorController = StreamController<String?>();
  }

  void mockStreams() {
    when(presenter.emailErrorStream).thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);
    when(presenter.isFormValidStream).thenAnswer((_) => isFormValidController.stream);
    when(presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
    when(presenter.mainErrorStream).thenAnswer((_) => mainErrorController.stream);
  }

  void closeStreams() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    initStreams();
    mockStreams();
    final loginPage = MaterialApp(
      home: LoginPage(presenter),
    );
    await tester.pumpWidget(loginPage);
  }

  tearDown(() => closeStreams());

  setUp(() {});
  testWidgets('Should load with correct initial state', (WidgetTester tester) async {
    await loadPage(tester);
    final emailTextChildren = find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    final passwordTextChildren = find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(emailTextChildren, findsOneWidget);
    expect(passwordTextChildren, findsOneWidget);
    expect(button.onPressed, null);
  });

  testWidgets('Should call validate with correct values', (WidgetTester tester) async {
    await loadPage(tester);
    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(presenter.validatePassword(password));
  });

  testWidgets('Should present error if email is invalid', (WidgetTester tester) async {
    await loadPage(tester);
    emailErrorController.add('any error');
    await tester.pump();
    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('Should present no error if email is valid', (WidgetTester tester) async {
    await loadPage(tester);
    emailErrorController.add(null);
    await tester.pump();
    expect(find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text)), findsOneWidget);
  });

  testWidgets('Should present error if password is invalid', (WidgetTester tester) async {
    await loadPage(tester);
    await tester.pump();
    passwordErrorController.add(null);
    expect(find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text)), findsOneWidget);
  });

  testWidgets('Should present no error if password is valid', (WidgetTester tester) async {
    await loadPage(tester);
    passwordErrorController.add('');
    await tester.pump();
    expect(find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text)), findsOneWidget);
  });

  testWidgets('Should enable button if form is valid', (WidgetTester tester) async {
    await loadPage(tester);
    isFormValidController.add(true);
    await tester.pump();
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Should disable button if form is invalid', (WidgetTester tester) async {
    await loadPage(tester);
    isFormValidController.add(false);
    await tester.pump();
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);
  });
  testWidgets('Should call authentication on form submit', (WidgetTester tester) async {
    await loadPage(tester);
    isFormValidController.add(true);
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    verify(presenter.auth()).called(1);
  });

  testWidgets('Should present loading', (WidgetTester tester) async {
    await loadPage(tester);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should hide loading', (WidgetTester tester) async {
    await loadPage(tester);
    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    isLoadingController.add(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should present error message if  authentication fails', (WidgetTester tester) async {
    const errorMessage = 'main error';
    await loadPage(tester);
    mainErrorController.add(errorMessage);
    await tester.pump();
    expect(find.text(errorMessage), findsOneWidget);
    isLoadingController.add(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should close streams on dispose', (WidgetTester tester) async {
    await loadPage(tester);
    addTearDown(() {
      verify(presenter.dispose()).called(1);
    });
  });
}
