import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:moveness/dtos/enums/bad_request_code.dart';
import 'package:moveness/dtos/enums/not_forund_code.dart';
import 'package:moveness/dtos/enums/unauthorized_code.dart';
import 'package:moveness/services/api.dart';
import 'package:moveness/shared/ok_dialog.dart';

class ErrorDialogs {
  final BuildContext _context;
  final ApiResponse _response;

  ErrorDialogs(this._response, this._context);

  show() {
    var content = _getContent();

    showDialog(
      context: _context,
      builder: (context) => OkDialog(
        buttonText: "OK",
        content: content,
        title: "Nu gick något fel",
      ),
    );
  }

  String _getContent() {

    //Works as default message, if no errorCode or 500 error
    String content = "Något gick väldigt fel, men lugn, vi har blivit "
        "meddelade och kommer fixa det så snart vi bara kan!";

    var errorCode = _response.getError()?.errorCode;

    if (_response.statusCode == 500) {
      _reportToCrashlytics("Internal server error");
    }

    if (errorCode == -1) return content;

    if (_response.statusCode == 400) {
      var value = BadRequestCode.values[errorCode ?? -1];

      switch (value) {
        case BadRequestCode.UnidentifiedIdentityError:
        case BadRequestCode.IdsNotMatching:
        case BadRequestCode.UserAlreadyHasPassword:
          {
            _reportToCrashlytics(value);
            break;
          }
        case BadRequestCode.InvalidUserName:
          content = "Användarnamnet är inte giltigt.";
          break;
        case BadRequestCode.InvalidEmail:
          content = "E-postadressen inte är inte giltig.";
          break;
        case BadRequestCode.DuplicateUserName:
          content = "Användarnamnet är upptaget.";
          break;
        case BadRequestCode.DuplicateEmail:
          content = "Det finns redan ett konto med denna e-postadress.";
          break;
        case BadRequestCode.PasswordTooShort:
          content = "Lösenordet är för kort. Måste vara minst 6 tecken långt.";
          break;
        case BadRequestCode.PasswordRequiresUniqueChars:
          content = "Lösenordet måste innehålla mer blandade tecken.";
          break;
        case BadRequestCode.PasswordRequiresNonAlphanumeric:
          content = "Lösenordet måste innehålla ett specialtecken.";
          break;
        case BadRequestCode.PasswordRequiresDigit:
          content = "Lösenordet måste innehålla en siffra.";
          break;
        case BadRequestCode.PasswordRequiresLower:
          content = "Lösenordet måste innehålla liten bokstav.";
          break;
        case BadRequestCode.PasswordRequiresUpper:
          content = "Lösenordet måste innehålla stor bokstav.";
          break;
        case BadRequestCode.InvalidToken:
          content = "Den kopierade koden är inte giltig. Fick du med hela?";
          break;
        case BadRequestCode.CanNotDeleteAcceptedChallenge:
          content = "Det går inte att ta bort en accepterad utmaning.";
          break;
        case BadRequestCode.CanNotChallengeYourself:
          content = "Du kan inte utmana dig själv.";
          break;
        case BadRequestCode.CanNotEditChallengeAfterAcceptance:
          content = "Du kan inte ändra i utmaningen efter att den har "
              "accepterats.";
          break;
        case BadRequestCode.UserAlreadyInTeam:
          content = "Användaren är redan med i teamet.";
          break;
        case BadRequestCode.CanNotDeleteTeamWhenActiveChallenges:
          content = "Du kan inte ta bort ett team med aktiva utmaningar.";
          break;
        case BadRequestCode.UserIsOwnerOfTeam:
          content = "Du kan inte lämna ett lag som du är ägare för.";
          break;
      }
    } else if (_response.statusCode == 401) {
      var value = UnauthorizedCode.values[errorCode ?? -1];

      switch (value) {
        case UnauthorizedCode.UserNotOwnerOfChallenge:
        case UnauthorizedCode.UserNotOwnerOfTeam:
          {
            content = "Du är inte ägare för den här utmaningen eller teamet.";
            _reportToCrashlytics(value);
          }
          break;
      }
    } else if (_response.statusCode == 404) {
      var value = NotFoundCode.values[errorCode ?? -1];

      switch (value) {
        case NotFoundCode.UserNotFound: {
          content = "Användaren hittades inte.";
          _reportToCrashlytics(value);
        }
          break;
        case NotFoundCode.ActivityNotFound:
          content = "Aktiviteten hittades inte.";
          break;
        case NotFoundCode.ChallengingTeamNotFound:
          content = "Utmanande team hittades inte.";
          break;
        case NotFoundCode.ChallengedTeamNotFound:
          content = "Teamet som utmanades hittades inte.";
          break;
        case NotFoundCode.ChallengedUserNotFound:
          content = "Användaren som utmanades hittades inte.";
          break;
        case NotFoundCode.ChallengeNotFound:
          content = "Utmaningen hittades inte.";
          break;
        case NotFoundCode.TeamNotFound:
          content = "Teamet hittades inte.";
          break;
        case NotFoundCode.TeamMemberNotFound:
          content = "Teammedlemmen hittades inte.";
          break;
      }
    }

    return content;
  }

  void _reportToCrashlytics(dynamic value) {
    var message = _getMessage(value);
    FirebaseCrashlytics.instance.log(message);

    FirebaseCrashlytics.instance.recordError(
      Exception(_response.statusCode),
      StackTrace.current,
    );
  }

  String _getMessage(dynamic value) {
    return "${_response.getRequest()?.method} "
        "request ${_response.getRequest()?.url} "
        "returned ${_response.statusCode}"
        "with response ${value.toString()}";
  }
}
