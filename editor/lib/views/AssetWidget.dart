import 'package:editor/main.dart';
import 'package:editor/views/BoolWidget.dart';
import 'package:editor/views/StringField.dart';
import 'package:eyuuncore/core/components/standard.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      child: SingleChildScrollView(
        child: Column(
        children: [
          for (var entry in asset.components.entries)
            buildPanel(context, entry.key, entry.value)
        ]
      )),
    );
  }

  Widget buildPanel(BuildContext context, String name, ComponentReflectable reflecting) {
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
            Text(name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
      SizedBox(width: 150, child: Text(vartype.toString())),
      SizedBox(width: 16),
      SizedBox(width: 150, child: Text(declMirror.simpleName)),
      SizedBox(width: 16),
    ];

    Widget? varWidget = null;

    varWidget = switch(vartype) {
      String => _buildStringWidget(instanceMirror, declMirror),
      int => _buildIntWidget(instanceMirror, declMirror),
      bool => _buildBoolWidget(instanceMirror, declMirror),
      _ => null
    };

    if(varWidget != null){
      widgets.add(Flexible(child: varWidget));
    }

    return Row(children: widgets);
  }

  Switch _buildBoolWidget(InstanceMirror instanceMirror, VariableMirror declMirror) {
    return Switch(
        value: instanceMirror.invokeGetter(declMirror.simpleName) as bool,
        onChanged: (newval) {
          setState(() {
            instanceMirror.invokeSetter(declMirror.simpleName, newval);
          });
        },
      );
  }

  Widget _buildIntWidget(InstanceMirror instanceMirror, VariableMirror declMirror) {
    var stringVal = instanceMirror.invokeGetter(declMirror.simpleName) as int;

    var numController = TextEditingController(text: stringVal.toString());

    return TextFormField(
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      controller: numController,
      onFieldSubmitted: (newval) {
        var integer = int.tryParse(newval);
        if(integer == null) {
          setState(() {});
          return;
        }
        setState(() {
          instanceMirror.invokeSetter(declMirror.simpleName, integer);
          print("fuck");
        });
      },
    );
  }

  Widget _buildStringWidget(InstanceMirror instanceMirror, VariableMirror declMirror) {

    var stringVal = instanceMirror.invokeGetter(declMirror.simpleName) as String? ?? "";
    var strController = TextEditingController(text: stringVal);

    return TextField(
      controller: strController,
      onChanged: (newval) {
        setState(() {
          instanceMirror.invokeSetter(declMirror.simpleName, newval);
        });
      },
    );
  }
}
