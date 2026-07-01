# TODO

- [ ] Add Windows/Desktop CV file persistence to `cv/resume` when uploading.
  - [ ] Implement helper to write picked CV bytes to `cv/resume/` under app/project folder (Windows).
  - [ ] Update `lib/screens/profile/cv_screen.dart` `_saveToProfile()` to call helper after successful pick.
  - [ ] Update `UserProfile` state to keep `cvFileName` / `cvFileBytes` as before.
  - [ ] Add basic error handling + snackbars.


