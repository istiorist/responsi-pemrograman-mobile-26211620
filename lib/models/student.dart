class Student {
  final String name;
  final String nim;
  final String programStudi;
  final String email;

  const Student({
    required this.name,
    required this.nim,
    required this.programStudi,
    required this.email,
  });

  Student copyWith({String? name, String? nim, String? programStudi, String? email}) =>
      Student(
        name: name ?? this.name,
        nim: nim ?? this.nim,
        programStudi: programStudi ?? this.programStudi,
        email: email ?? this.email,
      );
}