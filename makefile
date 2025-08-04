l10n:
	flutter pub global run intl_utils:generate

gen:
	flutter pub run build_runner build --delete-conflicting-outputs

pub_get: 
	flutter pub get

init: pub_get gen l10n

	