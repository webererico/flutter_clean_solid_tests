import 'package:vibe/data/http/http.dart';
import 'package:vibe/data/models/remote_account_model.dart';
import 'package:vibe/domain/entities/account_entity.dart';
import 'package:vibe/domain/helpers/domain_error.dart';
import 'package:vibe/domain/usecases/authentication.dart';

class RemoteAuthentication implements Authentication {
  final HttpClient httpClient;
  final String? url;

  RemoteAuthentication({required this.httpClient, required this.url});

  @override
  Future<AccountEntity> auth(AuthenticationParams params) async {
    try {
      final httpResponse = await httpClient.request(
        url: url,
        method: 'post',
        body: RemoteAuthenticationParams.fromDomain(params).toJson(),
      );

      return RemoteAccountModel.fromJson(httpResponse!).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized ? DomainError.invalidCredentials : DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;
  RemoteAuthenticationParams({required this.email, required this.password});

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) {
    return RemoteAuthenticationParams(
      email: params.email,
      password: params.secret,
    );
  }

  Map toJson() => {'email': email, 'password': password};
}
