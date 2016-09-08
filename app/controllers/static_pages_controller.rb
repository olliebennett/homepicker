class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!

  layout false

  def homepage
  end
end
