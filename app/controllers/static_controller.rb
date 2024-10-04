# frozen_string_literal: true

class StaticController < ApplicationController
  @hide_header = true

  def index; end

  def members_only; end
end
