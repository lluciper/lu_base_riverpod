# lubaseriverpod

Base Flutter **MVVM + Riverpod 3** để khởi tạo app mới (go_router, dio + retrofit, freezed, i18n EN/VI).

## Chạy

```bash
make init     # pub get + sinh code + l10n
make check    # analyze + test, giống CI
```

Chạy theo môi trường: VS Code → **Run and Debug** → `dev|stg|prod iOS` / `dev|stg|prod Android`, hoặc:

```bash
flutter run --flavor dev --dart-define-from-file=dart_defines/develop.json   # Android (bắt buộc --flavor)
flutter run --dart-define-from-file=dart_defines/develop.json                # iOS, web
```

Môi trường **dev** đăng nhập giả (chưa có API login): email hợp lệ bất kỳ + mật khẩu ≥ 8 ký tự.

## Tài liệu

- [CLAUDE.md](CLAUDE.md) — công nghệ, cấu trúc thư mục, quy tắc MVVM, cách test.
- [PROJECT.md](PROJECT.md) — mục tiêu, phạm vi, backlog của dự án dựng trên base.
- Skill Claude Code: `/project-setup` (khởi tạo dự án), `/feature-team` (feature mới), `/bugfix-team` (sửa lỗi).
