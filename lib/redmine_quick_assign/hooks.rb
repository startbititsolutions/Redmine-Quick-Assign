module RedmineQuickAssign
  class Hooks < Redmine::Hook::ViewListener
    # Bind delegated quick-assign JS once per page (works with embedded Ajax edit form)
    render_on :view_layouts_base_body_bottom,
              partial: 'quick_assign/edit_script'

    # Issue show page — below the attributes block
    render_on :view_issues_show_details_bottom,
              partial: 'quick_assign/buttons'

    # Issue edit page — below the form fields (above Notes)
    render_on :view_issues_form_details_bottom,
              partial: 'quick_assign/edit_buttons'

    # Issues list — right-click context menu
    render_on :view_issues_context_menu_end,
              partial: 'quick_assign/context_menu'
  end
end
