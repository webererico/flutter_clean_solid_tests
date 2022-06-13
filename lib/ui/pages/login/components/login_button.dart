import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe/ui/pages/pages.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context, listen: false);
    return StreamBuilder<dynamic>(
      stream: presenter.isFormValidStream,
      builder: (context, snapshot) {
        final enableButton = snapshot.data == true;
        return ElevatedButton(
          onPressed: enableButton ? presenter.auth : null,
          style: Theme.of(context).elevatedButtonTheme.style,
          child: Text('Entrar'.toUpperCase()),
        );
      },
    );
  }
}
