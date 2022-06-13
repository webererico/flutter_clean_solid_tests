import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe/constants/constants.dart';
import 'package:vibe/ui/components/components.dart';
import 'package:vibe/ui/pages/login/components/components.dart';

import 'package:vibe/ui/pages/pages.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter? presenter;
  LoginPage(this.presenter);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          widget.presenter?.isLoadingStream?.listen((isLoading) {
            if (isLoading!) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });
          widget.presenter?.mainErrorStream?.listen((error) {
            if (error != null) {
              showErrorMessage(context, error);
            }
          });
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LoginHeader(),
                const Headerline1(text: 'Login'),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Provider(
                    create: (_) => widget.presenter,
                    child: Form(
                      child: Column(
                        children: [
                          const EmailInput(),
                          const Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 20.0),
                            child: PasswordInput(),
                          ),
                          const LoginButton(),
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Icon(
                                    Icons.person,
                                    color: primaryColor,
                                  ),
                                ),
                                Text(
                                  'Criar conta',
                                  style: TextStyle(color: primaryColor),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
