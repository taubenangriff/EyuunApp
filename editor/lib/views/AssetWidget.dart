import 'package:editor/main.dart';
import 'package:editor/views/BoolWidget.dart';
import 'package:editor/views/StringField.dart';
import 'package:eyuuncore/core/components/standard.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';
import 'package:flutter/material.dart';
import 'package:reflectable/mirrors.dart';

import '../Asset.dart';

class AssetWidget extends StatefulWidget {
  Asset asset;

  AssetWidget({super.key, required this.asset});

  @override
  State<AssetWidget> createState() => _AssetWidgetState();
}

class _AssetWidgetState extends State<AssetWidget> {
  @override
  Widget build(BuildContext context) {
    final asset = widget.asset;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: asset.components.map((e) => buildPanel(context, e)).toList(),
      ),
    );
  }

  Widget buildPanel(BuildContext context, Reflecting reflecting) {
    List<Widget> texts = [];

    InstanceMirror mirror = reflector.reflect(reflecting);
    ClassMirror classMirror = mirror.type;

    for (var key in classMirror.declarations.keys) {
      DeclarationMirror? variableMirror = classMirror.declarations[key];
      if (variableMirror != null) {
        texts.add(buildDeclaration(context, variableMirror, mirror));
      }
    }

    return Column(
      children:
          <Widget>[
            Text(reflecting.runtimeType.toString()),
            SizedBox(height: 16),
          ] +
          texts +
          <Widget>[SizedBox(height: 16)],
    );
  }

  Widget buildDeclaration(
    BuildContext,
    DeclarationMirror declMirror,
    InstanceMirror instanceMirror,
  ) {
    if (declMirror is! VariableMirror) {
      return Row(children: []);
    }

    if (!declMirror.hasReflectedType) {
      return Row(children: []);
    }

    Type vartype = declMirror.reflectedType;

    var widgets = <Widget>[
      Text(vartype.toString()),
      SizedBox(width: 16),
      Text(declMirror.simpleName),
    ];

    if (vartype == bool) {
      widgets.add(
        Switch(
          value: instanceMirror.invokeGetter(declMirror.simpleName) as bool,
          onChanged: (newval) {
            setState(() {
              instanceMirror.invokeSetter(declMirror.simpleName, newval);
            });
          },
        ),
      );
    }

    if (vartype == String) {

      var stringVal = instanceMirror.invokeGetter(declMirror.simpleName) as String? ?? "";

      var _controller = TextEditingController(text: stringVal);

      widgets.add(
        Flexible(child:
        TextField(
          controller: _controller,
          onChanged: (newval) {
            setState(() {
              instanceMirror.invokeSetter(declMirror.simpleName, newval);
            });
          },
        ))
      );
    }

    return Row(children: widgets);
  }
}
