enum AuthResultStatus {
  successful,
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  weakPassword,
  undefined,
}

class AuthExceptionHandler {
  static handleException(e) {
    AuthResultStatus status;
    print(e.code);
    switch (e.code) {
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        status = AuthResultStatus.invalidEmail;
        break;
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        status = AuthResultStatus.wrongPassword;
        break;
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        status = AuthResultStatus.userNotFound;
        break;
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        status = AuthResultStatus.userDisabled;
        break;
      case "ERROR_TOO_MANY_REQUESTS":
      case "too-many-requests":
        status = AuthResultStatus.tooManyRequests;
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        status = AuthResultStatus.operationNotAllowed;
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case 'credential-already-in-use':
      case "email-already-in-use":
      case "firebase_auth/email-already-in-use":
        status = AuthResultStatus.emailAlreadyExists;
        break;
      case "weak-password":
        status = AuthResultStatus.weakPassword;
        break;
      default:
        status = AuthResultStatus.undefined;
    }
    return status;
  }

  ///
  /// Accepts AuthExceptionHandler.errorType
  ///
  static generateExceptionMessage(exceptionCode) {
    String errorMessage;
    print(exceptionCode);
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = "Invalid e-mail address.";
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = "Invalid password.";
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = "User with this e-mail doesn't exist.";
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = "User with this e-mail has been disabled.";
        break;
      case AuthResultStatus.tooManyRequests:
        errorMessage = "Too many requests. Try again later.";
        break;
      case AuthResultStatus.operationNotAllowed:
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage =
        "The e-mail has already been registered. Please login or reset your password.";
        break;
      case AuthResultStatus.weakPassword:
        errorMessage = "Password must be at least 6 characters long.";
        break;
      default:
        errorMessage = "An undefined Error happened.";
    }

    return errorMessage;
  }
}