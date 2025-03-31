import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';

class EditItemPage extends ConsumerStatefulWidget {
  const EditItemPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditItemPageState();
}

class _EditItemPageState extends ConsumerState<EditItemPage> {
  TextEditingController controller = TextEditingController();
  GlobalKey key = GlobalKey();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: key,      
        child: Column(
          children: [
            TextFieldFactory.createBasic(controller),
            AppGap.l(),
            ElevatedButton(
              style: AppButtonStyle.basicStyle,
              onPressed: () {
                  

              },
              child: Text("Сохранить"),
            ),
          ],
        ),
      ),
    );
  }
}
