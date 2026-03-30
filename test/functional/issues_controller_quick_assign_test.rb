require_relative '../test_helper'

class IssuesControllerQuickAssignTest < Redmine::ControllerTest
  fixtures :projects,
           :users, :email_addresses, :user_preferences,
           :roles,
           :members,
           :member_roles,
           :issues,
           :issue_statuses,
           :issue_relations,
           :versions,
           :trackers,
           :projects_trackers,
           :issue_categories,
           :enabled_modules,
           :enumerations,
           :attachments,
           :workflows,
           :custom_fields,
           :custom_values,
           :custom_fields_projects,
           :custom_fields_trackers,
           :time_entries,
           :journals,
           :journal_details,
           :queries,
           :repositories,
           :changesets,
           :watchers, :groups_users

  def setup
    User.current = nil
    @request.session[:user_id] = 1
  end

  def test_put_update_with_quick_assign_author
    issue = Issue.find(6)
    assert_nil issue.assigned_to_id
    assert_equal 2, issue.author_id

    put(:update, params: {id: issue.id, quick_assign: 'author'})

    assert_redirected_to issue_path(issue)
    assert_equal 2, issue.reload.assigned_to_id
  end

  def test_put_update_with_quick_assign_last
    issue = Issue.find(6)
    expected_last_user = issue.journals.order(id: :desc).detect { |journal| journal.user.present? }&.user
    assert_not_nil expected_last_user

    put(:update, params: {id: issue.id, quick_assign: 'last'})

    assert_redirected_to issue_path(issue)
    assert_equal expected_last_user.id, issue.reload.assigned_to_id
  end

  def test_put_update_with_quick_assign_last_without_journal_keeps_current_assignee
    issue = Issue.find(3)
    original_assignee_id = issue.assigned_to_id
    assert_nil issue.journals.order(:id).last

    put(:update, params: {id: issue.id, quick_assign: 'last'})

    assert_redirected_to issue_path(issue)
    assert_equal original_assignee_id, issue.reload.assigned_to_id
  end

  def test_put_update_with_quick_assign_previous
    issue = Issue.find(6)
    detail = JournalDetail
      .joins(:journal)
      .where(
        journals: {journalized_type: 'Issue', journalized_id: issue.id},
        property: 'attr',
        prop_key: 'assigned_to_id'
      )
      .reorder('journals.id DESC')
      .first
    assert_not_nil detail

    put(:update, params: {id: issue.id, quick_assign: 'previous'})

    assert_redirected_to issue_path(issue)
    assert_equal detail.old_value.to_i, issue.reload.assigned_to_id
  end

  def test_show_displays_quick_assign_buttons_for_available_targets
    get(:show, params: {id: 6})

    assert_response :success
    assert_select "form[action='#{issue_path(6)}'] input[name='issue[assigned_to_id]'][value='2']"
    assert_select "form[action='#{issue_path(6)}'] input[name='issue[assigned_to_id]'][value='1']"
  end

  def test_show_hides_last_button_when_last_user_is_unavailable
    get(:show, params: {id: 3})

    assert_response :success
    assert_select "form[action='#{issue_path(3)}'] input[name='issue[assigned_to_id]'][value='2']"
    assert_select "form[action='#{issue_path(3)}'] input[name='issue[assigned_to_id]'][value='3']", 0
  end
end
