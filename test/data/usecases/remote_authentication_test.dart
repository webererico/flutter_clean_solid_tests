import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:vibe/data/http/http.dart';
import 'package:vibe/data/usecases/usecases.dart';
import 'package:vibe/domain/helpers/helpers.dart';
import 'package:vibe/domain/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late HttpClientSpy httpClient;
  late String url;
  late RemoteAuthentication sut;
  late AuthenticationParams params;

  PostExpectation _mockRequest() {
    return when(httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body')));
  }

  Map mockValidData() => {'accessToken': faker.guid.guid(), 'name': faker.person.name()};
  void mockHttpData(Map data) => _mockRequest().thenAnswer((_) async => data);
  void mockHttpError(HttpError error) => _mockRequest().thenThrow(error);

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
      email: faker.internet.email(),
      secret: faker.internet.password(),
    );
    mockHttpData(mockValidData());
  });

  test('Should call Http client with correct values', () async {
    await sut.auth(params);
    verify(
      httpClient.request(
        url: url,
        method: 'post',
        body: {
          'email': params.email,
          'password': params.secret,
        },
      ),
    );
  });

  test('Should throw UnexpectedError if HttpClient return 400', () async {
    mockHttpError(HttpError.badRequest);
    final future = sut.auth(params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient return 404', () async {
    mockHttpError(HttpError.notFound);
    final future = sut.auth(params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient return 401', () async {
    mockHttpError(HttpError.unauthorized);
    final future = sut.auth(params);
    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return an Account if HttpClient return 200', () async {
    final validData = mockValidData();
    mockHttpData(validData);
    final account = await sut.auth(params);
    expect(account.token, validData['accessToken']);
  });

  test('Should throw UnexpectedError if HttpClient return 200 with invalid data', () async {
    mockHttpData({'ivalid_key': '', 'invalid_value': faker.person.name()});
    final future = sut.auth(params);
    expect(future, throwsA(DomainError.unexpected));
  });
}
