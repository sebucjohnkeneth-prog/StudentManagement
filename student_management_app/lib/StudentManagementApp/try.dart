import 'package:flutter/material.dart';

void main() {
  runApp(const StudentManagementApp());
}

class StudentManagementApp extends StatelessWidget {
  const StudentManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Management App',
      home: const StudentListPage(),
    );
  }
}


class Student {
  String name;
  String course;

  Student({required this.name, required this.course});
}


class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  List<Student> students = [];

  void addStudent(Student student) {
    setState(() {
      students.add(student);
    });
  }

  void updateStudent(int index, Student student) {
    setState(() {
      students[index] = student;
    });
  }

  void deleteStudent(int index) {
    setState(() {
      students.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Records")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StudentFormPage(
                onSave: addStudent,
              ),
            ),
          );
        },
      ),
      body: students.isEmpty
          ? const Center(child: Text("No student records yet"))
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(students[index].name),
                    subtitle: Text(students[index].course),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StudentFormPage(
                                  student: students[index],
                                  onSave: (updatedStudent) {
                                    updateStudent(index, updatedStudent);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deleteStudent(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}


class StudentFormPage extends StatefulWidget {
  final Student? student;
  final Function(Student) onSave;

  const StudentFormPage({super.key, this.student, required this.onSave});

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController courseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      nameController.text = widget.student!.name;
      courseController.text = widget.student!.course;
    }
  }

  void saveStudent() {
    if (nameController.text.isEmpty ||
        courseController.text.isEmpty) {
      return;
    }

    widget.onSave(
      Student(
        name: nameController.text,
        course: courseController.text,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null
            ? "Add Student"
            : "Edit Student"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(labelText: "Student Name"),
            ),
            TextField(
              controller: courseController,
              decoration:
                  const InputDecoration(labelText: "Course"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveStudent,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
