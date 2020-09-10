class Result {
  Result(this.currectOption);
  int status = 0;
  String attemptedOption;
  final String currectOption;

  setResult(String x) {
    status = 1;
    attemptedOption = x;
  }

  get isAttempted => status != 0;
  get isCorrect => attemptedOption == currectOption;
}
