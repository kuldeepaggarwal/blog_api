# Be sure to restart your server when you modify this file.

# Require `belongs_to` associations by default. This is a new Rails 5.0
# default, so it is introduced as a configuration option to ensure that apps
# made on earlier versions of Rails are not affected when upgrading.
# Rails.application.config.active_record.belongs_to_required_by_default = true
#
# [HACK]: `cancancan` gem hinder the loading sequence.
# see: https://github.com/CanCanCommunity/cancancan/pull/292/files
ActiveRecord::Base.belongs_to_required_by_default = true
