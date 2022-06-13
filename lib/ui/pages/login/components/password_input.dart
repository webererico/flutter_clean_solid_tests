import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe/ui/pages/pages.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context, listen: false);
    return StreamBuilder<dynamic>(
      stream: presenter.passwordErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
            labelText: 'Senha',
            icon: Icon(
              Icons.lock,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          obscureText: true,
          onChanged: presenter.validatePassword,
        );
      },
    );
  }
}
