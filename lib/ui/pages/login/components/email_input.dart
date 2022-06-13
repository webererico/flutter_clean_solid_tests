import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe/ui/pages/pages.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context, listen: false);
    return StreamBuilder<dynamic>(
      stream: presenter.emailErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
            labelText: 'Email',
            icon: Icon(
              Icons.email,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: presenter.validateEmail,
        );
      },
    );
  }
}
