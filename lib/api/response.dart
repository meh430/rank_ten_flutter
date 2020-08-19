class Response<T> {
  Status status;
  T value;
  String message;

  Response.loading(this.message) : status = Status.LOADING;

  Response.completed(this.value) : status = Status.COMPLETED;

  Response.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $value";
  }
}

enum Status { LOADING, COMPLETED, ERROR }
