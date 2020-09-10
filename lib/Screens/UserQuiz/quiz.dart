class Quiz {
  final String question;
  final String imageUrl;
  final String op1;
  final String op2;
  final String op3;
  final String op4;
  final String op;
  Quiz(
      {this.question,
      this.imageUrl,
      this.op,
      this.op1,
      this.op2,
      this.op3,
      this.op4});

  factory Quiz.fromJson(json) {
    return Quiz(
      question: json['question'],
      imageUrl: json['imageUrl'],
      op1: json['op1'],
      op2: json['op2'],
      op3: json['op3'],
      op4: json['op4'],
      op: json['op'],
    );
  }
}
