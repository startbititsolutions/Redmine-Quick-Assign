# Redmine Quick Assign

[![Redmine](https://img.shields.io/badge/Redmine-5.1.x%20%7C%206.0.x%20%7C%206.1.x-red)](https://www.redmine.org)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.0.0-blue)](CHANGELOG.md)

Redmine plugin to assign issues quickly from common targets:
- Author
- Last Commenter
- Previous Assignee

## Features

- Issue show page quick actions.
- Issue edit page quick actions.
- Embedded edit form on show page is supported.
- Context menu quick actions for a single selected issue.
- Same-assignee actions on show/context stay visible but are disabled.
- Manual assignee change on edit form clears quick-action highlight.
- No database migration required.

## Compatibility

- Redmine: `5.1.x`, `6.0.x`, `6.1.x`
- Ruby: use the Ruby version required by your Redmine version

## Installation

1. Copy the plugin into Redmine plugins directory:

```bash
cd /path/to/redmine/plugins
git clone https://github.com/Govind-Upadhyay/Redmine-Quick-Assign.git
```

2. Restart Redmine:

```bash
touch /path/to/redmine/tmp/restart.txt
```

3. Verify from `Administration -> Plugins`.

## Usage

### Issue show page
- Click quick-assign buttons under issue details.
- Buttons submit normal Redmine update (`issue[assigned_to_id]`) so journaling/notifications stay standard.

### Issue edit page
- Click quick-assign buttons in the form.
- Assignee dropdown updates immediately.
- Save the form once with other changes.

### Issue context menu
- Right-click one issue in issue list.
- Use `Quick assign` submenu.

## Uninstall

```bash
rm -rf /path/to/redmine/plugins/redmine_quick_assign
touch /path/to/redmine/tmp/restart.txt
```

## Test

Run from Redmine root:

```bash
bundle exec rails test plugins/redmine_quick_assign/test
```

## Public Release Checklist

- Set your final Git repository URL in this README clone command.
- Confirm plugin version in `init.rb` and `CHANGELOG.md`.
- Push a Git tag (example: `v1.1.0`).
- Create a release ZIP from that tag.
- Publish repository as public and submit plugin page details where needed.
- See `RELEASE.md` for full commands.

## Project Structure

```text
redmine_quick_assign/
├── init.rb
├── README.md
├── CHANGELOG.md
├── LICENSE
├── Gemfile
├── app/views/quick_assign/
│   ├── _buttons.html.erb
│   ├── _edit_buttons.html.erb
│   ├── _edit_script.html.erb
│   └── _context_menu.html.erb
├── lib/redmine_quick_assign/
│   ├── hooks.rb
│   └── patches/issues_controller_patch.rb
└── test/functional/issues_controller_quick_assign_test.rb
```
