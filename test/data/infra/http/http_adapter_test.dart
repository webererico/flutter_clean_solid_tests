import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

class ClientSpy extends Mock implements Client {}

class HttpAdapter {
  final Client? client;
  HttpAdapter(this.client);
  Future<void>? request({required String? url, required String? method, Map? body}) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final jsonBody = body != null ? jsonEncode(body) : null;
    await client?.post(
      Uri.parse(url!),
      headers: headers,
      body: jsonBody,
    );
  }
}

void main() {
  late ClientSpy client = ClientSpy();
  late String url = faker.internet.httpUrl();
  late HttpAdapter sut = HttpAdapter(client);
  setUp(() {
    client = ClientSpy();
    url = faker.internet.httpUrl();
    sut = HttpAdapter(client);
  });

  group('post', () {
    test('Should call post with correct values', () async {
      await sut.request(
        url: url,
        method: 'post',
        body: {'any_key': 'any_value'},
      );
      verify(client.post(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
        body: '{"any_key": "any_value"}',
      ));
    });

    test('Should call post with wihtout', () async {
      await sut.request(url: url, method: 'post');
      verify(
        client.post(
          Uri(),
          headers: anyNamed('headers'),
        ),
      );
    });
    test('Should return data if post returns 200', () async {
      await sut.request(
        url: url,
        method: 'post',
      );
      verify(
        client.post(
          Uri(),
          headers: anyNamed('headers'),
        ),
      );
    });
  });
}
