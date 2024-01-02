import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditPage extends StatefulWidget {
  final String editData;
  final int editId;
  const EditPage(this.editData, this.editId, {super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  bool isLoading = false;
  TextEditingController titleController = TextEditingController();
  SupabaseClient supabase = Supabase.instance.client;
  void dispose() {
    titleController.dispose();
    supabase.dispose();
    super.dispose();
  }

  Future<void> udpateData() async {
    if (titleController.text != '') {
      setState(() {
        isLoading = true;
      });
      try {
        await supabase.from('todos').update(
            {'title': titleController.text}).match({'id': widget.editId});
        Navigator.pop(context);
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Something Went Wrong')));
      }
    }
  }

  Future<void> deletData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await supabase.from('todos').delete().match({'id': widget.editId});
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Something Went Wrong')));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    titleController.text = widget.editData;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                  hintText: "Edit the title ", border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                            onPressed: udpateData, child: const Text("Update")),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(),
                      ElevatedButton.icon(
                        onPressed: deletData,
                        icon: const Icon(Icons.delete),
                        label: const Text("delete"),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                        ),
                      )
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
