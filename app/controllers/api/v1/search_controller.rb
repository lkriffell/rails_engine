class Api::V1::SearchController < ApplicationController
  include SearchHelper

  def index
    if attribute_exists? == true
      search
    end
  end

  def show
    if attribute_exists? == true
      search
    end
  end
end
