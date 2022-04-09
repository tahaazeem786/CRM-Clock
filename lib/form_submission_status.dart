abstract class FormSubmissionStatus {
  const FormSubmissionStatus();
}

class IntialFormStatus extends FormSubmissionStatus {
  const IntialFormStatus();
}

class FormSubmitting extends FormSubmissionStatus {}

class SubmissionSuccess extends FormSubmissionStatus {}

class SubmissionFailed extends FormSubmissionStatus {
  final Exception exception;
  SubmissionFailed(this.exception);
}
