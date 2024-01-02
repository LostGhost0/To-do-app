import "package:flutter/material.dart";
import "package:supabase_flutter/supabase_flutter.dart";

class CreatPage extends StatefulWidget {
  const CreatPage({super.key});

  @override
  State<CreatPage> createState() => _CreatPageState();
}

class _CreatPageState extends State<CreatPage> {
  bool isLoading = false;
  TextEditingController titleController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;
  @override
  void dispose() {
    titleController.dispose();
    supabase.dispose();
    super.dispose();
  }

  Future insertData() async {
    setState(() {
      isLoading = true;
    });
    try {
      String userId = supabase.auth.currentUser!.id;
      await supabase
          .from('todos')
          .insert({'title': titleController.text, 'user_id': userId});
      Navigator.pop(context);
    } catch (e) {
      print("Error inserting data : $e");
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('something went wrong')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                  hintText: "Enter the title ", border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: insertData, child: const Text("Create"))
          ],
        ),
      ),
    );
  }
}
