abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {}

class RegisterErrorState extends RegisterStates {}

class CreateUserSuccessState extends RegisterStates {}

class CreateUserErrorState extends RegisterStates {}

class ProfileImagePickedSuccessState extends RegisterStates {}

class ProfileImagePickedErrorState extends RegisterStates {}

class UploadProfileImagePickedSuccessState extends RegisterStates {}

class UploadProfileImagePickedErrorState extends RegisterStates {}

class RemoveProfileImageSuccessState extends RegisterStates {}

class UploadProfileImagePickedLoadingState extends RegisterStates {}

class RegisterChangePasswordVisibilityState extends RegisterStates{}