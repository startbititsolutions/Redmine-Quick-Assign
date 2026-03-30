# Changelog

All notable changes to this project are documented in this file.

## [1.0.0] - 2026-03-26

### Added
- Initial release with quick assign to `Author` and `Last User`.
- Show and edit page integration using Redmine view hooks.
- Controller patch for `quick_assign` update mode.
- Added `Previous Assignee` quick action.
- Added quick-assign actions to the issue context menu (single selected issue).
- Added support for embedded edit form on issue show page.

### Changed
- Simplified button labels to `Author`, `Last Commenter`, `Prev Assignee`.
- Context menu no longer shows user icon.
- Show page buttons submit standard `issue[assigned_to_id]` updates.
- Show and context menu buttons remain visible and are disabled when target user is already the assignee.
- Edit page quick-assign highlight is cleared when assignee is changed manually.
- Improved plugin metadata for public release (`author_url`, description, version).

### Fixed
- Fixed edit quick-assign in embedded show-page edit form.
- Fixed `issue_assigned_to_id` DOM ID collisions caused by hidden fields on show page.
- Hardened assignee `<select>` lookup in edit quick-assign JavaScript.

