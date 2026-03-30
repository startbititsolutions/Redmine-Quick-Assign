module RedmineQuickAssign
  module Patches
    module IssuesControllerPatch
      def self.included(base)
        base.before_action :apply_quick_assign, only: [:update]
      end

      private

      # @issue may or may not be set depending on filter chain order across
      # Redmine versions (5.1.x, 6.0.x, 6.1.x), so fall back to find_by.
      def apply_quick_assign
        return if params[:quick_assign].blank?

        issue = @issue || Issue.find_by(id: params[:id])
        return unless issue
        return unless issue.attributes_editable?

        assignee = quick_assignee_for(issue, params[:quick_assign])
        return unless assignee
        return unless quick_assignable_user?(issue, assignee)
        return if issue.assigned_to_id.to_i == assignee.id

        # Build a properly permitted params object so Redmine's safe_attributes=
        # picks up the new value. A plain Ruby {} is NOT treated as permitted by
        # Rails 6.1 ActionController::Parameters.
        issue_params = ActionController::Parameters.new(
          assigned_to_id: assignee.id.to_s
        ).permit!

        # Merge into existing issue params (preserve notes, custom fields, etc.)
        if params[:issue].present?
          params[:issue].merge!(issue_params)
        else
          params[:issue] = issue_params
        end
      end

      def quick_assignee_for(issue, mode)
        case mode.to_s
        when 'author'
          issue.author
        when 'last'
          issue.journals.reorder(id: :desc).detect { |journal| journal.user.present? }&.user
        when 'previous'
          # Find the most recent journal that changed assigned_to_id
          # and return the user from old_value (who was assigned before that change)
          detail = JournalDetail
            .joins(:journal)
            .where(
              journals: { journalized_type: 'Issue', journalized_id: issue.id },
              property: 'attr',
              prop_key: 'assigned_to_id'
            )
            .reorder('journals.id DESC')
            .first
          user_id = detail&.old_value.presence
          User.find_by(id: user_id) if user_id
        end
      end

      def quick_assignable_user?(issue, assignee)
        issue.assignable_users.any? { |user| user.id == assignee.id }
      end
    end
  end
end
