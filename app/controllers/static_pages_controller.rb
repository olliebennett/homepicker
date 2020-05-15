class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!

  layout 'minimal'

  def homepage; end
end
